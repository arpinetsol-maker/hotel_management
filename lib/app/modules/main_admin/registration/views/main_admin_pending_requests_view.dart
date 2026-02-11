import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_admin_registration_controller.dart';
import '../../../../core/constants/app_constants.dart';
import 'package:intl/intl.dart';
import 'package:hotel_management/app/modules/main_admin/registration/views/main_admin_approved_hotels_view.dart';

class MainAdminPendingRequestsView extends GetView<MainAdminRegistrationController> {
  const MainAdminPendingRequestsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.adminAccent2,
      appBar: AppBar(
        backgroundColor: AppColors.adminPrimary,
        title: Row(
          children: [
            const Text('Pending Registrations'),
            const SizedBox(width: 8),
            Obx(
                  () => controller.pendingCount.value > 0
                  ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${controller.pendingCount.value}',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'View Approved Hotels',
            icon: const Icon(Icons.list_alt_rounded,color:Colors.white,),
            onPressed: () {
              Get.toNamed('/main-admin/approved-hotels');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_outlined,color:Colors.white,),
            onPressed: () {
              Get.toNamed('/login');
            },
          ),

        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: AppColors.adminPrimary,));
        }

        if (controller.pendingRequests.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, size: 80, color: AppColors.success),
                SizedBox(height: 16),
                Text(
                  'No Pending Requests',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'All registration requests have been reviewed',
                  style: TextStyle(color: AppColors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadPendingRequests,
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: controller.pendingRequests.length,
            itemBuilder: (context, index) {
              final request = controller.pendingRequests[index];
              return Card(
                margin: EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () => controller.viewRequestDetails(request),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppColors.adminAccent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.hotel, color: Colors.white, size: 30),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    request.hotelName,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${request.city}, ${request.state}',
                                    style: TextStyle(color: AppColors.grey),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                        SizedBox(height: 16),
                        Divider(),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildInfoChip(Icons.meeting_room, '${request.totalRooms} Rooms'),
                            if (request.starRating != null)
                              _buildInfoChip(Icons.star, '${request.starRating} Star'),
                            _buildInfoChip(
                              Icons.calendar_today,
                              DateFormat('dd MMM').format(request.createdAt),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => controller.showRejectDialog(request.id),
                                icon: Icon(Icons.close, size: 18),
                                label: Text('Reject'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.error,
                                  side: BorderSide(color: AppColors.error),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => controller.approveRegistration(request.id),
                                icon: Icon(Icons.check, size: 18),
                                label: Text('Approve'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.success,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.adminAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.adminSecondary),
          SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}