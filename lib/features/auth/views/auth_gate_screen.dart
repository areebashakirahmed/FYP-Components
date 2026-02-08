import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mehfilista/features/auth/provider/auth_provider.dart';
import 'package:mehfilista/features/main_shell.dart';
import 'package:mehfilista/features/vendor/models/vendor_model.dart';
import 'package:mehfilista/features/vendor/providers/vendor_provider.dart';
import 'package:mehfilista/features/vendor/views/vendor_verification_pending_screen.dart';
import 'package:mehfilista/utils/constants/colors.dart';
import 'package:provider/provider.dart';

/// Decides whether to show MainShell or VendorVerificationPendingScreen.
/// Unverified vendors (pending/rejected) are blocked from app access.
class AuthGateScreen extends StatefulWidget {
  const AuthGateScreen({super.key});

  @override
  State<AuthGateScreen> createState() => _AuthGateScreenState();
}

class _AuthGateScreenState extends State<AuthGateScreen> {
  bool _resolved = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _resolveVendorStatus());
  }

  Future<void> _resolveVendorStatus() async {
    final auth = context.read<AuthProvider>();
    if (!auth.isVendor) {
      if (mounted) setState(() => _resolved = true);
      return;
    }
    // Load vendor profile if not already in user (e.g. /auth/me didn't return vendor_profile)
    if (auth.user?.vendorProfile == null && auth.token != null) {
      await context.read<VendorProvider>().loadMyVendorProfile(auth.token!);
    }
    if (mounted) setState(() => _resolved = true);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final vendorProvider = context.watch<VendorProvider>();

    if (!_resolved && authProvider.isVendor) {
      return Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              SizedBox(height: 16.h),
              Text(
                'Checking verification status...',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    if (!authProvider.isVendor) {
      return const MainShell();
    }

    final ApprovalStatus? approvalStatus =
        authProvider.user?.vendorProfile?.approvalStatus ??
        vendorProvider.myVendorProfile?.approvalStatus;

    if (approvalStatus != ApprovalStatus.approved) {
      return VendorVerificationPendingScreen(
        vendorEmail: authProvider.user?.email ?? '',
        approvalStatus: approvalStatus?.name ?? 'pending',
      );
    }

    return const MainShell();
  }
}
