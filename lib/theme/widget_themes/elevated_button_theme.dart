import 'package:flutter/material.dart';
import 'package:mehfilista/utils/constants/colors.dart';
import 'package:mehfilista/utils/constants/sizes.dart';
// import '../../constants/colors.dart';
// import '../../constants/sizes.dart';

/* -- Light & Dark Elevated Button Themes -- */
class TElevatedButtonTheme {
  TElevatedButtonTheme._(); // To avoid creating instances

  /* -- Light Theme -- */
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.light,
      // padding: const EdgeInsets.symmetric(vertical: AppSizes.buttonHeight),
      textStyle: TextStyle(
        fontSize: 14,
        fontFamily: 'Poppins',

        color: AppColors.textWhite,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
      ),
      // Set background to transparent so the gradient can show
      backgroundColor: Colors.transparent, // Makes the background transparent
    ).copyWith(backgroundColor: WidgetStateProperty.all(Colors.transparent)),
  );

  /* -- Dark Theme -- */
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.light,
      // padding: const EdgeInsets.symmetric(vertical: AppSizes.buttonHeight),
      textStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        color: AppColors.textWhite,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
      ),
      // Set background to transparent so the gradient can show
      backgroundColor: Colors.transparent, // Makes the background transparent
    ).copyWith(backgroundColor: WidgetStateProperty.all(Colors.transparent)),
  );
}
