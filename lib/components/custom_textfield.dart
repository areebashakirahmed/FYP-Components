import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mehfilista/utils/constants/colors.dart';
// import 'package:hip_physio/utils/constants/colors.dart';

class CustomTextfield extends StatefulWidget {
  final String hintText;
  final String heading;
  final bool isPassword;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;

  const CustomTextfield({
    super.key,
    required this.hintText,
    required this.heading,
    this.isPassword = false,
    required this.controller,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  final FocusNode _focusNode = FocusNode();
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 11.h,
      children: [
        // Text(
        //   widget.heading,
        //   style: TextStyle(
        //     fontSize: 13.sp,
        //     fontWeight: FontWeight.w300,
        //     color: AppColors.primary,
        //   ),
        // ),
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onChanged: widget.onChanged,
          enabled: widget.enabled,
          style: TextStyle(
            fontSize: 12.0.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.secondary,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: 16.h,
              horizontal: 16.w,
            ),
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontFamily: "Poppins",
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w300,
              color: AppColors.grey,
            ),
            // prefixIcon: Padding(
            //   padding: EdgeInsets.all(12.w),
            //   child: SvgPicture.asset(
            //     widget.prefixIcon,
            //     width: 24.w,
            //     height: 24.h,
            //   ),
            // ),
            // prefixIconConstraints: BoxConstraints(
            //   minHeight: 40.h,
            //   minWidth: 40.w,
            // ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.grey,
                      size: 20.sp,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : widget.suffixIcon,
            fillColor: Color(0xffF1F1F1),
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
