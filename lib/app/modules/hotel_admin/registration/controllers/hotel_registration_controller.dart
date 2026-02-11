import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

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

  // ---------------- IMAGE STATE ----------------
  final Rx<File?> selectedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  // ===============================
  // LIFECYCLE
  // ===============================
  @override
  void onInit() {
    super.onInit();
    loadMyRequests();
  }

  // ===============================
  // PICK IMAGE (OPTIONAL)
  // ===============================
  Future<void> pickHotelImage() async {
    final XFile? image =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  // ===============================
  // UPLOAD IMAGE (FIXED)
  // ===============================
  Future<String?> _uploadHotelImage() async {
    if (selectedImage.value == null) return null;

    final userId = _supabase.auth.currentUser!.id;

    // Convert file → bytes (IMPORTANT)
    final Uint8List bytes = await selectedImage.value!.readAsBytes();

    // RLS-safe path (matches your policy)
    final String filePath =
        '$userId/hotel_${DateTime.now().millisecondsSinceEpoch}.png';

    await _supabase.storage
        .from('hotel-images')
        .uploadBinary(
      filePath,
      bytes,
      fileOptions: const FileOptions(
        contentType: 'image/png',
      ),
    );

    return filePath; // store only path, NOT URL
  }

  // ===============================
  // LOAD MY REGISTRATIONS
  // ===============================
  Future<void> loadMyRequests() async {
    try {
      isLoading.value = true;

      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final response = await _supabase
          .from('hotel_registration_requests')
          .select()
          .eq('hotel_admin_id', userId)
          .order('created_at', ascending: false);

      final list = (response as List)
          .map((e) => HotelRegistrationRequestModel.fromJson(e))
          .toList();

      myRequests.assignAll(list);

      hasPendingRequest.value =
          list.any((e) => e.status == 'pending');
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
  // SUBMIT REGISTRATION (FINAL)
  // ===============================
  Future<void> submitRegistration(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;

      final imagePath = await _uploadHotelImage();

      await _supabase.from('hotel_registration_requests').insert({
        ...data,
        'hotel_admin_id': _supabase.auth.currentUser!.id,
        'hotel_image_path': imagePath, // optional
        'website_url':
        data['website_url']?.toString().trim().isEmpty == true
            ? null
            : data['website_url'],
        'status': 'pending',
        'created_at': DateTime.now().toIso8601String(),

      }
      );

      selectedImage.value = null;

      Get.snackbar(
        'Submitted',
        'Hotel registration request submitted',
        backgroundColor: AppColors.success,
        colorText: Colors.white,
      );

      await loadMyRequests();
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
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
  // WITHDRAW REGISTRATION
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
