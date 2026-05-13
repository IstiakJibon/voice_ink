import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/utilities/extensions/user_extension.dart';
import 'package:voice_ink/features/files/presentation/cubit/files_cubit.dart';
import 'package:voice_ink/features/files/presentation/pages/transcript_detail_screen.dart';
import 'package:voice_ink/features/podcast/domain/entities/podcast_entity.dart';
import 'package:voice_ink/features/podcast/presentation/cubit/podcast_cubit.dart';
import 'package:voice_ink/features/podcast/presentation/cubit/podcast_state.dart';
import 'package:voice_ink/features/url_import/presentation/cubit/url_import_cubit.dart';
import 'package:voice_ink/features/url_import/presentation/cubit/url_import_state.dart';

class PodcastSearchScreen extends StatefulWidget {
  const PodcastSearchScreen({super.key});

  @override
  State<PodcastSearchScreen> createState() => _PodcastSearchScreenState();
}

class _PodcastSearchScreenState extends State<PodcastSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _selectedEpisodeKey = GlobalKey();

  bool _advancedExpanded = false;
  final Map<String, bool> _advancedFlags = {
    'sentimentAnalysis': false,
    'entityDetection': false,
    'topicDetection': false,
    'autoHighlights': false,
    'autoChapters': false,
    'summarization': false,
    'contentSafety': false,
    'profanityFilter': false,
  };

  int get _advancedSelectedCount =>
      _advancedFlags.values.where((v) => v).length;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PodcastCubit>().reset();
      // Default the toggles to ON to match the web's initial state.
      final urlCubit = context.read<UrlImportCubit>();
      urlCubit.toggleAutoTranscribe(true);
      urlCubit.toggleSpeakerIdentification(true);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    context.read<PodcastCubit>().searchDebounced(
          token: context.token,
          query: value,
        );
  }

  void _onFeedTap(PodcastFeedEntity feed) {
    context.read<PodcastCubit>().selectFeed(
          token: context.token,
          feed: feed,
        );
  }

  /// Tapping an episode only selects it — actual import waits for the
  /// "Start Transcription" button in the Selected Episode panel below.
  void _onEpisodeTap(PodcastEpisodeEntity episode) {
    final key = _episodeKey(episode);
    context.read<PodcastCubit>().selectEpisode(key);
    // Scroll the Selected Episode panel into view on the next frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _selectedEpisodeKey.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          alignment: 0.1,
        );
      }
    });
  }

  /// Triggered by the "Start Transcription" button — calls the dedicated
  /// `/v1/podcasts/download-and-import` endpoint with the same payload shape
  /// the web sends.
  Future<void> _startTranscription(
    PodcastEpisodeEntity episode,
    PodcastFeedEntity feed,
  ) async {
    final url = episode.enclosureUrl;
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Episode has no audio URL')),
      );
      return;
    }

    final podcastCubit = context.read<PodcastCubit>();
    final urlCubit = context.read<UrlImportCubit>();
    final filesCubit = context.read<FilesCubit>();
    final navigator = Navigator.of(context);
    final wantsAutoTranscribe = urlCubit.state.autoTranscribe;

    final body = <String, dynamic>{
      'episodeUrl': url,
      'showTitle': feed.title ?? '',
      'episodeTitle': episode.title ?? '',
      if (episode.durationSeconds != null) 'duration': episode.durationSeconds,
      if (feed.feedUrl != null) 'feedUrl': feed.feedUrl,
      'metadata': <String, dynamic>{
        if ((feed.title ?? '').isNotEmpty) 'author': feed.title,
        if ((episode.description ?? '').isNotEmpty)
          'description': episode.description,
        if ((episode.image ?? episode.feedImage ?? feed.image) != null)
          'image': episode.image ?? episode.feedImage ?? feed.image,
        if (episode.datePublishedEpoch != null)
          'datePublished': episode.datePublishedEpoch,
      },
    };

    final fileId = await podcastCubit.startPodcastImport(
      token: context.token,
      body: body,
    );
    if (!mounted) return;
    if (fileId != null && fileId.isNotEmpty) {
      filesCubit.refreshFiles();
      navigator.pop();
      navigator.push(
        MaterialPageRoute(
          builder: (_) => TranscriptDetailScreen(
            fileId: fileId,
            autoTranscribeOnArrival: wantsAutoTranscribe,
          ),
        ),
      );
    } else {
      final err = podcastCubit.state.importError;
      if (err != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err)),
        );
      }
    }
  }

  String _episodeKey(PodcastEpisodeEntity e) =>
      e.id?.toString() ?? e.enclosureUrl ?? '${e.title}-${e.datePublishedEpoch}';

  /// Cleans podcast descriptions for safe rendering:
  /// - Strips HTML tags (the API returns escaped HTML).
  /// - Inserts zero-width spaces inside long unbreakable URLs/words so the
  ///   text layout can wrap them instead of overflowing horizontally.
  /// - Collapses runs of whitespace.
  String _cleanDescription(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    final stripped = raw
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</p\s*>', caseSensitive: false), '\n\n')
        .replaceAll(RegExp(r'<[^>]+>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");
    // Break overly long unbreakable runs (e.g. concatenated URLs) so the
    // Text widget can wrap them. Insert a zero-width space every 24 chars
    // inside any token longer than 40 chars with no whitespace.
    final withBreaks = stripped.split(RegExp(r'(\s+)')).map((tok) {
      if (tok.length <= 40) return tok;
      final buf = StringBuffer();
      for (int i = 0; i < tok.length; i++) {
        if (i > 0 && i % 24 == 0) buf.write('​');
        buf.write(tok[i]);
      }
      return buf.toString();
    }).join(' ');
    return withBreaks.replaceAll(RegExp(r'\n{3,}'), '\n\n').trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<PodcastCubit, PodcastState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xffE5E5EA)),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    24.verticalSpace,
                    _buildSourceCard(),
                    24.verticalSpace,
                    _buildSearchSection(state),
                    24.verticalSpace,
                    if (state.selectedFeed != null)
                      _buildEpisodesSection(state)
                    else
                      _buildFeedsSection(state),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: const BoxDecoration(
              color: Color(0xffECECF2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chevron_left_rounded,
              size: 20.sp,
              color: const Color(0xff1E1E1E),
            ),
          ),
        ),
        12.horizontalSpace,
        Text(
          'Podcast Search',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w500,
            fontSize: 22.sp,
            height: 28 / 22,
            color: const Color(0xff1E1E1E),
          ),
        ),
      ],
    );
  }

  Widget _buildSourceCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffE5E5EA)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: const Color(0xff8B5CF6).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.podcasts_rounded,
              size: 24.sp,
              color: const Color(0xff8B5CF6),
            ),
          ),
          12.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Podcast Episodes',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w500,
                  fontSize: 15.sp,
                  height: 20 / 15,
                  color: const Color(0xff1E222B),
                ),
              ),
              2.verticalSpace,
              Text(
                'Search and transcribe podcast episodes',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                  height: 16 / 12,
                  color: const Color(0xff8C8C8C),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection(PodcastState state) {
    final isSearching = state.searchStatus == PodcastSearchStatus.searching;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search Podcasts',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w500,
            fontSize: 15.sp,
            color: const Color(0xff1E222B),
          ),
        ),
        12.verticalSpace,
        TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
            color: const Color(0xff1E222B),
          ),
          decoration: InputDecoration(
            hintText: 'Search podcasts (type at least 3 characters)...',
            hintStyle: GoogleFonts.dmSans(
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
              color: const Color(0xff9CA3AF),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: isSearching
                  ? Center(
                      child: SizedBox(
                        width: 16.w,
                        height: 16.h,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xff4A59FE),
                          ),
                        ),
                      ),
                    )
                  : Icon(
                      Icons.search_rounded,
                      size: 20.sp,
                      color: const Color(0xff6B7280),
                    ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: Color(0xffD1D5DB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: Color(0xffD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide:
                  const BorderSide(color: Color(0xff4A59FE), width: 1.5),
            ),
          ),
        ),
        10.verticalSpace,
        if (state.searchStatus == PodcastSearchStatus.loaded)
          Text(
            'Found ${state.feeds.length} podcasts',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              color: const Color(0xff6B7280),
            ),
          )
        else if (state.searchStatus == PodcastSearchStatus.failed &&
            state.searchError != null)
          Text(
            state.searchError!,
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              color: const Color(0xffDC2626),
            ),
          ),
      ],
    );
  }

  Widget _buildFeedsSection(PodcastState state) {
    if (state.searchStatus == PodcastSearchStatus.idle) {
      return _buildEmptyHint('Type a podcast name to start searching.');
    }
    if (state.searchStatus == PodcastSearchStatus.searching &&
        state.feeds.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    if (state.feeds.isEmpty) {
      return _buildEmptyHint('No podcasts matched your search.');
    }
    return Column(
      children: [
        for (final feed in state.feeds)
          Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: _buildFeedRow(feed),
          ),
      ],
    );
  }

  Widget _buildFeedRow(PodcastFeedEntity feed) {
    return GestureDetector(
      onTap: () => _onFeedTap(feed),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffE5E7EB)),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            _buildArtwork(feed.image, 56),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feed.title ?? 'Untitled podcast',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      height: 18 / 14,
                      color: const Color(0xff1E222B),
                    ),
                  ),
                  if ((feed.author ?? '').isNotEmpty) ...[
                    4.verticalSpace,
                    Text(
                      feed.author!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        color: const Color(0xff6B7280),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20.sp,
              color: const Color(0xff9CA3AF),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEpisodesSection(PodcastState state) {
    final feed = state.selectedFeed!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => context.read<PodcastCubit>().backToShows(),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Text(
                  '← Back to shows',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w500,
                    fontSize: 13.sp,
                    color: const Color(0xff2563EB),
                  ),
                ),
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Episodes from "${feed.title ?? ''}"',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 15.sp,
                      height: 20 / 15,
                      color: const Color(0xff1E222B),
                    ),
                  ),
                  if ((feed.author ?? '').isNotEmpty)
                    Text(
                      feed.author!,
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        color: const Color(0xff6B7280),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        16.verticalSpace,
        if (state.episodesStatus == PodcastEpisodesStatus.loading)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: const Center(child: CircularProgressIndicator()),
          )
        else if (state.episodesStatus == PodcastEpisodesStatus.failed)
          _buildEmptyHint(
            state.episodesError ?? 'Failed to load episodes.',
            isError: true,
          )
        else if (state.episodes.isEmpty)
          _buildEmptyHint('No episodes found.')
        else ...[
          for (final ep in state.episodes)
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _buildEpisodeRow(
                ep,
                feed,
                isSelected: _episodeKey(ep) == state.selectedEpisodeKey,
              ),
            ),
          if (_findSelectedEpisode(state) != null) ...[
            20.verticalSpace,
            _buildSelectedEpisodePanel(
              _findSelectedEpisode(state)!,
              feed,
            ),
          ],
        ],
      ],
    );
  }

  PodcastEpisodeEntity? _findSelectedEpisode(PodcastState state) {
    final key = state.selectedEpisodeKey;
    if (key == null) return null;
    for (final ep in state.episodes) {
      if (_episodeKey(ep) == key) return ep;
    }
    return null;
  }

  Widget _buildEpisodeRow(
    PodcastEpisodeEntity ep,
    PodcastFeedEntity feed, {
    required bool isSelected,
  }) {
    return BlocBuilder<PodcastCubit, PodcastState>(
      buildWhen: (prev, curr) =>
          prev.importStatus != curr.importStatus ||
          prev.selectedEpisodeKey != curr.selectedEpisodeKey,
      builder: (context, podcastState) {
        final isImporting = isSelected &&
            podcastState.importStatus == PodcastImportStatus.importing;
        return GestureDetector(
          onTap: (podcastState.importStatus == PodcastImportStatus.importing)
              ? null
              : () => _onEpisodeTap(ep),
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xff4A59FE).withValues(alpha: 0.08)
                  : Colors.white,
              border: Border.all(
                color: isSelected
                    ? const Color(0xff4A59FE)
                    : const Color(0xffE5E7EB),
                width: isSelected ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildArtwork(ep.image ?? ep.feedImage ?? feed.image, 56),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ep.title ?? 'Untitled episode',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          height: 18 / 14,
                          color: const Color(0xff1E222B),
                        ),
                      ),
                      if ((ep.description ?? '').isNotEmpty) ...[
                        6.verticalSpace,
                        Text(
                          _cleanDescription(ep.description),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            height: 16 / 12,
                            color: const Color(0xff6B7280),
                          ),
                        ),
                      ],
                      8.verticalSpace,
                      Wrap(
                        spacing: 12.w,
                        runSpacing: 4.h,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          _buildMetaItem(
                            Icons.access_time_rounded,
                            ep.formattedDuration,
                          ),
                          _buildMetaItem(
                            Icons.calendar_today_outlined,
                            ep.formattedDate,
                          ),
                          if (ep.hasAudio)
                            Text(
                              'Audio Available',
                              style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 11.sp,
                                color: const Color(0xff16A34A),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isImporting)
                  Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: SizedBox(
                      width: 18.w,
                      height: 18.h,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else if (isSelected)
                  Container(
                    width: 22.w,
                    height: 22.h,
                    decoration: const BoxDecoration(
                      color: Color(0xff4A59FE),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedEpisodePanel(
    PodcastEpisodeEntity episode,
    PodcastFeedEntity feed,
  ) {
    return Container(
      key: _selectedEpisodeKey,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xffEFF6FF),
        border: Border.all(color: const Color(0xffBFDBFE), width: 2),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected Episode',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
              color: const Color(0xff1E222B),
            ),
          ),
          16.verticalSpace,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildArtwork(
                episode.image ?? episode.feedImage ?? feed.image,
                80,
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      episode.title ?? 'Untitled episode',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w500,
                        fontSize: 15.sp,
                        height: 20 / 15,
                        color: const Color(0xff1E222B),
                      ),
                    ),
                    if ((feed.title ?? '').isNotEmpty) ...[
                      4.verticalSpace,
                      Text(
                        feed.title!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 13.sp,
                          color: const Color(0xff2563EB),
                        ),
                      ),
                    ],
                    8.verticalSpace,
                    Wrap(
                      spacing: 12.w,
                      runSpacing: 4.h,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _buildMetaItem(
                          Icons.access_time_rounded,
                          episode.formattedDuration,
                        ),
                        _buildMetaItem(
                          Icons.calendar_today_outlined,
                          episode.formattedDate,
                        ),
                        if (episode.hasAudio)
                          Text(
                            'Audio Available',
                            style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w500,
                              fontSize: 11.sp,
                              color: const Color(0xff16A34A),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if ((episode.description ?? '').isNotEmpty) ...[
            20.verticalSpace,
            Text(
              'Episode Description',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                color: const Color(0xff1E222B),
              ),
            ),
            8.verticalSpace,
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 140.h),
              child: SingleChildScrollView(
                child: Text(
                  _cleanDescription(episode.description),
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                    height: 18 / 12,
                    color: const Color(0xff6B7280),
                  ),
                ),
              ),
            ),
          ],
          20.verticalSpace,
          _buildProcessingOptionsCard(),
          16.verticalSpace,
          _buildStartTranscriptionButton(episode, feed),
        ],
      ),
    );
  }

  Widget _buildProcessingOptionsCard() {
    return BlocBuilder<UrlImportCubit, UrlImportState>(
      builder: (context, importState) {
        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xffE5E7EB)),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.settings_outlined,
                      size: 18.sp, color: const Color(0xff4B5563)),
                  8.horizontalSpace,
                  Text(
                    'Processing Options',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: const Color(0xff111827),
                    ),
                  ),
                ],
              ),
              14.verticalSpace,
              _buildOptionCheckCard(
                emoji: '🎯',
                title: 'Auto Transcribe',
                subtitle: 'Automatically start transcription',
                value: importState.autoTranscribe,
                onChanged: (v) =>
                    context.read<UrlImportCubit>().toggleAutoTranscribe(v),
              ),
              10.verticalSpace,
              _buildOptionCheckCard(
                emoji: '👥',
                title: 'Speaker Identification',
                subtitle: 'Identify different speakers',
                value: importState.speakerIdentification,
                onChanged: (v) => context
                    .read<UrlImportCubit>()
                    .toggleSpeakerIdentification(v),
              ),
              14.verticalSpace,
              _buildAdvancedFeaturesPlaceholder(),
              14.verticalSpace,
              _buildProcessingTimeNote(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionCheckCard({
    required String emoji,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: value ? const Color(0xffEFF6FF) : Colors.white,
          border: Border.all(
            color: value
                ? const Color(0xffBFDBFE)
                : const Color(0xffE5E7EB),
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 18.w,
              height: 18.h,
              child: Checkbox(
                value: value,
                onChanged: (v) => onChanged(v ?? false),
                activeColor: const Color(0xff2563EB),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(emoji, style: TextStyle(fontSize: 16.sp)),
                      8.horizontalSpace,
                      Text(
                        title,
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 13.sp,
                          color: const Color(0xff111827),
                        ),
                      ),
                    ],
                  ),
                  2.verticalSpace,
                  Text(
                    subtitle,
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 11.sp,
                      height: 14 / 11,
                      color: const Color(0xff6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedFeaturesPlaceholder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: () => setState(() => _advancedExpanded = !_advancedExpanded),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: const Color(0xffF9FAFB),
              border: Border.all(color: const Color(0xffE5E7EB)),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Icon(Icons.settings_outlined,
                    size: 16.sp, color: const Color(0xff6B7280)),
                8.horizontalSpace,
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6.w,
                    runSpacing: 2.h,
                    children: [
                      Text(
                        'Advanced AI Features',
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 13.sp,
                          color: const Color(0xff374151),
                        ),
                      ),
                      Text(
                        '($_advancedSelectedCount selected)',
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 11.sp,
                          color: const Color(0xff9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: _advancedExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: Icon(Icons.keyboard_arrow_down_rounded,
                      size: 18.sp, color: const Color(0xff9CA3AF)),
                ),
              ],
            ),
          ),
        ),
        if (_advancedExpanded) ...[
          12.verticalSpace,
          _buildAdvancedContent(),
        ],
      ],
    );
  }

  Widget _buildAdvancedContent() {
    return Container(
      padding: EdgeInsets.only(top: 12.h),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xffE5E7EB))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCreditsNote(),
          12.verticalSpace,
          _buildAdvancedSection(
            'Analysis',
            [
              _AdvancedItem(
                  flag: 'sentimentAnalysis',
                  emoji: '😊',
                  title: 'Sentiment Analysis',
                  subtitle: 'Analyze emotional tone and sentiment',
                  isPro: true),
              _AdvancedItem(
                  flag: 'entityDetection',
                  emoji: '🏢',
                  title: 'Entity Detection',
                  subtitle: 'Extract names, places, and organizations',
                  isPro: true),
              _AdvancedItem(
                  flag: 'topicDetection',
                  emoji: '🏷️',
                  title: 'Topic Detection',
                  subtitle: 'Identify main topics and themes',
                  isPro: true),
            ],
          ),
          16.verticalSpace,
          _buildAdvancedSection(
            'Content Generation',
            [
              _AdvancedItem(
                  flag: 'autoHighlights',
                  emoji: '⭐',
                  title: 'Auto Highlights',
                  subtitle: 'Automatically detect important moments',
                  isPro: true),
              _AdvancedItem(
                  flag: 'autoChapters',
                  emoji: '📑',
                  title: 'Auto Chapters',
                  subtitle: 'Automatically divide content into chapters',
                  isPro: true),
              _AdvancedItem(
                  flag: 'summarization',
                  emoji: '📝',
                  title: 'Summarization',
                  subtitle: 'Generate automatic summaries',
                  isPro: true),
            ],
          ),
          16.verticalSpace,
          _buildAdvancedSection(
            'Safety & Moderation',
            [
              _AdvancedItem(
                  flag: 'contentSafety',
                  emoji: '🛡️',
                  title: 'Content Safety',
                  subtitle: 'Detect sensitive or inappropriate content',
                  isPro: true),
              _AdvancedItem(
                  flag: 'profanityFilter',
                  emoji: '🚫',
                  title: 'Profanity Filter',
                  subtitle: 'Filter out profanity and offensive language',
                  isPro: false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreditsNote() {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xffFFFBEB),
        border: Border.all(color: const Color(0xffFDE68A)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.auto_awesome_rounded,
              size: 14.sp, color: const Color(0xff92400E)),
          8.horizontalSpace,
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 11.sp,
                  height: 15 / 11,
                  color: const Color(0xff92400E),
                ),
                children: const [
                  TextSpan(
                    text: 'Note: ',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text:
                        'Advanced AI features consume additional processing credits. Select only the features you need.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSection(String label, List<_AdvancedItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w600,
            fontSize: 11.sp,
            letterSpacing: 0.5,
            color: const Color(0xff6B7280),
          ),
        ),
        8.verticalSpace,
        for (final item in items)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: _buildAdvancedItem(item),
          ),
      ],
    );
  }

  Widget _buildAdvancedItem(_AdvancedItem item) {
    final value = _advancedFlags[item.flag] ?? false;
    return GestureDetector(
      onTap: () => setState(() => _advancedFlags[item.flag] = !value),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: value
                ? const Color(0xffBFDBFE)
                : const Color(0xffE5E7EB),
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 18.w,
              height: 18.h,
              child: Checkbox(
                value: value,
                onChanged: (v) =>
                    setState(() => _advancedFlags[item.flag] = v ?? false),
                activeColor: const Color(0xff2563EB),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row uses Wrap so the Pro badge falls to a new line
                  // on narrow screens instead of pushing past the right edge.
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8.w,
                    runSpacing: 4.h,
                    children: [
                      Text(item.emoji,
                          style: TextStyle(fontSize: 15.sp)),
                      Text(
                        item.title,
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 13.sp,
                          color: const Color(0xff111827),
                        ),
                      ),
                      if (item.isPro) _buildProBadge(),
                    ],
                  ),
                  4.verticalSpace,
                  Text(
                    item.subtitle,
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 11.sp,
                      height: 14 / 11,
                      color: const Color(0xff6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: const Color(0xffF3E8FF),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome_rounded,
              size: 10.sp, color: const Color(0xff6B21A8)),
          3.horizontalSpace,
          Text(
            'Pro',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w600,
              fontSize: 10.sp,
              color: const Color(0xff6B21A8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingTimeNote() {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xffEFF6FF),
        border: Border.all(color: const Color(0xffBFDBFE)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w400,
            fontSize: 11.sp,
            height: 15 / 11,
            color: const Color(0xff1E40AF),
          ),
          children: const [
            TextSpan(text: '⏱️ '),
            TextSpan(
              text: 'Processing Time: ',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(
              text:
                  "Transcription typically takes 1-3 minutes for most recordings. You'll receive a notification when it's complete, and you can continue using the app while processing runs in the background.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartTranscriptionButton(
    PodcastEpisodeEntity episode,
    PodcastFeedEntity feed,
  ) {
    return BlocBuilder<PodcastCubit, PodcastState>(
      buildWhen: (prev, curr) => prev.importStatus != curr.importStatus,
      builder: (context, podcastState) {
        final isImporting =
            podcastState.importStatus == PodcastImportStatus.importing;
        return GestureDetector(
          onTap: isImporting ? null : () => _startTranscription(episode, feed),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: isImporting ? 0.6 : 1.0,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: const Color(0xff2563EB),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isImporting) ...[
                    SizedBox(
                      width: 16.w,
                      height: 16.h,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    8.horizontalSpace,
                  ],
                  Text(
                    isImporting ? 'Starting…' : 'Start Transcription',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildArtwork(String? url, double size) {
    if (url == null || url.isEmpty) {
      return Container(
        width: size.w,
        height: size.h,
        decoration: BoxDecoration(
          color: const Color(0xffF3F4F6),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: const Color(0xffE5E7EB)),
        ),
        child: Icon(
          Icons.podcasts_rounded,
          size: (size * 0.5).sp,
          color: const Color(0xff9CA3AF),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Image.network(
        url,
        width: size.w,
        height: size.h,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(color: const Color(0xffF3F4F6));
        },
        errorBuilder: (context, error, stack) => Container(
          width: size.w,
          height: size.h,
          color: const Color(0xffF3F4F6),
          child: Icon(
            Icons.podcasts_rounded,
            size: (size * 0.5).sp,
            color: const Color(0xff9CA3AF),
          ),
        ),
      ),
    );
  }

  Widget _buildMetaItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12.sp, color: const Color(0xff6B7280)),
        4.horizontalSpace,
        Text(
          text,
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w400,
            fontSize: 11.sp,
            color: const Color(0xff6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyHint(String text, {bool isError = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w400,
            fontSize: 13.sp,
            color: isError
                ? const Color(0xffDC2626)
                : const Color(0xff8C8C8C),
          ),
        ),
      ),
    );
  }
}

class _AdvancedItem {
  final String flag;
  final String emoji;
  final String title;
  final String subtitle;
  final bool isPro;

  const _AdvancedItem({
    required this.flag,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.isPro,
  });
}
