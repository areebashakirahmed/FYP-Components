import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mehfilista/features/vendor/models/vendor_model.dart';
import 'package:mehfilista/features/vendor/providers/vendor_provider.dart';
import 'package:mehfilista/features/vendor/views/vendor_detail_screen.dart';
import 'package:mehfilista/utils/constants/colors.dart';
import 'package:provider/provider.dart';

class VendorSearchScreen extends StatefulWidget {
  final String? initialCategory;
  final String? initialLocation;

  const VendorSearchScreen({
    super.key,
    this.initialCategory,
    this.initialLocation,
  });

  @override
  State<VendorSearchScreen> createState() => _VendorSearchScreenState();
}

class _VendorSearchScreenState extends State<VendorSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  String? _selectedLocation;
  double? _minRating;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _selectedLocation = widget.initialLocation;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _performSearch();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    context.read<VendorProvider>().searchVendors(
      category: _selectedCategory,
      location: _selectedLocation,
      minRating: _minRating,
      approvedOnly: true,
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => _buildFilterSheet(),
    );
  }

  Widget _buildFilterSheet() {
    return StatefulBuilder(
      builder: (context, setSheetState) {
        return Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Vendors',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setSheetState(() {
                        _selectedCategory = null;
                        _selectedLocation = null;
                        _minRating = null;
                      });
                    },
                    child: Text('Clear All'),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Category dropdown
              Text('Category', style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 8.h),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                ),
                items: [
                  DropdownMenuItem(value: null, child: Text('All Categories')),
                  DropdownMenuItem(
                    value: 'photography',
                    child: Text('Photography'),
                  ),
                  DropdownMenuItem(
                    value: 'videography',
                    child: Text('Videography'),
                  ),
                  DropdownMenuItem(value: 'catering', child: Text('Catering')),
                  DropdownMenuItem(
                    value: 'decoration',
                    child: Text('Decoration'),
                  ),
                  DropdownMenuItem(value: 'venue', child: Text('Venue')),
                  DropdownMenuItem(value: 'makeup', child: Text('Makeup')),
                  DropdownMenuItem(value: 'mehndi', child: Text('Mehndi')),
                  DropdownMenuItem(value: 'music', child: Text('Music/DJ')),
                ],
                onChanged: (value) {
                  setSheetState(() => _selectedCategory = value);
                },
              ),

              SizedBox(height: 16.h),

              // Location dropdown
              Text('Location', style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 8.h),
              DropdownButtonFormField<String>(
                value: _selectedLocation,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                ),
                items: [
                  DropdownMenuItem(value: null, child: Text('All Locations')),
                  DropdownMenuItem(value: 'Karachi', child: Text('Karachi')),
                  DropdownMenuItem(value: 'Lahore', child: Text('Lahore')),
                  DropdownMenuItem(
                    value: 'Islamabad',
                    child: Text('Islamabad'),
                  ),
                  DropdownMenuItem(
                    value: 'Rawalpindi',
                    child: Text('Rawalpindi'),
                  ),
                  DropdownMenuItem(
                    value: 'Faisalabad',
                    child: Text('Faisalabad'),
                  ),
                  DropdownMenuItem(value: 'Multan', child: Text('Multan')),
                ],
                onChanged: (value) {
                  setSheetState(() => _selectedLocation = value);
                },
              ),

              SizedBox(height: 16.h),

              // Rating slider
              Text(
                'Minimum Rating: ${_minRating?.toStringAsFixed(1) ?? 'Any'}',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Slider(
                value: _minRating ?? 0,
                min: 0,
                max: 5,
                divisions: 10,
                label: _minRating?.toStringAsFixed(1) ?? 'Any',
                onChanged: (value) {
                  setSheetState(() => _minRating = value == 0 ? null : value);
                },
              ),

              SizedBox(height: 20.h),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _performSearch();
                  },
                  child: Text(
                    'Apply Filters',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: Text(
          'Find Vendors',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: EdgeInsets.all(16.w),
            color: AppColors.primary,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search vendors...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16.w,
                ),
              ),
              onSubmitted: (_) => _performSearch(),
            ),
          ),

          // Active filters chips
          Consumer<VendorProvider>(
            builder: (context, provider, _) {
              final hasFilters =
                  provider.categoryFilter != null ||
                  provider.locationFilter != null ||
                  provider.minRatingFilter != null;

              if (!hasFilters) return SizedBox.shrink();

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Wrap(
                  spacing: 8.w,
                  children: [
                    if (provider.categoryFilter != null)
                      Chip(
                        label: Text(provider.categoryFilter!),
                        onDeleted: () {
                          _selectedCategory = null;
                          _performSearch();
                        },
                      ),
                    if (provider.locationFilter != null)
                      Chip(
                        label: Text(provider.locationFilter!),
                        onDeleted: () {
                          _selectedLocation = null;
                          _performSearch();
                        },
                      ),
                    if (provider.minRatingFilter != null)
                      Chip(
                        label: Text(
                          '${provider.minRatingFilter!.toStringAsFixed(1)}+ ⭐',
                        ),
                        onDeleted: () {
                          _minRating = null;
                          _performSearch();
                        },
                      ),
                  ],
                ),
              );
            },
          ),

          // Results
          Expanded(
            child: Consumer<VendorProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (provider.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48.sp,
                          color: Colors.red,
                        ),
                        SizedBox(height: 16.h),
                        Text(provider.error ?? 'Something went wrong'),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: _performSearch,
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (provider.vendors.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 60.sp, color: Colors.grey),
                        SizedBox(height: 16.h),
                        Text(
                          'No vendors found',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Try adjusting your filters',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: provider.vendors.length,
                  itemBuilder: (context, index) {
                    final vendor = provider.vendors[index];
                    return _buildVendorCard(vendor);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVendorCard(VendorModel vendor) {
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
        margin: EdgeInsets.only(bottom: 16.h),
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
        child: Row(
          children: [
            // Image
            Container(
              width: 120.w,
              height: 120.h,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(12.r),
                ),
              ),
              child: vendor.portfolioImages.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(12.r),
                      ),
                      child: Image.network(
                        vendor.portfolioImages.first,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Center(
                          child: Icon(
                            Icons.store,
                            color: AppColors.primary,
                            size: 40.sp,
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

            // Details
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vendor.businessName,
                      style: TextStyle(
                        fontSize: 16.sp,
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
                          size: 14.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          vendor.location,
                          style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Wrap(
                      spacing: 4.w,
                      children: vendor.category
                          .take(2)
                          .map(
                            (cat) => Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                cat,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.star, size: 16.sp, color: Colors.amber),
                            SizedBox(width: 4.w),
                            Text(
                              vendor.averageRating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ' (${vendor.totalReviews})',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          vendor.pricing,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
