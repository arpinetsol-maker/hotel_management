import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import 'package:hotel_management/app/data/models/hotel_registration_model.dart';

class MainAdminApprovedHotelsController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  final RxBool isLoading = false.obs;
  final RxList<HotelRegistrationRequestModel> approvedHotels =
      <HotelRegistrationRequestModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadApprovedHotels();
  }

  Future<void> loadApprovedHotels() async {
    try {
      isLoading.value = true;

      final response = await _supabase
          .from('hotel_registration_requests')
          .select()
          .eq('status', 'approved')
          .order('reviewed_at', ascending: false);

      final list = (response as List)
          .map((e) => HotelRegistrationRequestModel.fromJson(e))
          .toList();

      approvedHotels.assignAll(list);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load approved hotels',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
