import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mehfilista/utils/constants/colors.dart';

class CustomGlassContainer extends StatelessWidget {
  final List<Widget> children; // 👈 dynamic content
  final double blurSigma; // 👈 customizable blur
  final double borderRadius; // 👈 customizable radius
  final bool showHandle; // 👈 toggle drag handle
  final bool showTopGradient; // 👈 toggle gradient overlay
  // final double height;

  const CustomGlassContainer({
    // this.height,÷
    super.key,
    required this.children,
    this.blurSigma = 30,
    this.borderRadius = 20,
    this.showHandle = false,
    this.showTopGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity.w,
      // height: heig÷ht÷,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            /// Blur + content
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
              child: Container(
                width: double.infinity.w,
                // height: height.h,
                padding: EdgeInsets.all(24.sp),
                color: Colors.black.withOpacity(0.3), // glass effect
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// drag handle

                      /// dynamic content
                      ...children,

                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
            ),

            /// gradient overlay at top
            if (showTopGradient)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 60.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primary.withOpacity(0.4),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
