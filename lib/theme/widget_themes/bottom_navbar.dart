import 'package:flutter/material.dart';
import 'package:mehfilista/utils/constants/colors.dart';
// import 'package:vipera/utils/constants/colors.dart'; // Make sure to add your custom colors here

class TBottomNavigationBarTheme {
  TBottomNavigationBarTheme._();

  // Light theme for the BottomNavigationBar
  static BottomNavigationBarThemeData lightBottomNavTheme =
      BottomNavigationBarThemeData(
        backgroundColor:
            AppColors.white, // Background color for the BottomNavBar
        selectedItemColor: AppColors.buttonPrimary, // Selected item color
        unselectedItemColor: AppColors.textSecondary, // Unselected item color
        showUnselectedLabels: true, // Show labels for unselected items
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600, // Bold font for selected tab labels
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400, // Regular font for unselected tab labels
        ),
      );

  // Dark theme for the BottomNavigationBar
  static BottomNavigationBarThemeData darkBottomNavTheme =
      BottomNavigationBarThemeData(
        backgroundColor: AppColors.primary.withOpacity(0.1), // Dark background
        selectedItemColor: AppColors.buttonPrimary, // Selected item color
        unselectedItemColor: AppColors.textSecondary, // Unselected item color
        showUnselectedLabels: true, // Show labels for unselected items
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600, // Bold font for selected tab labels
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400, // Regular font for unselected tab labels
        ),
      );
}
