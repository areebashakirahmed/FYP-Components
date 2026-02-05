/// Validation utilities for form fields
/// Matches backend API validation rules exactly
class Validators {
  // Private constructor to prevent instantiation
  Validators._();

  /// Validates email format (backend: EmailStr)
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates phone number (Pakistani format)
  /// Backend: string, required, no regex enforced
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }

    // Remove spaces, dashes, and parentheses
    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Pakistani phone number patterns
    final patterns = [
      RegExp(r'^0[3][0-9]{9}$'), // 03001234567
      RegExp(r'^\+92[3][0-9]{9}$'), // +923001234567
      RegExp(r'^92[3][0-9]{9}$'), // 923001234567
      RegExp(r'^[3][0-9]{9}$'), // 3001234567
    ];

    final isValid = patterns.any((pattern) => pattern.hasMatch(cleaned));

    if (!isValid) {
      return 'Please enter a valid phone number (e.g., 03001234567)';
    }
    return null;
  }

  /// Validates required field
  static String? validateRequired(
    String? value, {
    String fieldName = 'This field',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates password (backend: min_length=6)
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Validates confirm password
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validates name (backend: min_length=2)
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (value.trim().length > 50) {
      return 'Name must be less than 50 characters';
    }
    return null;
  }

  /// Validates business name (backend: min_length=2)
  static String? validateBusinessName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your business name';
    }
    if (value.trim().length < 2) {
      return 'Business name must be at least 2 characters';
    }
    return null;
  }

  /// Validates services description (backend: min_length=10)
  static String? validateServices(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please describe your services';
    }
    if (value.trim().length < 10) {
      return 'Services description must be at least 10 characters';
    }
    return null;
  }

  /// Validates CNIC number (backend: pattern ^\d{5}-\d{7}-\d{1}$)
  /// Format: 42101-1234567-1
  static String? validateCnic(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your CNIC number';
    }
    final cnicRegex = RegExp(r'^\d{5}-\d{7}-\d{1}$');
    if (!cnicRegex.hasMatch(value.trim())) {
      return 'CNIC must be in format: 42101-1234567-1';
    }
    return null;
  }

  /// Validates WhatsApp number (required by backend)
  static String? validateWhatsApp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your WhatsApp number';
    }
    // Allow +country code format
    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (cleaned.length < 10) {
      return 'Please enter a valid WhatsApp number';
    }
    return null;
  }

  /// Validates pricing package description (backend: min_length=10)
  static String? validatePackageDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter package description';
    }
    if (value.trim().length < 10) {
      return 'Description must be at least 10 characters';
    }
    return null;
  }

  /// Validates pricing package price (backend: must be > 0)
  static String? validatePrice(String? value, {String fieldName = 'Price'}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $fieldName';
    }
    final price = double.tryParse(value);
    if (price == null || price <= 0) {
      return '$fieldName must be greater than 0';
    }
    return null;
  }

  /// Validates selected package (backend: must match ^(basic|premium|luxury)$)
  static String? validateSelectedPackage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select a package';
    }
    final validPackages = ['basic', 'premium', 'luxury'];
    if (!validPackages.contains(value.trim().toLowerCase())) {
      return 'Package must be basic, premium, or luxury';
    }
    return null;
  }

  /// Validates message/inquiry content
  static String? validateMessage(
    String? value, {
    int minLength = 10,
    int maxLength = 500,
  }) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a message';
    }
    if (value.trim().length < minLength) {
      return 'Message must be at least $minLength characters';
    }
    if (value.trim().length > maxLength) {
      return 'Message must be less than $maxLength characters';
    }
    return null;
  }

  /// Validates event type
  static String? validateEventType(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the event type';
    }
    if (value.trim().length < 3) {
      return 'Event type must be at least 3 characters';
    }
    return null;
  }

  /// Validates date is selected and in the future
  static String? validateFutureDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a date';
    }
    try {
      final date = DateTime.parse(value);
      if (date.isBefore(DateTime.now())) {
        return 'Please select a future date';
      }
    } catch (e) {
      return 'Invalid date format';
    }
    return null;
  }

  /// Validates review comment
  static String? validateReviewComment(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please add a comment';
    }
    if (value.trim().length < 10) {
      return 'Comment must be at least 10 characters';
    }
    if (value.trim().length > 500) {
      return 'Comment must be less than 500 characters';
    }
    return null;
  }

  /// Validates vendor response (backend: min_length=5)
  static String? validateVendorResponse(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a response';
    }
    if (value.trim().length < 5) {
      return 'Response must be at least 5 characters';
    }
    if (value.trim().length > 1000) {
      return 'Response must be less than 1000 characters';
    }
    return null;
  }

  /// Validates location
  static String? validateLocation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a location';
    }
    if (value.trim().length < 3) {
      return 'Location must be at least 3 characters';
    }
    return null;
  }

  /// Validates city name (required for vendor create)
  static String? validateCity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select a city';
    }
    if (value.trim().length < 2) {
      return 'City must be at least 2 characters';
    }
    return null;
  }

  /// Validates area name (required for vendor create)
  static String? validateArea(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select an area';
    }
    return null;
  }

  /// Validates package name
  static String? validatePackageName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select a package';
    }
    return null;
  }

  /// Validates guest count
  static String? validateGuestCount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the number of guests';
    }
    final count = int.tryParse(value);
    if (count == null || count <= 0) {
      return 'Please enter a valid number of guests';
    }
    if (count > 10000) {
      return 'Guest count seems too high';
    }
    return null;
  }
}
