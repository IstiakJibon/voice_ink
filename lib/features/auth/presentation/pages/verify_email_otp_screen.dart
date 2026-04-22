import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';
import 'package:voice_ink/config/navigation/route_name.dart';
import 'package:voice_ink/features/launcher/presentation/widgets/custom_blue_button.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;

  const VerifyEmailScreen({super.key, required this.email});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _handleVerify() {
    focusNode.unfocus();

    if (pinController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the verification code')),
      );
      return;
    }

    if (pinController.text.trim().length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all 6 digits')),
      );
      return;
    }

    // Verify OTP
    print('OTP Code: ${pinController.text.trim()}');
    // Call your verification API here

    Navigator.of(context).pushNamed(RouteName.singIn);


  }

  void _handleResend() {
    pinController.clear();
    focusNode.requestFocus();

    print('Resending code to ${widget.email}');
    // Call resend OTP API here

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Code resent to ${widget.email}')));
  }

  @override
  Widget build(BuildContext context) {
    // Pinput theme for version 6.0.1
    final defaultPinTheme = PinTheme(
      width: 52.w,
      height: 52.h,
      textStyle: GoogleFonts.dmSans(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFF2F2F7), width: 1),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color(0xFF4A59FE), width: 1),
      borderRadius: BorderRadius.circular(10.r),
    );

    final submittedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color(0xFF4A59FE), width: 1),
      borderRadius: BorderRadius.circular(10.r),
    );

    final errorPinTheme = defaultPinTheme.copyBorderWith(
      border: Border.all(color: Colors.red, width: 1),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(AppAssets.backButton),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  8.verticalSpace,

                  // Header
                  Text(
                    'Verify your email',
                    style: GoogleFonts.dmSans(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      height: 28 / 22,
                      letterSpacing: -0.26,
                      color: Colors.black,
                    ),
                  ),

                  8.verticalSpace,

                  Text(
                    'Enter the 6-digit code we sent to',
                    style: GoogleFonts.dmSans(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      height: 21 / 16,
                      letterSpacing: -0.31,
                      color: const Color(0xFF767679),
                    ),
                  ),
                  Text(
                    widget.email,
                    style: GoogleFonts.dmSans(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      height: 21 / 16,
                      letterSpacing: -0.31,
                      color: const Color(0xFF767679),
                    ),
                  ),

                  32.verticalSpace,

                  // OTP Input using Pinput
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Pinput(
                      length: 6,
                      controller: pinController,
                      focusNode: focusNode,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      submittedPinTheme: submittedPinTheme,
                      errorPinTheme: errorPinTheme,
                      separatorBuilder: (index) => SizedBox(width: 8.w),
                      hapticFeedbackType: HapticFeedbackType.lightImpact,
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      autofillHints: const [AutofillHints.oneTimeCode],
                      keyboardType: TextInputType.number,
                      onCompleted: (pin) {
                        // Auto verify when all 6 digits entered
                        _handleVerify();
                      },
                      cursor: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 9.h),
                            width: 22.w,
                            height: 1.h,
                            color: const Color(0xFF4A59FE),
                          ),
                        ],
                      ),
                    ),
                  ),

                  32.verticalSpace,

                  // Verify button
                  CustomBlueButton(text: 'Verify Code', onTap: _handleVerify),

                  16.verticalSpace,

                  // Resend code
                  Center(
                    child: GestureDetector(
                      onTap: _handleResend,
                      child: Padding(
                        padding: EdgeInsets.all(8.w),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Didn\'t receive a code? ',
                                style: GoogleFonts.dmSans(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  height: 21 / 16,
                                  letterSpacing: -0.31,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: 'Resend',
                                style: GoogleFonts.dmSans(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  height: 21 / 16,
                                  letterSpacing: -0.31,
                                  color: const Color(0xFF4A59FE),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
