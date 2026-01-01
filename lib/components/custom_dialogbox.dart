import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mehfilista/utils/constants/colors.dart';

class CustomDialogBox extends StatelessWidget {
  // final String title;
  final List<Widget> content;
  // final List<Widget> actions;
  final double blurSigma;
  final double borderRadius;
  final bool showTopGradient;

  const CustomDialogBox({
    super.key,
    // required this.title,
    required this.content,
    // required this.actions,
    this.blurSigma = 15,
    this.borderRadius = 20,
    this.showTopGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(20.sp),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            /// Blur + content
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
              child: Container(
                padding: EdgeInsets.all(24.sp),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1), // glass effect
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title
                    // Text(
                    //   title,
                    //   style: TextStyle(
                    //     fontSize: 20.sp,
                    //     fontWeight: FontWeight.w600,
                    //     color: Colors.white,
                    //   ),
                    // ),

                    // SizedBox(height: 16.h),

                    /// Content
                    ...content,

                    // SizedBox(height: 24.h),

                    /// Actions
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: actions,
                    // ),
                  ],
                ),
              ),
            ),

            /// Gradient overlay at top
            if (showTopGradient)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(borderRadius),
                      topRight: Radius.circular(borderRadius),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primary.withOpacity(
                          0.2,
                        ), // Using blue as primary
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(borderRadius),
                    topRight: Radius.circular(borderRadius),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.primary.withOpacity(
                        0.2,
                      ), // Using blue as primary
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

// Example usage:
