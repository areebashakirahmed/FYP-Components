enum InquiryStatus { pending, accepted, declined }

class InquiryModel {
  final String id;
  final String userId;
  final String vendorId;
  final String eventType;
  final String preferredDate; // Legacy field
  final String? eventDate; // New field (YYYY-MM-DD format)
  final String message;
  final InquiryStatus status;
  final String? vendorResponse;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Populated fields (when available)
  final String? userName;
  final String? userEmail;
  final String? vendorName;

  // Package selection and cost calculation
  final String? selectedPackage; // 'basic', 'premium', or 'luxury'
  final int? numberOfGuests;
  final double? estimatedCost; // Auto-calculated by server

  // Legacy fields for backwards compatibility
  final String? eventLocation;
  final int? guestCount;

  InquiryModel({
    required this.id,
    required this.userId,
    required this.vendorId,
    required this.eventType,
    required this.preferredDate,
    this.eventDate,
    required this.message,
    this.status = InquiryStatus.pending,
    this.vendorResponse,
    this.createdAt,
    this.updatedAt,
    this.userName,
    this.userEmail,
    this.vendorName,
    this.selectedPackage,
    this.numberOfGuests,
    this.estimatedCost,
    this.eventLocation,
    this.guestCount,
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
      preferredDate:
          json['preferred_date'] ??
          json['preferredDate'] ??
          json['event_date'] ??
          '',
      eventDate: json['event_date'] ?? json['eventDate'],
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
      selectedPackage: json['selected_package'] ?? json['selectedPackage'],
      numberOfGuests: json['number_of_guests'] ?? json['numberOfGuests'],
      estimatedCost: json['estimated_cost'] != null
          ? (json['estimated_cost'] as num).toDouble()
          : null,
      eventLocation: json['event_location'] ?? json['eventLocation'],
      guestCount:
          json['guest_count'] ?? json['guestCount'] ?? json['number_of_guests'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': userId,
      'vendor_id': vendorId,
      'event_type': eventType,
      'preferred_date': preferredDate,
      if (eventDate != null) 'event_date': eventDate,
      'message': message,
      'status': status.name,
      if (vendorResponse != null) 'vendor_response': vendorResponse,
      if (selectedPackage != null) 'selected_package': selectedPackage,
      if (numberOfGuests != null) 'number_of_guests': numberOfGuests,
      if (estimatedCost != null) 'estimated_cost': estimatedCost,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Get the effective date (prefers eventDate, falls back to preferredDate)
  String get effectiveDate => eventDate ?? preferredDate;

  /// Get the effective guest count
  int get effectiveGuestCount => numberOfGuests ?? guestCount ?? 0;

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
