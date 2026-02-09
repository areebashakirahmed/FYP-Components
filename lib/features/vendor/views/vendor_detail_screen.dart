import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mehfilista/components/cost_calculator_widget.dart';
import 'package:mehfilista/features/auth/provider/auth_provider.dart';
import 'package:mehfilista/features/inquiry/models/inquiry_model.dart';
import 'package:mehfilista/features/inquiry/providers/inquiry_provider.dart';
import 'package:mehfilista/features/review/providers/review_provider.dart';
import 'package:mehfilista/features/vendor/providers/vendor_provider.dart';
import 'package:mehfilista/utils/constants/colors.dart';
import 'package:mehfilista/utils/helpers/whatsapp_helper.dart';
import 'package:mehfilista/utils/validators.dart';
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
      // Load user inquiries to check booking status for reviews
      final authProvider = context.read<AuthProvider>();
      if (authProvider.isAuthenticated && !authProvider.isVendor) {
        context.read<InquiryProvider>().loadMyInquiries(authProvider.token!);
      }
    });
  }

  void _showInquiryDialog() {
    final authProvider = context.read<AuthProvider>();
    final vendorProvider = context.read<VendorProvider>();
    final vendor = vendorProvider.selectedVendor;

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
    final locationController = TextEditingController();
    final guestCountController = TextEditingController(text: '100');
    final messageController = TextEditingController();
    String selectedPackage =
        'basic'; // Default to basic - backend requires this
    int numberOfGuests = 100;
    double estimatedCost = 0;
    final formKey = GlobalKey<FormState>();

    // Check if vendor has new pricing tiers
    final hasNewPricing = vendor?.hasPricingTiers ?? false;

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
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Send Inquiry',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Event Type
                      TextFormField(
                        controller: eventTypeController,
                        decoration: InputDecoration(
                          labelText: 'Event Type *',
                          hintText: 'e.g., Wedding, Birthday, Corporate',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        validator: Validators.validateEventType,
                      ),
                      SizedBox(height: 12.h),

                      // Event Date (required in new API)
                      TextFormField(
                        controller: dateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Event Date *',
                          hintText: 'Select date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        validator: (value) => Validators.validateRequired(
                          value,
                          fieldName: 'Date',
                        ),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now().add(Duration(days: 7)),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                          );
                          if (date != null) {
                            dateController.text =
                                '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                          }
                        },
                      ),
                      SizedBox(height: 12.h),

                      // Event Location
                      TextFormField(
                        controller: locationController,
                        decoration: InputDecoration(
                          labelText: 'Event Location *',
                          hintText: 'Enter event venue/location',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          prefixIcon: Icon(Icons.location_on_outlined),
                        ),
                        validator: Validators.validateLocation,
                      ),
                      SizedBox(height: 12.h),

                      // New pricing tier selection with cost calculator
                      if (hasNewPricing && vendor != null) ...[
                        Text(
                          'Select Package & Guests',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        CostCalculatorWidget(
                          vendor: vendor,
                          initialGuests: numberOfGuests,
                          onCostChanged: (packageType, guests, cost) {
                            setSheetState(() {
                              selectedPackage = packageType;
                              numberOfGuests = guests;
                              estimatedCost = cost;
                              guestCountController.text = guests.toString();
                            });
                          },
                        ),
                        SizedBox(height: 12.h),
                      ] else ...[
                        // Package selection dropdown (required by backend)
                        DropdownButtonFormField<String>(
                          value: selectedPackage,
                          decoration: InputDecoration(
                            labelText: 'Select Package *',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            prefixIcon: Icon(Icons.card_giftcard_outlined),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'basic',
                              child: Text('Basic'),
                            ),
                            DropdownMenuItem(
                              value: 'premium',
                              child: Text('Premium'),
                            ),
                            DropdownMenuItem(
                              value: 'luxury',
                              child: Text('Luxury'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setSheetState(() => selectedPackage = value);
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a package';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 12.h),
                        // Guest count field
                        TextFormField(
                          controller: guestCountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Expected Guests *',
                            hintText: 'Number of guests',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            prefixIcon: Icon(Icons.people_outline),
                          ),
                          validator: Validators.validateGuestCount,
                          onChanged: (value) {
                            numberOfGuests = int.tryParse(value) ?? 100;
                          },
                        ),
                        SizedBox(height: 12.h),
                      ],

                      // Message
                      TextFormField(
                        controller: messageController,
                        maxLines: 3,
                        maxLength: 500,
                        decoration: InputDecoration(
                          labelText: 'Message *',
                          hintText: 'Describe your requirements in detail...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          helperText: 'Minimum 10 characters',
                        ),
                        validator: Validators.validateMessage,
                      ),
                      SizedBox(height: 20.h),

                      // Estimated Cost Display (if new pricing)
                      if (hasNewPricing && estimatedCost > 0) ...[
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Estimated Cost:',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Rs. ${estimatedCost.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),
                      ],

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
                                      if (!formKey.currentState!.validate()) {
                                        return;
                                      }

                                      // Build detailed message with location
                                      final detailedMessage =
                                          _buildInquiryMessage(
                                            message: messageController.text,
                                            location: locationController.text,
                                            guestCount: numberOfGuests
                                                .toString(),
                                            selectedPackage: selectedPackage,
                                          );

                                      // Validate package is selected
                                      if (selectedPackage.isEmpty) {
                                        Fluttertoast.showToast(
                                          msg: 'Please select a package',
                                        );
                                        return;
                                      }

                                      // Send inquiry with required fields
                                      final success = await inquiryProvider
                                          .sendInquiry(
                                            token: authProvider.token ?? '',
                                            vendorId: widget.vendorId,
                                            eventType: eventTypeController.text,
                                            eventDate: dateController.text,
                                            message: detailedMessage,
                                            selectedPackage: selectedPackage,
                                            numberOfGuests: numberOfGuests,
                                          );

                                      if (success && context.mounted) {
                                        Navigator.pop(context);
                                        Fluttertoast.showToast(
                                          msg: 'Inquiry sent successfully!',
                                        );
                                      } else if (inquiryProvider.error !=
                                          null) {
                                        Fluttertoast.showToast(
                                          msg:
                                              inquiryProvider.error ??
                                              'Failed to send inquiry',
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
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _buildInquiryMessage({
    required String message,
    required String location,
    String? guestCount,
    String? selectedPackage,
  }) {
    final buffer = StringBuffer();
    buffer.writeln(message);
    buffer.writeln();
    buffer.writeln('--- Additional Details ---');
    buffer.writeln('Location: $location');
    if (guestCount != null && guestCount.isNotEmpty) {
      buffer.writeln('Expected Guests: $guestCount');
    }
    if (selectedPackage != null) {
      buffer.writeln('Interested Package: $selectedPackage');
    }
    return buffer.toString();
  }

  void _showReviewDialog() {
    final authProvider = context.read<AuthProvider>();
    final inquiryProvider = context.read<InquiryProvider>();

    if (!authProvider.isAuthenticated) {
      Fluttertoast.showToast(msg: 'Please login to leave a review');
      return;
    }

    if (authProvider.isVendor) {
      Fluttertoast.showToast(msg: 'Vendors cannot leave reviews');
      return;
    }

    // Check if user has a completed/accepted inquiry with this vendor
    final hasBooking = inquiryProvider.myInquiries.any(
      (inquiry) =>
          inquiry.vendorId == widget.vendorId &&
          inquiry.status == InquiryStatus.accepted,
    );

    if (!hasBooking) {
      _showBookingRequiredDialog();
      return;
    }

    int selectedRating = 5;
    final commentController = TextEditingController();
    final formKey = GlobalKey<FormState>();

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
              child: Form(
                key: formKey,
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
                    Text(
                      'Rating',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
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
                    TextFormField(
                      controller: commentController,
                      maxLines: 3,
                      maxLength: 500,
                      decoration: InputDecoration(
                        labelText: 'Comment *',
                        hintText: 'Share your experience...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        helperText: 'Minimum 10 characters',
                      ),
                      validator: Validators.validateReviewComment,
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
                                    if (!formKey.currentState!.validate()) {
                                      return;
                                    }

                                    final success = await reviewProvider
                                        .leaveReview(
                                          token: authProvider.token ?? '',
                                          vendorId: widget.vendorId,
                                          rating: selectedRating,
                                          comment: commentController.text
                                              .trim(),
                                        );

                                    if (success && context.mounted) {
                                      Navigator.pop(context);
                                      Fluttertoast.showToast(
                                        msg: 'Review submitted!',
                                      );
                                    } else if (reviewProvider.error != null) {
                                      Fluttertoast.showToast(
                                        msg:
                                            reviewProvider.error ??
                                            'Failed to submit review',
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
              ),
            );
          },
        );
      },
    );
  }

  void _showBookingRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        title: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.orange),
            SizedBox(width: 8.w),
            Text('Booking Required'),
          ],
        ),
        content: Text(
          'You can only leave a review after your inquiry has been accepted by this vendor. Please send an inquiry first and wait for acceptance.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showInquiryDialog();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text('Send Inquiry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showChatDialog() {
    final authProvider = context.read<AuthProvider>();
    final vendorProvider = context.read<VendorProvider>();
    final vendor = vendorProvider.selectedVendor;

    if (!authProvider.isAuthenticated) {
      Fluttertoast.showToast(msg: 'Please login to chat with vendor');
      return;
    }

    if (authProvider.isVendor) {
      Fluttertoast.showToast(msg: 'Vendors cannot chat with other vendors');
      return;
    }

    // Determine which number to use for WhatsApp
    final whatsappNumber = vendor?.whatsappNumber ?? vendor?.contactPhone;
    final hasWhatsApp = WhatsAppHelper.isValidWhatsAppNumber(whatsappNumber);

    // Show chat/contact options dialog
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Contact ${vendor?.businessName ?? "Vendor"}',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.h),

              // WhatsApp Option (prioritized if available)
              if (hasWhatsApp)
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green.shade700.withOpacity(0.1),
                    child: Icon(Icons.chat, color: Colors.green.shade700),
                  ),
                  title: Text('WhatsApp'),
                  subtitle: Text(
                    WhatsAppHelper.formatPhoneNumber(whatsappNumber!),
                  ),
                  trailing: Icon(Icons.open_in_new, size: 18.sp),
                  onTap: () async {
                    Navigator.pop(context);
                    final success = await WhatsAppHelper.openVendorChat(
                      phoneNumber: whatsappNumber,
                      vendorName: vendor?.businessName,
                    );
                    if (!success) {
                      Fluttertoast.showToast(
                        msg: 'Could not open WhatsApp. Please try again.',
                      );
                    }
                  },
                ),

              // Phone Option
              if (vendor?.contactPhone != null &&
                  vendor!.contactPhone!.isNotEmpty)
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green.withOpacity(0.1),
                    child: Icon(Icons.phone, color: Colors.green),
                  ),
                  title: Text('Call'),
                  subtitle: Text(vendor.contactPhone!),
                  onTap: () {
                    Navigator.pop(context);
                    Fluttertoast.showToast(msg: 'Opening dialer...');
                    // In production, use url_launcher to make call
                  },
                ),

              // Email Option
              if (vendor?.contactEmail != null &&
                  vendor!.contactEmail!.isNotEmpty)
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    child: Icon(Icons.email, color: Colors.blue),
                  ),
                  title: Text('Email'),
                  subtitle: Text(vendor.contactEmail!),
                  onTap: () {
                    Navigator.pop(context);
                    Fluttertoast.showToast(msg: 'Opening email app...');
                    // In production, use url_launcher to send email
                  },
                ),

              // Send Inquiry (fallback)
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Icon(Icons.mail_outline, color: AppColors.primary),
                ),
                title: Text('Send Inquiry'),
                subtitle: Text('Request quote or information'),
                onTap: () {
                  Navigator.pop(context);
                  _showInquiryDialog();
                },
              ),

              SizedBox(height: 10.h),
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
                  background: vendor.portfolioImageUrls.isNotEmpty
                      ? Image.network(
                          vendor.portfolioImageUrls.first,
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
                          Expanded(
                            child: Text(
                              vendor.city != null && vendor.area != null
                                  ? '${vendor.area}, ${vendor.city}'
                                  : vendor.location,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // Quick WhatsApp Button (if available)
                      if (WhatsAppHelper.isValidWhatsAppNumber(
                        vendor.whatsappNumber ?? vendor.contactPhone,
                      ))
                        Container(
                          margin: EdgeInsets.only(bottom: 16.h),
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.green.shade700,
                              side: BorderSide(color: Colors.green.shade700),
                              padding: EdgeInsets.symmetric(
                                vertical: 10.h,
                                horizontal: 16.w,
                              ),
                            ),
                            onPressed: () async {
                              final success =
                                  await WhatsAppHelper.openVendorChat(
                                    phoneNumber:
                                        vendor.whatsappNumber ??
                                        vendor.contactPhone!,
                                    vendorName: vendor.businessName,
                                  );
                              if (!success) {
                                Fluttertoast.showToast(
                                  msg: 'Could not open WhatsApp',
                                );
                              }
                            },
                            icon: Icon(Icons.chat, size: 20.sp),
                            label: Text('Chat on WhatsApp'),
                          ),
                        ),

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

                      // New Pricing Tiers (if available)
                      if (vendor.hasPricingTiers) ...[
                        Text(
                          'Pricing Packages',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        CostCalculatorWidget(vendor: vendor),
                        SizedBox(height: 16.h),
                      ] else if (vendor.pricingPackages.isNotEmpty) ...[
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
                                        borderRadius: BorderRadius.circular(
                                          20.r,
                                        ),
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
                                          color: AppColors.primary.withOpacity(
                                            0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            16.r,
                                          ),
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
                              Icon(
                                Icons.phone,
                                size: 18.sp,
                                color: Colors.grey,
                              ),
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
                              Icon(
                                Icons.email,
                                size: 18.sp,
                                color: Colors.grey,
                              ),
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
                      if (vendor.portfolioImageUrls.length > 1) ...[
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
                            itemCount: vendor.portfolioImageUrls.length,
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
                                    vendor.portfolioImageUrls[index],
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

                          if (reviewProvider.hasError ||
                              reviewProvider.vendorReviews.isEmpty) {
                            return Container(
                              padding: EdgeInsets.all(24.w),
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.rate_review_outlined,
                                    size: 48.sp,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    'No Reviews Yet',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Be the first to review!',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ],
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
          child: Row(
            children: [
              // Chat Button
              Expanded(
                flex: 1,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: () => _showChatDialog(),
                  icon: Icon(Icons.chat_bubble_outline, size: 20.sp),
                  label: Text(
                    'Chat',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // Send Inquiry Button
              Expanded(
                flex: 2,
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
            ],
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
