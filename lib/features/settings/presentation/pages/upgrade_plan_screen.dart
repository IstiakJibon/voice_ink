import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';

class UpgradePlansScreen extends StatefulWidget {
  const UpgradePlansScreen({super.key});

  @override
  State<UpgradePlansScreen> createState() => _UpgradePlansScreenState();
}

class _UpgradePlansScreenState extends State<UpgradePlansScreen> {
  int _selectedBillingIndex = 1; // 0 = Monthly, 1 = Yearly (default)
  int _selectedTrialIndex = 0; // 0 = VoiceInk Trial, 1 = Day Pass
  String? _selectedSubscriptionPlan; // 'basic', 'pro', 'studio'

  @override
  void initState() {
    super.initState();
    _selectedSubscriptionPlan = 'basic'; // Default selected
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Blue gradient background (top portion)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 457.h,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff4A59FE), Color(0xff4738E2)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
            ),
          ),
          // Main content
          SafeArea(
            child: Column(
              children: [
                // App bar
                _buildAppBar(),
                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header section (on blue gradient)
                        _buildHeaderSection(),
                        // Features carousel
                        _buildFeaturesCarousel(),
                        16.verticalSpace,
                        // Unlimited features list
                        _buildUnlimitedFeatures(),
                        // White section with pricing
                        _buildPricingSection(),
                      ],
                    ),
                  ),
                ),
                // Bottom button
                _buildBottomButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SizedBox(
        height: 54.h,
        child: Row(
          crossAxisAlignment: .center,
          mainAxisAlignment: .spaceBetween,
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
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
            // Title (centered)
            Text(
              'Upgrade Plan',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w400,
                fontSize: 17.sp,
                height: 22 / 17,
                letterSpacing: -0.43,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(width: 32.w, height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          16.verticalSpace,
          Text(
            'Unlocked Full Power',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
              height: 25 / 20,
              letterSpacing: -0.45,
              color: Colors.white,
            ),
          ),
          8.verticalSpace,
          Text(
            'Get unlimited access to all AI features.',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w400,
              fontSize: 17.sp,
              height: 22 / 17,
              letterSpacing: -0.43,
              color: Colors.white.withOpacity(0.75),
            ),
          ),
          24.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildFeaturesCarousel() {
    final features = [
      {
        'icon': AppAssets.scratchpad,
        'iconBg': const Color(0xffFFDC50),
        'title': 'Auto Transcription',
        'description': 'Smart notes & summaries',
      },
      {
        'icon': AppAssets.calendar,
        'iconBg': const Color(0xffFFDC50),
        'title': 'Calendar Sync',
        'description': 'Google and Microsoft',
      },
      {
        'icon': AppAssets.sparkle,
        'iconBg': const Color(0xffFFDC50),
        'title': 'Advanced AI',
        'description': 'Ask questions to your meetings',
      },
      {
        'icon': AppAssets.globe,
        'iconBg': const Color(0xffFFDC50),
        'title': 'Multi-language',
        'description': 'Support for 10+ languages',
      },
    ];

    return SizedBox(
      height: 132.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: features.length,
        separatorBuilder: (_, __) => 8.horizontalSpace,
        itemBuilder: (context, index) {
          final feature = features[index];
          return _buildFeatureCard(
            icon: feature['icon'] as String,
            iconBgColor: feature['iconBg'] as Color,
            title: feature['title'] as String,
            description: feature['description'] as String,
          );
        },
      ),
    );
  }

  Widget _buildFeatureCard({
    required String icon,
    required Color iconBgColor,
    required String title,
    required String description,
  }) {
    return Container(
      width: 156.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                icon,
                width: 24.w,
                height: 24.h,
                colorFilter: const ColorFilter.mode(
                  Color(0xff4A59FE),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          4.verticalSpace,
          // Title
          Text(
            title,
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w600,
              fontSize: 15.sp,
              height: 20 / 15,
              letterSpacing: -0.23,
              color: Colors.white,
            ),
          ),
          4.verticalSpace,
          // Description
          Text(
            description,
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w400,
              fontSize: 15.sp,
              height: 20 / 15,
              letterSpacing: -0.23,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnlimitedFeatures() {
    final unlimitedFeatures = [
      'Unlimited notes history',
      'Unlimited recording duration',
      'Unlimited import files',
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: unlimitedFeatures.map((feature) {
          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              children: [
                // Unlimited badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(1000.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        AppAssets.rocket,
                        width: 16.w,
                        height: 16.h,
                        colorFilter: const ColorFilter.mode(
                          Color(0xffFFDC50),
                          BlendMode.srcIn,
                        ),
                      ),
                      4.horizontalSpace,
                      Text(
                        'Unlimited',
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                          height: 18 / 13,
                          letterSpacing: -0.08,
                          color: const Color(0xffFFDC50),
                        ),
                      ),
                    ],
                  ),
                ),
                8.horizontalSpace,
                // Feature text
                Text(
                  feature,
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                    height: 20 / 15,
                    letterSpacing: -0.23,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPricingSection() {
    return Container(
      margin: EdgeInsets.only(top: 33.h),
      padding: EdgeInsets.all(16.w),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Billing toggle (Monthly / Yearly)
          _buildBillingToggle(),
          16.verticalSpace,
          // Try First section
          _buildTryFirstSection(),
          24.verticalSpace,
          // Subscriptions section
          _buildSubscriptionsSection(),
          100.verticalSpace, // Space for bottom button
        ],
      ),
    );
  }

  Widget _buildBillingToggle() {
    return Container(
      height: 48.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F7),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / 2;
          return Stack(
            children: [
              // Sliding indicator
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                left: _selectedBillingIndex * tabWidth,
                top: 0,
                bottom: 0,
                width: tabWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              // Tab buttons
              Row(
                children: [
                  // Monthly
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedBillingIndex = 0),
                      behavior: HitTestBehavior.opaque,
                      child: SizedBox(
                        height: 40.h,
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: GoogleFonts.dmSans(
                              fontWeight: _selectedBillingIndex == 0
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              fontSize: 16.sp,
                              height: 21 / 16,
                              letterSpacing: -0.31,
                              color: const Color(0xff000000),
                            ),
                            child: const Text('Monthly'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Yearly with discount badge
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedBillingIndex = 1),
                      behavior: HitTestBehavior.opaque,
                      child: SizedBox(
                        height: 40.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: GoogleFonts.dmSans(
                                fontWeight: _selectedBillingIndex == 1
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                fontSize: 16.sp,
                                height: 21 / 16,
                                letterSpacing: -0.31,
                                color: const Color(0xff000000),
                              ),
                              child: const Text('Yearly'),
                            ),
                            8.horizontalSpace,
                            // Discount badge
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xff1D9D70),
                                borderRadius: BorderRadius.circular(1000.r),
                              ),
                              child: Text(
                                '2 months free',
                                style: GoogleFonts.dmSans(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                  height: 16 / 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTryFirstSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          'TRY FIRST',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            height: 21 / 16,
            letterSpacing: -0.31,
            color: const Color(0xff999999),
          ),
        ),
        16.verticalSpace,
        // Trial cards row
        Row(
          children: [
            // VoiceInk Trial card
            Expanded(
              child: _buildTrialCard(
                index: 0,
                title: 'VoiceInk Trial',
                subtitle: '20 minutes',
                price: '\$1.49',
                isSelected: _selectedTrialIndex == 0,
                isDark: true,
              ),
            ),
            18.horizontalSpace,
            // Day Pass card
            Expanded(
              child: _buildTrialCard(
                index: 1,
                title: 'Day Pass',
                subtitle: '200 minutes',
                price: '\$1.99',
                isSelected: _selectedTrialIndex == 1,
                isDark: false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrialCard({
    required int index,
    required String title,
    required String subtitle,
    required String price,
    required bool isSelected,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: () => setState(() => _selectedTrialIndex = index),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xff1E222B) : Colors.white,
          border: isDark ? null : Border.all(color: const Color(0xffF2F2F7)),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row with checkmark
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                          height: 21 / 16,
                          letterSpacing: -0.31,
                          color: isDark
                              ? Colors.white
                              : const Color(0xff000000),
                        ),
                      ),
                      8.verticalSpace,
                      Text(
                        subtitle,
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                          height: 20 / 15,
                          letterSpacing: -0.23,
                          color: isDark
                              ? Colors.white
                              : const Color(0xff000000),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  SvgPicture.asset(
                    AppAssets.checkmark,
                    width: 24.w,
                    height: 24.h,
                    colorFilter: ColorFilter.mode(
                      isDark
                          ? const Color(0xff16FFAB)
                          : const Color(0xff4A59FE),
                      BlendMode.srcIn,
                    ),
                  ),
              ],
            ),
            16.verticalSpace,
            // Price
            Text(
              price,
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w700,
                fontSize: 22.sp,
                height: 28 / 22,
                letterSpacing: -0.26,
                color: isDark ? Colors.white : const Color(0xff000000),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          'SUBSCRIPTIONS',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            height: 21 / 16,
            letterSpacing: -0.31,
            color: const Color(0xff999999),
          ),
        ),
        16.verticalSpace,
        // Basic plan
        _buildSubscriptionCard(
          planId: 'basic',
          title: 'Basic',
          minutes: '700 minutes/mo',
          monthlyPrice: '\$ 8.25/month',
          yearlyPrice: '\$99.00/year',
          features: ['Transcription', 'Speaker ID', 'AI Summary'],
          isSelected: _selectedSubscriptionPlan == 'basic',
        ),
        16.verticalSpace,
        // Pro plan (with recommended badge)
        _buildSubscriptionCard(
          planId: 'pro',
          title: 'Pro',
          minutes: '1600 minutes/mo',
          monthlyPrice: '\$ 16.58/month',
          yearlyPrice: '\$199.00/year',
          features: [
            'Every thing in basic',
            'Topics',
            'Chapters',
            'Key points',
          ],
          isSelected: _selectedSubscriptionPlan == 'pro',
          isRecommended: true,
        ),
        16.verticalSpace,
        // Studio plan
        _buildSubscriptionCard(
          planId: 'studio',
          title: 'Studio',
          minutes: '2400 minutes/mo',
          monthlyPrice: '\$ 24.92/month',
          yearlyPrice: '\$299.00/year',
          features: [
            'Every thing in Pro',
            'PII Redaction',
            'Content Moderation',
          ],
          isSelected: _selectedSubscriptionPlan == 'studio',
          isLarger: true,
        ),
      ],
    );
  }

  Widget _buildSubscriptionCard({
    required String planId,
    required String title,
    required String minutes,
    required String monthlyPrice,
    required String yearlyPrice,
    required List<String> features,
    required bool isSelected,
    bool isRecommended = false,
    bool isLarger = false,
  }) {
    return GestureDetector(
      onTap: () => setState(() => _selectedSubscriptionPlan = planId),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected
                ? const Color(0xff4A59FE)
                : const Color(0xffF2F2F7),
          ),
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xff4A59FE).withOpacity(0.05),
                    blurRadius: 30,
                    offset: const Offset(17, 48),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row
            Row(
              children: [
                // Left side: Title, checkmark, minutes
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
                              fontSize: 20.sp,
                              height: 25 / 20,
                              letterSpacing: -0.45,
                              color: const Color(0xff000000),
                            ),
                          ),
                          4.horizontalSpace,
                          if (isSelected)
                            SvgPicture.asset(
                              AppAssets.checkmark,
                              width: 24.w,
                              height: 24.h,
                              colorFilter: const ColorFilter.mode(
                                Color(0xff4A59FE),
                                BlendMode.srcIn,
                              ),
                            ),
                          if (isRecommended) ...[
                            4.horizontalSpace,
                            _buildRecommendedBadge(),
                          ],
                        ],
                      ),
                      8.verticalSpace,
                      Text(
                        minutes,
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                          height: 20 / 15,
                          letterSpacing: -0.23,
                          color: const Color(0xff8C8C8C),
                        ),
                      ),
                    ],
                  ),
                ),
                // Right side: Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _selectedBillingIndex == 1 ? monthlyPrice : monthlyPrice,
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp,
                        height: 25 / 20,
                        letterSpacing: -0.45,
                        color: const Color(0xff000000),
                      ),
                    ),
                    8.verticalSpace,
                    Text(
                      yearlyPrice,
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 15.sp,
                        height: 20 / 15,
                        letterSpacing: -0.23,
                        color: const Color(0xff8C8C8C),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ],
            ),
            16.verticalSpace,
            // Feature tags
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: features.map((feature) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xffF2F2F7),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Text(
                    feature,
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                      height: 16 / 12,
                      color: const Color(0xff000000),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedBadge() {
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
            'RECOMMENDED',
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

  Widget _buildBottomButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      decoration: const BoxDecoration(color: Colors.white),
      child: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: () {
            // TODO: Handle subscription
          },
          child: Container(
            height: 50.h,
            decoration: BoxDecoration(
              color: const Color(0xff4A59FE),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: Text(
                'Continue with Basic',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w600,
                  fontSize: 17.sp,
                  height: 22 / 17,
                  letterSpacing: -0.43,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
