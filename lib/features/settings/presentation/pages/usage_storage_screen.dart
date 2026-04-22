import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';

class UsageStorageScreen extends StatefulWidget {
  const UsageStorageScreen({super.key});

  @override
  State<UsageStorageScreen> createState() => _UsageStorageScreenState();
}

class _UsageStorageScreenState extends State<UsageStorageScreen> {
  // Sample data - replace with actual data
  final double _transcriptionUsed = 7.0;
  final double _transcriptionTotal = 2500;
  final double _aiTokensUsed = 0.0;
  final double _aiTokensTotal = 0.0;
  final double _storageUsed = 4.3;
  final double _storageTotal = 2048;
  final int _totalFiles = 7;

  final List<Map<String, dynamic>> _recentActivities = [
    {
      'fileName': 'recording-1767707369957.webm',
      'date': 'Jan 6, 04:32 PM',
      'duration': '32.0s',
      'language': 'EN',
      'minutes': 1.0,
    },
    {
      'fileName': 'recording-1767707369957.webm',
      'date': 'Jan 6, 04:32 PM',
      'duration': '32.0s',
      'language': 'EN',
      'minutes': 1.0,
    },
    {
      'fileName': 'recording-1767707369957.webm',
      'date': 'Jan 6, 04:32 PM',
      'duration': '32.0s',
      'language': 'EN',
      'minutes': 1.0,
    },
    {
      'fileName': 'recording-1767707369957.webm',
      'date': 'Jan 6, 04:32 PM',
      'duration': '32.0s',
      'language': 'EN',
      'minutes': 1.0,
    },
  ];

  int _visibleActivities = 4;
  final int _remainingActivities = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            _buildAppBar(),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    8.verticalSpace,
                    // Usage Overview section
                    _buildUsageOverviewHeader(),
                    8.verticalSpace,
                    // Transcription Minutes card
                    _buildUsageCard(
                      label: 'TRANSCRIPTION MINUTES',
                      used: _transcriptionUsed,
                      total: _transcriptionTotal,
                      unit: 'min',
                      remaining: '${(_transcriptionTotal - _transcriptionUsed).toStringAsFixed(1)}K minutes remaining',
                      percentage: (_transcriptionUsed / _transcriptionTotal * 100).round(),
                      color: const Color(0xff4A59FE),
                      badgeColor: const Color(0xffECF4FE),
                    ),
                    16.verticalSpace,
                    // AI Tokens card
                    _buildUsageCard(
                      label: 'AI TOKENS',
                      used: _aiTokensUsed,
                      total: _aiTokensTotal,
                      unit: '',
                      remaining: '${_aiTokensTotal.toStringAsFixed(1)} tokens remaining',
                      percentage: _aiTokensTotal > 0 ? (_aiTokensUsed / _aiTokensTotal * 100).round() : 0,
                      color: const Color(0xff1D9D70),
                      badgeColor: const Color(0xffE7FDF4),
                    ),
                    16.verticalSpace,
                    // Storage card
                    _buildUsageCard(
                      label: 'STORAGE',
                      used: _storageUsed,
                      total: _storageTotal,
                      unit: 'MB',
                      remaining: '$_totalFiles files ${(_storageTotal - _storageUsed).toStringAsFixed(1)} MB remaining',
                      percentage: (_storageUsed / _storageTotal * 100).round(),
                      color: const Color(0xff9F17F5),
                      badgeColor: const Color(0xffFAF3FF),
                    ),
                    48.verticalSpace,
                    // Minutes Breakdown section
                    _buildMinutesBreakdown(),
                    24.verticalSpace,
                    // Recent Activity card
                    _buildRecentActivityCard(),
                    40.verticalSpace,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SizedBox(
        height: 54.h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: SizedBox(
                width: 44.w,
                height: 44.h,
                child: Center(
                  child: SvgPicture.asset(
                    AppAssets.backButton,
                    width: 32.w,
                    height: 32.h,
                    colorFilter: const ColorFilter.mode(
                      Color(0xff04071E),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
            // Title
            Text(
              'Usage & Storage',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w400,
                fontSize: 17.sp,
                height: 22 / 17,
                letterSpacing: -0.43,
                color: const Color(0xff000000),
              ),
            ),
            // Spacer
            SizedBox(width: 44.w),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageOverviewHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Usage Overview',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w600,
            fontSize: 17.sp,
            height: 22 / 17,
            letterSpacing: -0.43,
            color: const Color(0xff333333),
          ),
        ),
        8.verticalSpace,
        Text(
          'Monitor your transcription minutes, AI tokens, and storage usage across all your files and activities.',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            height: 21 / 16,
            letterSpacing: -0.31,
            color: const Color(0xff999999),
          ),
        ),
      ],
    );
  }

  Widget _buildUsageCard({
    required String label,
    required double used,
    required double total,
    required String unit,
    required String remaining,
    required int percentage,
    required Color color,
    required Color badgeColor,
  }) {
    String formatValue(double value, double total, String unit) {
      if (total >= 1000) {
        return '${value.toStringAsFixed(1)} /${(total / 1000).toStringAsFixed(1)}K $unit';
      }
      return '${value.toStringAsFixed(1)} / ${total.toStringAsFixed(0)} $unit';
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffF2F2F7)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                        height: 18 / 13,
                        letterSpacing: -0.08,
                        color: const Color(0xff999999),
                      ),
                    ),
                    8.verticalSpace,
                    Text(
                      formatValue(used, total, unit),
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp,
                        height: 25 / 20,
                        letterSpacing: -0.45,
                        color: const Color(0xff333333),
                      ),
                    ),
                  ],
                ),
              ),
              // Percentage badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(9999.r),
                ),
                child: Text(
                  '$percentage%',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                    height: 18 / 13,
                    letterSpacing: -0.08,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          16.verticalSpace,
          // Progress bar
          _buildSegmentedProgressBar(
            percentage: percentage,
            color: color,
          ),
          8.verticalSpace,
          // Remaining text
          Text(
            remaining,
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
              height: 21 / 16,
              letterSpacing: -0.31,
              color: const Color(0xff333333),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedProgressBar({
    required int percentage,
    required Color color,
  }) {
    const int totalSegments = 43;
    final int filledSegments = (percentage / 100 * totalSegments).round();

    return SizedBox(
      height: 16.h,
      child: Row(
        children: List.generate(totalSegments, (index) {
          final bool isFilled = index < filledSegments;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < totalSegments - 1 ? 4.w : 0),
              decoration: BoxDecoration(
                color: isFilled ? color : const Color(0xffF2F2F7),
                borderRadius: BorderRadius.circular(9999.r),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMinutesBreakdown() {
    return Column(
      children: [
        // Title
        Text(
          'MINUTES BREAKDOWN',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            height: 21 / 16,
            letterSpacing: -0.31,
            color: const Color(0xff999999),
          ),
          textAlign: TextAlign.center,
        ),
        8.verticalSpace,
        // Legend row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 12.w,
              height: 12.h,
              decoration: const BoxDecoration(
                color: Color(0xff4A59FE),
                shape: BoxShape.circle,
              ),
            ),
            12.horizontalSpace,
            Text(
              'File Transcription ${_transcriptionUsed.toStringAsFixed(1)} / ${(_transcriptionTotal / 1000).toStringAsFixed(1)}K min',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                height: 21 / 16,
                letterSpacing: -0.31,
                color: const Color(0xff000000),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentActivityCard() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffF2F2F7)),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xffF2F2F7)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Activity',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w600,
                    fontSize: 17.sp,
                    height: 22 / 17,
                    letterSpacing: -0.43,
                    color: const Color(0xff000000),
                  ),
                ),
                Text(
                  '${_recentActivities.length + _remainingActivities} activities',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 17.sp,
                    height: 22 / 17,
                    letterSpacing: -0.43,
                    color: const Color(0xff999999),
                  ),
                ),
              ],
            ),
          ),
          // Activity items
          ...List.generate(
            _visibleActivities > _recentActivities.length
                ? _recentActivities.length
                : _visibleActivities,
            (index) => _buildActivityItem(
              activity: _recentActivities[index],
              showBorder: index < _visibleActivities - 1,
            ),
          ),
          // Load more button
          if (_remainingActivities > 0)
            GestureDetector(
              onTap: () {
                setState(() {
                  _visibleActivities += _remainingActivities;
                });
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                child: Center(
                  child: Text(
                    'Load More • $_remainingActivities remaining',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w600,
                      fontSize: 17.sp,
                      height: 22 / 17,
                      letterSpacing: -0.43,
                      color: const Color(0xff4A59FE),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required Map<String, dynamic> activity,
    required bool showBorder,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
      decoration: BoxDecoration(
        border: showBorder
            ? const Border(
                bottom: BorderSide(color: Color(0xffF2F2F7)),
              )
            : null,
      ),
      child: Column(
        children: [
          // Tags and minutes row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Tags
              Row(
                children: [
                  // File Transcription tag
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xff4A59FE).withOpacity(0.1),
                      border: Border.all(color: const Color(0xff4A59FE)),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      'File Transcription',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 13.sp,
                        height: 18 / 13,
                        letterSpacing: -0.08,
                        color: const Color(0xff4A59FE),
                      ),
                    ),
                  ),
                  8.horizontalSpace,
                  // Completed tag
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xffF2F2F7)),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      'Completed',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 13.sp,
                        height: 18 / 13,
                        letterSpacing: -0.08,
                        color: const Color(0xff333333),
                      ),
                    ),
                  ),
                ],
              ),
              // Minutes
              Text(
                '${activity['minutes'].toStringAsFixed(1)} min',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  height: 21 / 16,
                  letterSpacing: -0.31,
                  color: const Color(0xff000000),
                ),
              ),
            ],
          ),
          8.verticalSpace,
          // File info row
          Row(
            children: [
              // File icon
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: const Color(0xffF2F2F7),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    AppAssets.scratchpad,
                    width: 24.w,
                    height: 24.h,
                    colorFilter: const ColorFilter.mode(
                      Color(0xff8C8C8C),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              17.horizontalSpace,
              // File details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity['fileName'],
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        height: 21 / 16,
                        letterSpacing: -0.31,
                        color: const Color(0xff000000),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    8.verticalSpace,
                    // Meta info
                    Row(
                      children: [
                        Text(
                          activity['date'],
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            height: 16 / 12,
                            color: const Color(0xff3C3C43).withOpacity(0.6),
                          ),
                        ),
                        12.horizontalSpace,
                        _buildDot(),
                        12.horizontalSpace,
                        Text(
                          activity['duration'],
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            height: 16 / 12,
                            color: const Color(0xff3C3C43).withOpacity(0.6),
                          ),
                        ),
                        12.horizontalSpace,
                        _buildDot(),
                        12.horizontalSpace,
                        Text(
                          activity['language'],
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            height: 16 / 12,
                            color: const Color(0xff3C3C43).withOpacity(0.6),
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
    );
  }

  Widget _buildDot() {
    return Container(
      width: 8.w,
      height: 8.h,
      decoration: const BoxDecoration(
        color: Color(0xff8C8C8C),
        shape: BoxShape.circle,
      ),
    );
  }
}