class VendorModel {
  final String id;
  final String userId;
  final String businessName;
  final List<String> category;
  final String services;
  final String location;
  final List<String> eventTypes;
  final String pricing;
  final String availability;
  final List<String> portfolioImages;
  final double averageRating;
  final int totalReviews;
  final bool isApproved;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  VendorModel({
    required this.id,
    required this.userId,
    required this.businessName,
    required this.category,
    required this.services,
    required this.location,
    required this.eventTypes,
    required this.pricing,
    required this.availability,
    this.portfolioImages = const [],
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.isApproved = false,
    this.createdAt,
    this.updatedAt,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['user_id'] ?? json['userId'] ?? '',
      businessName: json['business_name'] ?? json['businessName'] ?? '',
      category: List<String>.from(json['category'] ?? []),
      services: json['services'] ?? '',
      location: json['location'] ?? '',
      eventTypes: List<String>.from(
        json['event_types'] ?? json['eventTypes'] ?? [],
      ),
      pricing: json['pricing'] ?? '',
      availability: json['availability'] ?? '',
      portfolioImages: List<String>.from(
        json['portfolio_images'] ?? json['portfolioImages'] ?? [],
      ),
      averageRating: (json['average_rating'] ?? json['averageRating'] ?? 0)
          .toDouble(),
      totalReviews: json['total_reviews'] ?? json['totalReviews'] ?? 0,
      isApproved: json['is_approved'] ?? json['isApproved'] ?? false,
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
      'location': location,
      'event_types': eventTypes,
      'pricing': pricing,
      'availability': availability,
      'portfolio_images': portfolioImages,
      'average_rating': averageRating,
      'total_reviews': totalReviews,
      'is_approved': isApproved,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  VendorModel copyWith({
    String? id,
    String? userId,
    String? businessName,
    List<String>? category,
    String? services,
    String? location,
    List<String>? eventTypes,
    String? pricing,
    String? availability,
    List<String>? portfolioImages,
    double? averageRating,
    int? totalReviews,
    bool? isApproved,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VendorModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      businessName: businessName ?? this.businessName,
      category: category ?? this.category,
      services: services ?? this.services,
      location: location ?? this.location,
      eventTypes: eventTypes ?? this.eventTypes,
      pricing: pricing ?? this.pricing,
      availability: availability ?? this.availability,
      portfolioImages: portfolioImages ?? this.portfolioImages,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      isApproved: isApproved ?? this.isApproved,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
