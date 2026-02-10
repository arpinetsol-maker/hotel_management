import 'package:get/get.dart';
import '../controllers/hotel_admin_dashboard_controller.dart';

class HotelAdminDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HotelAdminDashboardController>(
          () => HotelAdminDashboardController(),
    );
  }
}
