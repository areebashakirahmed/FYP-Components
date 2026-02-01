import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mehfilista/features/vendor/models/vendor_model.dart';
import 'package:mehfilista/features/vendor/models/pricing_tier_model.dart';
import 'package:mehfilista/utils/constants/colors.dart';

/// A widget that displays pricing packages and calculates cost based on guest count
class CostCalculatorWidget extends StatefulWidget {
  final VendorModel vendor;
  final String? initialPackage;
  final int initialGuests;
  final Function(String packageType, int guests, double cost)? onCostChanged;

  const CostCalculatorWidget({
    super.key,
    required this.vendor,
    this.initialPackage,
    this.initialGuests = 100,
    this.onCostChanged,
  });

  @override
  State<CostCalculatorWidget> createState() => _CostCalculatorWidgetState();
}

class _CostCalculatorWidgetState extends State<CostCalculatorWidget> {
  late String? _selectedPackage;
  late int _numberOfGuests;
  late TextEditingController _guestController;

  @override
  void initState() {
    super.initState();
    final availablePackages = widget.vendor.availablePackageTypes;
    _selectedPackage = widget.initialPackage ?? 
        (availablePackages.isNotEmpty ? availablePackages.first : null);
    _numberOfGuests = widget.initialGuests;
    _guestController = TextEditingController(text: _numberOfGuests.toString());
  }

  @override
  void dispose() {
    _guestController.dispose();
    super.dispose();
  }

  double get _calculatedCost {
    if (_selectedPackage == null) return 0;
    return widget.vendor.calculateCost(_selectedPackage!, _numberOfGuests);
  }

  void _notifyChange() {
    if (widget.onCostChanged != null && _selectedPackage != null) {
      widget.onCostChanged!(_selectedPackage!, _numberOfGuests, _calculatedCost);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.vendor.hasPricingTiers) {
      return _buildLegacyPricing();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Package',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        _buildPackageOptions(),
        SizedBox(height: 20.h),
        _buildGuestSelector(),
        SizedBox(height: 20.h),
        _buildCostSummary(),
      ],
    );
  }

  Widget _buildLegacyPricing() {
    // Fallback for vendors without the new pricing structure
    // Just show text that pricing info is available through inquiry
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pricing',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          if (widget.vendor.pricing.isNotEmpty)
            Text(
              widget.vendor.pricing,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.greyText,
              ),
            )
          else
            Text(
              'Contact vendor for pricing details',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.greyText,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPackageOptions() {
    final packages = <String, PricingTier?>{
      'basic': widget.vendor.basicPackage,
      'premium': widget.vendor.premiumPackage,
      'luxury': widget.vendor.luxuryPackage,
    };

    return Column(
      children: packages.entries
          .where((e) => e.value != null)
          .map((e) => _buildPackageCard(e.key, e.value!))
          .toList(),
    );
  }

  Widget _buildPackageCard(String type, PricingTier tier) {
    final isSelected = _selectedPackage == type;
    final displayName = type[0].toUpperCase() + type.substring(1);

    Color cardColor;
    Color borderColor;
    IconData iconData;

    switch (type) {
      case 'basic':
        cardColor = Colors.green.shade50;
        borderColor = Colors.green;
        iconData = Icons.star_outline;
        break;
      case 'premium':
        cardColor = Colors.blue.shade50;
        borderColor = Colors.blue;
        iconData = Icons.star_half;
        break;
      case 'luxury':
        cardColor = Colors.amber.shade50;
        borderColor = Colors.amber.shade700;
        iconData = Icons.star;
        break;
      default:
        cardColor = Colors.grey.shade50;
        borderColor = Colors.grey;
        iconData = Icons.star_outline;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPackage = type;
        });
        _notifyChange();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected ? cardColor : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? borderColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: borderColor.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: borderColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                color: borderColor,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (tier.description.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      tier.description,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.greyText,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Rs. ${tier.basePrice.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: borderColor,
                  ),
                ),
                Text(
                  '+ Rs. ${tier.perHeadPrice.toStringAsFixed(0)}/head',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.greyText,
                  ),
                ),
              ],
            ),
            SizedBox(width: 8.w),
            Radio<String>(
              value: type,
              groupValue: _selectedPackage,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedPackage = value;
                  });
                  _notifyChange();
                }
              },
              activeColor: borderColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestSelector() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Number of Guests',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildGuestButton(
                Icons.remove,
                () {
                  if (_numberOfGuests > 10) {
                    setState(() {
                      _numberOfGuests = (_numberOfGuests - 10).clamp(10, 2000);
                      _guestController.text = _numberOfGuests.toString();
                    });
                    _notifyChange();
                  }
                },
              ),
              Expanded(
                child: TextField(
                  controller: _guestController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) {
                    final guests = int.tryParse(value) ?? 100;
                    setState(() {
                      _numberOfGuests = guests.clamp(10, 2000);
                    });
                    _notifyChange();
                  },
                  onSubmitted: (value) {
                    final guests = int.tryParse(value) ?? 100;
                    setState(() {
                      _numberOfGuests = guests.clamp(10, 2000);
                      _guestController.text = _numberOfGuests.toString();
                    });
                    _notifyChange();
                  },
                ),
              ),
              _buildGuestButton(
                Icons.add,
                () {
                  if (_numberOfGuests < 2000) {
                    setState(() {
                      _numberOfGuests = (_numberOfGuests + 10).clamp(10, 2000);
                      _guestController.text = _numberOfGuests.toString();
                    });
                    _notifyChange();
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Slider(
            value: _numberOfGuests.toDouble(),
            min: 10,
            max: 2000,
            divisions: 199,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.primary.withOpacity(0.3),
            onChanged: (value) {
              setState(() {
                _numberOfGuests = value.round();
                _guestController.text = _numberOfGuests.toString();
              });
              _notifyChange();
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '10',
                style: TextStyle(fontSize: 10.sp, color: AppColors.greyText),
              ),
              Text(
                '2000',
                style: TextStyle(fontSize: 10.sp, color: AppColors.greyText),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGuestButton(IconData icon, VoidCallback onPressed) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(8.r),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.all(8.w),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildCostSummary() {
    if (_selectedPackage == null) {
      return const SizedBox.shrink();
    }

    final tier = widget.vendor.getPricingTier(_selectedPackage!);
    if (tier == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Base Price',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              Text(
                'Rs. ${tier.basePrice.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Per Head (${_numberOfGuests} × Rs. ${tier.perHeadPrice.toStringAsFixed(0)})',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              Text(
                'Rs. ${(tier.perHeadPrice * _numberOfGuests).toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Divider(color: Colors.white.withOpacity(0.3)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Estimated Total',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                'Rs. ${_calculatedCost.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
