import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// Centralized error handler for all API responses.
/// Maps raw API errors to user-friendly messages.
class ApiErrorHandler {
  /// Main entry: get a friendly error message from any HTTP response
  static String getErrorMessage(http.Response response) {
    switch (response.statusCode) {
      case 400:
        return _handleBadRequest(response);
      case 401:
        return _handleUnauthorized(response);
      case 403:
        return _handleForbidden(response);
      case 404:
        return _handleNotFound(response);
      case 422:
        return _handleValidationError(response);
      case 500:
        return 'Something went wrong. Please try again later';
      default:
        return 'An unexpected error occurred';
    }
  }

  /// Check if the response is a 401 (token expired / auth required)
  static bool isUnauthorized(http.Response response) {
    return response.statusCode == 401;
  }

  /// Get a friendly message for network/socket errors
  static String getNetworkErrorMessage(dynamic error) {
    if (error is SocketException) {
      return 'No internet connection. Please check your network';
    }
    if (error is HttpException) {
      return 'Could not reach the server. Please try again';
    }
    if (error.toString().contains('SocketException') ||
        error.toString().contains('Connection refused') ||
        error.toString().contains('Network is unreachable')) {
      return 'No internet connection. Please check your network';
    }
    if (error.toString().contains('TimeoutException') ||
        error.toString().contains('timed out')) {
      return 'Connection timed out. Please try again';
    }
    return 'Something went wrong. Please check your connection';
  }

  // --------------- Private Handlers ---------------

  /// 400 Bad Request – parse detail for specific messages
  static String _handleBadRequest(http.Response response) {
    final detail = _parseDetail(response);

    // Auth: registration
    if (detail.contains('Email already registered')) {
      return 'This email is already in use. Please try a different email';
    }

    // Vendor: profile exists
    if (detail.contains('already exists') ||
        detail.contains('Vendor profile already exists')) {
      return 'You already have a vendor profile';
    }

    // Vendor search: bad filters
    if (detail.contains('Invalid filter')) {
      return 'Invalid search filters. Please try again';
    }

    // Vendor ID format
    if (detail.contains('Invalid') && detail.contains('ID')) {
      return 'Invalid ID format';
    }

    // Review: already reviewed
    if (detail.contains('already reviewed')) {
      return "You've already reviewed this vendor";
    }

    // Upload: no file
    if (detail.contains('No file provided')) {
      return 'Please select an image';
    }

    // Upload: invalid type
    if (detail.contains('Invalid file type')) {
      return 'Please select a valid image (JPEG, PNG, or WebP)';
    }

    // Upload: file too large
    if (detail.contains('File too large') || detail.contains('too large')) {
      return 'Image is too large. Maximum size is 10 MB';
    }

    // Fallback: return the detail if it exists, otherwise generic
    return detail.isNotEmpty ? detail : 'Bad request';
  }

  /// 401 Unauthorized
  static String _handleUnauthorized(http.Response response) {
    final detail = _parseDetail(response);

    if (detail.contains('Invalid email or password') ||
        detail.contains('Incorrect')) {
      return 'Incorrect email or password. Please try again';
    }

    if (detail.contains('expired')) {
      return 'Your session has expired. Please login again';
    }

    return 'Please login to continue';
  }

  /// 403 Forbidden
  static String _handleForbidden(http.Response response) {
    final detail = _parseDetail(response);

    // Vendor creation
    if (detail.contains('Only vendors')) {
      return 'This feature is only available for vendor accounts';
    }

    // Inquiry – user only
    if (detail.contains('Only users can send')) {
      return 'Only user accounts can send inquiries';
    }

    // Review – user only
    if (detail.contains('Only users can leave')) {
      return 'Only user accounts can leave reviews';
    }

    // Inquiry lists
    if (detail.contains('Only users can view their inquiries')) {
      return 'Access denied';
    }
    if (detail.contains('Only vendors can view vendor inquiries')) {
      return 'Access denied';
    }

    // Vendor edit – not owner
    if (detail.contains('Not authorized to edit') ||
        detail.contains('not authorized')) {
      return 'You can only edit your own profile';
    }

    // Inquiry respond – not owner
    if (detail.contains('Not authorized to respond')) {
      return 'You can only respond to your own inquiries';
    }

    // Portfolio upload – not owner
    if (detail.contains('only upload to your own')) {
      return 'You can only upload to your own portfolio';
    }

    // Admin only
    if (detail.contains('Admin access')) {
      return 'Access denied. Admin only';
    }

    return 'Access denied';
  }

  /// 404 Not Found
  static String _handleNotFound(http.Response response) {
    final detail = _parseDetail(response);

    if (detail.contains('Vendor not found')) {
      return 'This vendor is no longer available';
    }

    if (detail.contains('Inquiry not found')) {
      return 'Inquiry not found';
    }

    if (detail.contains('City not found')) {
      return 'City not found';
    }

    // Auth: reset password
    if (detail.contains('No account found') ||
        detail.contains('not found') && detail.contains('email')) {
      return 'No account found with this email address';
    }

    return 'The item you\'re looking for doesn\'t exist';
  }

  /// 422 Validation Error – parse errors array or detail string
  static String _handleValidationError(http.Response response) {
    try {
      final body = jsonDecode(response.body);

      // Case 1: errors array from FastAPI validation
      if (body['errors'] is List && (body['errors'] as List).isNotEmpty) {
        final errors = body['errors'] as List;
        return _formatValidationErrors(errors);
      }

      // Case 2: detail is a List (old FastAPI format)
      if (body['detail'] is List && (body['detail'] as List).isNotEmpty) {
        final errors = body['detail'] as List;
        return _formatValidationErrors(errors);
      }

      // Case 3: detail is a string
      if (body['detail'] is String) {
        return _mapValidationDetail(body['detail']);
      }

      return 'Please check your input and try again';
    } catch (_) {
      return 'Please check your input and try again';
    }
  }

  // --------------- Helpers ---------------

  /// Safely extract the 'detail' string from a response body
  static String _parseDetail(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      if (body['detail'] is String) {
        return body['detail'];
      }
      return '';
    } catch (_) {
      return '';
    }
  }

  /// Format a list of FastAPI validation errors into a user-friendly string
  static String _formatValidationErrors(List<dynamic> errors) {
    if (errors.isEmpty) return 'Please check your input and try again';

    final messages = <String>[];
    for (final error in errors) {
      final msg = error['msg']?.toString() ?? '';
      final loc = error['loc'] as List?;
      final fieldName = loc != null && loc.length > 1
          ? _humanizeFieldName(loc.last.toString())
          : null;

      if (fieldName != null && msg.isNotEmpty) {
        messages.add('$fieldName: $msg');
      } else if (msg.isNotEmpty) {
        messages.add(msg);
      }
    }

    // Return just the first message to avoid overwhelming the user
    return messages.isNotEmpty
        ? messages.first
        : 'Please check your input and try again';
  }

  /// Convert snake_case field names to human-readable labels
  static String _humanizeFieldName(String field) {
    const fieldLabels = {
      'email': 'Email',
      'password': 'Password',
      'name': 'Name',
      'phone': 'Phone',
      'role': 'Role',
      'city': 'City',
      'area': 'Area',
      'business_name': 'Business name',
      'category': 'Category',
      'services': 'Services',
      'event_types': 'Event types',
      'cnic_number': 'CNIC number',
      'cnic_front_image': 'CNIC front image',
      'cnic_back_image': 'CNIC back image',
      'whatsapp_number': 'WhatsApp number',
      'vendor_id': 'Vendor',
      'event_type': 'Event type',
      'event_date': 'Event date',
      'selected_package': 'Package',
      'number_of_guests': 'Number of guests',
      'message': 'Message',
      'rating': 'Rating',
      'comment': 'Comment',
      'basic_package': 'Basic package',
      'premium_package': 'Premium package',
      'luxury_package': 'Luxury package',
      'new_password': 'New password',
    };

    return fieldLabels[field] ??
        field.replaceAll('_', ' ').replaceRange(0, 1, field[0].toUpperCase());
  }

  /// Map known validation detail strings to friendlier messages
  static String _mapValidationDetail(String detail) {
    if (detail.contains('Invalid email')) {
      return 'Please enter a valid email address';
    }
    if (detail.contains('Password too short') ||
        detail.contains('password') && detail.contains('short')) {
      return 'Password must be at least 8 characters';
    }
    if (detail.contains('Invalid package')) {
      return 'Please check your package details';
    }
    if (detail.contains('Rating must be')) {
      return 'Rating must be between 1 and 5';
    }
    if (detail.contains('at least 10 characters')) {
      return 'Must be at least 10 characters long';
    }
    if (detail.contains('greater than 0')) {
      return 'Number of guests must be at least 1';
    }
    if (detail.contains('Invalid status')) {
      return 'Invalid status. Must be accepted or declined';
    }
    if (detail.contains('Rejection reason')) {
      return 'Please provide a rejection reason';
    }
    return detail;
  }
}
