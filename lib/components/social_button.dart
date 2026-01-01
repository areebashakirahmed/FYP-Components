// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mehfilista/utils/constants/colors.dart';

class SocialButton extends StatelessWidget {
  final VoidCallback onTap;
  double? width;
  double? height;
  final String btnText;
  Color? borderColor;
  Color? mainColor;
  Color? txtColor;
  String socialimage;

  SocialButton({
    this.borderColor,
    required this.socialimage,
    this.mainColor,
    this.txtColor,
    super.key,
    // this.icon,
    required this.onTap,
    this.width,
    this.height,
    required this.btnText,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.sp),
        width: width ?? double.infinity.w,
        height: height ?? 50.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32.r),
          color: mainColor ?? AppColors.primary,
          // gradient: LinearGradient(
          //   colors: mainColor ?? [Color(0xffBA711F), AppColors.primary],
          // ),
          border: Border.all(
            color: borderColor ?? AppColors.primary,
            width: 1.5.w,
          ),

          // color: AppColors.secondary,
        ),
        alignment: Alignment.center,
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.transparent,
              child: SvgPicture.asset(socialimage),
            ),
            SizedBox(width: 40.w),
            Text(
              btnText,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 16.0.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.25,
                color: txtColor ?? AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
