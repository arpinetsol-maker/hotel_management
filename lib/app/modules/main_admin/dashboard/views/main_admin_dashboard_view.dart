import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/app/core/constants/app_constants.dart';
import 'package:hotel_management/app/modules/main_admin/dashboard/controllers/main_admin_dashboard_controller.dart';

class MainAdminApprovalView
    extends GetView<MainAdminApprovalController> {
  const MainAdminApprovalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.adminAccent2,
      appBar: AppBar(
        title: const Text('Hotel Approval Requests'),
        backgroundColor: AppColors.adminPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchPendingHotels,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.pendingHotels.isEmpty) {
          return const Center(
            child: Text('No pending hotel requests'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.pendingHotels.length,
          itemBuilder: (context, index) {
            final hotel = controller.pendingHotels[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hotel['name'] ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(hotel['city'] ?? ''),
                    Text(hotel['email'] ?? ''),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => controller.approveHotel(
                              hotel['id'],
                            ),
                            icon: const Icon(Icons.check),
                            label: const Text('Approve'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => controller.rejectHotel(
                              hotel['id'],
                            ),
                            icon: const Icon(Icons.close),
                            label: const Text('Reject'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
