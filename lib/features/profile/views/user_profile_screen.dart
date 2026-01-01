import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mehfilista/features/auth/model/user_model.dart';
import 'package:mehfilista/features/auth/provider/auth_provider.dart';
import 'package:mehfilista/features/auth/views/login_screen.dart';
import 'package:mehfilista/features/profile/views/edit_profile_screen.dart';
import 'package:mehfilista/utils/constants/colors.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: AppColors.primary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final user = authProvider.user;

          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off, size: 64.sp, color: Colors.grey),
                  SizedBox(height: 16.h),
                  Text(
                    'Not logged in',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                      );
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                // Profile Header
                _buildProfileHeader(user),
                SizedBox(height: 24.h),

                // Account Info Card
                _buildInfoCard(
                  title: 'Account Information',
                  children: [
                    _buildInfoRow(
                      icon: Icons.person,
                      label: 'Name',
                      value: user.name.isNotEmpty ? user.name : 'N/A',
                    ),
                    _buildDivider(),
                    _buildInfoRow(
                      icon: Icons.email,
                      label: 'Email',
                      value: user.email.isNotEmpty ? user.email : 'N/A',
                    ),
                    _buildDivider(),
                    _buildInfoRow(
                      icon: Icons.phone,
                      label: 'Phone',
                      value: user.phone.isNotEmpty ? user.phone : 'N/A',
                    ),
                    _buildDivider(),
                    _buildInfoRow(
                      icon: Icons.badge,
                      label: 'Role',
                      value: user.role.toUpperCase(),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Settings Card
                _buildInfoCard(
                  title: 'Settings',
                  children: [
                    _buildSettingsRow(
                      icon: Icons.notifications,
                      label: 'Notifications',
                      onTap: () {
                        Fluttertoast.showToast(msg: 'Coming soon');
                      },
                    ),
                    _buildDivider(),
                    _buildSettingsRow(
                      icon: Icons.lock,
                      label: 'Change Password',
                      onTap: () {
                        Fluttertoast.showToast(msg: 'Coming soon');
                      },
                    ),
                    _buildDivider(),
                    _buildSettingsRow(
                      icon: Icons.language,
                      label: 'Language',
                      onTap: () {
                        Fluttertoast.showToast(msg: 'Coming soon');
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Support Card
                _buildInfoCard(
                  title: 'Support',
                  children: [
                    _buildSettingsRow(
                      icon: Icons.help,
                      label: 'Help Center',
                      onTap: () {
                        Fluttertoast.showToast(msg: 'Coming soon');
                      },
                    ),
                    _buildDivider(),
                    _buildSettingsRow(
                      icon: Icons.privacy_tip,
                      label: 'Privacy Policy',
                      onTap: () {
                        Fluttertoast.showToast(msg: 'Coming soon');
                      },
                    ),
                    _buildDivider(),
                    _buildSettingsRow(
                      icon: Icons.description,
                      label: 'Terms of Service',
                      onTap: () {
                        Fluttertoast.showToast(msg: 'Coming soon');
                      },
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showLogoutDialog(context, authProvider),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                  ),
                ),
                SizedBox(height: 32.h),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(UserModel user) {
    final name = user.name;
    final email = user.email;

    return Column(
      children: [
        CircleAvatar(
          radius: 50.r,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : 'U',
            style: TextStyle(
              fontSize: 36.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          name.isNotEmpty ? name : 'User',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          email,
          style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: 16.h),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: Colors.grey),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsRow({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Icon(icon, size: 20.sp, color: Colors.grey),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
            ),
            Icon(Icons.chevron_right, size: 20.sp, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, color: Colors.grey.shade200);
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await authProvider.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false,
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
