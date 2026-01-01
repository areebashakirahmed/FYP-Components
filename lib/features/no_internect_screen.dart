import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              "assets/animations/loader.js", // Use a proper animation
              width: 200.w,
              height: 200.h,
              repeat: true,
            ),
            SizedBox(height: 20.h),
            Text("No Internet Connection", style: TextStyle(fontSize: 20.sp)),
            SizedBox(height: 10.h),
            Text(
              "Please check your internet and try again.",
              style: TextStyle(fontSize: 16.sp),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
