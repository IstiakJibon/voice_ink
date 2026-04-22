import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';

enum FileStatus { recorded, transcribed }

class RecentFile {
  final String id;
  final String title;
  final String duration;
  final String date;
  final FileStatus status;
  final Color iconColor;
  final Color bgColor;
  final VoidCallback? onPlay;
  final VoidCallback? onMore;
  final VoidCallback? onTap;

  const RecentFile({
    required this.id,
    required this.title,
    required this.duration,
    required this.date,
    required this.status,
    required this.iconColor,
    required this.bgColor,
    this.onPlay,
    this.onMore,
    this.onTap,
  });
}

class RecentFileTile extends StatelessWidget {
  final RecentFile file;

  const RecentFileTile({
    super.key,
    required this.file,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: file.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffF2F2F7)),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            // Checkbox
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xff8C8C8C)),
              ),
            ),
            8.horizontalSpace,
            // Icon
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: file.bgColor,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.scratchpad,
                  width: 24.w,
                  height: 24.h,
                  colorFilter: ColorFilter.mode(
                    file.iconColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            4.horizontalSpace,
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file.title,
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
                      // Duration
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
                        file.duration,
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 13.sp,
                          height: 18 / 13,
                          letterSpacing: -0.08,
                          color: const Color(0xff999999),
                        ),
                      ),
                      8.horizontalSpace,
                      // Date
                      Text(
                        file.date,
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 13.sp,
                          height: 18 / 13,
                          letterSpacing: -0.08,
                          color: const Color(0xff999999),
                        ),
                      ),
                      8.horizontalSpace,
                      // Dot separator
                      Container(
                        width: 8.w,
                        height: 8.h,
                        decoration: const BoxDecoration(
                          color: Color(0xffE5E5EA),
                          shape: BoxShape.circle,
                        ),
                      ),
                      8.horizontalSpace,
                      // Status
                      Text(
                        file.status == FileStatus.recorded
                            ? 'Recorded'
                            : 'Transcribed',
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 13.sp,
                          height: 18 / 13,
                          letterSpacing: -0.08,
                          color: file.status == FileStatus.recorded
                              ? const Color(0xffFE8F4A)
                              : const Color(0xff1D9D70),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Action buttons
            Opacity(
              opacity: 0.8,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: file.onPlay,
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
                    onTap: file.onMore,
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
                ],
              ),
            ),
            4.horizontalSpace,
          ],
        ),
      ),
    );
  }
}

class RecentFilesCard extends StatelessWidget {
  const RecentFilesCard({super.key});

  static final List<RecentFile> _files = [
    RecentFile(
      id: '1',
      title: 'Meeting Note 11',
      duration: '30:15',
      date: 'Now',
      status: FileStatus.recorded,
      iconColor: const Color(0xffFA4100),
      bgColor: const Color(0xffFFF6EB),
    ),
    RecentFile(
      id: '2',
      title: 'Meeting Note 33',
      duration: '12:15',
      date: 'Dec 30',
      status: FileStatus.transcribed,
      iconColor: const Color(0xff4A59FE),
      bgColor: const Color(0xffECF4FE),
    ),
    RecentFile(
      id: '3',
      title: 'Meeting Note 31',
      duration: '12:15',
      date: 'Dec 30',
      status: FileStatus.transcribed,
      iconColor: const Color(0xff4A59FE),
      bgColor: const Color(0xffECF4FE),
    ),
    RecentFile(
      id: '4',
      title: 'Meeting Note 58',
      duration: '14:30',
      date: 'Feb 2',
      status: FileStatus.transcribed,
      iconColor: const Color(0xff4A59FE),
      bgColor: const Color(0xffECF4FE),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(_files.length, (index) {
        return Padding(
          padding: EdgeInsets.only(bottom: index < _files.length - 1 ? 16.h : 0),
          child: RecentFileTile(file: _files[index]),
        );
      }),
    );
  }
}