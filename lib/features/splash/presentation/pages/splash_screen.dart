import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';
import 'package:voice_ink/config/const/app/app_colors.dart';
import 'package:voice_ink/config/navigation/route_name.dart';
import 'package:voice_ink/features/auth/presentation/cubit/authentication/authentication_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _zoomController;
  late AnimationController _transitionController;
  late AnimationController _fadeController;

  late Animation<Color?> _colorAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _imageOpacity;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Zoom controller for first image (0-1 second)
    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _zoomController,
        curve: Curves.easeInOut,
      ),
    );

    // Transition controller for color + image change (1-2 seconds)
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _colorAnimation = ColorTween(
      begin: Colors.white,
      end: AppColors.primary,
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeInOut,
    ));

    _imageOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _transitionController,
        curve: Curves.easeInOut,
      ),
    );

    // Fade out controller (2.5-3 seconds)
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _startAnimationSequence() async {
    // Start zoom animation
    _zoomController.forward();

    // Wait 1 second, then start color + image transition
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      _transitionController.forward();
    }

    // Wait 2.5 seconds total, then fade out
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      _fadeController.forward();
    }

    // Wait 3 seconds total, then navigate based on login status
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      _navigateBasedOnAuthStatus();
    }
  }

  void _navigateBasedOnAuthStatus() {
    final authState = context.read<AuthenticationCubit>().state;

    if (authState.isLoggedIn) {
      // User is logged in -> Go to Home
      Navigator.of(context).pushReplacementNamed(RouteName.homeNavBar);
    } else {
      // User is not logged in -> Go to Launcher/Onboarding
      Navigator.of(context).pushReplacementNamed(RouteName.launcherScreen);
    }
  }

  @override
  void dispose() {
    _zoomController.dispose();
    _transitionController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _zoomController,
        _transitionController,
        _fadeController,
      ]),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _colorAnimation.value,
          body: Opacity(
            opacity: _fadeAnimation.value,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // First image - zooms in then fades out
                  Opacity(
                    opacity: 1 - _imageOpacity.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: SvgPicture.asset(AppAssets.splash_1),
                    ),
                  ),
                  // Second image - fades in
                  Opacity(
                    opacity: _imageOpacity.value,
                    child: SvgPicture.asset(AppAssets.splash_2),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}