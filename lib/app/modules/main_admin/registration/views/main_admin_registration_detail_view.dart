import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_admin_registration_controller.dart';
import '../../../../core/constants/app_constants.dart';
import 'package:hotel_management/app/data/models/hotel_registration_model.dart';
import 'package:intl/intl.dart';

class MainAdminRegistrationDetailView extends GetView<MainAdminRegistrationController> {
  const MainAdminRegistrationDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HotelRegistrationRequestModel request = Get.arguments;

    return Scaffold(
      backgroundColor: AppColors.adminAccent2,
      appBar: AppBar(
        backgroundColor: AppColors.adminPrimary,
        title: Text('Registration Details'),
        actions: [
          if (request.status == 'pending')
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () => _showActions(request.id),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Badge
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: _getStatusColor(request.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: _getStatusColor(request.status)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_getStatusIcon(request.status),
                        color: _getStatusColor(request.status)),
                    SizedBox(width: 8),
                    Text(
                      request.status.toUpperCase(),
                      style: TextStyle(
                        color: _getStatusColor(request.status),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            // Hotel Information
            _buildSection(
              'Hotel Information',
              [
                _buildDetailRow('Hotel Name', request.hotelName),
                _buildDetailRow('Email', request.hotelEmail),
                _buildDetailRow('Phone', request.hotelPhone),
                if (request.description != null)
                  _buildDetailRow('Description', request.description!),
              ],
            ),

            SizedBox(height: 16),

            // Address
            _buildSection(
              'Address',
              [
                _buildDetailRow('Street', request.address),
                _buildDetailRow('City', request.city),
                _buildDetailRow('State', request.state),
                _buildDetailRow('Country', request.country),
                if (request.postalCode != null)
                  _buildDetailRow('Postal Code', request.postalCode!),
              ],
            ),

            SizedBox(height: 16),

            // Hotel Details
            _buildSection(
              'Hotel Details',
              [
                _buildDetailRow('Total Rooms', request.totalRooms.toString()),
                if (request.starRating != null)
                  _buildDetailRow('Star Rating',
                      '⭐ ' * request.starRating!),
                if (request.taxId != null)
                  _buildDetailRow('Tax ID', request.taxId!),
              ],
            ),

            SizedBox(height: 16),

            // Documents
            _buildSection(
              'Documents',
              [
                if (request.businessLicensePath != null)
                  _buildDocumentRow('Business License', request.businessLicensePath!),
                if (request.ownerIdProofPath != null)
                  _buildDocumentRow('Owner ID Proof', request.ownerIdProofPath!),
              ],
            ),

            SizedBox(height: 16),

            // Submission Info
            _buildSection(
              'Submission Information',
              [
                _buildDetailRow(
                  'Submitted On',
                  DateFormat('dd MMM yyyy, hh:mm a').format(request.createdAt),
                ),
                if (request.reviewedAt != null)
                  _buildDetailRow(
                    'Reviewed On',
                    DateFormat('dd MMM yyyy, hh:mm a').format(request.reviewedAt!),
                  ),
              ],
            ),

            if (request.status == 'rejected' && request.rejectionReason != null) ...[
              SizedBox(height: 16),
              _buildSection(
                'Rejection Details',
                [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      request.rejectionReason!,
                      style: TextStyle(color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ],

            if (request.adminNotes != null) ...[
              SizedBox(height: 16),
              _buildSection(
                'Admin Notes',
                [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.adminAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(request.adminNotes!),
                  ),
                ],
              ),
            ],

            SizedBox(height: 24),

            // Action Buttons (if pending)
            if (request.status == 'pending')
              Obx(() => Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.approveRegistration(request.id),
                      icon: Icon(Icons.check_circle),
                      label: Text('Approve Registration'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.showRejectDialog(request.id),
                      icon: Icon(Icons.cancel),
                      label: Text('Reject Registration'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: BorderSide(color: AppColors.error),
                      ),
                    ),
                  ),
                ],
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.adminPrimary,
            ),
          ),
          SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentRow(String label, String path) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(Icons.description, color: AppColors.adminSecondary),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
                Text(
                  'View Document',
                  style: TextStyle(
                    color: AppColors.adminSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }

  void _showActions(String requestId) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.check_circle, color: AppColors.success),
              title: Text('Approve'),
              onTap: () {
                Get.back();
                controller.approveRegistration(requestId);
              },
            ),
            ListTile(
              leading: Icon(Icons.cancel, color: AppColors.error),
              title: Text('Reject'),
              onTap: () {
                Get.back();
                controller.showRejectDialog(requestId);
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Color(0xFFFFA726);
      case 'approved':
        return AppColors.success;
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }
}