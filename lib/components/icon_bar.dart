import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mehfilista/utils/constants/colors.dart';

class IconBar extends StatelessWidget {
  const IconBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.sp),
              color: AppColors.black.withOpacity(0.32),
              border: Border.all(color: AppColors.borderSecondary, width: 1.sp),
            ),
            child: Center(
              child: Icon(
                Icons.arrow_back,
                color: AppColors.primary,
                size: 25.sp,
              ),
            ),
          ),
        ),
        Image.asset(
          "assets/logoapp.png",
          width: 112,
          height: 72,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
        ),
        Text(""),
      ],
    );
  }
}
