import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mehfilista/components/custom_button.dart';
import 'package:mehfilista/features/auth/views/identification_screen.dart';
import 'package:mehfilista/features/auth/views/new_pass_screen.dart';
import 'package:mehfilista/features/auth/views/signup_screen.dart';
import 'package:mehfilista/utils/constants/colors.dart';
import 'package:mehfilista/utils/helpers/localization_extension.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:mehfilista/components/auth_form_layout.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthFormLayout(
      title: "",
      heading: "Check Your Email",
      description:
          "We sent a reset link to contact@dscode...com enter 5 digit code that mentioned in the email",
      icon: Icon(Icons.mail, size: 180.sp, color: Colors.red.shade600),
      child: Column(
        children: [
          // OTP Input
          PinCodeTextField(
            appContext: context,
            length: 5,
            onChanged: (value) {},
            keyboardType: TextInputType.number,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,

              borderRadius: BorderRadius.circular(8.r),
              fieldOuterPadding: EdgeInsets.symmetric(horizontal: 5.w),

              fieldHeight: 45.h,
              fieldWidth: 45.w,

              inactiveColor: Colors.black26,
              activeColor: AppColors.primary,
              selectedColor: AppColors.primary,
              activeFillColor: AppColors.scaffoldColor,
              inactiveFillColor: AppColors.scaffoldColor,
              selectedFillColor: AppColors.scaffoldColor,
            ),
            enableActiveFill: false,
            backgroundColor: AppColors.scaffoldColor,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),

          SizedBox(height: 30.h),

          // Verify Button
          CustomButton(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NewPassScreen()),
              );
            },
            btnText: context.loc.verify,
            width: double.infinity,
            height: 50.h,
          ),
          SizedBox(height: 60.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Have'nt got the email yet?  ",
                style: TextStyle(fontSize: 14.sp),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SignupScreen()),
                  );
                },
                child: Text(
                  "Resend Email",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
