import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mehfilista/features/auth/provider/auth_provider.dart';
import 'package:mehfilista/features/home/providers/home_provider.dart';
import 'package:mehfilista/features/vendor/models/vendor_model.dart';
import 'package:mehfilista/features/vendor/views/vendor_detail_screen.dart';
import 'package:mehfilista/features/vendor/views/vendor_search_screen.dart';
import 'package:mehfilista/utils/constants/colors.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load home data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().loadRecommendations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final homeProvider = context.watch<HomeProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: Text(
          'Mehfilista',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          if (authProvider.isAuthenticated)
            IconButton(
              icon: Icon(Icons.logout, color: Colors.white),
              onPressed: () async {
                await authProvider.logout();
              },
            ),
        ],
      ),
      body: homeProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : homeProvider.hasError
          ? _buildErrorWidget(homeProvider.error ?? 'Unknown error occurred')
          : RefreshIndicator(
              onRefresh: () => homeProvider.loadRecommendations(),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome section
                      if (authProvider.isAuthenticated)
                        _buildWelcomeSection(authProvider.user?.name ?? 'User'),

                      SizedBox(height: 20.h),

                      // Statistics
                      _buildStatisticsSection(homeProvider),

                      SizedBox(height: 24.h),

                      // Categories
                      _buildSectionHeader(
                        'Categories',
                        onSeeAll: () {
                          // Navigate to all categories
                        },
                      ),
                      SizedBox(height: 12.h),
                      _buildCategoriesGrid(homeProvider),

                      SizedBox(height: 24.h),

                      // Featured Vendors
                      _buildSectionHeader(
                        'Featured Vendors',
                        onSeeAll: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VendorSearchScreen(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 12.h),
                      _buildVendorsList(homeProvider.featuredVendors),

                      SizedBox(height: 24.h),

                      // Recent Vendors
                      _buildSectionHeader(
                        'Recent Vendors',
                        onSeeAll: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VendorSearchScreen(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 12.h),
                      _buildVendorsList(homeProvider.recentVendors),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60.sp, color: Colors.red),
          SizedBox(height: 16.h),
          Text(
            'Something went wrong',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Text(
            error,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () => context.read<HomeProvider>().loadRecommendations(),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(String name) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: TextStyle(fontSize: 14.sp, color: Colors.white70),
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: 25.r,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection(HomeProvider provider) {
    return Row(
      children: [
        _buildStatCard(
          'Vendors',
          provider.totalVendors.toString(),
          Icons.store,
        ),
        SizedBox(width: 12.w),
        _buildStatCard('Reviews', provider.totalReviews.toString(), Icons.star),
        SizedBox(width: 12.w),
        _buildStatCard(
          'Events',
          provider.totalEventsBooked.toString(),
          Icons.event,
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 24.sp),
            SizedBox(height: 8.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: Text(
              'See All',
              style: TextStyle(fontSize: 14.sp, color: AppColors.primary),
            ),
          ),
      ],
    );
  }

  Widget _buildCategoriesGrid(HomeProvider provider) {
    final categories = provider.popularCategories;

    if (categories.isEmpty) {
      return Center(child: Text('No categories available'));
    }

    return SizedBox(
      height: 100.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      VendorSearchScreen(initialCategory: category.name),
                ),
              );
            },
            child: Container(
              width: 80.w,
              margin: EdgeInsets.only(right: 12.w),
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getCategoryIcon(category.icon),
                    color: AppColors.primary,
                    size: 28.sp,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '(${category.count})',
                    style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getCategoryIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'camera':
        return Icons.camera_alt;
      case 'videography':
        return Icons.videocam;
      case 'music':
        return Icons.music_note;
      case 'catering':
        return Icons.restaurant;
      case 'decoration':
        return Icons.celebration;
      case 'venue':
        return Icons.location_city;
      case 'makeup':
        return Icons.face;
      case 'mehndi':
        return Icons.brush;
      default:
        return Icons.category;
    }
  }

  Widget _buildVendorsList(List<VendorModel> vendors) {
    if (vendors.isEmpty) {
      return Container(
        height: 150.h,
        alignment: Alignment.center,
        child: Text('No vendors available'),
      );
    }

    return SizedBox(
      height: 200.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: vendors.length,
        itemBuilder: (context, index) {
          final vendor = vendors[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VendorDetailScreen(vendorId: vendor.id),
                ),
              );
            },
            child: Container(
              width: 160.w,
              margin: EdgeInsets.only(right: 12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image placeholder
                  Container(
                    height: 100.h,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12.r),
                      ),
                    ),
                    child: vendor.portfolioImages.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12.r),
                            ),
                            child: Image.network(
                              vendor.portfolioImages.first,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (_, __, ___) => Center(
                                child: Icon(
                                  Icons.image,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Icon(
                              Icons.store,
                              color: AppColors.primary,
                              size: 40.sp,
                            ),
                          ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vendor.businessName,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 12.sp,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                vendor.location,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(Icons.star, size: 14.sp, color: Colors.amber),
                            SizedBox(width: 4.w),
                            Text(
                              vendor.averageRating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              ' (${vendor.totalReviews})',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
