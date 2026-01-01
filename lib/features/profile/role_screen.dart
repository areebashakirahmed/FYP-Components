import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mehfilista/components/custom_button.dart';
import 'package:mehfilista/features/auth/views/signup_screen.dart';
import 'package:mehfilista/utils/constants/colors.dart';

class RoleScreen extends StatelessWidget {
  const RoleScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0),

        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 22.sp, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: AppColors.scaffoldColor,
      body: Container(
        width: double.infinity.w,
        height: double.infinity.h,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/rolebg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Select your role",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),

              SizedBox(height: 150.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/svgs/mehfil_logo.svg",
                    height: 120.h,
                  ),
                ],
              ),

              SizedBox(height: 100.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    width: 160.w,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SignupScreen(role: 'vendor'),
                        ),
                      );
                    },
                    btnText: "Vendor",
                  ),
                  CustomButton(
                    width: 160.w,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SignupScreen(role: 'user'),
                        ),
                      );
                    },
                    btnText: "User",
                  ),
                ],
              ),

              SizedBox(height: 20.h),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Mehfilista",
                    style: GoogleFonts.roboto(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w300,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
