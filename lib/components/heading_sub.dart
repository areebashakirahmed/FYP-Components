import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mehfilista/utils/constants/colors.dart';

class HeadingSub extends StatelessWidget {
  final String headingtxt;
  final String subHeadTxt;
  const HeadingSub({
    super.key,
    required this.headingtxt,
    required this.subHeadTxt,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          headingtxt,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 31.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
            fontFamily: "Poppins",
          ),
        ),
        SizedBox(height: 15.h),
        Text(
          subHeadTxt,
          textAlign: TextAlign.center,

          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.greyText,
            fontFamily: "Poppins",
          ),
        ),
      ],
    );
  }
}
