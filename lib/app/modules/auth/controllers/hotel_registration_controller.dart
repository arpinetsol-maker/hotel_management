import 'package:get/get.dart';
import 'package:hotel_management/app/core/services/supabase_service.dart';
import 'package:hotel_management/app/data/models/hotel_registration_model.dart';
import 'package:hotel_management/app/data/repositories/hotel_registration_repository.dart';

class HotelRegistrationController extends GetxController {
  final HotelRegistrationRepository _repo = HotelRegistrationRepository();

  final RxList<HotelRegistrationRequestModel> myRegistrations =
      <HotelRegistrationRequestModel>[].obs;
  final RxList<HotelRegistrationRequestModel> pendingRegistrations =
      <HotelRegistrationRequestModel>[].obs;
  final RxList<HotelRegistrationRequestModel> allRegistrations =
      <HotelRegistrationRequestModel>[].obs;
  final RxBool isLoading = false.obs;

  Future<void> loadMyRegistrations() async {
    final uid = SupabaseService.currentUserid;
    if (uid == null) return;
    try {
      isLoading.value = true;
      myRegistrations.value = await _repo.getMyRegistrations(uid);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load registrations');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadPendingRegistrations() async {
    try {
      isLoading.value = true;
      pendingRegistrations.value = await _repo.getPendingRegistrations();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load pending registrations');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadAllRegistrations({String? status}) async {
    try {
      isLoading.value = true;
      allRegistrations.value = await _repo.getAllRegistrations(status: status);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load registrations');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitRegistration(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      final r = await _repo.submitRegistration(data);
      if (r != null) {
        myRegistrations.insert(0, r);
        Get.snackbar('Success', 'Registration request submitted');
        Get.back();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit registration');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> approveRegistration(
    String requestId, {
    String? adminNotes,
  }) async {
    final adminId = SupabaseService.currentUserid;
    if (adminId == null) return;
    try {
      isLoading.value = true;
      final r = await _repo.approveRegistration(
        requestId,
        adminId,
        adminNotes: adminNotes,
      );
      if (r != null) {
        pendingRegistrations.removeWhere((e) => e.id == requestId);
        Get.snackbar('Success', 'Registration approved');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to approve');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> rejectRegistration(
    String requestId,
    String reason, {
    String? adminNotes,
  }) async {
    final adminId = SupabaseService.currentUserid;
    if (adminId == null) return;
    try {
      isLoading.value = true;
      final r = await _repo.rejectRegistration(
        requestId,
        adminId,
        reason,
        adminNotes: adminNotes,
      );
      if (r != null) {
        pendingRegistrations.removeWhere((e) => e.id == requestId);
        Get.snackbar('Success', 'Registration rejected');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to reject');
    } finally {
      isLoading.value = false;
    }
  }
}
