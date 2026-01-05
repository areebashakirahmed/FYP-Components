import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mehfilista/features/auth/provider/auth_provider.dart';
import 'package:mehfilista/features/inquiry/providers/inquiry_provider.dart';
import 'package:mehfilista/features/review/providers/review_provider.dart';
import 'package:mehfilista/features/vendor/providers/vendor_provider.dart';
import 'package:mehfilista/utils/constants/colors.dart';
import 'package:provider/provider.dart';

class VendorDetailScreen extends StatefulWidget {
  final String vendorId;

  const VendorDetailScreen({super.key, required this.vendorId});

  @override
  State<VendorDetailScreen> createState() => _VendorDetailScreenState();
}

class _VendorDetailScreenState extends State<VendorDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VendorProvider>().getVendorDetails(widget.vendorId);
      context.read<ReviewProvider>().loadVendorReviews(widget.vendorId);
    });
  }

  void _showInquiryDialog() {
    final authProvider = context.read<AuthProvider>();

    if (!authProvider.isAuthenticated) {
      Fluttertoast.showToast(msg: 'Please login to send an inquiry');
      return;
    }

    if (authProvider.isVendor) {
      Fluttertoast.showToast(msg: 'Vendors cannot send inquiries');
      return;
    }

    final eventTypeController = TextEditingController();
    final dateController = TextEditingController();
    final messageController = TextEditingController();
    DateTime? selectedDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 20.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Send Inquiry',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.h),

              // Event Type
              TextField(
                controller: eventTypeController,
                decoration: InputDecoration(
                  labelText: 'Event Type',
                  hintText: 'e.g., Wedding, Birthday, Corporate',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // Preferred Date
              TextField(
                controller: dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Preferred Date',
                  hintText: 'Select date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(Duration(days: 7)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (date != null) {
                    selectedDate = date;
                    dateController.text =
                        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                  }
                },
              ),
              SizedBox(height: 12.h),

              // Message
              TextField(
                controller: messageController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Message',
                  hintText: 'Describe your requirements...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Submit Button
              Consumer<InquiryProvider>(
                builder: (context, inquiryProvider, _) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      onPressed: inquiryProvider.isLoading
                          ? null
                          : () async {
                              if (eventTypeController.text.isEmpty ||
                                  dateController.text.isEmpty ||
                                  messageController.text.isEmpty) {
                                Fluttertoast.showToast(
                                  msg: 'Please fill all fields',
                                );
                                return;
                              }

                              final success = await inquiryProvider.sendInquiry(
                                token: authProvider.token ?? '',
                                vendorId: widget.vendorId,
                                eventType: eventTypeController.text,
                                preferredDate: dateController.text,
                                message: messageController.text,
                              );

                              if (success && context.mounted) {
                                Navigator.pop(context);
                                Fluttertoast.showToast(
                                  msg: 'Inquiry sent successfully!',
                                );
                              } else if (inquiryProvider.error != null) {
                                Fluttertoast.showToast(
                                  msg: inquiryProvider.error ?? 'Failed to send inquiry',
                                );
                              }
                            },
                      child: inquiryProvider.isLoading
                          ? SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Send Inquiry',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showReviewDialog() {
    final authProvider = context.read<AuthProvider>();

    if (!authProvider.isAuthenticated) {
      Fluttertoast.showToast(msg: 'Please login to leave a review');
      return;
    }

    if (authProvider.isVendor) {
      Fluttertoast.showToast(msg: 'Vendors cannot leave reviews');
      return;
    }

    int selectedRating = 5;
    final commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 20.h,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Leave a Review',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Rating
                  Text('Rating', style: TextStyle(fontWeight: FontWeight.w500)),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < selectedRating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 36.sp,
                        ),
                        onPressed: () {
                          setSheetState(() => selectedRating = index + 1);
                        },
                      );
                    }),
                  ),
                  SizedBox(height: 12.h),

                  // Comment
                  TextField(
                    controller: commentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Comment',
                      hintText: 'Share your experience...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Submit Button
                  Consumer<ReviewProvider>(
                    builder: (context, reviewProvider, _) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          onPressed: reviewProvider.isLoading
                              ? null
                              : () async {
                                  final comment = commentController.text.trim();
                                  if (comment.isEmpty) {
                                    Fluttertoast.showToast(
                                      msg: 'Please add a comment',
                                    );
                                    return;
                                  }
                                  if (comment.length < 10) {
                                    Fluttertoast.showToast(
                                      msg: 'Comment must be at least 10 characters',
                                    );
                                    return;
                                  }

                                  final success = await reviewProvider
                                      .leaveReview(
                                        token: authProvider.token ?? '',
                                        vendorId: widget.vendorId,
                                        rating: selectedRating,
                                        comment: comment,
                                      );

                                  if (success && context.mounted) {
                                    Navigator.pop(context);
                                    Fluttertoast.showToast(
                                      msg: 'Review submitted!',
                                    );
                                  } else if (reviewProvider.error != null) {
                                    Fluttertoast.showToast(
                                      msg: reviewProvider.error ?? 'Failed to submit review',
                                    );
                                  }
                                },
                          child: reviewProvider.isLoading
                              ? SizedBox(
                                  height: 20.h,
                                  width: 20.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Submit Review',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: Consumer<VendorProvider>(
        builder: (context, vendorProvider, _) {
          if (vendorProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (vendorProvider.hasError ||
              vendorProvider.selectedVendor == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60.sp, color: Colors.red),
                  SizedBox(height: 16.h),
                  Text(vendorProvider.error ?? 'Vendor not found'),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () =>
                        vendorProvider.getVendorDetails(widget.vendorId),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final vendor = vendorProvider.selectedVendor!;

          return CustomScrollView(
            slivers: [
              // App Bar with Image
              SliverAppBar(
                expandedHeight: 250.h,
                pinned: true,
                backgroundColor: AppColors.primary,
                leading: IconButton(
                  icon: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.arrow_back, color: AppColors.primary),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: vendor.portfolioImages.isNotEmpty
                      ? Image.network(
                          vendor.portfolioImages.first,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.primary.withOpacity(0.3),
                            child: Center(
                              child: Icon(
                                Icons.store,
                                size: 60.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          color: AppColors.primary.withOpacity(0.3),
                          child: Center(
                            child: Icon(
                              Icons.store,
                              size: 60.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Business Name & Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              vendor.businessName,
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 18.sp,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  vendor.averageRating.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),

                      // Location
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 18.sp,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            vendor.location,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // Categories
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: vendor.category.map((cat) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              cat,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 24.h),

                      // Services
                      _buildSection('Services', vendor.services),
                      SizedBox(height: 16.h),

                      // Event Types
                      _buildSection(
                        'Event Types',
                        vendor.eventTypes.join(', '),
                      ),
                      SizedBox(height: 16.h),

                      // Pricing
                      _buildSection('Pricing', vendor.pricing),
                      SizedBox(height: 16.h),

                      // Pricing Packages
                      if (vendor.pricingPackages.isNotEmpty) ...[
                        Text(
                          'Pricing Packages',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        ...vendor.pricingPackages.map((package) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.2),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      package.name,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 4.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                      ),
                                      child: Text(
                                        package.price,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (package.description.isNotEmpty) ...[
                                  SizedBox(height: 8.h),
                                  Text(
                                    package.description,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                                if (package.features != null &&
                                    package.features!.isNotEmpty) ...[
                                  SizedBox(height: 12.h),
                                  Wrap(
                                    spacing: 8.w,
                                    runSpacing: 8.h,
                                    children: package.features!.map((feature) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              AppColors.primary.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(16.r),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.check,
                                              size: 14.sp,
                                              color: AppColors.primary,
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              feature,
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }),
                        SizedBox(height: 8.h),
                      ],

                      // Availability
                      _buildSection('Availability', vendor.availability),
                      SizedBox(height: 16.h),

                      // Contact Info
                      if (vendor.contactPhone != null ||
                          vendor.contactEmail != null) ...[
                        Text(
                          'Contact',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        if (vendor.contactPhone != null)
                          Row(
                            children: [
                              Icon(Icons.phone,
                                  size: 18.sp, color: Colors.grey),
                              SizedBox(width: 8.w),
                              Text(
                                vendor.contactPhone!,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        if (vendor.contactEmail != null) ...[
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Icon(Icons.email,
                                  size: 18.sp, color: Colors.grey),
                              SizedBox(width: 8.w),
                              Text(
                                vendor.contactEmail!,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                        SizedBox(height: 16.h),
                      ],

                      // Description
                      if (vendor.description != null &&
                          vendor.description!.isNotEmpty) ...[
                        _buildSection('About', vendor.description!),
                        SizedBox(height: 16.h),
                      ],

                      // Portfolio Images
                      if (vendor.portfolioImages.length > 1) ...[
                        Text(
                          'Portfolio',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        SizedBox(
                          height: 120.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: vendor.portfolioImages.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 120.w,
                                margin: EdgeInsets.only(right: 8.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Image.network(
                                    vendor.portfolioImages[index],
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      color: Colors.grey[300],
                                      child: Icon(Icons.image),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 24.h),
                      ],

                      // Reviews Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Reviews (${vendor.totalReviews})',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _showReviewDialog,
                            icon: Icon(Icons.add, color: AppColors.primary),
                            label: Text(
                              'Add Review',
                              style: TextStyle(color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      // Reviews List
                      Consumer<ReviewProvider>(
                        builder: (context, reviewProvider, _) {
                          if (reviewProvider.isLoading) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (reviewProvider.vendorReviews.isEmpty) {
                            return Container(
                              padding: EdgeInsets.all(24.w),
                              alignment: Alignment.center,
                              child: Text(
                                'No reviews yet. Be the first to review!',
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          }

                          return Column(
                            children: reviewProvider.vendorReviews.take(5).map((
                              review,
                            ) {
                              return Container(
                                margin: EdgeInsets.only(bottom: 12.h),
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          review.userName ?? 'Anonymous',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: List.generate(
                                            5,
                                            (index) => Icon(
                                              index < review.rating
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: Colors.amber,
                                              size: 16.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      review.comment,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      SizedBox(height: 100.h), // Space for bottom button
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            onPressed: _showInquiryDialog,
            child: Text(
              'Send Inquiry',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          content.isEmpty ? 'Not specified' : content,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
