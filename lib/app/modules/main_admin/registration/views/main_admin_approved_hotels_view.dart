import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_admin_approved_hotels_controller.dart';
import '../../../../core/constants/app_constants.dart';
import 'package:intl/intl.dart';

class MainAdminApprovedHotelsView
    extends GetView<MainAdminApprovedHotelsController> {
  const MainAdminApprovedHotelsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.adminAccent2,
      appBar: AppBar(
 iconTheme: IconThemeData(color: Colors.white),
        title: const Text('Approved Hotels'),
        backgroundColor: AppColors.adminPrimary,

      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.adminPrimary,));
        }

        if (controller.approvedHotels.isEmpty) {
          return const Center(
            child: Text(
              'No approved hotels found',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadApprovedHotels,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.approvedHotels.length,
            itemBuilder: (context, index) {
              final hotel = controller.approvedHotels[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hotel.hotelName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${hotel.city}, ${hotel.state}',
                        style: TextStyle(color: AppColors.grey),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rooms: ${hotel.totalRooms}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            hotel.reviewedAt != null
                                ? 'Approved on ${DateFormat('dd MMM yyyy').format(hotel.reviewedAt!)}'
                                : 'Approval date not available',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.grey,
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
