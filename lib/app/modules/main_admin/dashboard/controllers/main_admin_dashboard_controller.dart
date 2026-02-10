import 'package:get/get.dart';
import 'package:hotel_management/app/core/services/supabase_service.dart';

class MainAdminApprovalController extends GetxController {
  final isLoading = false.obs;
  final pendingHotels = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPendingHotels();
  }

  /// Fetch hotels waiting for approval
  Future<void> fetchPendingHotels() async {
    try {
      isLoading.value = true;

      final res = await SupabaseService.client
          .from('hotels')
          .select()
          .eq('is_approved', false)
          .order('created_at', ascending: false);

      pendingHotels.assignAll(List<Map<String, dynamic>>.from(res));
    } catch (e) {
      Get.snackbar('Error', 'Failed to load hotel requests');
    } finally {
      isLoading.value = false;
    }
  }

  /// Approve hotel
  Future<void> approveHotel(String hotelId) async {
    try {
      await SupabaseService.client
          .from('hotels')
          .update({
        'is_approved': true,
        'is_visible': true,
        'is_active': true,
      })
          .eq('id', hotelId);

      pendingHotels.removeWhere((h) => h['id'] == hotelId);

      Get.snackbar('Approved', 'Hotel approved successfully');
    } catch (e) {
      Get.snackbar('Error', 'Approval failed');
    }
  }

  /// Reject hotel
  Future<void> rejectHotel(String hotelId) async {
    try {
      await SupabaseService.client
          .from('hotels')
          .update({
        'is_active': false,
      })
          .eq('id', hotelId);

      pendingHotels.removeWhere((h) => h['id'] == hotelId);

      Get.snackbar('Rejected', 'Hotel rejected');
    } catch (e) {
      Get.snackbar('Error', 'Rejection failed');
    }
  }
}
