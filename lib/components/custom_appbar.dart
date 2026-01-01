import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mehfilista/utils/constants/colors.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget firstIcon;
  final VoidCallback firstTap;
  final Widget secondIcon;
  final VoidCallback secondTap;

  const CustomAppbar({
    super.key,
    required this.title,
    required this.firstIcon,
    required this.firstTap,
    required this.secondIcon,
    required this.secondTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: preferredSize.height,
      // padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Icon Button
          InkWell(
            onTap: firstTap,
            borderRadius: BorderRadius.circular(16.sp),
            child: Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.sp),
                color: AppColors.black.withOpacity(0.32),
                border: Border.all(
                  color: AppColors.borderSecondary,
                  width: 1.sp,
                ),
              ),
              child: Center(child: firstIcon),
            ),
          ),

          // Title
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.25.sp,
            ),
          ),

          // Right Icon Button
          InkWell(
            onTap: secondTap,
            borderRadius: BorderRadius.circular(16.sp),
            child: Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.20),
                borderRadius: BorderRadius.circular(16.sp),
              ),
              padding: EdgeInsets.all(12.sp),
              child: Center(child: secondIcon),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
