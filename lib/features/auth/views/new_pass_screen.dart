import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mehfilista/components/auth_form_layout.dart';
import 'package:mehfilista/components/custom_button.dart';
import 'package:mehfilista/components/custom_textfield.dart';
import 'package:mehfilista/features/auth/views/resetpw_screen.dart';
import 'package:mehfilista/features/auth/views/verify_email_screen.dart';
import 'package:mehfilista/utils/constants/colors.dart';
import 'package:mehfilista/components/auth_form_layout.dart';
import 'package:mehfilista/utils/helpers/localization_extension.dart';

class NewPassScreen extends StatelessWidget {
  NewPassScreen({super.key});

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AuthFormLayout(
      heading: "Set a New Password",
      description:
          "Create a new password. Ensure it differs from previous ones for security",
      icon: Icon(Icons.lock, size: 130.sp, color: AppColors.primary),
      title: '',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextfield(
            hintText: "Password}",
            controller: TextEditingController(),
            heading: '',
            isPassword: true,
          ),

          SizedBox(height: 20.h),
          CustomTextfield(
            hintText: "Confirm Password",
            controller: TextEditingController(),
            heading: '',
            isPassword: true,
          ),

          SizedBox(height: 30.h),

          CustomButton(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => VerifyEmailScreen()),
              );
            },
            btnText: "Update Password",
            width: double.infinity,
            height: 50.h,
          ),
        ],
      ),
    );
  }
}
