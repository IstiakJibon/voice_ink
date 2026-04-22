import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';
import 'package:voice_ink/config/const/app/app_colors.dart';
import 'package:voice_ink/config/navigation/route_name.dart';
import 'package:voice_ink/config/utilities/enum/bloc_api_state.dart';
import 'package:voice_ink/features/auth/data/models/registation_uc.dart';
import 'package:voice_ink/features/auth/presentation/cubit/authentication/authentication_cubit.dart';
import 'package:voice_ink/features/auth/presentation/cubit/registation/registation_cubit.dart';
import 'package:voice_ink/features/auth/presentation/cubit/registation/registation_state.dart';
import 'package:voice_ink/features/auth/presentation/widgets/textfield.dart';
import 'package:voice_ink/features/launcher/presentation/widgets/custom_blue_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Full name validation - requires at least first and last name
  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    final nameParts = value.trim().split(RegExp(r'\s+'));
    if (nameParts.length < 2) {
      return 'Please enter both first and last name';
    }
    if (nameParts[0].length < 2) {
      return 'First name must be at least 2 characters';
    }
    if (nameParts[1].length < 2) {
      return 'Last name must be at least 2 characters';
    }
    return null;
  }

  // Email validation
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

  // Password validation
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Confirm password validation
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      // Split full name into first and last name
      final nameParts = _fullNameController.text.trim().split(RegExp(r'\s+'));
      final firstName = nameParts.first;
      final lastName = nameParts.sublist(1).join(' ');

      context.read<RegistrationCubit>().register(
            RegistrationUc(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              firstName: firstName,
              lastName: lastName,
            ),
          );
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
      body: BlocConsumer<RegistrationCubit, RegistrationState>(
        listener: (context, state) {
          if (state.apiState == NormalApiState.loaded) {
            // Save user data to AuthenticationCubit
            context.read<AuthenticationCubit>().makeAuthenticate(
                  user: state.userEntities,
                );

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
                    Text(
                      'Welcome aboard! Your account is ready.',
                      style: GoogleFonts.dmSans(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
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

            // Navigate to home
            Navigator.pushReplacementNamed(context, RouteName.homeNavBar);
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
                        'Create an account',
                        style: GoogleFonts.dmSans(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                          height: 28 / 22,
                          letterSpacing: -0.26,
                          color: Colors.black,
                        ),
                      ),
                      8.verticalSpace,
                      Row(
                        children: [
                          Text(
                            'Already have an account? ',
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

                      16.verticalSpace,

                      // Full Name field
                      AuthTextFormField(
                        label: 'Full Name',
                        controller: _fullNameController,
                        keyboardType: TextInputType.name,
                        validator: _validateFullName,
                      ),

                      16.verticalSpace,

                      // Email/Phone field
                      AuthTextFormField(
                        label: 'Email address',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),

                      16.verticalSpace,

                      // Password field
                      AuthTextFormField(
                        label: 'Password',
                        controller: _passwordController,
                        isPassword: true,
                        validator: _validatePassword,
                      ),

                      16.verticalSpace,

                      // Confirm Password field
                      AuthTextFormField(
                        label: 'Confirm Password',
                        controller: _confirmPasswordController,
                        isPassword: true,
                        validator: _validateConfirmPassword,
                      ),

                      24.verticalSpace,

                      // Create Account Button with loading state
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
                              text: 'Create Account',
                              onTap: _handleSignUp,
                            ),

                      32.verticalSpace,

                      // Divider with text
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: const Color(0xFFF2F2F7),
                              thickness: 1,
                              endIndent: 10.w,
                            ),
                          ),
                          Text(
                            'or sign up with',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.dmSans(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              height: 18 / 13,
                              letterSpacing: -0.08,
                              color: const Color(0xFF3C3C43).withOpacity(0.6),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: const Color(0xFFF2F2F7),
                              thickness: 1,
                              indent: 10.w,
                            ),
                          ),
                        ],
                      ),

                      32.verticalSpace,

                      // Social login buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              // Google sign in
                            },
                            child: Container(
                              width: 104.h,
                              height: 56.w,
                              decoration: BoxDecoration(
                                color: const Color(0xffF2F2F7),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Center(
                                child: SvgPicture.asset(AppAssets.google),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // Apple sign in
                            },
                            child: Container(
                              width: 104.h,
                              height: 56.w,
                              decoration: BoxDecoration(
                                color: const Color(0xffF2F2F7),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Center(
                                child: SvgPicture.asset(AppAssets.apple),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // Facebook sign in
                            },
                            child: Container(
                              width: 104.h,
                              height: 56.w,
                              decoration: BoxDecoration(
                                color: const Color(0xffF2F2F7),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Center(
                                child: SvgPicture.asset(AppAssets.facebook),
                              ),
                            ),
                          ),
                        ],
                      ),

                      102.verticalSpace,

                      // Terms and Privacy
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: GoogleFonts.dmSans(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            height: 18 / 14,
                            color: const Color(0xFF3C3C43).withOpacity(0.6),
                          ),
                          children: [
                            const TextSpan(
                              text: 'By creating an account, you agree to our ',
                            ),
                            TextSpan(
                              text: 'Terms',
                              style: GoogleFonts.dmSans(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                height: 18 / 14,
                                color: AppColors.primary,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Navigate to terms
                                },
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: GoogleFonts.dmSans(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                height: 18 / 14,
                                color: AppColors.primary,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Navigate to privacy policy
                                },
                            ),
                          ],
                        ),
                      ),

                      32.verticalSpace,
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