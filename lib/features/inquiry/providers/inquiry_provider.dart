import 'package:flutter/material.dart';
import 'package:mehfilista/features/inquiry/models/inquiry_model.dart';
import 'package:mehfilista/features/inquiry/services/inquiry_service.dart';

class InquiryProvider extends ChangeNotifier {
  final InquiryService _inquiryService = InquiryService();

  // State
  List<InquiryModel> _myInquiries = []; // For users
  List<InquiryModel> _vendorInquiries = []; // For vendors
  InquiryModel? _selectedInquiry;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<InquiryModel> get myInquiries => _myInquiries;
  List<InquiryModel> get vendorInquiries => _vendorInquiries;
  InquiryModel? get selectedInquiry => _selectedInquiry;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  // Filtered inquiries by status
  List<InquiryModel> get pendingInquiries =>
      _vendorInquiries.where((i) => i.status == InquiryStatus.pending).toList();
  List<InquiryModel> get acceptedInquiries => _vendorInquiries
      .where((i) => i.status == InquiryStatus.accepted)
      .toList();
  List<InquiryModel> get declinedInquiries => _vendorInquiries
      .where((i) => i.status == InquiryStatus.declined)
      .toList();

  /// Send inquiry to vendor (User only)
  Future<bool> sendInquiry({
    required String token,
    required String vendorId,
    required String eventType,
    required String preferredDate,
    required String message,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _inquiryService.sendInquiry(
      token: token,
      vendorId: vendorId,
      eventType: eventType,
      preferredDate: preferredDate,
      message: message,
    );

    bool success = false;
    result.when(
      success: (data) {
        _myInquiries.insert(0, data); // Add to beginning
        _error = null;
        success = true;
      },
      failure: (error) {
        _error = error;
        success = false;
      },
    );

    _isLoading = false;
    notifyListeners();
    return success;
  }

  /// Load my inquiries (User only)
  Future<void> loadMyInquiries(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _inquiryService.getMyInquiries(token);

    result.when(
      success: (data) {
        _myInquiries = data;
        _error = null;
      },
      failure: (error) {
        _error = error;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  /// Load vendor inquiries (Vendor only)
  Future<void> loadVendorInquiries(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _inquiryService.getVendorInquiries(token);

    result.when(
      success: (data) {
        _vendorInquiries = data;
        _error = null;
      },
      failure: (error) {
        _error = error;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  /// Get inquiry details
  Future<void> getInquiryDetails({
    required String token,
    required String inquiryId,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _inquiryService.getInquiryDetails(
      token: token,
      inquiryId: inquiryId,
    );

    result.when(
      success: (data) {
        _selectedInquiry = data;
        _error = null;
      },
      failure: (error) {
        _error = error;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  /// Accept inquiry (Vendor only)
  Future<bool> acceptInquiry({
    required String token,
    required String inquiryId,
    required String vendorResponse,
  }) async {
    return await _respondToInquiry(
      token: token,
      inquiryId: inquiryId,
      status: 'accepted',
      vendorResponse: vendorResponse,
    );
  }

  /// Decline inquiry (Vendor only)
  Future<bool> declineInquiry({
    required String token,
    required String inquiryId,
    required String vendorResponse,
  }) async {
    return await _respondToInquiry(
      token: token,
      inquiryId: inquiryId,
      status: 'declined',
      vendorResponse: vendorResponse,
    );
  }

  /// Respond to inquiry (Internal method)
  Future<bool> _respondToInquiry({
    required String token,
    required String inquiryId,
    required String status,
    required String vendorResponse,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _inquiryService.respondToInquiry(
      token: token,
      inquiryId: inquiryId,
      status: status,
      vendorResponse: vendorResponse,
    );

    bool success = false;
    result.when(
      success: (data) {
        // Update the inquiry in the list
        final index = _vendorInquiries.indexWhere((i) => i.id == inquiryId);
        if (index != -1) {
          _vendorInquiries[index] = data;
        }
        _selectedInquiry = data;
        _error = null;
        success = true;
      },
      failure: (error) {
        _error = error;
        success = false;
      },
    );

    _isLoading = false;
    notifyListeners();
    return success;
  }

  /// Clear selected inquiry
  void clearSelectedInquiry() {
    _selectedInquiry = null;
    notifyListeners();
  }

  /// Clear all data
  void clearAllData() {
    _myInquiries = [];
    _vendorInquiries = [];
    _selectedInquiry = null;
    _error = null;
    notifyListeners();
  }
}
