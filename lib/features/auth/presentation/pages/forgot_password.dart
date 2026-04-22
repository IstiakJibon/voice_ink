import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';
import 'package:voice_ink/config/navigation/route_name.dart';
import 'package:voice_ink/config/utilities/enum/bloc_api_state.dart';
import 'package:voice_ink/features/auth/data/models/forgot_pass_uc.dart';
import 'package:voice_ink/features/auth/presentation/cubit/forgot_password/forgot_password_cubit.dart';
import 'package:voice_ink/features/auth/presentation/cubit/forgot_password/forgot_password_state.dart';
import 'package:voice_ink/features/auth/presentation/widgets/textfield.dart';
import 'package:voice_ink/features/launcher/presentation/widgets/custom_blue_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  void _handleResetLink() {
    if (_formKey.currentState!.validate()) {
      context.read<ForgotPasswordCubit>().forgotPassword(
            ForgotPasswordUc(
              email: _emailController.text.trim(),
            ),
          );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state.apiState == NormalApiState.loaded) {
            // Show success snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 20.w,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'Reset link sent! Check your email.',
                        style: GoogleFonts.dmSans(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                backgroundColor: const Color(0xFF4CAF50),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(16.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                duration: const Duration(seconds: 2),
              ),
            );

            // Navigate to reset password screen with hash
            Navigator.of(context).pushNamed(
              RouteName.resetPassword,
              arguments: state.hash,
            );
          } else if (state.apiState == NormalApiState.failure) {
            // Show error snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: Colors.white,
                      size: 20.w,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        state.errorMessage,
                        style: GoogleFonts.dmSans(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(16.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      8.verticalSpace,
                      // Header
                      Text(
                        'Forgot password?',
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
                        'Enter your email and we will send you link to reset\nyour password',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.dmSans(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          height: 21 / 16,
                          letterSpacing: -0.31,
                          color: const Color(0xFF767679),
                        ),
                      ),
                      32.verticalSpace,
                      // Email field
                      AuthTextFormField(
                        label: 'Email address',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),
                      24.verticalSpace,

                      // Send reset link button with loading state
                      state.apiState == NormalApiState.loading
                          ? Container(
                              width: double.infinity,
                              height: 50.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFF4A59FE),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Center(
                                child: SizedBox(
                                  width: 24.w,
                                  height: 24.h,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                ),
                              ),
                            )
                          : CustomBlueButton(
                              text: 'Send reset link',
                              onTap: _handleResetLink,
                            ),

                      24.verticalSpace,
                      // Remember password link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Remember your password? ',
                            style: GoogleFonts.dmSans(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              height: 21 / 16,
                              letterSpacing: -0.31,
                              color: const Color(0xFF767679),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(RouteName.singIn);
                            },
                            child: Text(
                              'Sign in',
                              style: GoogleFonts.dmSans(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                height: 21 / 16,
                                letterSpacing: -0.31,
                                color: const Color(0xFF4A59FE),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}