import 'package:flutter/material.dart';
// import 'package:hip_physio/utils/constants/colors.dart';
import 'package:mehfilista/utils/constants/colors.dart';
// import 'package:vipera/utils/constants/colors.dart';

class TRadioTheme {
  TRadioTheme._();

  // Light Theme Radio Button
  static final lightRadioTheme = RadioThemeData(
    fillColor: WidgetStateProperty.all(
      AppColors.primary,
    ), // Active color for radio button
    overlayColor: WidgetStateProperty.all(
      Colors.transparent,
    ), // No overlay color
    splashRadius: 20.0, // Size of the ripple effect
    visualDensity: VisualDensity.compact, // Compact visual density
    // toggleableActiveColor:
    //     Colors.blue, // Color of the radio button when it's selected
  );

  // Dark Theme Radio Button
  static final darkRadioTheme = RadioThemeData(
    fillColor: WidgetStateProperty.all(
      AppColors.primary,
    ), // Active color for radio button
    overlayColor: WidgetStateProperty.all(
      Colors.transparent,
    ), // No overlay color

    splashRadius: 20.0, // Size of the ripple effect
    visualDensity: VisualDensity.compact, // Compact visual density
    // toggleableActiveColor:
    //     Colors.white, // Color of the radio button when it's selected
  );
}
