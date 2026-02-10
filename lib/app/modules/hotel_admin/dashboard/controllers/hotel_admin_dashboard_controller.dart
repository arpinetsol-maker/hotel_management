import 'package:get/get.dart';

class HotelAdminDashboardController extends GetxController {
  /// loading / state flags (extend later)
  final isLoading = false.obs;

  /// navigation helpers
  void goToAddHotel() {
    Get.toNamed('/hotel-admin/add-hotel');
  }

  void goToAddMenu(String hotelId) {
    Get.toNamed(
      '/hotel-admin/add-menu',
      arguments: hotelId,
    );
  }
}
