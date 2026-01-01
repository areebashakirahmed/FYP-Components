import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mehfilista/components/custom_button.dart';
import 'package:mehfilista/utils/constants/colors.dart';

class IdentifyScreen extends StatefulWidget {
  const IdentifyScreen({super.key});

  @override
  State<IdentifyScreen> createState() => _IdentifyScreenState();
}

class _IdentifyScreenState extends State<IdentifyScreen> {
  // Controllers
  final TextEditingController nameController = TextEditingController();

  // State
  String? selectedGender;
  String? selectedPreference;

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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Heading + Description
            Column(
              children: [
                Text(
                  "Identify Yourself",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  "We’ll use this info to personalize your experience\nand show you better matches.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w300,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            SizedBox(height: 37.h),

            // Name Field
            Text(
              "Your Name",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w300,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 6.h),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Your Name Here",
                filled: true,
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.2,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 14.h,
                ),
              ),
            ),
            SizedBox(height: 27.h),

            // Birthday Field
            Text(
              "Your Birthday",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w300,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 6.h),
            Row(
              children: [
                _dobField("MM"),
                SizedBox(width: 8.w),
                _dobField("DD"),
                SizedBox(width: 8.w),
                _dobField("YY"),
              ],
            ),
            SizedBox(height: 27.h),

            // Gender Selection
            Text(
              "Specify your gender",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w300,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 13.h),
            Row(
              children: [
                _selectableButton(
                  "Female",
                  Icons.female,
                  selectedGender,
                  height: 47.h,
                  fontSize: 10.sp,
                  onTap: () => setState(() => selectedGender = "Female"),
                ),
                SizedBox(width: 12.w),
                _selectableButton(
                  "Male",
                  Icons.male,
                  selectedGender,
                  height: 47.h,
                  fontSize: 10.sp,
                  onTap: () => setState(() => selectedGender = "Male"),
                ),
              ],
            ),
            SizedBox(height: 27.h),

            // Preference Selection
            Text(
              "Your Preference",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w300,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 6.h),
            Row(
              children: [
                _selectableButton(
                  "Female",
                  null,
                  selectedPreference,
                  height: 45.h,
                  fontSize: 15.sp,
                  onTap: () => setState(() => selectedPreference = "Female"),
                ),
                SizedBox(width: 12.w),
                _selectableButton(
                  "Male",
                  null,
                  selectedPreference,
                  height: 45.h,
                  fontSize: 15.sp,
                  onTap: () => setState(() => selectedPreference = "Male"),
                ),
                SizedBox(width: 12.w),
                _selectableButton(
                  "Both",
                  null,
                  selectedPreference,
                  height: 45.h,
                  fontSize: 15.sp,
                  onTap: () => setState(() => selectedPreference = "Both"),
                ),
              ],
            ),

            SizedBox(height: 40.h),

            // Continue Button
            CustomButton(
              btnText: "Continue",
              onTap: () {
                // Next step logic
              },
              height: 50.h,
              width: double.infinity,
            ),

            SizedBox(height: 15.h),

            // Progress
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Step 1 of 6",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 4.h),
                LinearProgressIndicator(
                  value: 1 / 6,
                  color: AppColors.primary,
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Reusable DOB field
  Widget _dobField(String hint) {
    return Expanded(
      child: TextField(
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Theme.of(
            context,
          ).scaffoldBackgroundColor, // scaffold color
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ), // light grey border
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: Colors.grey.shade400, width: 1.2),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  // Reusable Selectable Button
  Widget _selectableButton(
    String text,
    IconData? icon,
    String? selected, {
    required VoidCallback onTap,
    required double height,
    required double fontSize,
  }) {
    final isSelected = text == selected;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: isSelected ? Colors.red.shade50 : Colors.transparent,
            border: Border.all(
              color: isSelected ? Colors.red : Colors.grey,
              width: 1.w,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Icon(
                  icon,
                  size: fontSize + 4.sp,
                  color: isSelected ? Colors.red : Colors.black,
                ),
              if (icon != null) SizedBox(width: 4.w),
              Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  color: isSelected ? Colors.red : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
