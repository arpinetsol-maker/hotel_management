import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/app/core/constants/app_constants.dart';
import 'package:hotel_management/app/data/models/hotel_registration_model.dart';
import 'package:hotel_management/app/modules/auth/controllers/hotel_registration_controller.dart';

class HotelRegistrationsView extends GetView<HotelRegistrationController> {
  const HotelRegistrationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadPendingRegistrations();
    });
    return Scaffold(
      backgroundColor: AppColors.adminAccent2,
      appBar: AppBar(
        title: const Text('Hotel Registration Requests'),
        backgroundColor: AppColors.adminPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.loadPendingRegistrations(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.pendingRegistrations.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.pendingRegistrations.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.hotel, size: 64, color: AppColors.grey),
                const SizedBox(height: 16),
                Text(
                  'No pending registration requests',
                  style: TextStyle(color: AppColors.grey),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.pendingRegistrations.length,
          itemBuilder: (context, index) {
            final r = controller.pendingRegistrations[index];
            return _RegistrationCard(
              model: r,
              onApprove: () => _showApproveDialog(context, r.id),
              onReject: () => _showRejectDialog(context, r.id),
            );
          },
        );
      }),
    );
  }

  void _showApproveDialog(BuildContext context, String requestId) {
    final notesController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('Approve Registration'),
        content: TextField(
          controller: notesController,
          decoration: const InputDecoration(
            labelText: 'Admin notes (optional)',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.approveRegistration(
                requestId,
                adminNotes: notesController.text.trim().isEmpty
                    ? null
                    : notesController.text.trim(),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(BuildContext context, String requestId) {
    final reasonController = TextEditingController();
    final notesController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('Reject Registration'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Rejection reason *',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Admin notes (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.trim().isEmpty) {
                Get.snackbar('Error', 'Please enter rejection reason');
                return;
              }
              Get.back();
              controller.rejectRegistration(
                requestId,
                reasonController.text.trim(),
                adminNotes: notesController.text.trim().isEmpty
                    ? null
                    : notesController.text.trim(),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }
}

class _RegistrationCard extends StatelessWidget {
  final HotelRegistrationRequestModel model;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _RegistrationCard({
    required this.model,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    model.hotelName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text(model.status),
                  backgroundColor: model.status == 'pending'
                      ? Colors.orange.shade100
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('${model.hotelEmail} • ${model.hotelPhone}'),
            Text(
              '${model.address}, ${model.city}, ${model.state}, ${model.country}',
            ),
            if (model.description != null) Text(model.description!),
            Text('Total rooms: ${model.totalRooms}'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onReject,
                  child: Text(
                    'Reject',
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onApprove,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.adminPrimary,
                  ),
                  child: const Text('Approve'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
