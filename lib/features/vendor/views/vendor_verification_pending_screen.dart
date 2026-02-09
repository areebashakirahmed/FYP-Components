import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mehfilista/features/auth/provider/auth_provider.dart';
import 'package:mehfilista/utils/constants/colors.dart';
import 'package:provider/provider.dart';

class VendorVerificationPendingScreen extends StatefulWidget {
  final String? vendorEmail;
  final String? approvalStatus; // 'pending' or 'rejected'

  const VendorVerificationPendingScreen({
    super.key,
    this.vendorEmail,
    this.approvalStatus = 'pending',
  });

  @override
  State<VendorVerificationPendingScreen> createState() =>
      _VendorVerificationPendingScreenState();
}

class _VendorVerificationPendingScreenState
    extends State<VendorVerificationPendingScreen> {
  @override
  Widget build(BuildContext context) {
    final isPending = widget.approvalStatus == 'pending';
    final isRejected = widget.approvalStatus == 'rejected';

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => _logout(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40.h),

            // Icon/Illustration
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                color: isPending
                    ? Colors.amber.shade50
                    : isRejected
                    ? Colors.red.shade50
                    : Colors.green.shade50,
                borderRadius: BorderRadius.circular(60.r),
              ),
              child: Center(
                child: Icon(
                  isPending
                      ? Icons.hourglass_bottom_rounded
                      : isRejected
                      ? Icons.cancel_rounded
                      : Icons.check_circle_rounded,
                  size: 60.sp,
                  color: isPending
                      ? Colors.amber.shade700
                      : isRejected
                      ? Colors.red.shade700
                      : Colors.green.shade700,
                ),
              ),
            ),

            SizedBox(height: 32.h),

            // Title
            if (isPending) ...[
              Text(
                'Verification Pending',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your account has been sent for approval.',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Please wait for more details. We will notify you via email at ${widget.vendorEmail ?? 'Mehfilista@gmail.com'} once the verification process is complete.',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Thank you for your patience!',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (isRejected) ...[
              Text(
                'Verification Rejected',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your vendor account registration has been rejected.',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.red.shade700,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Please contact support at Mehfilista@gmail.com for more information about the rejection reason.',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'You can try registering again with updated information.',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: 48.h),

            // Info Section
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade700,
                    size: 20.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      isPending
                          ? 'Vendor verification is a manual process. Our admin team reviews your information and documents carefully to ensure quality standards.'
                          : 'If you believe this is a mistake or would like to provide additional information, please contact our support team.',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.blue.shade900,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: _logout,
                child: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    await context.read<AuthProvider>().logout();
    if (mounted) {
      Fluttertoast.showToast(msg: 'Logged out successfully');
      Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
    }
  }
}
