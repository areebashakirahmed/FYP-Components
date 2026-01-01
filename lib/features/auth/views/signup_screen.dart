import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mehfilista/features/auth/provider/auth_provider.dart';
import 'package:mehfilista/features/auth/views/login_screen.dart';
import 'package:mehfilista/features/main_shell.dart';
import 'package:mehfilista/utils/constants/colors.dart';
import 'package:mehfilista/components/custom_button.dart';
import 'package:mehfilista/components/custom_textfield.dart';
import 'package:mehfilista/utils/helpers/localization_extension.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  final String role; // 'user' or 'vendor'

  SignupScreen({super.key, this.role = 'user'});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    cityController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    if (passwordController.text != confirmPasswordController.text) {
      Fluttertoast.showToast(msg: context.loc.pwmatch);
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.register(
      emailController.text.trim(),
      passwordController.text,
      nameController.text.trim(),
      phoneController.text.trim(),
      widget.role,
    );

    if (success && mounted) {
      Fluttertoast.showToast(msg: 'Registration successful!');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainShell()),
        (route) => false,
      );
    } else if (mounted && authProvider.error != null) {
      Fluttertoast.showToast(msg: authProvider.error!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 22.sp, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sp),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),

                  SizedBox(height: 50.h),

                  CustomTextfield(
                    hintText: "Full Name",
                    heading: "Name",
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20.h),
                  CustomTextfield(
                    hintText: "E-mail",
                    heading: context.loc.semail,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20.h),
                  CustomTextfield(
                    hintText: "City Name",
                    heading: "City",
                    controller: cityController,
                  ),

                  SizedBox(height: 20.h),
                  CustomTextfield(
                    hintText: "Contact",
                    heading: "Phone",
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20.h),

                  CustomTextfield(
                    hintText: "Password",
                    heading: context.loc.spw,
                    controller: passwordController,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),

                  CustomTextfield(
                    hintText: "Confirm Password",
                    heading: context.loc.scpw,
                    controller: confirmPasswordController,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30.h),

                  /// --- Sign Up Button
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return CustomButton(
                        btnText: context.loc.signupbtn,
                        isLoading: authProvider.isLoading,
                        onTap: authProvider.isLoading
                            ? null
                            : () => _handleSignup(),
                        height: 50.h,
                        width: double.infinity,
                      );
                    },
                  ),

                  SizedBox(height: 15.h),

                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?  ",
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => LoginScreen()),
                          );
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
