import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';
import 'package:voice_ink/config/const/app/app_colors.dart';
import 'package:voice_ink/config/navigation/route_name.dart';
import 'package:voice_ink/features/launcher/presentation/widgets/custom_blue_button.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _onboardingPages = [
    OnboardingData(
      image: AppAssets.ob1,
      speechSegments: [
        ColoredText('Turn anything into text\n', AppColors.primary),
        ColoredText(
          'Paste a link, speak live, or upload a\nnote, we\'ll take it from there\n',
          Color(0xFF3C3C43).withOpacity(0.6),
        ),
        ColoredText('VoiceInk captures ', AppColors.primary),
        ColoredText('it all', Color(0xFF3C3C43).withOpacity(0.6)),
      ],
    ),
    OnboardingData(
      image: AppAssets.ob2,
      speechSegments: [
        ColoredText('Transform ', AppColors.primary),
        ColoredText(
          'your conversations,\nmeetings, and ideas into clear,\nactionable ',
          Color(0xFF3C3C43).withOpacity(0.6),
        ),
        ColoredText('text', AppColors.primary),
      ],
    ),
    OnboardingData(
      image: AppAssets.ob3,
      speechSegments: [
        ColoredText('Smart Transcription\n', AppColors.primary),
        ColoredText(
          'Instantly convert speech to text\nwith ',
          Color(0xFF3C3C43).withOpacity(0.6),
        ),
        ColoredText('90+ ', AppColors.primary),
        ColoredText(
          'language support and\nspeaker detection',
          Color(0xFF3C3C43).withOpacity(0.6),
        ),
      ],
    ),
    OnboardingData(
      image: AppAssets.ob4,
      speechSegments: [
        ColoredText('AI-Powered Analysis\n', AppColors.primary),
        ColoredText(
          'Get instant summaries, key\npoints, and actionable ',
          Color(0xFF3C3C43).withOpacity(0.6),
        ),
        ColoredText('insights\n', AppColors.primary),
        ColoredText('from your recordings', Color(0xFF3C3C43).withOpacity(0.6)),
      ],
    ),
  ];

  void _onContinueTapped() {
    if (_currentPage < _onboardingPages.length - 1) {
      // Go to next page
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushNamed(RouteName.singUp);
    }
  }

  void _onSkipTapped() {
    Navigator.of(context).pushNamed(RouteName.singUp);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            20.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _onboardingPages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  width: 16.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: _currentPage >= index
                        ? AppColors.primary
                        : const Color(0xffF2F2F7),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
              ),
            ),
            // PageView for images and speeches
            10.verticalSpace,
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingPages.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Image.asset(_onboardingPages[index].image),
                      10.verticalSpace,
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: _onboardingPages[index].speechSegments.map((
                            segment,
                          ) {
                            return TextSpan(
                              text: segment.text,
                              style: GoogleFonts.dmSans(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w400,
                                height: 28 / 22,
                                letterSpacing: -0.26,
                                color: segment.color,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // 24.verticalSpace,

            // Buttons
            Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 20.h),
              child: Column(
                children: [
                  CustomBlueButton(
                    text: _currentPage == _onboardingPages.length - 1
                        ? 'Get Started'
                        : 'Continue',
                    onTap: _onContinueTapped,
                  ),
                  16.verticalSpace,
                  GestureDetector(
                    onTap: _onSkipTapped,
                    child: Text(
                      'Skip',
                      style: GoogleFonts.dmSans(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
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
}

// Data model for onboarding pages
class OnboardingData {
  final String image;
  final List<ColoredText> speechSegments;

  OnboardingData({required this.image, required this.speechSegments});
}

// Model for colored text segments
class ColoredText {
  final String text;
  final Color color;

  ColoredText(this.text, this.color);
}
