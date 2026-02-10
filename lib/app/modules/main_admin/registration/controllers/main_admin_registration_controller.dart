import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:hotel_management/app/data/models/hotel_registration_model.dart';
import '../../../../core/constants/app_constants.dart';

class MainAdminRegistrationController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ===============================
  // OBSERVABLE STATES
  // ===============================
  final RxBool isLoading = false.obs;
  final RxList<HotelRegistrationRequestModel> pendingRequests =
      <HotelRegistrationRequestModel>[].obs;

  final RxInt pendingCount = 0.obs;

  // ===============================
  // LIFECYCLE
  // ===============================
  @override
  void onInit() {
    super.onInit();
    loadPendingRequests();
  }

  // ===============================
  // FETCH PENDING REQUESTS
  // ===============================
  Future<void> loadPendingRequests() async {
    try {
      isLoading.value = true;

      final response = await _supabase
          .from('hotel_registration_requests')
          .select()
          .eq('status', 'pending')
          .order('created_at', ascending: false);

      final List<HotelRegistrationRequestModel> list =
      (response as List)
          .map((e) => HotelRegistrationRequestModel.fromJson(e))
          .toList();

      pendingRequests.assignAll(list);
      pendingCount.value = list.length;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load pending requests',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ===============================
  // VIEW DETAILS
  // ===============================
  void viewRequestDetails(HotelRegistrationRequestModel request) {
    Get.toNamed(
      '/main-admin/registration-detail',
      arguments: request,
    );
  }

  // ===============================
  // APPROVE REGISTRATION
  // ===============================
  Future<void> approveRegistration(String requestId) async {
    try {
      isLoading.value = true;

      await _supabase
          .from('hotel_registration_requests')
          .update({
        'status': 'approved',
        'reviewed_at': DateTime.now().toIso8601String(),
      })
          .eq('id', requestId);

      // Remove from local list
      pendingRequests.removeWhere((e) => e.id == requestId);
      pendingCount.value = pendingRequests.length;

      Get.back(closeOverlays: true);

      Get.snackbar(
        'Approved',
        'Hotel registration approved successfully',
        backgroundColor: AppColors.success,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to approve registration',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ===============================
  // REJECT DIALOG
  // ===============================
  void showRejectDialog(String requestId) {
    final TextEditingController reasonController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Reject Registration'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please provide a reason for rejection'),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Rejection reason',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            onPressed: () {
              if (reasonController.text.trim().isEmpty) {
                Get.snackbar(
                  'Required',
                  'Please enter a rejection reason',
                  backgroundColor: AppColors.error,
                  colorText: Colors.white,
                );
                return;
              }
              Get.back();
              rejectRegistration(requestId, reasonController.text.trim());
            },
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  // ===============================
  // REJECT REGISTRATION
  // ===============================
  Future<void> rejectRegistration(
      String requestId, String reason) async {
    try {
      isLoading.value = true;

      await _supabase
          .from('hotel_registration_requests')
          .update({
        'status': 'rejected',
        'rejection_reason': reason,
        'reviewed_at': DateTime.now().toIso8601String(),
      })
          .eq('id', requestId);

      pendingRequests.removeWhere((e) => e.id == requestId);
      pendingCount.value = pendingRequests.length;

      Get.back(closeOverlays: true);

      Get.snackbar(
        'Rejected',
        'Hotel registration rejected',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to reject registration',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
