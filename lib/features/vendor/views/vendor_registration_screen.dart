import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mehfilista/features/auth/provider/auth_provider.dart';
import 'package:mehfilista/features/location/providers/location_provider.dart';
import 'package:mehfilista/features/vendor/providers/vendor_provider.dart';
import 'package:mehfilista/features/vendor/views/vendor_verification_pending_screen.dart';
import 'package:mehfilista/utils/constants/colors.dart';
import 'package:mehfilista/components/custom_button.dart';
import 'package:mehfilista/components/custom_textfield.dart';
import 'package:mehfilista/utils/validators.dart';
import 'package:provider/provider.dart';

class VendorRegistrationScreen extends StatefulWidget {
  const VendorRegistrationScreen({super.key});

  @override
  State<VendorRegistrationScreen> createState() =>
      _VendorRegistrationScreenState();
}

class _VendorRegistrationScreenState extends State<VendorRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Basic Info Controllers
  final _businessNameController = TextEditingController();
  final _servicesController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pricingController = TextEditingController();
  final _availabilityController = TextEditingController();

  // Contact Controllers
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _whatsappController = TextEditingController();

  // CNIC Controllers
  final _cnicNumberController = TextEditingController();
  File? _cnicFrontImage;
  File? _cnicBackImage;

  // Pricing Tier Controllers
  final _basicDescController = TextEditingController();
  final _basicBasePriceController = TextEditingController();
  final _basicPerHeadController = TextEditingController();
  final _premiumDescController = TextEditingController();
  final _premiumBasePriceController = TextEditingController();
  final _premiumPerHeadController = TextEditingController();
  final _luxuryDescController = TextEditingController();
  final _luxuryBasePriceController = TextEditingController();
  final _luxuryPerHeadController = TextEditingController();

  // Selected categories and event types
  List<String> _selectedCategories = [];
  List<String> _selectedEventTypes = [];

  final List<String> _availableCategories = [
    'Catering',
    'Decoration',
    'Photography',
    'Videography',
    'Music/DJ',
    'Venue',
    'Makeup',
    'Event Planning',
    'Transportation',
    'Florist',
    'Other',
  ];

  final List<String> _availableEventTypes = [
    'Wedding',
    'Birthday',
    'Corporate',
    'Engagement',
    'Anniversary',
    'Mehndi',
    'Baraat',
    'Walima',
    'Baby Shower',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationProvider>().loadCities();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _businessNameController.dispose();
    _servicesController.dispose();
    _descriptionController.dispose();
    _pricingController.dispose();
    _availabilityController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _whatsappController.dispose();
    _cnicNumberController.dispose();
    _basicDescController.dispose();
    _basicBasePriceController.dispose();
    _basicPerHeadController.dispose();
    _premiumDescController.dispose();
    _premiumBasePriceController.dispose();
    _premiumPerHeadController.dispose();
    _luxuryDescController.dispose();
    _luxuryBasePriceController.dispose();
    _luxuryPerHeadController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isFront) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (isFront) {
          _cnicFrontImage = File(image.path);
        } else {
          _cnicBackImage = File(image.path);
        }
      });
    }
  }

  void _nextStep() {
    if (_currentStep < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    }
  }

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(msg: 'Please fill all required fields');
      return;
    }

    if (_selectedCategories.isEmpty) {
      Fluttertoast.showToast(msg: 'Please select at least one category');
      return;
    }

    if (_selectedEventTypes.isEmpty) {
      Fluttertoast.showToast(msg: 'Please select at least one event type');
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final vendorProvider = context.read<VendorProvider>();
    final locationProvider = context.read<LocationProvider>();

    if (authProvider.token == null) {
      Fluttertoast.showToast(msg: 'Please login first');
      return;
    }

    // Validate required fields for backend
    final city = locationProvider.selectedCity;
    final area = locationProvider.selectedArea;

    if (city == null || city.isEmpty) {
      Fluttertoast.showToast(msg: 'Please select a city');
      return;
    }

    if (area == null || area.isEmpty) {
      Fluttertoast.showToast(msg: 'Please select or enter an area');
      return;
    }

    final cnicNumber = _cnicNumberController.text.trim();
    if (cnicNumber.isEmpty) {
      Fluttertoast.showToast(msg: 'CNIC number is required');
      return;
    }

    // Validate CNIC format: 12345-1234567-1
    final cnicRegex = RegExp(r'^\d{5}-\d{7}-\d{1}$');
    if (!cnicRegex.hasMatch(cnicNumber)) {
      Fluttertoast.showToast(msg: 'CNIC format must be: 12345-1234567-1');
      return;
    }

    if (_cnicFrontImage == null || _cnicBackImage == null) {
      Fluttertoast.showToast(msg: 'Both CNIC images are required');
      return;
    }

    final whatsappNumber = _whatsappController.text.trim();
    if (whatsappNumber.isEmpty) {
      Fluttertoast.showToast(msg: 'WhatsApp number is required');
      return;
    }

    // Upload CNIC images using portfolio upload endpoint
    Fluttertoast.showToast(msg: 'Uploading CNIC images...');
    String cnicFrontUrl = '';
    String cnicBackUrl = '';

    try {
      // Use the vendor service uploadFile for CNIC images
      final urls = await vendorProvider.uploadCnicImages(
        token: authProvider.token!,
        frontImagePath: _cnicFrontImage!.path,
        backImagePath: _cnicBackImage!.path,
      );
      if (urls != null) {
        cnicFrontUrl = urls['front'] ?? '';
        cnicBackUrl = urls['back'] ?? '';
      }
    } catch (e) {
      // If upload fails, use placeholder - the backend will validate
      Fluttertoast.showToast(msg: 'CNIC upload failed, using local paths');
      cnicFrontUrl = _cnicFrontImage!.path;
      cnicBackUrl = _cnicBackImage!.path;
    }

    if (cnicFrontUrl.isEmpty || cnicBackUrl.isEmpty) {
      // Fallback to file paths if upload returned empty
      cnicFrontUrl = cnicFrontUrl.isEmpty
          ? _cnicFrontImage!.path
          : cnicFrontUrl;
      cnicBackUrl = cnicBackUrl.isEmpty ? _cnicBackImage!.path : cnicBackUrl;
    }

    // Build pricing packages
    Map<String, dynamic>? basicPackage;
    Map<String, dynamic>? premiumPackage;
    Map<String, dynamic>? luxuryPackage;

    if (_basicBasePriceController.text.isNotEmpty) {
      basicPackage = {
        'description': _basicDescController.text,
        'base_price': double.tryParse(_basicBasePriceController.text) ?? 0,
        'per_head_price': double.tryParse(_basicPerHeadController.text) ?? 0,
      };
    }

    if (_premiumBasePriceController.text.isNotEmpty) {
      premiumPackage = {
        'description': _premiumDescController.text,
        'base_price': double.tryParse(_premiumBasePriceController.text) ?? 0,
        'per_head_price': double.tryParse(_premiumPerHeadController.text) ?? 0,
      };
    }

    if (_luxuryBasePriceController.text.isNotEmpty) {
      luxuryPackage = {
        'description': _luxuryDescController.text,
        'base_price': double.tryParse(_luxuryBasePriceController.text) ?? 0,
        'per_head_price': double.tryParse(_luxuryPerHeadController.text) ?? 0,
      };
    }

    final success = await vendorProvider.createVendorProfile(
      token: authProvider.token!,
      businessName: _businessNameController.text.trim(),
      category: _selectedCategories,
      services: _servicesController.text.trim(),
      city: city,
      area: area,
      eventTypes: _selectedEventTypes,
      cnicNumber: cnicNumber,
      cnicFrontImage: cnicFrontUrl,
      cnicBackImage: cnicBackUrl,
      whatsappNumber: whatsappNumber,
      availability: _availabilityController.text.trim(),
      contactPhone: _phoneController.text.trim(),
      contactEmail: _emailController.text.trim(),
      description: _descriptionController.text.trim(),
      basicPackage: basicPackage,
      premiumPackage: premiumPackage,
      luxuryPackage: luxuryPackage,
    );

    if (success && mounted) {
      // Refresh user data to get updated vendorProfile with approval_status
      await authProvider.refreshUser();

      Fluttertoast.showToast(
        msg: 'Registration submitted! Please wait for approval.',
      );

      // Navigate to verification pending screen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => VendorVerificationPendingScreen(
              vendorEmail: authProvider.user?.email ?? '',
              approvalStatus:
                  authProvider.user?.vendorProfile?.approvalStatus.name ??
                  'pending',
            ),
          ),
        );
      }
    } else if (vendorProvider.error != null) {
      Fluttertoast.showToast(
        msg: vendorProvider.error ?? 'Registration failed',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        title: Text('Vendor Registration'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Progress Indicator
            _buildProgressIndicator(),
            // Form Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildBasicInfoStep(),
                  _buildContactInfoStep(),
                  _buildCnicVerificationStep(),
                  _buildPricingStep(),
                ],
              ),
            ),
            // Navigation Buttons
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: List.generate(4, (index) {
          final isActive = index <= _currentStep;
          final labels = ['Basic', 'Contact', 'CNIC', 'Pricing'];
          return Expanded(
            child: Column(
              children: [
                Container(
                  height: 4.h,
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  labels[index],
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: isActive ? AppColors.primary : Colors.grey,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Business Information',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.h),
          CustomTextfield(
            heading: 'Business Name *',
            hintText: 'Your business name',
            controller: _businessNameController,
            validator: Validators.validateName,
          ),
          SizedBox(height: 16.h),
          Text(
            'Categories *',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _availableCategories.map((cat) {
              final isSelected = _selectedCategories.contains(cat);
              return FilterChip(
                label: Text(cat),
                selected: isSelected,
                selectedColor: AppColors.primary.withValues(alpha: 0.2),
                checkmarkColor: AppColors.primary,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedCategories.add(cat);
                    } else {
                      _selectedCategories.remove(cat);
                    }
                  });
                },
              );
            }).toList(),
          ),
          SizedBox(height: 16.h),
          Text(
            'Event Types *',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _availableEventTypes.map((type) {
              final isSelected = _selectedEventTypes.contains(type);
              return FilterChip(
                label: Text(type),
                selected: isSelected,
                selectedColor: AppColors.primary.withValues(alpha: 0.2),
                checkmarkColor: AppColors.primary,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedEventTypes.add(type);
                    } else {
                      _selectedEventTypes.remove(type);
                    }
                  });
                },
              );
            }).toList(),
          ),
          SizedBox(height: 16.h),
          CustomTextfield(
            heading: 'Services *',
            hintText: 'Describe your services',
            controller: _servicesController,
            validator: (value) =>
                Validators.validateRequired(value, fieldName: 'Services'),
          ),
          SizedBox(height: 16.h),
          Text(
            'Short Service Description',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 4.h),
          Text(
            '250–500 characters recommended',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: _descriptionController,
            maxLines: 4,
            maxLength: 500,
            decoration: InputDecoration(
              hintText: 'About your business',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              counterText: '',
            ),
          ),
          SizedBox(height: 16.h),
          // City/Area Selection
          Consumer<LocationProvider>(
            builder: (context, locationProvider, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'City *',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: locationProvider.selectedCity,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                        border: InputBorder.none,
                        hintText: 'Select city',
                      ),
                      items: locationProvider.cityNames.map((city) {
                        return DropdownMenuItem(value: city, child: Text(city));
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          locationProvider.selectCity(value);
                        }
                      },
                    ),
                  ),
                  // Area Field (always show when city is selected)
                  if (locationProvider.selectedCity != null) ...[
                    SizedBox(height: 16.h),
                    locationProvider.areaNames.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Area *',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: DropdownButtonFormField<String>(
                                  value: locationProvider.selectedArea,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                    ),
                                    border: InputBorder.none,
                                    hintText: 'Select area',
                                  ),
                                  items: locationProvider.areaNames.map((area) {
                                    return DropdownMenuItem(
                                      value: area,
                                      child: Text(area),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      locationProvider.selectArea(value);
                                    }
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select an area';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          )
                        : CustomTextfield(
                            heading: 'Area *',
                            hintText: 'Enter your area',
                            controller: TextEditingController(
                              text: locationProvider.selectedArea ?? '',
                            )..addListener(() {
                                final value = locationProvider.selectedArea;
                                if (value != null && value.isNotEmpty) {
                                  // Keep synced
                                }
                              }),
                            validator: (value) =>
                                Validators.validateRequired(value, fieldName: 'Area'),
                            onChanged: (value) {
                              locationProvider.selectArea(value);
                            },
                          ),
                  ],
                ],
              );
            },
          ),
          SizedBox(height: 16.h),
          CustomTextfield(
            heading: 'Availability *',
            hintText: 'e.g., Monday-Saturday, 9AM-6PM',
            controller: _availabilityController,
            validator: (value) =>
                Validators.validateRequired(value, fieldName: 'Availability'),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildContactInfoStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.h),
          CustomTextfield(
            heading: 'Phone Number *',
            hintText: '03001234567',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            validator: Validators.validatePhone,
          ),
          SizedBox(height: 16.h),
          CustomTextfield(
            heading: 'WhatsApp Number',
            hintText: '+923001234567',
            controller: _whatsappController,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 8.h),
          Text(
            'Include country code for WhatsApp (e.g., +92)',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
          SizedBox(height: 16.h),
          CustomTextfield(
            heading: 'Email',
            hintText: 'business@email.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                return Validators.validateEmail(value);
              }
              return null;
            },
          ),
          SizedBox(height: 16.h),
          CustomTextfield(
            heading: 'Pricing Info *',
            hintText: 'e.g., Starting from Rs. 50,000',
            controller: _pricingController,
            validator: (value) =>
                Validators.validateRequired(value, fieldName: 'Pricing'),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildCnicVerificationStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CNIC Verification',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.amber.shade700),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'CNIC verification helps build trust with customers. Your profile will be marked as "Verified" after approval.',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.amber.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          CustomTextfield(
            heading: 'CNIC Number *',
            hintText: '12345-1234567-1',
            controller: _cnicNumberController,
            keyboardType: TextInputType.text,
            validator: Validators.validateCnic,
          ),
          SizedBox(height: 20.h),
          Text(
            'CNIC Front Image',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 4.h),
          Text(
            'JPG or PNG supported',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
          SizedBox(height: 8.h),
          _buildImagePicker(
            image: _cnicFrontImage,
            onTap: () => _pickImage(true),
            label: 'Upload Front Side',
          ),
          SizedBox(height: 16.h),
          Text(
            'CNIC Back Image',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8.h),
          _buildImagePicker(
            image: _cnicBackImage,
            onTap: () => _pickImage(false),
            label: 'Upload Back Side',
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildImagePicker({
    File? image,
    required VoidCallback onTap,
    required String label,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150.h,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: image != null ? AppColors.primary : Colors.grey.shade300,
            width: image != null ? 2 : 1,
          ),
        ),
        child: image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.file(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo, size: 40.sp, color: Colors.grey),
                  SizedBox(height: 8.h),
                  Text(label, style: TextStyle(color: Colors.grey)),
                ],
              ),
      ),
    );
  }

  Widget _buildPricingStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pricing Packages',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Text(
            'Set up your pricing tiers. Each package has a base price plus per-head pricing.',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
          SizedBox(height: 20.h),
          _buildPricingTierCard(
            title: 'Basic Package',
            color: Colors.green,
            descController: _basicDescController,
            basePriceController: _basicBasePriceController,
            perHeadController: _basicPerHeadController,
          ),
          SizedBox(height: 16.h),
          _buildPricingTierCard(
            title: 'Premium Package',
            color: Colors.blue,
            descController: _premiumDescController,
            basePriceController: _premiumBasePriceController,
            perHeadController: _premiumPerHeadController,
          ),
          SizedBox(height: 16.h),
          _buildPricingTierCard(
            title: 'Luxury Package',
            color: Colors.amber.shade700,
            descController: _luxuryDescController,
            basePriceController: _luxuryBasePriceController,
            perHeadController: _luxuryPerHeadController,
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildPricingTierCard({
    required String title,
    required Color color,
    required TextEditingController descController,
    required TextEditingController basePriceController,
    required TextEditingController perHeadController,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: color, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          TextField(
            controller: descController,
            decoration: InputDecoration(
              labelText: 'Description',
              hintText: 'What\'s included in this package',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: basePriceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Base Price',
                    prefixText: 'Rs. ',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: TextField(
                  controller: perHeadController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Per Head Price',
                    prefixText: 'Rs. ',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: _prevStep,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    side: BorderSide(color: AppColors.primary),
                  ),
                  child: Text('Previous'),
                ),
              ),
            if (_currentStep > 0) SizedBox(width: 12.w),
            Expanded(
              flex: 2,
              child: Consumer<VendorProvider>(
                builder: (context, vendorProvider, _) {
                  final isLastStep = _currentStep == 3;
                  return CustomButton(
                    btnText: isLastStep ? 'Submit' : 'Next',
                    isLoading: vendorProvider.isLoading,
                    onTap: vendorProvider.isLoading
                        ? null
                        : (isLastStep ? _submitRegistration : _nextStep),
                    height: 50.h,
                    width: double.infinity,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
