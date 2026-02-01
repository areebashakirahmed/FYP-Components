import 'package:mehfilista/features/vendor/models/pricing_package_model.dart';
import 'package:mehfilista/features/vendor/models/pricing_tier_model.dart';

/// Vendor approval status enum
enum ApprovalStatus {
  pending,
  approved,
  rejected;

  static ApprovalStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'approved':
        return ApprovalStatus.approved;
      case 'rejected':
        return ApprovalStatus.rejected;
      default:
        return ApprovalStatus.pending;
    }
  }

  String get displayName {
    switch (this) {
      case ApprovalStatus.pending:
        return 'Pending Review';
      case ApprovalStatus.approved:
        return 'Approved';
      case ApprovalStatus.rejected:
        return 'Rejected';
    }
  }
}

class VendorModel {
  final String id;
  final String userId;
  final String businessName;
  final List<String> category;
  final String services;
  // Location fields (new structure)
  final String? city;
  final String? area;
  final String location; // Legacy field - can be derived from city + area
  final List<String> eventTypes;
  final String pricing;
  final String availability; // 'active' or 'inactive'
  final List<String> portfolioImages;
  final double averageRating;
  final int totalReviews;

  // Approval workflow
  final ApprovalStatus approvalStatus;
  final String? rejectionReason;
  final bool isApproved; // Computed from approvalStatus

  // CNIC verification
  final String? cnicNumber;
  final String? cnicFrontImage;
  final String? cnicBackImage;

  // Contact info
  final String? whatsappNumber;
  final String? contactPhone;
  final String? contactEmail;
  final String? description;

  // New pricing tiers (base + per-head)
  final PricingTier? basicPackage;
  final PricingTier? premiumPackage;
  final PricingTier? luxuryPackage;

  // Legacy pricing packages (for backwards compatibility)
  final List<PricingPackageModel> pricingPackages;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  VendorModel({
    required this.id,
    required this.userId,
    required this.businessName,
    required this.category,
    required this.services,
    this.city,
    this.area,
    required this.location,
    required this.eventTypes,
    required this.pricing,
    required this.availability,
    this.portfolioImages = const [],
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.approvalStatus = ApprovalStatus.pending,
    this.rejectionReason,
    this.isApproved = false,
    this.cnicNumber,
    this.cnicFrontImage,
    this.cnicBackImage,
    this.whatsappNumber,
    this.contactPhone,
    this.contactEmail,
    this.description,
    this.basicPackage,
    this.premiumPackage,
    this.luxuryPackage,
    this.pricingPackages = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    final approvalStatus = ApprovalStatus.fromString(json['approval_status']);

    return VendorModel(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['user_id'] ?? json['userId'] ?? '',
      businessName: json['business_name'] ?? json['businessName'] ?? '',
      category: List<String>.from(json['category'] ?? []),
      services: json['services'] ?? '',
      city: json['city'],
      area: json['area'],
      location:
          json['location'] ??
          '${json['city'] ?? ''}${json['area'] != null ? ', ${json['area']}' : ''}',
      eventTypes: List<String>.from(
        json['event_types'] ?? json['eventTypes'] ?? [],
      ),
      pricing: json['pricing'] ?? '',
      availability: json['availability'] ?? 'active',
      portfolioImages: List<String>.from(
        json['portfolio_images'] ?? json['portfolioImages'] ?? [],
      ),
      averageRating: (json['average_rating'] ?? json['averageRating'] ?? 0)
          .toDouble(),
      totalReviews: json['total_reviews'] ?? json['totalReviews'] ?? 0,
      approvalStatus: approvalStatus,
      rejectionReason: json['rejection_reason'],
      isApproved:
          approvalStatus == ApprovalStatus.approved ||
          (json['is_approved'] ?? json['isApproved'] ?? false),
      cnicNumber: json['cnic_number'],
      cnicFrontImage: json['cnic_front_image'],
      cnicBackImage: json['cnic_back_image'],
      whatsappNumber: json['whatsapp_number'],
      contactPhone: json['contact_phone'],
      contactEmail: json['contact_email'],
      description: json['description'],
      basicPackage: json['basic_package'] != null
          ? PricingTier.fromJson(json['basic_package'])
          : null,
      premiumPackage: json['premium_package'] != null
          ? PricingTier.fromJson(json['premium_package'])
          : null,
      luxuryPackage: json['luxury_package'] != null
          ? PricingTier.fromJson(json['luxury_package'])
          : null,
      pricingPackages:
          (json['pricing_packages'] as List?)
              ?.map((p) => PricingPackageModel.fromJson(p))
              .toList() ??
          [],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': userId,
      'business_name': businessName,
      'category': category,
      'services': services,
      if (city != null) 'city': city,
      if (area != null) 'area': area,
      'location': location,
      'event_types': eventTypes,
      'pricing': pricing,
      'availability': availability,
      'portfolio_images': portfolioImages,
      'average_rating': averageRating,
      'total_reviews': totalReviews,
      'approval_status': approvalStatus.name,
      if (rejectionReason != null) 'rejection_reason': rejectionReason,
      'is_approved': isApproved,
      if (cnicNumber != null) 'cnic_number': cnicNumber,
      if (cnicFrontImage != null) 'cnic_front_image': cnicFrontImage,
      if (cnicBackImage != null) 'cnic_back_image': cnicBackImage,
      if (whatsappNumber != null) 'whatsapp_number': whatsappNumber,
      if (contactPhone != null) 'contact_phone': contactPhone,
      if (contactEmail != null) 'contact_email': contactEmail,
      if (description != null) 'description': description,
      if (basicPackage != null) 'basic_package': basicPackage!.toJson(),
      if (premiumPackage != null) 'premium_package': premiumPackage!.toJson(),
      if (luxuryPackage != null) 'luxury_package': luxuryPackage!.toJson(),
      'pricing_packages': pricingPackages.map((p) => p.toJson()).toList(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Check if vendor has any pricing tiers set
  bool get hasPricingTiers =>
      basicPackage != null || premiumPackage != null || luxuryPackage != null;

  /// Get list of available package types
  List<String> get availablePackageTypes {
    final types = <String>[];
    if (basicPackage != null) types.add('basic');
    if (premiumPackage != null) types.add('premium');
    if (luxuryPackage != null) types.add('luxury');
    return types;
  }

  /// Get pricing tier by type
  PricingTier? getPricingTier(String type) {
    switch (type.toLowerCase()) {
      case 'basic':
        return basicPackage;
      case 'premium':
        return premiumPackage;
      case 'luxury':
        return luxuryPackage;
      default:
        return null;
    }
  }

  /// Calculate cost for a specific package and guest count
  double calculateCost(String packageType, int numberOfGuests) {
    final tier = getPricingTier(packageType);
    if (tier == null) return 0.0;
    return tier.calculateCost(numberOfGuests);
  }

  VendorModel copyWith({
    String? id,
    String? userId,
    String? businessName,
    List<String>? category,
    String? services,
    String? city,
    String? area,
    String? location,
    List<String>? eventTypes,
    String? pricing,
    String? availability,
    List<String>? portfolioImages,
    double? averageRating,
    int? totalReviews,
    ApprovalStatus? approvalStatus,
    String? rejectionReason,
    bool? isApproved,
    String? cnicNumber,
    String? cnicFrontImage,
    String? cnicBackImage,
    String? whatsappNumber,
    String? contactPhone,
    String? contactEmail,
    String? description,
    PricingTier? basicPackage,
    PricingTier? premiumPackage,
    PricingTier? luxuryPackage,
    List<PricingPackageModel>? pricingPackages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VendorModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      businessName: businessName ?? this.businessName,
      category: category ?? this.category,
      services: services ?? this.services,
      city: city ?? this.city,
      area: area ?? this.area,
      location: location ?? this.location,
      eventTypes: eventTypes ?? this.eventTypes,
      pricing: pricing ?? this.pricing,
      availability: availability ?? this.availability,
      portfolioImages: portfolioImages ?? this.portfolioImages,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      approvalStatus: approvalStatus ?? this.approvalStatus,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      isApproved: isApproved ?? this.isApproved,
      cnicNumber: cnicNumber ?? this.cnicNumber,
      cnicFrontImage: cnicFrontImage ?? this.cnicFrontImage,
      cnicBackImage: cnicBackImage ?? this.cnicBackImage,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      contactPhone: contactPhone ?? this.contactPhone,
      contactEmail: contactEmail ?? this.contactEmail,
      description: description ?? this.description,
      basicPackage: basicPackage ?? this.basicPackage,
      premiumPackage: premiumPackage ?? this.premiumPackage,
      luxuryPackage: luxuryPackage ?? this.luxuryPackage,
      pricingPackages: pricingPackages ?? this.pricingPackages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
