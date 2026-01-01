import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mehfilista/features/auth/provider/auth_provider.dart';
import 'package:mehfilista/features/inquiry/models/inquiry_model.dart';
import 'package:mehfilista/features/inquiry/providers/inquiry_provider.dart';
import 'package:mehfilista/features/inquiry/views/inquiry_detail_screen.dart';
import 'package:mehfilista/utils/constants/colors.dart';
import 'package:provider/provider.dart';

class InquiryListScreen extends StatefulWidget {
  const InquiryListScreen({super.key});

  @override
  State<InquiryListScreen> createState() => _InquiryListScreenState();
}

class _InquiryListScreenState extends State<InquiryListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInquiries();
    });
  }

  void _loadInquiries() {
    final authProvider = context.read<AuthProvider>();
    final inquiryProvider = context.read<InquiryProvider>();
    final token = authProvider.token;

    if (token == null) return;

    if (authProvider.isVendor) {
      inquiryProvider.loadVendorInquiries(token);
    } else {
      inquiryProvider.loadMyInquiries(token);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
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
        automaticallyImplyLeading: false,
        title: Text(
          isVendor ? 'Customer Inquiries' : 'My Inquiries',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Responded'),
          ],
        ),
      ),
      body: Consumer<InquiryProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64.sp, color: Colors.grey),
                  SizedBox(height: 16.h),
                  Text(
                    provider.error!,
                    style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: _loadInquiries,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final allInquiries = isVendor
              ? provider.vendorInquiries
              : provider.myInquiries;
          final pendingInquiries = allInquiries
              .where((i) => i.status == InquiryStatus.pending)
              .toList();
          final respondedInquiries = allInquiries
              .where((i) => i.status != InquiryStatus.pending)
              .toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildInquiryList(allInquiries, isVendor),
              _buildInquiryList(pendingInquiries, isVendor),
              _buildInquiryList(respondedInquiries, isVendor),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInquiryList(List<InquiryModel> inquiries, bool isVendor) {
    if (inquiries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              'No inquiries found',
              style: TextStyle(color: Colors.grey, fontSize: 16.sp),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _loadInquiries(),
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: inquiries.length,
        itemBuilder: (context, index) {
          final inquiry = inquiries[index];
          return _InquiryCard(
            inquiry: inquiry,
            isVendor: isVendor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => InquiryDetailScreen(inquiry: inquiry),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _InquiryCard extends StatelessWidget {
  final InquiryModel inquiry;
  final bool isVendor;
  final VoidCallback onTap;

  const _InquiryCard({
    required this.inquiry,
    required this.isVendor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      inquiry.eventType,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  _buildStatusChip(inquiry.status),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14.sp, color: Colors.grey),
                  SizedBox(width: 4.w),
                  Text(
                    inquiry.preferredDate,
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
              if (inquiry.message.isNotEmpty) ...[
                SizedBox(height: 8.h),
                Text(
                  inquiry.message,
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (inquiry.createdAt != null) ...[
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14.sp, color: Colors.grey),
                    SizedBox(width: 4.w),
                    Text(
                      _formatDate(inquiry.createdAt!),
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(InquiryStatus status) {
    Color color;
    String label;

    switch (status) {
      case InquiryStatus.pending:
        color = Colors.orange;
        label = 'Pending';
        break;
      case InquiryStatus.accepted:
        color = Colors.green;
        label = 'Accepted';
        break;
      case InquiryStatus.declined:
        color = Colors.red;
        label = 'Declined';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
