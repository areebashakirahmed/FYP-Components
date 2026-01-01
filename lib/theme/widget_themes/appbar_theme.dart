import 'package:flutter/material.dart';
import 'package:mehfilista/utils/constants/colors.dart';
import 'package:mehfilista/utils/constants/sizes.dart';

class TAppBarTheme {
  TAppBarTheme._();

  static var lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: AppColors.black, size: AppSizes.iconMd),
    actionsIconTheme: IconThemeData(
      color: AppColors.black,
      size: AppSizes.iconMd,
    ),
    titleTextStyle: TextStyle(
      fontFamily: "Poppins",

      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: AppColors.black,
    ),
  );
  static var darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: AppColors.white, size: AppSizes.iconMd),
    actionsIconTheme: IconThemeData(
      color: AppColors.white,
      size: AppSizes.iconMd,
    ),
    titleTextStyle: TextStyle(
      fontFamily: "Poppins",
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
      color: AppColors.white,
    ),
  );
}
