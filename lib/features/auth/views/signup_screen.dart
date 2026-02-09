import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mehfilista/features/auth/provider/auth_provider.dart';
import 'package:mehfilista/features/auth/views/login_screen.dart';
import 'package:mehfilista/features/location/providers/location_provider.dart';
import 'package:mehfilista/features/auth/views/auth_gate_screen.dart';
import 'package:mehfilista/utils/constants/colors.dart';
import 'package:mehfilista/components/custom_button.dart';
import 'package:mehfilista/components/custom_textfield.dart';
import 'package:mehfilista/utils/helpers/localization_extension.dart';
import 'package:mehfilista/utils/validators.dart';
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
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Load cities when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationProvider>().loadCities();
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    areaController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    if (passwordController.text != confirmPasswordController.text) {
      Fluttertoast.showToast(msg: context.loc.pwmatch);
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final locationProvider = context.read<LocationProvider>();

    // Get area from dropdown selection or text field
    final area = locationProvider.selectedArea ?? areaController.text.trim();
    if (area.isEmpty) {
      Fluttertoast.showToast(msg: 'Please select or enter an area');
      return;
    }

    final success = await authProvider.register(
      emailController.text.trim(),
      passwordController.text,
      nameController.text.trim(),
      phoneController.text.trim(),
      widget.role,
      city: locationProvider.selectedCity,
      area: area,
    );

    if (success && mounted) {
      Fluttertoast.showToast(msg: 'Registration successful!');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AuthGateScreen()),
        (route) => false,
      );
    } else if (mounted && authProvider.error != null) {
      Fluttertoast.showToast(msg: authProvider.error ?? 'Registration failed');
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
                    validator: Validators.validateName,
                  ),

                  SizedBox(height: 20.h),
                  CustomTextfield(
                    hintText: "E-mail",
                    heading: context.loc.semail,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                  ),

                  SizedBox(height: 20.h),
                  // City and Area Selection
                  Consumer<LocationProvider>(
                    builder: (context, locationProvider, _) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // City Dropdown
                          Text(
                            'City',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: locationProvider.isLoading
                                ? Padding(
                                    padding: EdgeInsets.all(16.w),
                                    child: Center(
                                      child: SizedBox(
                                        width: 20.w,
                                        height: 20.h,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                  )
                                : DropdownButtonFormField<String>(
                                    value: locationProvider.selectedCity,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 12.h,
                                      ),
                                      border: InputBorder.none,
                                      hintText: 'Select your city',
                                    ),
                                    items: locationProvider.cityNames.map((
                                      cityName,
                                    ) {
                                      return DropdownMenuItem(
                                        value: cityName,
                                        child: Text(cityName),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        locationProvider.selectCity(value);
                                        // Clear area when city changes
                                        areaController.clear();
                                      }
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please select a city';
                                      }
                                      return null;
                                    },
                                  ),
                          ),

                          // Area Field (shows when city is selected)
                          if (locationProvider.selectedCity != null) ...[
                            SizedBox(height: 16.h),
                            // Show dropdown if areas are available, otherwise show text field
                            locationProvider.areasForSelectedCity.isNotEmpty
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Area',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.black,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8.r),
                                          border: Border.all(color: Colors.grey.shade300),
                                        ),
                                        child: DropdownButtonFormField<String>(
                                          value: locationProvider.selectedArea,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16.w,
                                              vertical: 12.h,
                                            ),
                                            border: InputBorder.none,
                                            hintText: 'Select your area',
                                          ),
                                          items: locationProvider.areaNames.map((
                                            areaName,
                                          ) {
                                            return DropdownMenuItem(
                                              value: areaName,
                                              child: Text(areaName),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            if (value != null) {
                                              locationProvider.selectArea(value);
                                              areaController.text = value;
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : CustomTextfield(
                                    heading: 'Area',
                                    hintText: 'Enter your area',
                                    controller: areaController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter an area';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      locationProvider.selectArea(value);
                                    },
                                  ),
                          ],
                        ],
                      );
                    },
                  ),

                  SizedBox(height: 20.h),
                  CustomTextfield(
                    hintText: "03001234567",
                    heading: "Phone",
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validator: Validators.validatePhone,
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
