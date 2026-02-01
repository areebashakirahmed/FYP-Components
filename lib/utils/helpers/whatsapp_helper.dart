import 'package:url_launcher/url_launcher.dart';

/// WhatsApp helper utility for launching WhatsApp chats
class WhatsAppHelper {
  /// Open WhatsApp chat with the given phone number
  /// [phoneNumber] should include country code (e.g., +923001234567)
  /// [message] optional pre-filled message
  static Future<bool> openChat({
    required String phoneNumber,
    String? message,
  }) async {
    // Clean the phone number - remove + and spaces
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    // Build WhatsApp URL
    String whatsappUrl = 'https://wa.me/$cleanNumber';
    if (message != null && message.isNotEmpty) {
      final encodedMessage = Uri.encodeComponent(message);
      whatsappUrl += '?text=$encodedMessage';
    }

    final uri = Uri.parse(whatsappUrl);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// Open WhatsApp with a vendor inquiry message
  static Future<bool> openVendorChat({
    required String phoneNumber,
    String? vendorName,
    String? eventType,
  }) async {
    final buffer = StringBuffer("Hi");
    if (vendorName != null) {
      buffer.write(" $vendorName");
    }
    buffer.write("! I'm interested in your services");
    if (eventType != null) {
      buffer.write(" for my $eventType");
    }
    buffer.write(". I found you on Mehfilista.");

    return openChat(phoneNumber: phoneNumber, message: buffer.toString());
  }

  /// Validate if a phone number looks like a WhatsApp number
  static bool isValidWhatsAppNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) return false;

    // Remove all non-digit characters
    final digits = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    // Should have at least 10 digits (with country code)
    return digits.length >= 10;
  }

  /// Format phone number for display
  static String formatPhoneNumber(String phoneNumber) {
    final digits = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    // Pakistani number format
    if (digits.startsWith('92') && digits.length == 12) {
      return '+92 ${digits.substring(2, 5)} ${digits.substring(5, 12)}';
    }

    // Default format with +
    if (!phoneNumber.startsWith('+')) {
      return '+$phoneNumber';
    }

    return phoneNumber;
  }
}
