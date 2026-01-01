// custom_loader.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomLoader {
  static void showLoader(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing the loader
      builder: (context) => Center(
        child: Lottie.asset(
          'assets/animations/loader.json',
          width: 150,
          height: 150,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  static void hideLoader(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop(); // Dismiss loader
  }
}
