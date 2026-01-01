import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mehfilista/components/custom_button.dart';
import 'package:mehfilista/features/auth/views/login_screen.dart';
import 'package:mehfilista/features/auth/views/signup_screen.dart';
import 'package:mehfilista/utils/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mehfilista/utils/helpers/localization_extension.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: Container(
        width: double.infinity.w,
        height: double.infinity.h,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/onboarding.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(height: 40.h),

              Text(
                "Grab all events now\nonly in your hands",

                style: TextStyle(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.start,
              ),

              SizedBox(height: 12.h),

              Text(
                "Stream is here to help you to find the best events\nbased on your interests",
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.start,
              ),

              SizedBox(height: 40.h),

              CustomButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  );
                },
                btnText: "Get Started",
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
