import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mehfilista/components/custom_button.dart';
import 'package:mehfilista/components/custom_textfield.dart';
import 'package:mehfilista/features/auth/provider/auth_provider.dart';
import 'package:mehfilista/features/vendor/providers/vendor_provider.dart';
import 'package:mehfilista/utils/constants/colors.dart';
import 'package:provider/provider.dart';

class VendorProfileEditScreen extends StatefulWidget {
  const VendorProfileEditScreen({super.key});

  @override
  State<VendorProfileEditScreen> createState() =>
      _VendorProfileEditScreenState();
}

class _VendorProfileEditScreenState extends State<VendorProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _servicesController = TextEditingController();
  final _locationController = TextEditingController();
  final _pricingController = TextEditingController();
  final _availabilityController = TextEditingController();

  List<String> _selectedCategories = [];
  List<String> _selectedEventTypes = [];
  bool _isLoading = false;
  bool _isNewProfile = true;

  final List<String> _categories = [
    'Photography',
    'Catering',
    'Decoration',
    'Entertainment',
    'Venue',
    'Makeup',
    'Planning',
    'Other',
  ];

  final List<String> _eventTypes = [
    'Wedding',
    'Birthday',
    'Corporate',
    'Anniversary',
    'Engagement',
    'Baby Shower',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _loadExistingProfile();
  }

  void _loadExistingProfile() {
    final vendor = context.read<VendorProvider>().myVendorProfile;
    if (vendor != null) {
      _isNewProfile = false;
      _businessNameController.text = vendor.businessName;
      _servicesController.text = vendor.services;
      _locationController.text = vendor.location;
      _pricingController.text = vendor.pricing;
      _availabilityController.text = vendor.availability;
      _selectedCategories = List.from(vendor.category);
      _selectedEventTypes = List.from(vendor.eventTypes);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _servicesController.dispose();
    _locationController.dispose();
    _pricingController.dispose();
    _availabilityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isNewProfile ? 'Create Vendor Profile' : 'Edit Vendor Profile',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Business Name
              CustomTextfield(
                heading: 'Business Name',
                controller: _businessNameController,
                hintText: 'Enter your business name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter business name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // Categories
              Text(
                'Categories',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: _categories.map((category) {
                  final isSelected = _selectedCategories.contains(category);
                  return FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedCategories.add(category);
                        } else {
                          _selectedCategories.remove(category);
                        }
                      });
                    },
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    checkmarkColor: AppColors.primary,
                  );
                }).toList(),
              ),
              SizedBox(height: 16.h),

              // Services
              CustomTextfield(
                heading: 'Services',
                controller: _servicesController,
                hintText: 'Describe your services',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please describe your services';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // Location
              CustomTextfield(
                heading: 'Location',
                controller: _locationController,
                hintText: 'Your service location',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your location';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // Event Types
              Text(
                'Event Types',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: _eventTypes.map((eventType) {
                  final isSelected = _selectedEventTypes.contains(eventType);
                  return FilterChip(
                    label: Text(eventType),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedEventTypes.add(eventType);
                        } else {
                          _selectedEventTypes.remove(eventType);
                        }
                      });
                    },
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    checkmarkColor: AppColors.primary,
                  );
                }).toList(),
              ),
              SizedBox(height: 16.h),

              // Pricing
              CustomTextfield(
                heading: 'Pricing',
                controller: _pricingController,
                hintText: 'e.g., Starting from PKR 50,000',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter pricing info';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // Availability
              CustomTextfield(
                heading: 'Availability',
                controller: _availabilityController,
                hintText: 'e.g., Weekends, By appointment',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter availability';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.h),

              // Save Button
              CustomButton(
                btnText: _isNewProfile ? 'Create Profile' : 'Save Changes',
                isLoading: _isLoading,
                onTap: _isLoading ? null : _saveProfile,
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategories.isEmpty) {
      Fluttertoast.showToast(msg: 'Please select at least one category');
      return;
    }

    if (_selectedEventTypes.isEmpty) {
      Fluttertoast.showToast(msg: 'Please select at least one event type');
      return;
    }

    setState(() => _isLoading = true);

    final authProvider = context.read<AuthProvider>();
    final vendorProvider = context.read<VendorProvider>();
    final token = authProvider.token;

    if (token == null) {
      Fluttertoast.showToast(msg: 'Not authenticated');
      setState(() => _isLoading = false);
      return;
    }

    bool success;
    if (_isNewProfile) {
      success = await vendorProvider.createVendorProfile(
        token: token,
        businessName: _businessNameController.text.trim(),
        category: _selectedCategories,
        services: _servicesController.text.trim(),
        location: _locationController.text.trim(),
        eventTypes: _selectedEventTypes,
        pricing: _pricingController.text.trim(),
        availability: _availabilityController.text.trim(),
      );
    } else {
      final vendorId = vendorProvider.myVendorProfile?.id ?? '';
      success = await vendorProvider.updateVendorProfile(
        token: token,
        vendorId: vendorId,
        businessName: _businessNameController.text.trim(),
        category: _selectedCategories,
        services: _servicesController.text.trim(),
        location: _locationController.text.trim(),
        eventTypes: _selectedEventTypes,
        pricing: _pricingController.text.trim(),
        availability: _availabilityController.text.trim(),
      );
    }

    setState(() => _isLoading = false);

    if (success) {
      Fluttertoast.showToast(
        msg: _isNewProfile ? 'Profile created!' : 'Profile updated!',
      );
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: vendorProvider.error ?? 'Failed to save');
    }
  }
}
