import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mehfilista/features/auth/provider/auth_provider.dart';
import 'package:mehfilista/features/inquiry/models/inquiry_model.dart';
import 'package:mehfilista/features/inquiry/providers/inquiry_provider.dart';
import 'package:mehfilista/utils/constants/colors.dart';
import 'package:provider/provider.dart';

class InquiryDetailScreen extends StatefulWidget {
  final InquiryModel inquiry;

  const InquiryDetailScreen({super.key, required this.inquiry});

  @override
  State<InquiryDetailScreen> createState() => _InquiryDetailScreenState();
}

class _InquiryDetailScreenState extends State<InquiryDetailScreen> {
  final TextEditingController _responseController = TextEditingController();
  bool _isResponding = false;

  @override
  void dispose() {
    _responseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isVendor = authProvider.isVendor;

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Inquiry Details',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            _buildStatusCard(),
            SizedBox(height: 16.h),

            // Event Details Card
            _buildEventDetailsCard(),
            SizedBox(height: 16.h),

            // Message Card
            _buildMessageCard(),
            SizedBox(height: 16.h),

            // Vendor Response (if any)
            if (widget.inquiry.vendorResponse != null &&
                widget.inquiry.vendorResponse!.isNotEmpty)
              _buildVendorResponseCard(),

            // Response Section (for vendors)
            if (isVendor && widget.inquiry.status == InquiryStatus.pending) ...[
              SizedBox(height: 16.h),
              _buildResponseSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            _buildStatusIcon(widget.inquiry.status),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getStatusTitle(widget.inquiry.status),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(widget.inquiry.status),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _getStatusDescription(widget.inquiry.status),
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(InquiryStatus status) {
    IconData icon;
    Color color;

    switch (status) {
      case InquiryStatus.pending:
        icon = Icons.hourglass_empty;
        color = Colors.orange;
        break;
      case InquiryStatus.accepted:
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case InquiryStatus.declined:
        icon = Icons.cancel;
        color = Colors.red;
        break;
    }

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24.sp),
    );
  }

  String _getStatusTitle(InquiryStatus status) {
    switch (status) {
      case InquiryStatus.pending:
        return 'Pending';
      case InquiryStatus.accepted:
        return 'Accepted';
      case InquiryStatus.declined:
        return 'Declined';
    }
  }

  Color _getStatusColor(InquiryStatus status) {
    switch (status) {
      case InquiryStatus.pending:
        return Colors.orange;
      case InquiryStatus.accepted:
        return Colors.green;
      case InquiryStatus.declined:
        return Colors.red;
    }
  }

  String _getStatusDescription(InquiryStatus status) {
    switch (status) {
      case InquiryStatus.pending:
        return 'Waiting for vendor response';
      case InquiryStatus.accepted:
        return 'The vendor has accepted your inquiry';
      case InquiryStatus.declined:
        return 'The vendor has declined your inquiry';
    }
  }

  Widget _buildEventDetailsCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Event Details',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: 16.h),
            _buildDetailRow(
              Icons.event,
              'Event Type',
              widget.inquiry.eventType,
            ),
            SizedBox(height: 12.h),
            _buildDetailRow(
              Icons.calendar_today,
              'Preferred Date',
              widget.inquiry.preferredDate,
            ),
            if (widget.inquiry.vendorName != null) ...[
              SizedBox(height: 12.h),
              _buildDetailRow(
                Icons.store,
                'Vendor',
                widget.inquiry.vendorName!,
              ),
            ],
            if (widget.inquiry.userName != null) ...[
              SizedBox(height: 12.h),
              _buildDetailRow(
                Icons.person,
                'Customer',
                widget.inquiry.userName!,
              ),
            ],
            if (widget.inquiry.createdAt != null) ...[
              SizedBox(height: 12.h),
              _buildDetailRow(
                Icons.access_time,
                'Sent On',
                _formatDateTime(widget.inquiry.createdAt!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: Colors.grey),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Message',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              widget.inquiry.message.isEmpty
                  ? 'No message provided'
                  : widget.inquiry.message,
              style: TextStyle(
                fontSize: 14.sp,
                color: widget.inquiry.message.isEmpty
                    ? Colors.grey
                    : Colors.grey[700],
                fontStyle: widget.inquiry.message.isEmpty
                    ? FontStyle.italic
                    : FontStyle.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVendorResponseCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      color: Colors.blue.shade50,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.reply, size: 20.sp, color: Colors.blue),
                SizedBox(width: 8.w),
                Text(
                  'Vendor Response',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              widget.inquiry.vendorResponse!,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[800]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponseSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Respond to Inquiry',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _responseController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Enter your response...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                contentPadding: EdgeInsets.all(12.w),
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isResponding ? null : () => _respond(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: _isResponding
                        ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Decline'),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isResponding ? null : () => _respond(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: _isResponding
                        ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Accept'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _respond(bool accept) async {
    final response = _responseController.text.trim();
    if (response.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter a response');
      return;
    }

    setState(() => _isResponding = true);

    final authProvider = context.read<AuthProvider>();
    final inquiryProvider = context.read<InquiryProvider>();
    final token = authProvider.token;

    if (token == null) {
      Fluttertoast.showToast(msg: 'Not authenticated');
      setState(() => _isResponding = false);
      return;
    }

    bool success;
    if (accept) {
      success = await inquiryProvider.acceptInquiry(
        token: token,
        inquiryId: widget.inquiry.id,
        vendorResponse: response,
      );
    } else {
      success = await inquiryProvider.declineInquiry(
        token: token,
        inquiryId: widget.inquiry.id,
        vendorResponse: response,
      );
    }

    setState(() => _isResponding = false);

    if (success) {
      Fluttertoast.showToast(
        msg: accept ? 'Inquiry accepted' : 'Inquiry declined',
      );
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: inquiryProvider.error ?? 'Failed to respond');
    }
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
