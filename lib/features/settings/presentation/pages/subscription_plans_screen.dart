import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';
import 'package:voice_ink/features/settings/presentation/widget/payment_success_bottom_sheet.dart';

class SubscriptionPlansScreen extends StatefulWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  State<SubscriptionPlansScreen> createState() =>
      _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen> {
  int _selectedTabIndex = 0;

  final List<String> _tabs = ['Overview', 'Top-ups', 'History'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            _buildAppBar(),
            10.verticalSpace,
            // Tab bar
            _buildTabBar(),
            16.verticalSpace,
            // Tab content
            Expanded(child: _buildTabContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SizedBox(
        height: 44.h,
        child: Row(
          crossAxisAlignment: .center,
          mainAxisAlignment: .spaceBetween,
          children: [
            // Title (centered)
            GestureDetector(
              onTap: () => Navigator.pop(context),
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

            Text(
              'Subscription & Plans',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w400,
                fontSize: 17.sp,
                height: 22 / 17,
                letterSpacing: -0.43,
                color: const Color(0xff000000),
              ),
              textAlign: TextAlign.center,
            ),
            // Back button (left aligned)
            SizedBox(   width: 32.w,
                  height: 32.h,),
          ],
        ),
      ),
    );
  }

Widget _buildTabBar() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Container(
      height: 48.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F7),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / _tabs.length;
          return Stack(
            children: [
              // Sliding indicator
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                left: _selectedTabIndex * tabWidth,
                top: 0,
                bottom: 0,
                width: tabWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.black.withOpacity(0.06),
                    //     blurRadius: 8,
                    //     offset: const Offset(0, 2),
                    //   ),
                    // ],
                  ),
                ),
              ),
              // Tab buttons
              Row(
                children: List.generate(_tabs.length, (index) {
                  final isSelected = _selectedTabIndex == index;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTabIndex = index;
                        });
                      },
                      behavior: HitTestBehavior.opaque,
                      child: SizedBox(
                        height: 40.h,
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            style: GoogleFonts.dmSans(
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              fontSize: 15.sp,
                              height: 20 / 15,
                              letterSpacing: -0.23,
                              color: const Color(0xff000000),
                            ),
                            child: Text(_tabs[index]),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    ),
  );
}

// Widget _buildTabButton(int index) {
//   final isSelected = _selectedTabIndex == index;

//   return GestureDetector(
//     onTap: () {
//       setState(() {
//         _selectedTabIndex = index;
//       });
//     },
//     child: AnimatedContainer(
//       duration: const Duration(milliseconds: 500),
//       curve: Curves.easeInOut,
//       height: 40.h,
//       decoration: BoxDecoration(
//         color: isSelected ? Colors.white : Colors.transparent,
//         borderRadius: BorderRadius.circular(8.r),
//         boxShadow: isSelected
//             ? [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.06),
//                   blurRadius: 20,
//                   offset: const Offset(0, 2),
//                 ),
//               ]
//             : null,
//       ),
//       child: Center(
//         child: AnimatedDefaultTextStyle(
//           duration: const Duration(milliseconds: 250),
//           curve: Curves.easeInOut,
//           style: GoogleFonts.dmSans(
//             fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
//             fontSize: 15.sp,
//             height: 20 / 15,
//             letterSpacing: -0.23,
//             color: const Color(0xff000000),
//           ),
//           child: Text(
//             _tabs[index],
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ),
//     ),
//   );
// }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildOverviewTab();
      case 1:
        return _buildTopUpsTab();
      case 2:
        return _buildHistoryTab();
      default:
        return _buildOverviewTab();
    }
  }

  // ==================== OVERVIEW TAB ====================

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Premium Card
          _buildPremiumCard(),
          16.verticalSpace,
          // Usage Overview Section
          _buildUsageOverviewSection(),
          16.verticalSpace,
          // Two small cards row (Live Minutes & Storage)
          _buildSmallCardsRow(),
          40.verticalSpace,
          // Upgrade Promo Card
          _buildUpgradePromoCard(),
          16.verticalSpace,
          // Cancel Subscription
          _buildCancelSubscription(),
          40.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildPremiumCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff4A59FE), Color(0xff4738E2)],
        ),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Plan badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.25),
              borderRadius: BorderRadius.circular(1000.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffFED74A), Color(0xffFF9B05)],
                    ),
                  ),
                ),
                4.horizontalSpace,
                Text(
                  'Current Plan',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                    height: 16 / 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          24.verticalSpace,
          // Plan info row
          Row(
            children: [
              // Logo icon
              Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    AppAssets.voiceInkLogo,
                    width: 24.w,
                    height: 24.h,
                  ),
                ),
              ),
              8.horizontalSpace,
              // Plan name and title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Premium Plan',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 15.sp,
                        height: 20 / 15,
                        letterSpacing: -0.23,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'VoiceInk Trial',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp,
                        height: 25 / 20,
                        letterSpacing: -0.45,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$1.49',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 20.sp,
                      height: 25 / 20,
                      letterSpacing: -0.45,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Per month',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.sp,
                      height: 20 / 15,
                      letterSpacing: -0.23,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          24.verticalSpace,
          // Advance Progress section
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                // Payment icon with gradient
                Container(
                  width: 24.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xffFFBD14).withOpacity(0.1),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: SvgPicture.asset(
                    AppAssets.payment,
                    width: 24.w,
                    height: 24.h,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                8.horizontalSpace,
                Expanded(
                  child: Text(
                    'Title',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.sp,
                      height: 20 / 15,
                      letterSpacing: -0.23,
                      color: Colors.white,
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

  Widget _buildUsageOverviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Text(
            'Usage Overview',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w600,
              fontSize: 17.sp,
              height: 22 / 17,
              letterSpacing: -0.43,
              color: const Color(0xff000000),
            ),
          ),
        ),
        8.verticalSpace,
        // Main usage card (Recorded)
        _buildUsageCard(
          icon: AppAssets.scratchpad,
          iconBgColor: const Color(0xffECF4FE),
          iconColor: const Color(0xff4A59FE),
          label: 'RECORDED',
          value: '200 /850 min',
          percentage: '34%',
          percentageBgColor: const Color(0xffECF4FE),
          percentageTextColor: const Color(0xff4A59FE),
          progressColor: const Color(0xff4A59FE),
          filledBars: 13,
          totalBars: 40,
        ),
      ],
    );
  }

  Widget _buildUsageCard({
    required String icon,
    required Color iconBgColor,
    required Color iconColor,
    required String label,
    required String value,
    required String percentage,
    required Color percentageBgColor,
    required Color percentageTextColor,
    required Color progressColor,
    required int filledBars,
    required int totalBars,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffF2F2F7)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Icon
              Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    icon,
                    width: 24.w,
                    height: 24.h,
                    colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                  ),
                ),
              ),
              8.horizontalSpace,
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
                      value,
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        height: 21 / 16,
                        letterSpacing: -0.31,
                        color: const Color(0xff333333),
                      ),
                    ),
                  ],
                ),
              ),
              // Percentage badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: percentageBgColor,
                  borderRadius: BorderRadius.circular(9999.r),
                ),
                child: Text(
                  percentage,
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                    height: 18 / 13,
                    letterSpacing: -0.08,
                    color: percentageTextColor,
                  ),
                ),
              ),
            ],
          ),
          16.verticalSpace,
          // Progress bars
          _buildProgressBars(
            filledBars: filledBars,
            totalBars: totalBars,
            filledColor: progressColor,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBars({
    required int filledBars,
    required int totalBars,
    required Color filledColor,
  }) {
    return SizedBox(
      height: 16.h,
      child: Row(
        children: List.generate(totalBars, (index) {
          final isFilled = index < filledBars;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < totalBars - 1 ? 4.w : 0),
              height: 16.h,
              decoration: BoxDecoration(
                color: isFilled ? filledColor : const Color(0xffF2F2F7),
                borderRadius: BorderRadius.circular(9999.r),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSmallCardsRow() {
    return Row(
      children: [
        // Live Minutes card
        Expanded(
          child: _buildSmallUsageCard(
            icon: AppAssets.live,
            iconBgColor: const Color(0xffE7FDF4),
            iconColor: const Color(0xff1D9D70),
            label: 'LIVE MINUTES',
            value: '0 /0 min',
            percentage: '0%',
            percentageBgColor: const Color(0xffE7FDF4),
            percentageTextColor: const Color(0xff1D9D70),
            progressColor: const Color(0xff1D9D70),
            filledBars: 1,
            totalBars: 20,
          ),
        ),
        16.horizontalSpace,
        // Storage card
        Expanded(
          child: _buildSmallUsageCard(
            icon: AppAssets.folder,
            iconBgColor: const Color(0xffFAF3FF),
            iconColor: const Color(0xff9F17F5),
            label: 'STORAGE',
            value: '0.0 /1 GB',
            percentage: '0%',
            percentageBgColor: const Color(0xffFAF3FF),
            percentageTextColor: const Color(0xff9F17F5),
            progressColor: const Color(0xff9F17F5),
            filledBars: 1,
            totalBars: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildSmallUsageCard({
    required String icon,
    required Color iconBgColor,
    required Color iconColor,
    required String label,
    required String value,
    required String percentage,
    required Color percentageBgColor,
    required Color percentageTextColor,
    required Color progressColor,
    required int filledBars,
    required int totalBars,
  }) {
    return Container(
      padding: EdgeInsets.all(8.w),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon
                    Container(
                      width: 44.w,
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          icon,
                          width: 24.w,
                          height: 24.h,
                          colorFilter: ColorFilter.mode(
                            iconColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    8.verticalSpace,
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
                      value,
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        height: 21 / 16,
                        letterSpacing: -0.31,
                        color: const Color(0xff333333),
                      ),
                    ),
                  ],
                ),
              ),
              // Percentage badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: percentageBgColor,
                  borderRadius: BorderRadius.circular(9999.r),
                ),
                child: Text(
                  percentage,
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                    height: 18 / 13,
                    letterSpacing: -0.08,
                    color: percentageTextColor,
                  ),
                ),
              ),
            ],
          ),
          8.verticalSpace,
          // Progress bars
          _buildProgressBars(
            filledBars: filledBars,
            totalBars: totalBars,
            filledColor: progressColor,
          ),
        ],
      ),
    );
  }

  Widget _buildUpgradePromoCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xffFED94D), Color(0xffFF9904)],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PRO badge + Unlock text
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Text(
                  'PRO',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 15.sp,
                    height: 20 / 15,
                    letterSpacing: -0.23,
                    color: Colors.white,
                  ),
                ),
              ),
              8.horizontalSpace,
              Text(
                'Unlock full power',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 15.sp,
                  height: 20 / 15,
                  letterSpacing: -0.23,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          16.verticalSpace,
          // Crown icon and description
          Row(
            children: [
              Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xff4B58FD), Color(0xff473AE3)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xffFFBD14).withOpacity(0.1),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                    AppAssets.crown,
                    width: 24.w,
                    height: 24.h,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              8.horizontalSpace,
              Expanded(
                child: Text(
                  'Get unlimited access to all premium features and maximize your productivity.',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 15.sp,
                    height: 20 / 15,
                    letterSpacing: -0.23,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          12.verticalSpace,
          // Upgrade button
          Container(
            width: double.infinity,
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 21,
                  offset: const Offset(0, 9),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Upgrade to VoiceInk Pro',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                  height: 20 / 15,
                  letterSpacing: -0.23,
                  color: const Color(0xff4A59FE),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelSubscription() {
    return Center(
      child: GestureDetector(
        onTap: () {
          // TODO: Handle cancel subscription
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
          child: Text(
            'Cancel subscription',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w400,
              fontSize: 15.sp,
              height: 20 / 15,
              letterSpacing: -0.23,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  // ==================== TOP-UPS TAB ====================

  Widget _buildTopUpsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildTopUpsHeader(),
          24.verticalSpace,
          // Transcription Minutes section
          _buildTranscriptionMinutesSection(),
          40.verticalSpace,
          // AI Credits section
          _buildAICreditsSection(),
          40.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildTopUpsHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top-Up Add-ons',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w600,
              fontSize: 17.sp,
              height: 22 / 17,
              letterSpacing: -0.43,
              color: const Color(0xff000000),
            ),
          ),
          8.verticalSpace,
          Text(
            'Purchase additional minutes or tokens as needed.',
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

  Widget _buildTranscriptionMinutesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Container(
              width: 24.w,
              height: 24.h,
              decoration: const BoxDecoration(
                color: Color(0xff4A59FE),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.clock,
                  width: 16.w,
                  height: 16.h,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            8.horizontalSpace,
            Text(
              'TRANSCRIPTION MINUTES',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                height: 21 / 16,
                letterSpacing: -0.31,
                color: const Color(0xff999999),
              ),
            ),
          ],
        ),
        16.verticalSpace,
        // Transcription cards
        _buildTopUpCard(
          icon: AppAssets.clock,
          iconBgColor: const Color(0xffECF4FE),
          iconColor: const Color(0xff4A59FE),
          title: '400 Minutes',
          description: '80 min/\$ • Extra transcription time',
          price: '\$4.99',
          buttonColor: const Color(0xff4A59FE),
          buttonTextColor: const Color(0xffD1D1D6),
        ),
        16.verticalSpace,
        _buildTopUpCard(
          icon: AppAssets.clock,
          iconBgColor: const Color(0xffECF4FE),
          iconColor: const Color(0xff4A59FE),
          title: '850 Minutes',
          description: '85 min/\$ • Extra transcription time',
          price: '\$9.99',
          buttonColor: const Color(0xff1E222B),
          buttonTextColor: Colors.white,
          badge: _buildPopularBadge(),
        ),
        16.verticalSpace,
        _buildTopUpCard(
          icon: AppAssets.clock,
          iconBgColor: const Color(0xffECF4FE),
          iconColor: const Color(0xff4A59FE),
          title: '1,800 Minutes',
          description: '80 min/\$ • Extra transcription time',
          price: '\$22.49',
          buttonColor: const Color(0xff4A59FE),
          buttonTextColor: const Color(0xffD1D1D6),
          badge: _buildBestValueBadge(),
        ),
      ],
    );
  }

  Widget _buildAICreditsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Container(
              width: 24.w,
              height: 24.h,
              decoration: const BoxDecoration(
                color: Color(0xff9F17F5),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.sparkle,
                  width: 16.w,
                  height: 16.h,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            8.horizontalSpace,
            Text(
              'AI CREDITS',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                height: 21 / 16,
                letterSpacing: -0.31,
                color: const Color(0xff999999),
              ),
            ),
          ],
        ),
        16.verticalSpace,
        // AI Credit cards
        _buildTopUpCard(
          icon: AppAssets.flash,
          iconBgColor: const Color(0xffFAF3FF),
          iconColor: const Color(0xff9F17F5),
          title: '1M Credits',
          description: '1M credits • Add 1 million AI credits',
          price: '\$4.99',
          buttonColor: const Color(0xff9F17F5),
          buttonTextColor: const Color(0xffD1D1D6),
        ),
        16.verticalSpace,
        _buildTopUpCard(
          icon: AppAssets.flash,
          iconBgColor: const Color(0xffFAF3FF),
          iconColor: const Color(0xff9F17F5),
          title: '2M Credits',
          description: '2M credits • Add 2 million AI credits',
          price: '\$8.99',
          buttonColor: const Color(0xff9F17F5),
          buttonTextColor: const Color(0xffD1D1D6),
          badge: _buildBestValueBadge(),
        ),
        16.verticalSpace,
        _buildTopUpCard(
          icon: AppAssets.flash,
          iconBgColor: const Color(0xffFAF3FF),
          iconColor: const Color(0xff9F17F5),
          title: '5M Credits',
          description: '5M credits • Add 5 million AI credits',
          price: '\$19.99',
          buttonColor: const Color(0xff9F17F5),
          buttonTextColor: const Color(0xffD1D1D6),
        ),
        16.verticalSpace,
        _buildTopUpCard(
          icon: AppAssets.flash,
          iconBgColor: const Color(0xffFAF3FF),
          iconColor: const Color(0xff9F17F5),
          title: '15M Credits',
          description: '15M credits • Add 15 million AI credits',
          price: '\$49.99',
          buttonColor: const Color(0xff9F17F5),
          buttonTextColor: const Color(0xffD1D1D6),
        ),
      ],
    );
  }

  Widget _buildTopUpCard({
    required String icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String description,
    required String price,
    required Color buttonColor,
    required Color buttonTextColor,
    Widget? badge,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffF2F2F7)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                icon,
                width: 24.w,
                height: 24.h,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
          ),
          8.horizontalSpace,
          // Title and description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        height: 21 / 16,
                        letterSpacing: -0.31,
                        color: const Color(0xff333333),
                      ),
                    ),
                    if (badge != null) ...[8.horizontalSpace, badge],
                  ],
                ),
                8.verticalSpace,
                Text(
                  description,
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
          ),
          8.horizontalSpace,
          // Price button
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(1000.r),
            ),
            child: Text(
              price,
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w400,
                fontSize: 15.sp,
                height: 20 / 15,
                letterSpacing: -0.23,
                color: buttonTextColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xff4A59FE),
        borderRadius: BorderRadius.circular(1000.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(AppAssets.starW, width: 16.w, height: 16.h),
          4.horizontalSpace,
          Text(
            'Popular',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
              height: 18 / 13,
              letterSpacing: -0.08,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestValueBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xff1D9D70),
        borderRadius: BorderRadius.circular(1000.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AppAssets.rocket,
            width: 16.w,
            height: 16.h,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          4.horizontalSpace,
          Text(
            'Best Value',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
              height: 18 / 13,
              letterSpacing: -0.08,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== HISTORY TAB ====================

  Widget _buildHistoryTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHistoryHeader(),
          24.verticalSpace,
          // Billing cards
          _buildBillingCard(
            title: '1 × VoiceInk pro_new (at \$19.99 / month)',
            date: 'January 7, 2026 • USD • January 7, 2026 to January 7, 2026',
            amount: '\$19.99',
            isTopUp: false,
          ),
          16.verticalSpace,
          _buildBillingCard(
            title: 'Top-up - topup_850min',
            date: 'December 29, 2025 • USD',
            amount: '\$19.99',
            isTopUp: true,
          ),
          40.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildHistoryHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Billing History',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w600,
              fontSize: 17.sp,
              height: 22 / 17,
              letterSpacing: -0.43,
              color: const Color(0xff000000),
            ),
          ),
          8.verticalSpace,
          Text(
            'View and download your payment receipts',
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

  Widget _buildBillingCard({
    required String title,
    required String date,
    required String amount,
    required bool isTopUp,
  }) {
    return GestureDetector(
      onTap: () {
        PaymentSuccessBottomSheet.show(
          context,
          amount: amount,
          date: date.split(' • ').first, // Extract just the date
          serviceName: title,
          invoiceNumber: 'INV-NAN',
          paymentMethod: '•••• 4242',
          subtotal: amount,
          tax: '\$0.00',
          totalPaid: amount,
        );
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffF2F2F7)),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Document icon
            Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                color: const Color(0xffECF4FE),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.documentText,
                  width: 24.w,
                  height: 24.h,
                  colorFilter: const ColorFilter.mode(
                    Color(0xff4A59FE),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            8.horizontalSpace,
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row with optional Top-up badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            height: 21 / 16,
                            letterSpacing: -0.31,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                      if (isTopUp) ...[
                        8.horizontalSpace,
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffFE8F4A),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            'Top-up',
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
                    ],
                  ),
                  8.verticalSpace,
                  // Date
                  Text(
                    date,
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                      height: 18 / 13,
                      letterSpacing: -0.08,
                      color: const Color(0xff3C3C43).withOpacity(0.6),
                    ),
                  ),
                  8.verticalSpace,
                  // Amount and action buttons row
                  Row(
                    children: [
                      // Amount
                      Text(
                        amount,
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                          height: 21 / 16,
                          letterSpacing: -0.31,
                          color: const Color(0xff000000),
                        ),
                      ),
                      8.horizontalSpace,
                      // Paid badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xff34C759).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              AppAssets.checkmark,
                              width: 24.w,
                              height: 24.h,
                              colorFilter: const ColorFilter.mode(
                                Color(0xff34C759),
                                BlendMode.srcIn,
                              ),
                            ),
                            6.horizontalSpace,
                            Text(
                              'Paid',
                              style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.w400,
                                fontSize: 13.sp,
                                height: 18 / 13,
                                letterSpacing: -0.08,
                                color: const Color(0xff34C759),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Receipt button
                      GestureDetector(
                        onTap: () {
                          // TODO: Download receipt
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xff4A59FE).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                AppAssets.receipt,
                                width: 24.w,
                                height: 24.h,
                                colorFilter: const ColorFilter.mode(
                                  Color(0xff4A59FE),
                                  BlendMode.srcIn,
                                ),
                              ),
                              6.horizontalSpace,
                              Text(
                                'Receipt',
                                style: GoogleFonts.dmSans(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.sp,
                                  height: 18 / 13,
                                  letterSpacing: -0.08,
                                  color: const Color(0xff4A59FE),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
