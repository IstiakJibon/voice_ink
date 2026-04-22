import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';
import 'package:voice_ink/config/utilities/enum/bloc_api_state.dart';
import 'package:voice_ink/config/utilities/extensions/user_extension.dart';
import 'package:voice_ink/features/files/domain/entities/audio_file_entities.dart';
import 'package:voice_ink/features/files/presentation/cubit/files_cubit.dart';
import 'package:voice_ink/features/files/presentation/cubit/files_state.dart';
import 'package:voice_ink/features/files/presentation/widget/create_folder_dialog.dart';
import 'package:voice_ink/features/files/presentation/widget/file_option_popup.dart';
import 'package:voice_ink/features/files/presentation/widget/filter_bottom_sheet.dart';
import 'package:voice_ink/features/files/presentation/widget/sort_options_popup.dart';
import 'package:voice_ink/features/files/presentation/pages/transcript_detail_screen.dart';

class FolderItem {
  final String id;
  final String name;
  final int fileCount;

  const FolderItem({
    required this.id,
    required this.name,
    required this.fileCount,
  });
}

class FilesScreen extends StatefulWidget {
  const FilesScreen({super.key});

  @override
  State<FilesScreen> createState() => _FilesScreenState();
}

class _FilesScreenState extends State<FilesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _sortButtonKey = GlobalKey();
  SortOption _selectedSortOption = SortOption.date;
  int _selectedFilterIndex = 0;
  bool _foldersExpanded = false;
  bool _isGridView = false;
  final List<String> _filters = ['All', 'Recorded', 'Uploaded', 'YouTube'];

  final Map<String, GlobalKey> _fileMoreButtonKeys = {};

  GlobalKey _getMoreButtonKey(String fileId) {
    if (!_fileMoreButtonKeys.containsKey(fileId)) {
      _fileMoreButtonKeys[fileId] = GlobalKey();
    }
    return _fileMoreButtonKeys[fileId]!;
  }

  // Static folders for now
  final List<FolderItem> _folders = [
    const FolderItem(id: '1', name: 'Recording', fileCount: 6),
    const FolderItem(id: '2', name: 'Interviews', fileCount: 20),
    const FolderItem(id: '3', name: 'Ideas', fileCount: 14),
    const FolderItem(id: '4', name: 'Meetings', fileCount: 8),
    const FolderItem(id: '5', name: 'Podcasts', fileCount: 12),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Fetch files on init with token from context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FilesCubit>().getAudioFiles(token: context.token);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<FilesCubit>().loadMoreFiles();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }


Color _getIconColor(AudioFileEntity file) {
  switch (file.transcriptionStatus) {
    case 'completed':
      return const Color(0xff4A59FE);
    case 'pending':
    case 'processing':
      return const Color(0xffFA4100);
    case 'failed':
      return const Color(0xffEA001C);
    default:
      return const Color(0xffFA4100);  // Default to orange for null/unknown
  }
}

Color _getIconBgColor(AudioFileEntity file) {
  switch (file.transcriptionStatus) {
    case 'completed':
      return const Color(0xffECF4FE);
    case 'pending':
    case 'processing':
      return const Color(0xffFFF6EB);
    case 'failed':
      return const Color(0xffFFF0F0);
    default:
      return const Color(0xffFFF6EB);  // Default to orange bg for null/unknown
  }
}

String _getStatusText(String? transcriptionStatus) {
  switch (transcriptionStatus) {
    case 'completed':
      return 'Transcribed';
    case 'pending':
      return 'Pending';
    case 'processing':
      return 'Processing';
    case 'failed':
      return 'Failed';
    default:
      return 'Processing';  // Default to Processing for null
  }
}

Color _getStatusColor(String? transcriptionStatus) {
  switch (transcriptionStatus) {
    case 'completed':
      return const Color(0xff1D9D70);
    case 'pending':
    case 'processing':
      return const Color(0xffFE8F4A);
    case 'failed':
      return const Color(0xffFE4A4D);
    default:
      return const Color(0xffFE8F4A);  // Default to orange for null
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  16.verticalSpace,
                  // Header
                  _buildHeader(),
                  24.verticalSpace,
                  // Search bar
                  _buildSearchBar(),
                  16.verticalSpace,
                  // Filter tabs
                  _buildFilterTabs(),
                  16.verticalSpace,
                  // Folders header
                  _buildFoldersHeader(),
                ],
              ),
            ),
            16.verticalSpace,
            // Scrollable content
            Expanded(
              child: BlocBuilder<FilesCubit, FilesState>(
                builder: (context, state) {
                  return RefreshIndicator(
                    onRefresh: () => context.read<FilesCubit>().refreshFiles(),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          // Folders content
                          _foldersExpanded
                              ? _buildExpandedFoldersInline()
                              : _buildCollapsedFoldersInline(),
                          16.verticalSpace,
                          // Files header
                          _buildFilesHeader(state),
                          8.verticalSpace,
                          // Files content
                          _buildFilesContent(state),
                          // Loading more indicator
                          if (state.isLoadingMore)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xff4A59FE),
                                ),
                              ),
                            ),
                          32.verticalSpace,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 44.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Files',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
              height: 25 / 20,
              letterSpacing: -0.45,
              color: const Color(0xff000000),
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  CreateFolderDialog.show(context, (folderName) {
                    // Handle folder creation
                  });
                },
                child: SizedBox(
                  width: 44.w,
                  height: 44.h,
                  child: Center(
                    child: SvgPicture.asset(
                      AppAssets.collections,
                      width: 24.w,
                      height: 24.h,
                      colorFilter: const ColorFilter.mode(
                        Color(0xff04071E),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
              4.horizontalSpace,
              GestureDetector(
                onTap: () {
                  FilterBottomSheet.show(context);
                },
                child: SizedBox(
                  width: 44.w,
                  height: 44.h,
                  child: Center(
                    child: SvgPicture.asset(
                      AppAssets.filter,
                      width: 24.w,
                      height: 24.h,
                      colorFilter: const ColorFilter.mode(
                        Color(0xff000000),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
              4.horizontalSpace,
              GestureDetector(
                key: _sortButtonKey,
                onTap: () {
                  SortOptionsPopup.show(
                    context,
                    _sortButtonKey,
                    selectedOption: _selectedSortOption,
                    onOptionSelected: (option) {
                      setState(() {
                        _selectedSortOption = option;
                      });
                      // Update sort in cubit
                      String sortBy = 'createdAt';
                      String sortOrder = 'DESC';
                      switch (option) {
                        case SortOption.name:
                          sortBy = 'name';
                          sortOrder = 'ASC';
                          break;
                        case SortOption.date:
                          sortBy = 'createdAt';
                          sortOrder = 'DESC';
                          break;
                        case SortOption.duration:
                          sortBy = 'duration';
                          sortOrder = 'DESC';
                          break;
                      }
                      context.read<FilesCubit>().changeSortOption(
                            sortBy: sortBy,
                            sortOrder: sortOrder,
                          );
                    },
                  );
                },
                child: SizedBox(
                  width: 44.w,
                  height: 44.h,
                  child: Center(
                    child: SvgPicture.asset(
                      AppAssets.arrowSort,
                      width: 24.w,
                      height: 24.h,
                      colorFilter: const ColorFilter.mode(
                        Color(0xff04071E),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextFormField(
      controller: _searchController,
      style: GoogleFonts.dmSans(
        fontWeight: FontWeight.w400,
        fontSize: 17.sp,
        height: 22 / 17,
        letterSpacing: -0.43,
        color: const Color(0xff000000),
      ),
      decoration: InputDecoration(
        hintText: 'Search in files, folders or dates',
        hintStyle: GoogleFonts.dmSans(
          fontWeight: FontWeight.w400,
          fontSize: 17.sp,
          height: 22 / 17,
          letterSpacing: -0.43,
          color: const Color(0xff999999),
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.all(14.w),
          child: SvgPicture.asset(
            AppAssets.search,
            width: 21.w,
            height: 22.h,
            colorFilter: const ColorFilter.mode(
              Color(0xff999999),
              BlendMode.srcIn,
            ),
          ),
        ),
        filled: true,
        fillColor: const Color(0xffF2F2F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 14.h),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return SizedBox(
      height: 34.h,
      child: Row(
        children: List.generate(_filters.length, (index) {
          final isSelected = _selectedFilterIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilterIndex = index;
                });
              },
              child: Container(
                margin: EdgeInsets.only(
                  right: index < _filters.length - 1 ? 8.w : 0,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xff4A59FE)
                      : Colors.transparent,
                  border: isSelected
                      ? null
                      : Border.all(color: const Color(0xff999999)),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Text(
                    _filters[index],
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.sp,
                      height: 20 / 15,
                      letterSpacing: -0.23,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xff999999),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFoldersHeader() {
    return SizedBox(
      height: 44.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Folders(${_folders.length})',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
              height: 18 / 16,
              letterSpacing: -0.08,
              color: const Color(0xff000000),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _foldersExpanded = !_foldersExpanded;
              });
            },
            child: Row(
              children: [
                Text(
                  _foldersExpanded ? 'Collapse' : 'View all',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    height: 18 / 16,
                    letterSpacing: -0.08,
                    color: const Color(0xff4A59FE),
                  ),
                ),
                8.horizontalSpace,
                AnimatedRotation(
                  turns: _foldersExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: SvgPicture.asset(
                    AppAssets.chevronDown,
                    width: 24.w,
                    height: 24.h,
                    colorFilter: const ColorFilter.mode(
                      Color(0xff4A59FE),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsedFoldersInline() {
    return SizedBox(
      height: 124.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _folders.length,
        separatorBuilder: (context, index) => 8.horizontalSpace,
        itemBuilder: (context, index) {
          return _buildFolderCardSmall(_folders[index]);
        },
      ),
    );
  }

  Widget _buildExpandedFoldersInline() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 177 / 150,
      ),
      itemCount: _folders.length,
      itemBuilder: (context, index) {
        return _buildFolderCardLarge(_folders[index]);
      },
    );
  }

  Widget _buildFolderCardSmall(FolderItem folder) {
    return Container(
      width: 133.w,
      height: 124.h,
      padding: EdgeInsets.all(9.5.w),
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F7),
        borderRadius: BorderRadius.circular(11.875.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            AppAssets.folderS,
            width: 38.w,
            height: 38.h,
            colorFilter: const ColorFilter.mode(
              Color(0xff4A59FE),
              BlendMode.srcIn,
            ),
          ),
          10.69.verticalSpace,
          Text(
            folder.name,
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w400,
              fontSize: 19.sp,
              height: 25 / 19,
              letterSpacing: -0.368125,
              color: const Color(0xff000000),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          9.5.verticalSpace,
          Text(
            '${folder.fileCount} Files',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w400,
              fontSize: 15.4375.sp,
              height: 21 / 15.4375,
              letterSpacing: -0.095,
              color: const Color(0xff999999),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFolderCardLarge(FolderItem folder) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F7),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            AppAssets.folderS,
            width: 50.57.w,
            height: 50.57.h,
            colorFilter: const ColorFilter.mode(
              Color(0xff4A59FE),
              BlendMode.srcIn,
            ),
          ),
          16.verticalSpace,
          Text(
            folder.name,
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w600,
              fontSize: 17.sp,
              height: 22 / 17,
              letterSpacing: -0.43,
              color: const Color(0xff000000),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          8.verticalSpace,
          Text(
            '${folder.fileCount} Files',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
              height: 21 / 16,
              letterSpacing: -0.31,
              color: const Color(0xff999999),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilesHeader(FilesState state) {
    return SizedBox(
      height: 44.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Files(${state.audioFiles.total})',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
              height: 18 / 16,
              letterSpacing: -0.08,
              color: const Color(0xff000000),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffF2F2F7)),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isGridView = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: !_isGridView
                          ? const Color(0xffF2F2F7)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.list,
                      colorFilter: ColorFilter.mode(
                        !_isGridView
                            ? const Color(0xff404040)
                            : const Color(0xff999999),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                8.horizontalSpace,
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isGridView = true;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: _isGridView
                          ? const Color(0xffF2F2F7)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.table,
                      colorFilter: ColorFilter.mode(
                        _isGridView
                            ? const Color(0xff404040)
                            : const Color.fromRGBO(60, 60, 67, 0.6),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilesContent(FilesState state) {
    if (state.apiState == NormalApiState.loading) {
      return _buildLoadingShimmer();
    }

    if (state.apiState == NormalApiState.failure) {
      return _buildErrorWidget(state.errorMessage);
    }

    if (state.allFiles.isEmpty) {
      return _buildEmptyWidget();
    }

    final groupedFiles = state.groupedFiles;

    if (_isGridView) {
      return _buildGridFilesContent(groupedFiles);
    } else {
      return _buildListFilesContent(groupedFiles);
    }
  }

  Widget _buildLoadingShimmer() {
    return Column(
      children: List.generate(
        5,
        (index) => Container(
          height: 80.h,
          margin: EdgeInsets.only(bottom: 8.h),
          decoration: BoxDecoration(
            color: const Color(0xffF2F2F7),
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48.w,
            color: const Color(0xffFE4A4D),
          ),
          16.verticalSpace,
          Text(
            message,
            style: GoogleFonts.dmSans(
              fontSize: 16.sp,
              color: const Color(0xff999999),
            ),
            textAlign: TextAlign.center,
          ),
          16.verticalSpace,
          GestureDetector(
            onTap: () => context.read<FilesCubit>().getAudioFiles(token: context.token),
            child: Text(
              'Tap to retry',
              style: GoogleFonts.dmSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xff4A59FE),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppAssets.scratchpad,
            width: 48.w,
            height: 48.h,
            colorFilter: const ColorFilter.mode(
              Color(0xff999999),
              BlendMode.srcIn,
            ),
          ),
          16.verticalSpace,
          Text(
            'No files yet',
            style: GoogleFonts.dmSans(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff000000),
            ),
          ),
          8.verticalSpace,
          Text(
            'Start recording or upload a file',
            style: GoogleFonts.dmSans(
              fontSize: 14.sp,
              color: const Color(0xff999999),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListFilesContent(Map<String, List<AudioFileEntity>> groupedFiles) {
    final groups = groupedFiles.entries.toList();
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: groups.length,
      itemBuilder: (context, groupIndex) {
        final group = groups[groupIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateHeader(group.key),
            4.verticalSpace,
            ...group.value.map(
              (file) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: _buildListFileCard(file),
              ),
            ),
            if (groupIndex < groups.length - 1) 24.verticalSpace,
          ],
        );
      },
    );
  }

  Widget _buildGridFilesContent(Map<String, List<AudioFileEntity>> groupedFiles) {
    final groups = groupedFiles.entries.toList();
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: groups.length,
      itemBuilder: (context, groupIndex) {
        final group = groups[groupIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateHeader(group.key),
            8.verticalSpace,
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 177 / 124,
              ),
              itemCount: group.value.length,
              itemBuilder: (context, index) {
                return _buildGridFileCard(group.value[index]);
              },
            ),
            if (groupIndex < groups.length - 1) 32.verticalSpace,
          ],
        );
      },
    );
  }

  Widget _buildDateHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          SvgPicture.asset(
            AppAssets.calendar,
            width: 24.w,
            height: 24.h,
            colorFilter: const ColorFilter.mode(
              Color.fromRGBO(60, 60, 67, 0.6),
              BlendMode.srcIn,
            ),
          ),
          8.horizontalSpace,
          Text(
            title,
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
              height: 18 / 16,
              letterSpacing: -0.08,
              color: const Color(0xff8C8C8C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListFileCard(AudioFileEntity file) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TranscriptDetailScreen(
              fileId: file.id ?? '',
            ),
          ),
        );
      },
      child: Container(
        height: 80.h,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffF2F2F7)),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xff8C8C8C)),
              ),
            ),
            8.horizontalSpace,
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: _getIconBgColor(file),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.scratchpad,
                  width: 24.w,
                  height: 24.h,
                  colorFilter: ColorFilter.mode(
                    _getIconColor(file),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            4.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    file.name ?? 'Untitled',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                      height: 20 / 15,
                      letterSpacing: -0.23,
                      color: const Color(0xff000000),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  8.verticalSpace,
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppAssets.clock,
                        width: 16.w,
                        height: 16.h,
                        colorFilter: const ColorFilter.mode(
                          Color(0xffE5E5EA),
                          BlendMode.srcIn,
                        ),
                      ),
                      6.horizontalSpace,
                      Text(
                        file.formattedDuration,
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 13.sp,
                          height: 18 / 13,
                          letterSpacing: -0.08,
                          color: const Color(0xff999999),
                        ),
                      ),
                      8.horizontalSpace,
                      Text(
                        file.formattedDate,
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 13.sp,
                          height: 18 / 13,
                          letterSpacing: -0.08,
                          color: const Color(0xff999999),
                        ),
                      ),
                      6.horizontalSpace,
                      Container(
                        width: 8.w,
                        height: 8.h,
                        decoration: const BoxDecoration(
                          color: Color(0xffE5E5EA),
                          shape: BoxShape.circle,
                        ),
                      ),
                      8.horizontalSpace,
                      Text(
                        _getStatusText(file.transcriptionStatus),
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 13.sp,
                          height: 18 / 13,
                          letterSpacing: -0.08,
                          color: _getStatusColor(file.transcriptionStatus),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset(
                    AppAssets.play,
                    width: 24.w,
                    height: 24.h,
                    colorFilter: const ColorFilter.mode(
                      Color(0xff1E222B),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                16.horizontalSpace,
                GestureDetector(
                  key: _getMoreButtonKey(file.id ?? ''),
                  onTap: () {
                    FileOptionsPopup.show(context, _getMoreButtonKey(file.id ?? ''),);
                  },
                  child: SvgPicture.asset(
                    AppAssets.more,
                    width: 24.w,
                    height: 24.h,
                    colorFilter: const ColorFilter.mode(
                      Color(0xff1E222B),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                4.horizontalSpace,
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridFileCard(AudioFileEntity file) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TranscriptDetailScreen(
              fileId: file.id ?? '',
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffF2F2F7)),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xff8C8C8C)),
                  ),
                ),
                8.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: _getIconBgColor(file),
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                AppAssets.scratchpad,
                                width: 24.w,
                                height: 24.h,
                                colorFilter: ColorFilter.mode(
                                  _getIconColor(file),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            key: _getMoreButtonKey(file.id ?? ''),
                            onTap: () {
                              FileOptionsPopup.show(
                                context,
                                _getMoreButtonKey(file.id ?? ''),
                              );
                            },
                            child: SvgPicture.asset(
                              AppAssets.more,
                              width: 24.w,
                              height: 24.h,
                              colorFilter: const ColorFilter.mode(
                                Color(0xffE5E5EA),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ],
                      ),
                      4.verticalSpace,
                      Text(
                       file.name ?? 'Untitled',
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 15.sp,
                          height: 20 / 15,
                          letterSpacing: -0.23,
                          color: const Color(0xff000000),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      8.verticalSpace,
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppAssets.clock,
                            width: 16.w,
                            height: 16.h,
                            colorFilter: const ColorFilter.mode(
                              Color(0xffE5E5EA),
                              BlendMode.srcIn,
                            ),
                          ),
                          4.horizontalSpace,
                          Text(
                            file.formattedDuration,
                            style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w400,
                              fontSize: 13.sp,
                              height: 18 / 13,
                              letterSpacing: -0.08,
                              color: const Color(0xff999999),
                            ),
                          ),
                          4.horizontalSpace,
                          Container(
                            width: 8.w,
                            height: 8.h,
                            decoration: const BoxDecoration(
                              color: Color(0xffE5E5EA),
                              shape: BoxShape.circle,
                            ),
                          ),
                          4.horizontalSpace,
                          Text(
                            file.formattedDate,
                            style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w400,
                              fontSize: 12.sp,
                              height: 18 / 13,
                              letterSpacing: -0.08,
                              color: const Color(0xff999999),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}