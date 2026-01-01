import 'package:flutter/material.dart';
import 'package:mehfilista/features/inquiry/models/inquiry_model.dart';
import 'package:mehfilista/features/inquiry/services/inquiry_service.dart';
import 'package:mehfilista/utils/constants/app_config.dart';

class InquiryProvider extends ChangeNotifier {
  final InquiryService _inquiryService = InquiryService();

  // State
  List<InquiryModel> _myInquiries = []; // For users
  List<InquiryModel> _vendorInquiries = []; // For vendors
  InquiryModel? _selectedInquiry;
  bool _isLoading = false;
  String? _error;

  // Demo inquiries
  static final List<InquiryModel> _demoUserInquiries = [
    InquiryModel(
      id: 'inq1',
      userId: 'demo_user',
      vendorId: 'v1',
      eventType: 'Wedding',
      preferredDate: '2025-03-15',
      message:
          'Hi, I am interested in your wedding photography services for my wedding in March. Please share your availability and package details.',
      status: InquiryStatus.accepted,
      vendorResponse:
          'Thank you for your inquiry! We are available on March 15th. Our wedding package starts from PKR 80,000 which includes full day coverage. Would you like to schedule a meeting?',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      vendorName: 'Royal Photography',
    ),
    InquiryModel(
      id: 'inq2',
      userId: 'demo_user',
      vendorId: 'v2',
      eventType: 'Wedding',
      preferredDate: '2025-03-15',
      message:
          'Looking for catering services for approximately 300 guests. Can you provide a menu and pricing?',
      status: InquiryStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      vendorName: 'Elegant Catering',
    ),
    InquiryModel(
      id: 'inq3',
      userId: 'demo_user',
      vendorId: 'v3',
      eventType: 'Birthday',
      preferredDate: '2025-02-20',
      message: 'Need decoration for a birthday party. Theme is floral garden.',
      status: InquiryStatus.declined,
      vendorResponse:
          'Sorry, we are fully booked for that date. We recommend checking our availability for alternate dates.',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(days: 8)),
      vendorName: 'Dream Decorators',
    ),
  ];

  static final List<InquiryModel> _demoVendorInquiries = [
    InquiryModel(
      id: 'vinq1',
      userId: 'u1',
      vendorId: 'demo_vendor',
      eventType: 'Wedding',
      preferredDate: '2025-04-10',
      message:
          'We need photography and videography for our wedding. Can you provide both services?',
      status: InquiryStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      userName: 'Ahmed Khan',
      userEmail: 'ahmed@example.com',
    ),
    InquiryModel(
      id: 'vinq2',
      userId: 'u2',
      vendorId: 'demo_vendor',
      eventType: 'Corporate',
      preferredDate: '2025-03-05',
      message:
          'Corporate event photography needed for annual company meeting. 4 hours coverage.',
      status: InquiryStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      userName: 'Sara Ali',
      userEmail: 'sara@example.com',
    ),
    InquiryModel(
      id: 'vinq3',
      userId: 'u3',
      vendorId: 'demo_vendor',
      eventType: 'Birthday',
      preferredDate: '2025-02-28',
      message: 'First birthday party photoshoot. Need 2 hours coverage.',
      status: InquiryStatus.accepted,
      vendorResponse:
          'We would love to cover your little one\'s birthday! Our 2-hour package costs PKR 25,000.',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      userName: 'Fatima Hassan',
      userEmail: 'fatima@example.com',
    ),
  ];

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

    if (kDemoMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      final newInquiry = InquiryModel(
        id: 'inq_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'demo_user',
        vendorId: vendorId,
        eventType: eventType,
        preferredDate: preferredDate,
        message: message,
        status: InquiryStatus.pending,
        createdAt: DateTime.now(),
        vendorName: 'Demo Vendor',
      );
      _myInquiries.insert(0, newInquiry);
      _isLoading = false;
      notifyListeners();
      return true;
    }

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

    if (kDemoMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      _myInquiries = List.from(_demoUserInquiries);
      _isLoading = false;
      notifyListeners();
      return;
    }

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

    if (kDemoMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      _vendorInquiries = List.from(_demoVendorInquiries);
      _isLoading = false;
      notifyListeners();
      return;
    }

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

    if (kDemoMode) {
      await Future.delayed(const Duration(milliseconds: 200));
      _selectedInquiry = _myInquiries.firstWhere(
        (i) => i.id == inquiryId,
        orElse: () => _vendorInquiries.firstWhere(
          (i) => i.id == inquiryId,
          orElse: () => _demoUserInquiries.first,
        ),
      );
      _isLoading = false;
      notifyListeners();
      return;
    }

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

    if (kDemoMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      final index = _vendorInquiries.indexWhere((i) => i.id == inquiryId);
      if (index != -1) {
        final oldInquiry = _vendorInquiries[index];
        final updatedInquiry = InquiryModel(
          id: oldInquiry.id,
          userId: oldInquiry.userId,
          vendorId: oldInquiry.vendorId,
          eventType: oldInquiry.eventType,
          preferredDate: oldInquiry.preferredDate,
          message: oldInquiry.message,
          status: status == 'accepted'
              ? InquiryStatus.accepted
              : InquiryStatus.declined,
          vendorResponse: vendorResponse,
          createdAt: oldInquiry.createdAt,
          updatedAt: DateTime.now(),
          userName: oldInquiry.userName,
          userEmail: oldInquiry.userEmail,
          vendorName: oldInquiry.vendorName,
        );
        _vendorInquiries[index] = updatedInquiry;
        _selectedInquiry = updatedInquiry;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    }

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
