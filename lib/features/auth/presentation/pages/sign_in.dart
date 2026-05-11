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
import 'package:voice_ink/features/auth/data/models/login_uc.dart';
import 'package:voice_ink/features/auth/presentation/cubit/authentication/authentication_cubit.dart';
import 'package:voice_ink/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:voice_ink/features/auth/presentation/cubit/login/login_state.dart';
import 'package:voice_ink/features/auth/presentation/widgets/textfield.dart';
import 'package:voice_ink/features/launcher/presentation/widgets/custom_blue_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController(text: 'istiakhossainjibon@gmail.com');
  final TextEditingController _passwordController = TextEditingController(text: 'ghostjibon');
  bool _rememberMe = false;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email/Phone is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _handleSignIn() {
    if (_formKey.currentState!.validate()) {
      context.read<LoginCubit>().getLogins(
            LoginUc(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
      body: BlocConsumer<LoginCubit, LoginState>(
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
                      'Welcome back! Signed in successfully.',
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
                        'Sign in',
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
                            'Don\' have an account? ',
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
                              Navigator.of(context).pushNamed(RouteName.singUp);
                            },
                            child: Text(
                              'Create an account',
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

                      32.verticalSpace,

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

                      24.verticalSpace,

                      // Sign In Button with loading state
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
                              text: 'Sign In',
                              onTap: _handleSignIn,
                            ),

                      8.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Remember me checkbox
                          Row(
                            children: [
                              SizedBox(
                                width: 24.w,
                                height: 24.h,
                                child: Checkbox(
                                  value: _rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberMe = value ?? false;
                                    });
                                  },
                                  activeColor: const Color(0xFF4A59FE),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                              ),
                              8.horizontalSpace,
                              Text(
                                'Remember me',
                                style: GoogleFonts.dmSans(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  height: 21 / 16,
                                  letterSpacing: -0.31,
                                  color: const Color(0xFF999999),
                                ),
                              ),
                            ],
                          ),

                          // Forget password
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(RouteName.forgotPassword);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(8.w),
                              child: Text(
                                'Forget password?',
                                style: GoogleFonts.dmSans(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  height: 21 / 16,
                                  letterSpacing: -0.31,
                                  color: const Color(0xFF999999),
                                ),
                              ),
                            ),
                          ),
                        ],
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

                      174.verticalSpace,

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