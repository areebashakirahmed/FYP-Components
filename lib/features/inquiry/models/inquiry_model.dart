enum InquiryStatus { pending, accepted, declined }

class InquiryModel {
  final String id;
  final String userId;
  final String vendorId;
  final String eventType;
  final String preferredDate;
  final String message;
  final InquiryStatus status;
  final String? vendorResponse;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Populated fields (when available)
  final String? userName;
  final String? userEmail;
  final String? vendorName;

  InquiryModel({
    required this.id,
    required this.userId,
    required this.vendorId,
    required this.eventType,
    required this.preferredDate,
    required this.message,
    this.status = InquiryStatus.pending,
    this.vendorResponse,
    this.createdAt,
    this.updatedAt,
    this.userName,
    this.userEmail,
    this.vendorName,
  });

  factory InquiryModel.fromJson(Map<String, dynamic> json) {
    InquiryStatus parseStatus(String? status) {
      switch (status?.toLowerCase()) {
        case 'accepted':
          return InquiryStatus.accepted;
        case 'declined':
          return InquiryStatus.declined;
        default:
          return InquiryStatus.pending;
      }
    }

    return InquiryModel(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['user_id'] ?? json['userId'] ?? '',
      vendorId: json['vendor_id'] ?? json['vendorId'] ?? '',
      eventType: json['event_type'] ?? json['eventType'] ?? '',
      preferredDate: json['preferred_date'] ?? json['preferredDate'] ?? '',
      message: json['message'] ?? '',
      status: parseStatus(json['status']),
      vendorResponse: json['vendor_response'] ?? json['vendorResponse'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      userName: json['user_name'] ?? json['userName'],
      userEmail: json['user_email'] ?? json['userEmail'],
      vendorName: json['vendor_name'] ?? json['vendorName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': userId,
      'vendor_id': vendorId,
      'event_type': eventType,
      'preferred_date': preferredDate,
      'message': message,
      'status': status.name,
      'vendor_response': vendorResponse,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String get statusText {
    switch (status) {
      case InquiryStatus.accepted:
        return 'Accepted';
      case InquiryStatus.declined:
        return 'Declined';
      case InquiryStatus.pending:
        return 'Pending';
    }
  }
}
