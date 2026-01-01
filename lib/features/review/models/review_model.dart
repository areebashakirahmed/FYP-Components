class ReviewModel {
  final String id;
  final String userId;
  final String vendorId;
  final int rating;
  final String comment;
  final DateTime? createdAt;

  // Populated fields (when available)
  final String? userName;
  final String? userImage;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.vendorId,
    required this.rating,
    required this.comment,
    this.createdAt,
    this.userName,
    this.userImage,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['user_id'] ?? json['userId'] ?? '',
      vendorId: json['vendor_id'] ?? json['vendorId'] ?? '',
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      userName: json['user_name'] ?? json['userName'],
      userImage: json['user_image'] ?? json['userImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': userId,
      'vendor_id': vendorId,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
