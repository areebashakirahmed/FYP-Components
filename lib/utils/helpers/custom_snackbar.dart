import 'package:fluttertoast/fluttertoast.dart';
import 'package:mehfilista/utils/constants/colors.dart';

// import 'dart:io';

class CustomSnackbar {
  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppColors.black,
      textColor: AppColors.primary,
      fontSize: 16.0,
    );
  }
}
