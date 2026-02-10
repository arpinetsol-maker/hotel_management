import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import 'package:hotel_management/app/data/models/hotel_registration_model.dart';

class HotelRegistrationController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ===============================
  // STATE
  // ===============================
  final RxBool isLoading = false.obs;
  final RxList<HotelRegistrationRequestModel> myRequests =
      <HotelRegistrationRequestModel>[].obs;

  final RxBool hasPendingRequest = false.obs;

  // ===============================
  // LIFECYCLE
  // ===============================
  @override
  void onInit() {
    super.onInit();
    loadMyRequests();
  }

  // ===============================
  // LOAD USER REGISTRATIONS
  // ===============================
  Future<void> loadMyRequests() async {
    try {
      isLoading.value = true;

      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final response = await _supabase
          .from('hotel_registration_requests')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final List<HotelRegistrationRequestModel> list =
      (response as List)
          .map((e) => HotelRegistrationRequestModel.fromJson(e))
          .toList();

      myRequests.assignAll(list);

      // Check pending request
      hasPendingRequest.value =
          list.any((element) => element.status == 'pending');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load registrations',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ===============================
  // OPEN STATUS VIEW
  // ===============================
  void openStatus(HotelRegistrationRequestModel request) {
    Get.toNamed(
      '/hotel-admin/registration-status',
      arguments: request,
    );
  }

  // ===============================
  // DELETE / WITHDRAW (OPTIONAL)
  // ===============================
  Future<void> withdrawRegistration(String requestId) async {
    try {
      isLoading.value = true;

      await _supabase
          .from('hotel_registration_requests')
          .delete()
          .eq('id', requestId);

      myRequests.removeWhere((e) => e.id == requestId);
      hasPendingRequest.value =
          myRequests.any((e) => e.status == 'pending');

      Get.snackbar(
        'Withdrawn',
        'Registration withdrawn successfully',
        backgroundColor: AppColors.success,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to withdraw registration',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
