import 'package:flutter/material.dart';
import 'package:mehfilista/utils/constants/colors.dart';
import 'package:mehfilista/utils/constants/sizes.dart';
// import 'package:t_store/utils/constants/colors.dart';
// import 'package:vipera/utils/constants/colors.dart';
// import '../../constants/sizes.dart';

class TTextFormFieldTheme {
  TTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: AppColors.darkGrey,
    suffixIconColor: AppColors.darkGrey,
    contentPadding: EdgeInsets.all(AppSizes.spaceBtwInputFields),
    constraints: BoxConstraints.expand(height: AppSizes.inputFeildHeight),
    // labelStyle: const TextStyle().copyWith(
    //   fontSize: AppSizes.fontSizeXsm,
    //   color: AppColors.black,
    // ),
    hintStyle: const TextStyle().copyWith(
      fontSize: AppSizes.fontSizeXsm,
      color: AppColors.textSecondary,
      fontWeight: FontWeight.w400,
    ),
    fillColor: AppColors.textfieldBglight,
    errorStyle: const TextStyle().copyWith(
      fontSize: AppSizes.fontSizeXsm,
      color: AppColors.warning,
      fontWeight: FontWeight.w400,
    ),

    filled: true,
    // errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    // floatingLabelStyle: const TextStyle().copyWith(
    //   color: AppColors.black.withOpacity(0.8),
    // ),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: Colors.transparent),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: Colors.transparent),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: Colors.transparent),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: AppColors.warning),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: AppColors.warning),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,

    prefixIconColor: AppColors.darkGrey,
    suffixIconColor: AppColors.darkGrey,
    errorStyle: const TextStyle().copyWith(
      fontSize: AppSizes.fontSizeXsm,
      color: AppColors.warning,
      fontWeight: FontWeight.w400,
    ),
    constraints: BoxConstraints.expand(height: AppSizes.inputFeildHeight),
    // labelStyle: const TextStyle().copyWith(
    //   fontSize: AppSizes.fontSizeXsm,
    //   color: AppColors.white,
    //   fontWeight: FontWeight.w600,
    // ),
    fillColor: AppColors.textfieldBgdark,
    filled: true,
    hintStyle: const TextStyle().copyWith(
      fontSize: AppSizes.fontSizeXsm,
      color: AppColors.textSecondary,
      fontWeight: FontWeight.w400,
    ),
    floatingLabelStyle: const TextStyle().copyWith(
      color: AppColors.white.withOpacity(0.8),
    ),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: Colors.transparent),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: Colors.transparent),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: Colors.transparent),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: AppColors.warning),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: AppColors.warning),
    ),
  );
}
