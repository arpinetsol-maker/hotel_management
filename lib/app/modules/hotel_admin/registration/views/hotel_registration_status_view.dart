import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_constants.dart';
import 'package:hotel_management/app/data/models/hotel_registration_model.dart';
import 'package:intl/intl.dart';

class HotelRegistrationStatusView extends StatelessWidget {
  const HotelRegistrationStatusView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HotelRegistrationRequestModel request = Get.arguments;

    return Scaffold(
      backgroundColor: AppColors.userSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.userPrimary,
        title: Text('Registration Status'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatusCard(request),
            SizedBox(height: 16),
            _buildDetailsCard(request),
            if (request.status == 'rejected') ...[
              SizedBox(height: 16),
              _buildRejectionCard(request),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(HotelRegistrationRequestModel request) {
    IconData icon;
    Color color;
    String message;

    switch (request.status) {
      case 'pending':
        icon = Icons.hourglass_empty;
        color = Color(0xFFFFA726);
        message = 'Your registration is under review';
        break;
      case 'approved':
        icon = Icons.check_circle;
        color = AppColors.success;
        message = 'Congratulations! Your hotel is approved';
        break;
      case 'rejected':
        icon = Icons.cancel;
        color = AppColors.error;
        message = 'Your registration was not approved';
        break;
      default:
        icon = Icons.info;
        color = AppColors.grey;
        message = 'Status unknown';
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(icon, size: 80, color: color),
            SizedBox(height: 16),
            Text(
              request.status.toUpperCase(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(HotelRegistrationRequestModel request) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Registration Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildDetailRow('Hotel Name', request.hotelName),
            _buildDetailRow('Location', '${request.city}, ${request.state}'),
            _buildDetailRow('Total Rooms', '${request.totalRooms}'),
            if (request.starRating != null)
              _buildDetailRow('Star Rating', '${request.starRating}'),
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
      ),
    );
  }

  Widget _buildRejectionCard(HotelRegistrationRequestModel request) {
    return Card(
      color: AppColors.error.withOpacity(0.1),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.error_outline, color: AppColors.error),
                SizedBox(width: 8),
                Text(
                  'Rejection Reason',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              request.rejectionReason ?? 'No reason provided',
              style: TextStyle(color: AppColors.error),
            ),
            if (request.adminNotes != null) ...[
              SizedBox(height: 12),
              Divider(),
              SizedBox(height: 12),
              Text('Admin Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(request.adminNotes!),
            ],
          ],
        ),
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
            child: Text(label, style: TextStyle(color: AppColors.grey)),
          ),
          Expanded(
            child: Text(value, style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}