import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';

class NotificationItem {
  final String title;
  final String description;
  final String time;
  final bool isRead;

  NotificationItem({
    required this.title,
    required this.description,
    required this.time,
    required this.isRead,
  });
}

class NotificationPopup extends StatelessWidget {
  const NotificationPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      NotificationItem(
        title: 'Transcription Complete',
        description:
            'Your recording "recording-1767192096641.webm" has been successfully transcribed.',
        time: '18 hours ago',
        isRead: false,
      ),
      NotificationItem(
        title: 'Transcription Complete',
        description:
            'Your recording "recording-1767192096641.webm" has been successfully transcribed.',
        time: '18 hours ago',
        isRead: false,
      ),
      NotificationItem(
        title: 'Transcription Complete',
        description:
            'Your recording "recording-1767192096641.webm" has been successfully transcribed.',
        time: '18 hours ago',
        isRead: true,
      ),
    ];

    final unreadCount = notifications.where((n) => !n.isRead).length;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 100.h),
      alignment: Alignment.topCenter,
      child: Container(
        width: 370.w,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xffF2F2F7)),
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: const [
            BoxShadow(
              offset: Offset(4, 5),
              blurRadius: 15,
              color: Color.fromRGBO(68, 72, 126, 0.1),
            ),
            BoxShadow(
              offset: Offset(17, 21),
              blurRadius: 27,
              color: Color.fromRGBO(68, 72, 126, 0.09),
            ),
            BoxShadow(
              offset: Offset(39, 47),
              blurRadius: 37,
              color: Color.fromRGBO(68, 72, 126, 0.05),
            ),
            BoxShadow(
              offset: Offset(69, 84),
              blurRadius: 44,
              color: Color.fromRGBO(68, 72, 126, 0.01),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context, unreadCount),
              16.verticalSpace,
              ...notifications.map(
                (notification) => _buildNotificationTile(notification),
              ),
              8.verticalSpace,
              _buildViewAllButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int unreadCount) {
    return SizedBox(
      height: 44.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(AppAssets.alertBell, width: 20.w, height: 20.h),
              8.horizontalSpace,
              Text(
                'Notifications',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  height: 21 / 16,
                  letterSpacing: -0.31,
                  color: const Color(0xff000000),
                ),
              ),
              8.horizontalSpace,
              if (unreadCount > 0)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xff4A59FE),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Text(
                    '$unreadCount New',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                      height: 18 / 13,
                      letterSpacing: -0.08,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  // Clear all action
                },
                child: Text(
                  'Clear all',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    height: 21 / 16,
                    letterSpacing: -0.31,
                    color: const Color(0xff8C8C8C),
                  ),
                ),
              ),
              16.horizontalSpace,
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: SvgPicture.asset(
                  AppAssets.dismiss,
                  width: 24.w,
                  height: 24.h,
                  colorFilter: const ColorFilter.mode(
                    Color(0xff8C8C8C),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(NotificationItem notification) {
    final isRead = notification.isRead;

    return Container(
      padding: EdgeInsets.only(bottom: 8.h),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xffF2F2F7))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  notification.title,
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                    height: 18 / 13,
                    letterSpacing: -0.08,
                    color: isRead
                        ? const Color(0xff999999)
                        : const Color(0xff333333),
                  ),
                ),
              ),
              if (!isRead)
                Container(
                  width: 10.w,
                  height: 10.h,
                  decoration: const BoxDecoration(
                    color: Color(0xff4A59FE),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          8.verticalSpace,
          Text(
            notification.description,
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w400,
              fontSize: 13.sp,
              height: 18 / 13,
              letterSpacing: -0.08,
              color: isRead ? const Color(0xff8C8C8C) : const Color(0xff333333),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          8.verticalSpace,
          Text(
            notification.time,
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              height: 16 / 12,
              color: const Color(0xff999999),
            ),
          ),
          8.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildViewAllButton() {
    return GestureDetector(
      onTap: () {
        // Navigate to all notifications
      },
      child: Container(
        width: double.infinity,
        height: 34.h,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(40.r)),
        alignment: Alignment.center,
        child: Text(
          'View all notifications',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w600,
            fontSize: 15.sp,
            height: 20 / 15,
            letterSpacing: -0.23,
            color: const Color(0xff4A59FE),
          ),
        ),
      ),
    );
  }
}