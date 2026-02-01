import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mehfilista/features/auth/provider/auth_provider.dart';
import 'package:mehfilista/features/inquiry/models/inquiry_model.dart';
import 'package:mehfilista/features/inquiry/providers/inquiry_provider.dart';
import 'package:mehfilista/features/vendor/models/vendor_model.dart';
import 'package:mehfilista/features/vendor/providers/vendor_provider.dart';
import 'package:mehfilista/features/vendor/views/vendor_packages_screen.dart';
import 'package:mehfilista/features/vendor/views/vendor_portfolio_screen.dart';
import 'package:mehfilista/features/vendor/views/vendor_profile_edit_screen.dart';
import 'package:mehfilista/utils/constants/colors.dart';
import 'package:provider/provider.dart';

class VendorDashboardScreen extends StatefulWidget {
  const VendorDashboardScreen({super.key});

  @override
  State<VendorDashboardScreen> createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDashboardData();
    });
  }

  void _loadDashboardData() {
    final authProvider = context.read<AuthProvider>();
    final token = authProvider.token;

    if (token == null) return;

    // Load vendor profile
    context.read<VendorProvider>().loadMyVendorProfile(token);

    // Load vendor inquiries
    context.read<InquiryProvider>().loadVendorInquiries(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Vendor Dashboard',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: AppColors.primary),
            onPressed: _loadDashboardData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadDashboardData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              _buildWelcomeSection(),
              SizedBox(height: 16.h),

              // Approval Status Banner
              _buildApprovalStatusBanner(),
              SizedBox(height: 16.h),

              // CNIC Verification Status
              _buildCnicVerificationCard(),
              SizedBox(height: 24.h),

              // Stats Overview
              _buildStatsOverview(),
              SizedBox(height: 24.h),

              // Pricing Tiers Section
              _buildPricingTiersSection(),
              SizedBox(height: 24.h),

              // Quick Actions
              Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: 12.h),
              _buildQuickActions(),
              SizedBox(height: 24.h),

              // Recent Inquiries
              _buildRecentInquiries(),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        final user = auth.user;
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          color: AppColors.primary,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30.r,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Text(
                    (user?.name ?? 'V')[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        user?.name ?? 'Vendor',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildApprovalStatusBanner() {
    return Consumer<VendorProvider>(
      builder: (context, vendorProvider, _) {
        final vendor = vendorProvider.myVendorProfile;
        if (vendor == null) return const SizedBox.shrink();

        Color backgroundColor;
        Color textColor;
        IconData icon;
        String message;

        switch (vendor.approvalStatus) {
          case ApprovalStatus.pending:
            backgroundColor = Colors.orange.shade50;
            textColor = Colors.orange.shade800;
            icon = Icons.hourglass_empty;
            message =
                'Your profile is under review. You\'ll be notified once approved.';
            break;
          case ApprovalStatus.approved:
            backgroundColor = Colors.green.shade50;
            textColor = Colors.green.shade800;
            icon = Icons.verified;
            message =
                'Congratulations! Your profile is approved and visible to customers.';
            break;
          case ApprovalStatus.rejected:
            backgroundColor = Colors.red.shade50;
            textColor = Colors.red.shade800;
            icon = Icons.cancel;
            message =
                vendor.rejectionReason ??
                'Your profile was rejected. Please update and resubmit.';
            break;
        }

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: textColor.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(icon, color: textColor, size: 28.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vendor.approvalStatus.displayName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      message,
                      style: TextStyle(fontSize: 12.sp, color: textColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCnicVerificationCard() {
    return Consumer<VendorProvider>(
      builder: (context, vendorProvider, _) {
        final vendor = vendorProvider.myVendorProfile;
        if (vendor == null) return const SizedBox.shrink();

        final hasCnic =
            vendor.cnicNumber != null && vendor.cnicNumber!.isNotEmpty;
        final hasCnicImages =
            vendor.cnicFrontImage != null && vendor.cnicBackImage != null;
        final isVerified =
            hasCnic &&
            hasCnicImages &&
            vendor.approvalStatus == ApprovalStatus.approved;

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: isVerified
                        ? Colors.green.shade50
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    isVerified ? Icons.verified_user : Icons.badge_outlined,
                    color: isVerified ? Colors.green : Colors.grey,
                    size: 28.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CNIC Verification',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        isVerified
                            ? 'Verified ✓'
                            : hasCnic
                            ? 'Pending verification'
                            : 'Not submitted',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isVerified ? Colors.green : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!hasCnic)
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VendorProfileEditScreen(),
                        ),
                      );
                    },
                    child: Text('Add CNIC'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPricingTiersSection() {
    return Consumer<VendorProvider>(
      builder: (context, vendorProvider, _) {
        final vendor = vendorProvider.myVendorProfile;
        if (vendor == null) return const SizedBox.shrink();

        final hasPackages =
            vendor.basicPackage != null ||
            vendor.premiumPackage != null ||
            vendor.luxuryPackage != null;

        if (!hasPackages) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  Icon(
                    Icons.price_change_outlined,
                    size: 48.sp,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'No pricing packages set',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  ),
                  SizedBox(height: 8.h),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VendorPackagesScreen(),
                        ),
                      );
                    },
                    child: Text('Add Packages'),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Pricing Packages',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: 12.h),
            if (vendor.basicPackage != null)
              _buildPricingTierItem(
                'Basic',
                vendor.basicPackage!,
                Colors.green,
              ),
            if (vendor.premiumPackage != null)
              _buildPricingTierItem(
                'Premium',
                vendor.premiumPackage!,
                Colors.blue,
              ),
            if (vendor.luxuryPackage != null)
              _buildPricingTierItem(
                'Luxury',
                vendor.luxuryPackage!,
                Colors.amber.shade700,
              ),
          ],
        );
      },
    );
  }

  Widget _buildPricingTierItem(String name, dynamic tier, Color color) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.star, color: color, size: 20.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$name Package',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  if (tier.description != null && tier.description!.isNotEmpty)
                    Text(
                      tier.description!,
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Rs. ${tier.basePrice?.toStringAsFixed(0) ?? '0'}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                Text(
                  '+Rs. ${tier.perHeadPrice?.toStringAsFixed(0) ?? '0'}/head',
                  style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsOverview() {
    return Consumer2<InquiryProvider, VendorProvider>(
      builder: (context, inquiryProvider, vendorProvider, _) {
        final pendingCount = inquiryProvider.pendingInquiries.length;
        final totalInquiries = inquiryProvider.vendorInquiries.length;

        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.mail_outline,
                label: 'Total Inquiries',
                value: '$totalInquiries',
                color: Colors.blue,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildStatCard(
                icon: Icons.pending_outlined,
                label: 'Pending',
                value: '$pendingCount',
                color: Colors.orange,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: color, size: 24.sp),
            ),
            SizedBox(height: 12.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.edit,
                label: 'Edit Profile',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VendorProfileEditScreen(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildActionCard(
                icon: Icons.photo_library,
                label: 'Portfolio',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VendorPortfolioScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.price_change,
                label: 'Packages',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VendorPackagesScreen(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(child: SizedBox()), // Empty space for future actions
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 32.sp),
              SizedBox(height: 8.h),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentInquiries() {
    return Consumer<InquiryProvider>(
      builder: (context, provider, _) {
        final inquiries = provider.vendorInquiries.take(3).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Inquiries',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to inquiries tab (index 1 for vendor)
                  },
                  child: Text(
                    'View All',
                    style: TextStyle(fontSize: 14.sp, color: AppColors.primary),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            if (provider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (inquiries.isEmpty)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 48.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'No inquiries yet',
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              ...inquiries.map((inquiry) => _buildInquiryItem(inquiry)),
          ],
        );
      },
    );
  }

  Widget _buildInquiryItem(InquiryModel inquiry) {
    Color statusColor;
    switch (inquiry.status) {
      case InquiryStatus.pending:
        statusColor = Colors.orange;
        break;
      case InquiryStatus.accepted:
        statusColor = Colors.green;
        break;
      case InquiryStatus.declined:
        statusColor = Colors.red;
        break;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.1),
          child: Icon(Icons.event, color: statusColor, size: 20.sp),
        ),
        title: Text(
          inquiry.eventType,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          inquiry.preferredDate,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            inquiry.status.name,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: statusColor,
            ),
          ),
        ),
      ),
    );
  }
}
