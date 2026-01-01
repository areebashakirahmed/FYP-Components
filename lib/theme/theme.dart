import 'package:flutter/material.dart';
import 'package:mehfilista/theme/widget_themes/appbar_theme.dart';
import 'package:mehfilista/theme/widget_themes/bottom_navbar.dart';
import 'package:mehfilista/theme/widget_themes/bottom_sheet_theme.dart';
import 'package:mehfilista/theme/widget_themes/checkbox_theme.dart';
import 'package:mehfilista/theme/widget_themes/chip_theme.dart';
import 'package:mehfilista/theme/widget_themes/elevated_button_theme.dart';
import 'package:mehfilista/theme/widget_themes/outlined_button_theme.dart';
import 'package:mehfilista/theme/widget_themes/radio_theme.dart';
import 'package:mehfilista/theme/widget_themes/text_field_theme.dart';
import 'package:mehfilista/utils/constants/colors.dart';

// import 'package:t_store/utils/theme/widget_themes/appbar_theme.dart';
// import 'package:t_store/utils/theme/widget_themes/bottom_sheet_theme.dart';
// import 'package:t_store/utils/theme/widget_themes/checkbox_theme.dart';
// import 'package:t_store/utils/theme/widget_themes/chip_theme.dart';
// import 'package:t_store/utils/theme/widget_themes/elevated_button_theme.dart';
// import 'package:t_store/utils/theme/widget_themes/outlined_button_theme.dart';
// import 'package:t_store/utils/theme/widget_themes/text_field_theme.dart';
// import 'package:t_store/utils/theme/widget_themes/text_theme.dart';

// import '../constants/colors.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    // colorSchemeSeed: AppColors.accent,
    useMaterial3: true,
    fontFamily: 'Poppins',
    disabledColor: AppColors.grey,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    // textTheme: TTextTheme.lightTextTheme,
    chipTheme: TChipTheme.lightChipTheme,
    scaffoldBackgroundColor: AppColors.scaffoldColor,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    radioTheme: TRadioTheme.lightRadioTheme,
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
    // bottomAppBarTheme: BottomAppBarTheme(color: AppColors.light, height: 70.h),
    bottomNavigationBarTheme: TBottomNavigationBarTheme.lightBottomNavTheme,
  );

  static ThemeData darkTheme = ThemeData(
    // colorSchemeSeed: AppColors.accent,
    useMaterial3: true,
    fontFamily: 'Poppins',
    disabledColor: AppColors.grey,
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    // textTheme: TTextTheme.darkTextTheme,
    chipTheme: TChipTheme.darkChipTheme,
    scaffoldBackgroundColor: AppColors.dark,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    checkboxTheme: TCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    radioTheme: TRadioTheme.darkRadioTheme,
    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
    bottomNavigationBarTheme: TBottomNavigationBarTheme.darkBottomNavTheme,

    // bottomAppBarTheme: BottomAppBarTheme(color: AppColors.dark, height: 70.h),
  );
}
