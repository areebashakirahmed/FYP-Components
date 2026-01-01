// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mehfilista/utils/constants/colors.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  double? width;
  double? height;
  final String btnText;
  Color? borderColor;
  List<Color>? mainColor;
  Color? txtColor;
  final bool isLoading;

  CustomButton({
    this.borderColor,
    this.mainColor,
    this.txtColor,
    super.key,
    // this.icon,
    this.onTap,
    this.width,
    this.height,
    required this.btnText,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null || isLoading;

    return InkWell(
      onTap: isDisabled ? null : onTap,
      child: Container(
        width: width ?? double.infinity.w,
        height: height ?? 50.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: isDisabled
              ? AppColors.primary.withOpacity(0.6)
              : AppColors.primary,
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
        child: isLoading
            ? SizedBox(
                height: 20.h,
                width: 20.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              )
            : Text(
                btnText,
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16.0.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.25,
                  color: txtColor ?? AppColors.white,
                ),
              ),
      ),
    );
  }
}
