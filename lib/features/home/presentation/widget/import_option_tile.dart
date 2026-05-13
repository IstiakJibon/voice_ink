import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';
import 'package:voice_ink/features/home/presentation/pages/upload_files_screen.dart';
import 'package:voice_ink/features/podcast/presentation/pages/podcast_search_screen.dart';
import 'package:voice_ink/features/scan/presentation/pages/scan_notes_screen.dart';
import 'package:voice_ink/features/url_import/presentation/pages/from_url_import_screen.dart';
import 'package:voice_ink/features/url_import/presentation/pages/youtube_import_screen.dart';

class ImportOption {
  final String id;
  final String title;
  final String subtitle;
  final String icon;
  final Color iconColor;
  final Color bgColor;

  const ImportOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });
}

class ImportOptionTile extends StatelessWidget {
  final ImportOption option;
  final bool showDivider;
  final VoidCallback? onTap;

  const ImportOptionTile({
    super.key,
    required this.option,
    this.showDivider = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          border: showDivider
              ? const Border(
                  bottom: BorderSide(color: Color(0xffF2F2F7)),
                )
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: option.bgColor,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  option.icon,
                  width: 24.w,
                  height: 24.h,
                  colorFilter: ColorFilter.mode(
                    option.iconColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            8.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                      height: 20 / 15,
                      letterSpacing: -0.23,
                      color: const Color(0xff000000),
                    ),
                  ),
                  2.verticalSpace,
                  Text(
                    option.subtitle,
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                      height: 18 / 13,
                      letterSpacing: -0.08,
                      color: const Color(0xff999999),
                    ),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              AppAssets.chevronRight,
              width: 24.w,
              height: 24.h,
              colorFilter: const ColorFilter.mode(
                Color(0xff8E8E93),
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImportOptionsCard extends StatelessWidget {
  const ImportOptionsCard({super.key});

  static const List<ImportOption> _options = [
    ImportOption(
      id: 'upload',
      title: 'Upload Files',
      subtitle: 'MP3, WAV, M4A',
      icon: AppAssets.cloudUpload,
      iconColor: Color(0xff4A59FE),
      bgColor: Color(0xffECF4FE),
    ),
    ImportOption(
      id: 'youtube',
      title: 'YouTube',
      subtitle: 'Paste a YouTube URL',
      icon: AppAssets.youtube,
      iconColor: Color(0xffEA001C),
      bgColor: Color(0xffFFF0F0),
    ),
    ImportOption(
      id: 'link',
      title: 'From Link',
      subtitle: 'Direct audio URL',
      icon: AppAssets.link,
      iconColor: Color(0xff1D9D70),
      bgColor: Color(0xffE7FDF4),
    ),
    ImportOption(
      id: 'scan',
      title: 'Scan Doc',
      subtitle: 'Import from image',
      icon: AppAssets.scan,
      iconColor: Color(0xffFA4100),
      bgColor: Color(0xffFFF6EB),
    ),
    ImportOption(
      id: 'podcast',
      title: 'Podcast',
      subtitle: 'Search & transcribe',
      icon: AppAssets.podcast,
      iconColor: Color(0xff9F17F5),
      bgColor: Color(0xffFAF3FF),
    ),
  ];

  void _handleTap(BuildContext context, String id) {
    switch (id) {
      case 'upload':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const UploadFilesScreen()),
        );
        break;
      case 'youtube':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const YouTubeImportScreen()),
        );
        break;
      case 'link':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FromUrlImportScreen()),
        );
        break;
      case 'scan':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ScanNotesScreen()),
        );
        break;
      case 'podcast':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PodcastSearchScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffF2F2F7)),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: List.generate(_options.length, (index) {
          final option = _options[index];
          final isLast = index == _options.length - 1;
          return ImportOptionTile(
            option: option,
            showDivider: !isLast,
            onTap: () => _handleTap(context, option.id),
          );
        }),
      ),
    );
  }
}