import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mehfilista/features/auth/provider/auth_provider.dart';
import 'package:mehfilista/features/home/views/home_screen.dart';
import 'package:mehfilista/features/inquiry/views/inquiry_list_screen.dart';
import 'package:mehfilista/features/profile/views/user_profile_screen.dart';
import 'package:mehfilista/features/vendor/models/vendor_model.dart';
import 'package:mehfilista/features/vendor/providers/vendor_provider.dart';
import 'package:mehfilista/features/vendor/views/vendor_dashboard_screen.dart';
import 'package:mehfilista/features/vendor/views/vendor_search_screen.dart';
import 'package:mehfilista/utils/constants/app_config.dart';
import 'package:mehfilista/utils/constants/colors.dart';
import 'package:provider/provider.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  bool _vendorProfileLoadTriggered = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final vendorProvider = context.watch<VendorProvider>();
    final isVendor = authProvider.isVendor;

    // For vendors: ensure we load vendor profile so we have approval status (in case /auth/me doesn't return vendor_profile)
    if (isVendor &&
        authProvider.token != null &&
        !_vendorProfileLoadTriggered) {
      _vendorProfileLoadTriggered = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && context.mounted) {
          context.read<VendorProvider>().loadMyVendorProfile(authProvider.token!);
        }
      });
    }

    // Approval status: from /auth/me embed or from GET /vendors/me (VendorProvider)
    final ApprovalStatus? approvalStatus = isVendor
        ? (authProvider.user?.vendorProfile?.approvalStatus ??
            vendorProvider.myVendorProfile?.approvalStatus)
        : null;
    final bool isVendorVerified =
        approvalStatus == ApprovalStatus.approved;

    // Different screens for vendor vs user
    final List<Widget> userScreens = [
      const HomeScreen(),
      const VendorSearchScreen(),
      const InquiryListScreen(),
      const UserProfileScreen(),
    ];

    final List<Widget> vendorScreens = [
      const VendorDashboardScreen(),
      const InquiryListScreen(),
      const UserProfileScreen(),
    ];

    final screens = isVendor ? vendorScreens : userScreens;

    // Make sure index is within bounds
    if (_currentIndex >= screens.length) {
      _currentIndex = 0;
    }

    return Scaffold(
      body: Column(
        children: [
          // Demo mode banner
          if (kDemoMode)
            Container(
              width: double.infinity,
              color: Colors.orange,
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Text(
                '🎭 Demo Mode - No server required',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          // Vendor verification banner: show when vendor is not approved (pending, rejected, or status not loaded yet)
          if (isVendor && !isVendorVerified)
            _buildVerificationBanner(approvalStatus?.name ?? 'pending'),
          Expanded(
            child: IndexedStack(index: _currentIndex, children: screens),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: isVendor ? _buildVendorNavBar() : _buildUserNavBar(),
          ),
        ),
      ),
    );
  }

  Widget _buildVerificationBanner(String approvalStatus) {
    // Only show banner if not approved
    if (approvalStatus == 'approved') {
      return const SizedBox.shrink();
    }

    final isPending = approvalStatus == 'pending';

    return Container(
      width: double.infinity,
      color: isPending ? Colors.amber.shade100 : Colors.red.shade100,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Icon(
              isPending ? Icons.hourglass_bottom : Icons.warning,
              color: isPending ? Colors.amber.shade900 : Colors.red.shade900,
              size: 20.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isPending
                        ? 'Not verified yet'
                        : 'Verification Rejected',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: isPending
                          ? Colors.amber.shade900
                          : Colors.red.shade900,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    isPending
                        ? 'Admin will verify your profile, then you can use the app fully.'
                        : 'Your profile was rejected. Please contact support at Mehfilista@gmail.com',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: isPending
                          ? Colors.amber.shade800
                          : Colors.red.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserNavBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildNavItem(
          icon: Icons.home_outlined,
          activeIcon: Icons.home,
          label: 'Home',
          index: 0,
        ),
        _buildNavItem(
          icon: Icons.search_outlined,
          activeIcon: Icons.search,
          label: 'Search',
          index: 1,
        ),
        _buildNavItem(
          icon: Icons.mail_outline,
          activeIcon: Icons.mail,
          label: 'Inquiries',
          index: 2,
        ),
        _buildNavItem(
          icon: Icons.person_outline,
          activeIcon: Icons.person,
          label: 'Profile',
          index: 3,
        ),
      ],
    );
  }

  Widget _buildVendorNavBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildNavItem(
          icon: Icons.dashboard_outlined,
          activeIcon: Icons.dashboard,
          label: 'Dashboard',
          index: 0,
        ),
        _buildNavItem(
          icon: Icons.mail_outline,
          activeIcon: Icons.mail,
          label: 'Inquiries',
          index: 1,
        ),
        _buildNavItem(
          icon: Icons.person_outline,
          activeIcon: Icons.person,
          label: 'Profile',
          index: 2,
        ),
      ],
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.primary : Colors.grey,
              size: 24.sp,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.primary : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
