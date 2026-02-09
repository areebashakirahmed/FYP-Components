import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mehfilista/features/auth/provider/auth_provider.dart';
import 'package:mehfilista/features/vendor/models/pricing_package_model.dart';
import 'package:mehfilista/features/vendor/models/vendor_model.dart';
import 'package:mehfilista/features/vendor/providers/vendor_provider.dart';
import 'package:mehfilista/utils/constants/colors.dart';
import 'package:provider/provider.dart';

class VendorPackagesScreen extends StatefulWidget {
  const VendorPackagesScreen({super.key});

  @override
  State<VendorPackagesScreen> createState() => _VendorPackagesScreenState();
}

class _VendorPackagesScreenState extends State<VendorPackagesScreen> {
  List<PricingPackageModel> _packages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkVerificationAndLoad();
  }

  void _checkVerificationAndLoad() {
    final authProvider = context.read<AuthProvider>();
    final vendorProvider = context.read<VendorProvider>();
    
    final vendor = vendorProvider.myVendorProfile;
    final approvalStatus = vendor?.approvalStatus ??
        authProvider.user?.vendorProfile?.approvalStatus;
    
    if (approvalStatus != ApprovalStatus.approved) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Fluttertoast.showToast(
            msg: 'You can only access packages after your profile is verified by admin.',
          );
          Navigator.pop(context);
        }
      });
      return;
    }
    
    _loadPackages();
  }

  void _loadPackages() {
    final vendor = context.read<VendorProvider>().myVendorProfile;
    if (vendor != null) {
      _packages = List.from(vendor.pricingPackages);
    }
  }

  Future<void> _savePackages() async {
    setState(() => _isLoading = true);

    final authProvider = context.read<AuthProvider>();
    final vendorProvider = context.read<VendorProvider>();
    final token = authProvider.token;

    if (token == null) {
      Fluttertoast.showToast(msg: 'Not authenticated - please login again');
      setState(() => _isLoading = false);
      return;
    }

    // Ensure vendor profile is loaded
    if (vendorProvider.myVendorProfile == null) {
      Fluttertoast.showToast(msg: 'Loading vendor profile...');
      await vendorProvider.loadMyVendorProfile(token);
    }

    final vendorId = vendorProvider.myVendorProfile?.id;
    if (vendorId == null || vendorId.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Vendor profile not found. Please try again.',
      );
      setState(() => _isLoading = false);
      return;
    }

    // Convert packages list to individual tier packages for the backend
    // Backend expects: basicPackage, premiumPackage, luxuryPackage
    // Each with: description (min 10), base_price (>0), per_head_price (>0)
    Map<String, dynamic>? basicPackage;
    Map<String, dynamic>? premiumPackage;
    Map<String, dynamic>? luxuryPackage;

    for (final pkg in _packages) {
      final tierMap = {
        'description': pkg.description.isNotEmpty
            ? pkg.description
            : 'Package details',
        'base_price':
            double.tryParse(pkg.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0,
        'per_head_price': 0,
      };
      final name = pkg.name.toLowerCase();
      if (name.contains('basic')) {
        basicPackage = tierMap;
      } else if (name.contains('premium')) {
        premiumPackage = tierMap;
      } else if (name.contains('luxury') || name.contains('gold')) {
        luxuryPackage = tierMap;
      } else if (basicPackage == null) {
        basicPackage = tierMap;
      } else if (premiumPackage == null) {
        premiumPackage = tierMap;
      } else {
        luxuryPackage = tierMap;
      }
    }

    final success = await vendorProvider.updateVendorProfile(
      token: token,
      vendorId: vendorId,
      basicPackage: basicPackage,
      premiumPackage: premiumPackage,
      luxuryPackage: luxuryPackage,
    );

    setState(() => _isLoading = false);

    if (success) {
      Fluttertoast.showToast(msg: 'Packages updated successfully');
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
        msg: vendorProvider.error ?? 'Failed to update packages',
      );
    }
  }

  void _showAddEditPackageDialog([
    PricingPackageModel? existingPackage,
    int? index,
  ]) {
    final nameController = TextEditingController(
      text: existingPackage?.name ?? '',
    );
    final descriptionController = TextEditingController(
      text: existingPackage?.description ?? '',
    );
    final priceController = TextEditingController(
      text: existingPackage?.price ?? '',
    );
    final featuresController = TextEditingController(
      text: existingPackage?.features?.join('\n') ?? '',
    );
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Padding(
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
                      existingPackage != null ? 'Edit Package' : 'Add Package',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Package Name
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Package Name *',
                        hintText: 'e.g., Basic, Premium, Gold',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter package name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12.h),

                    // Description
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Description *',
                        hintText: 'Brief description of this package',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12.h),

                    // Price
                    TextFormField(
                      controller: priceController,
                      decoration: InputDecoration(
                        labelText: 'Price *',
                        hintText: 'e.g., PKR 50,000',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter price';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12.h),

                    // Features (one per line)
                    TextFormField(
                      controller: featuresController,
                      maxLines: 4,
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 14.sp,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Features (one per line)',
                        hintText:
                            '4 hours coverage\n100 edited photos\nOnline gallery',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        helperText: 'Enter each feature on a new line',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Save Button
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
                          if (!formKey.currentState!.validate()) return;

                          final features = featuresController.text
                              .split('\n')
                              .where((f) => f.trim().isNotEmpty)
                              .map((f) => f.trim())
                              .toList();

                          final package = PricingPackageModel(
                            name: nameController.text.trim(),
                            description: descriptionController.text.trim(),
                            price: priceController.text.trim(),
                            features: features.isNotEmpty ? features : null,
                          );

                          setState(() {
                            if (index != null) {
                              _packages[index] = package;
                            } else {
                              _packages.add(package);
                            }
                          });

                          Navigator.pop(context);
                        },
                        child: Text(
                          existingPackage != null
                              ? 'Update Package'
                              : 'Add Package',
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
          ),
        );
      },
    );
  }

  void _deletePackage(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Package'),
        content: Text(
          'Are you sure you want to delete "${_packages[index].name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _packages.removeAt(index));
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
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
          'Pricing Packages',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_packages.isNotEmpty)
            TextButton(
              onPressed: _isLoading ? null : _savePackages,
              child: _isLoading
                  ? SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      'Save',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
        ],
      ),
      body: _packages.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.price_change_outlined,
                    size: 64.sp,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No pricing packages yet',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Add packages to show your pricing options',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[400]),
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton.icon(
                    onPressed: () => _showAddEditPackageDialog(),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Package'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: _packages.length,
              itemBuilder: (context, index) {
                final package = _packages[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                package.name,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: AppColors.primary,
                                  ),
                                  onPressed: () =>
                                      _showAddEditPackageDialog(package, index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deletePackage(index),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          package.price,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          package.description,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (package.features != null &&
                            package.features!.isNotEmpty) ...[
                          SizedBox(height: 12.h),
                          Divider(),
                          SizedBox(height: 8.h),
                          Text(
                            'Features:',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          ...package.features!.map(
                            (feature) => Padding(
                              padding: EdgeInsets.only(top: 4.h),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 16.sp,
                                    color: Colors.green,
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      feature,
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: _packages.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => _showAddEditPackageDialog(),
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}
