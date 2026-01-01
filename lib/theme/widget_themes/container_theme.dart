import 'package:flutter/material.dart';
import 'package:mehfilista/utils/constants/colors.dart';
// import 'package:vipera/utils/constants/colors.dart'; // Import your color constants file

class TContainerTheme {
  TContainerTheme._(); // Prevent instantiation

  // Light Theme for Container
  static BoxDecoration lightContainerDecoration = BoxDecoration(
    color: AppColors.white, // Background color for the container
    borderRadius: BorderRadius.circular(16), // Border radius
    boxShadow: const [
      BoxShadow(
        color: Colors.black12, // Light shadow for the container
        blurRadius: 8,
        offset: Offset(0, 4), // Position of the shadow
      ),
    ],
  );

  // Dark Theme for Container
  static BoxDecoration darkContainerDecoration = BoxDecoration(
    color: AppColors.black, // Background color for the container
    borderRadius: BorderRadius.circular(16), // Border radius
    boxShadow: const [
      BoxShadow(
        color: Colors.black45, // Darker shadow for the container
        blurRadius: 8,
        offset: Offset(0, 4), // Position of the shadow
      ),
    ],
  );
}
