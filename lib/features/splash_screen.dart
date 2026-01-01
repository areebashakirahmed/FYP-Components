import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mehfilista/features/auth/provider/auth_provider.dart';
import 'package:mehfilista/features/main_shell.dart';
import 'package:mehfilista/utils/constants/colors.dart';
import 'package:mehfilista/features/onboarding/views/onboarding_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Wait for the splash to show
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final authProvider = context.read<AuthProvider>();

    // Wait for auth to load if needed
    if (authProvider.isLoading) {
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        return authProvider.isLoading && mounted;
      });
    }

    if (!mounted) return;

    // Navigate based on auth status
    if (authProvider.isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFFFE5E5), Colors.white],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 400),
            SvgPicture.asset("assets/svgs/mehfil_logo.svg", height: 100.h),
            const Spacer(),
            Text(
              "Mehfilista",
              style: GoogleFonts.roboto(
                fontSize: 32.sp,
                fontWeight: FontWeight.w300,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
