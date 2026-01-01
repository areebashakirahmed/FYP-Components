import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mehfilista/utils/constants/colors.dart';

class AuthFormLayout extends StatelessWidget {
  final String heading;
  final String? description;
  final Widget? icon;
  final Widget child;

  const AuthFormLayout({
    super.key,
    required this.heading,
    this.description,
    this.icon,
    required this.child,
    required String title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 22.sp, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // SizedBox(height: 30.h),
              Text(
                heading,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),

              SizedBox(height: 10.h),

              if (description != null)
                Text(
                  description!,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),

              SizedBox(height: 30.h),

              child,
            ],
          ),
        ),
      ),
    );
  }
}
