import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';
import 'package:voice_ink/config/const/app/app_colors.dart';
import 'package:voice_ink/config/navigation/route_name.dart';
import 'package:voice_ink/features/launcher/presentation/widgets/custom_blue_button.dart';

class LauncherScreen extends StatefulWidget {
  const LauncherScreen({super.key});

  @override
  State<LauncherScreen> createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          crossAxisAlignment: .center,
          children: [
            20.verticalSpace,
            SvgPicture.asset(AppAssets.frameLogo),
            Image.asset(AppAssets.ob),
            10.verticalSpace,
            Text(
              'Turn your voice into\nactionable insight with',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 22.sp,
                fontWeight: FontWeight.w400,
                height: 28 / 22,
                letterSpacing: -0.26,
                color: const Color(0xFF3C3C43).withOpacity(0.6),
              ),
            ),
            Text(
              'VoiceInk',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 22.sp,
                fontWeight: FontWeight.w400,
                height: 28 / 22,
                letterSpacing: -0.26,
                color: AppColors.primary,
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w,bottom: 20.h),
              child: Column(
                children: [
                  CustomBlueButton(
                    text: 'Continue',
                    onTap: () {
                      Navigator.of(
                        context,
                      ).pushReplacementNamed(RouteName.landingScreen);
                    },
                  ),
                  16.verticalSpace,
                  InkWell(
                    onTap: () {
                       Navigator.of(context).pushNamed(RouteName.singUp);
                    },
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
