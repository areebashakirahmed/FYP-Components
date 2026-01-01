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

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AuthFormLayout(
      heading: context.loc.forgotpw1,
      description: "Please enter your email to reset the password",
      icon: Icon(Icons.lock, size: 130.sp, color: AppColors.primary),
      title: '',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextfield(
            hintText: "Email",
            controller: emailController,
            heading: '',
          ),

          SizedBox(height: 30.h),

          CustomButton(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => VerifyEmailScreen()),
              );
            },
            btnText: "Reset Password",
            width: double.infinity,
            height: 50.h,
          ),
        ],
      ),
    );
  }
}
