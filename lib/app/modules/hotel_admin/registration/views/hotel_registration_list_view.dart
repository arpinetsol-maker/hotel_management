import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hotel_registration_controller.dart';
import '../../../../core/constants/app_constants.dart';
import 'package:intl/intl.dart';

class HotelRegistrationListView extends GetView<HotelRegistrationController> {
  const HotelRegistrationListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.userSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.userPrimary,
        title: Text('My Registrations'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.myRequests.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.hotel_outlined, size: 80, color: AppColors.grey),
                SizedBox(height: 16),
                Text('No registrations yet',
                    style: TextStyle(fontSize: 18, color: AppColors.grey)),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => Get.toNamed('/hotel-admin/register'),
                  icon: Icon(Icons.add),
                  label: Text('Register Hotel'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.userPrimary,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadMyRequests,
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: controller.myRequests.length,
            itemBuilder: (context, index) {
              final request = controller.myRequests[index];
              Color statusColor = request.status == 'approved'
                  ? AppColors.success
                  : request.status == 'rejected'
                  ? AppColors.error
                  : Color(0xFFFFA726);

              return Card(
                margin: EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.hotel, color: AppColors.userPrimary, size: 32),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(request.hotelName,
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                Text('${request.city}, ${request.state}',
                                    style: TextStyle(color: AppColors.grey)),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              request.status.toUpperCase(),
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Divider(),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.meeting_room, size: 16, color: AppColors.grey),
                              SizedBox(width: 4),
                              Text('${request.totalRooms} Rooms',
                                  style: TextStyle(fontSize: 12, color: AppColors.grey)),
                            ],
                          ),
                          if (request.starRating != null)
                            Row(
                              children: [
                                Icon(Icons.star, size: 16, color: Colors.amber),
                                SizedBox(width: 4),
                                Text('${request.starRating} Star',
                                    style: TextStyle(fontSize: 12, color: AppColors.grey)),
                              ],
                            ),
                          Text(DateFormat('dd MMM yyyy').format(request.createdAt),
                              style: TextStyle(fontSize: 12, color: AppColors.grey)),
                        ],
                      ),
                      if (request.status == 'rejected' && request.rejectionReason != null) ...[
                        SizedBox(height: 12),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: AppColors.error, size: 20),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(request.rejectionReason!,
                                    style: TextStyle(color: AppColors.error, fontSize: 12)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    floatingActionButton: Obx(() {
    if (controller.isLoading.value ||
    controller.hasPendingRequest.value) {
    return const SizedBox.shrink();
    }

    return FloatingActionButton.extended(
    onPressed: () => Get.toNamed('/hotel-admin/register'),
    backgroundColor: AppColors.userPrimary,
    icon: const Icon(Icons.add),
    label: const Text('New Registration'),
    );
    }),);
  }
}