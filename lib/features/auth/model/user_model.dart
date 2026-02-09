import 'package:mehfilista/features/vendor/models/vendor_model.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String role;
  final String? city;
  final String? area;
  final ApprovalStatus approvalStatus; // user-level (pending | approved | rejected)
  final VendorModel? vendorProfile; // For vendors - contains approval_status

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.role,
    this.city,
    this.area,
    this.approvalStatus = ApprovalStatus.pending,
    this.vendorProfile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['_id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      city: json['city'],
      area: json['area'],
      approvalStatus: ApprovalStatus.fromString(json['approval_status']),
      vendorProfile:
          json['vendor_profile'] != null || json['vendorProfile'] != null
          ? VendorModel.fromJson(
              json['vendor_profile'] ?? json['vendorProfile'] ?? {},
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'role': role,
      if (city != null) 'city': city,
      if (area != null) 'area': area,
      'approval_status': approvalStatus.name,
      if (vendorProfile != null) 'vendor_profile': vendorProfile!.toJson(),
    };
  }

  bool get isApproved => approvalStatus == ApprovalStatus.approved;
}
