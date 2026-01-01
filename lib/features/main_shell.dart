import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mehfilista/features/auth/provider/auth_provider.dart';
import 'package:mehfilista/features/home/views/home_screen.dart';
import 'package:mehfilista/features/inquiry/views/inquiry_list_screen.dart';
import 'package:mehfilista/features/profile/views/user_profile_screen.dart';
import 'package:mehfilista/features/vendor/views/vendor_search_screen.dart';
import 'package:mehfilista/features/vendor/views/vendor_dashboard_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isVendor = authProvider.isVendor;

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
