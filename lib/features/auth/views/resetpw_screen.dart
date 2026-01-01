import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mehfilista/components/social_button.dart';
import 'package:mehfilista/features/auth/views/forgotpw_screen.dart';
import 'package:mehfilista/features/auth/views/signup_screen.dart';
import 'package:mehfilista/utils/constants/colors.dart';
import 'package:mehfilista/components/custom_button.dart';
import 'package:mehfilista/components/custom_textfield.dart';
import 'package:mehfilista/utils/helpers/localization_extension.dart';

class ResetpwScreen extends StatefulWidget {
  ResetpwScreen({super.key});

  @override
  State<ResetpwScreen> createState() => _ResetpwScreenState();
}

class _ResetpwScreenState extends State<ResetpwScreen> {
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmpasswordController =
      TextEditingController();

  bool isChecked = false;
  // checkbox state
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.loc.resetpw,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),

              SizedBox(height: 50.h),

              CustomTextfield(
                hintText: "",
                heading: context.loc.newpw,
                controller: TextEditingController(),
                isPassword: true,
              ),

              SizedBox(height: 20.h),

              CustomTextfield(
                hintText: "",
                heading: context.loc.scpw,
                controller: TextEditingController(),
                isPassword: true,
              ),

              SizedBox(height: 40.h),

              CustomButton(
                btnText: context.loc.verify,
                onTap: () {},
                height: 50.h,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
