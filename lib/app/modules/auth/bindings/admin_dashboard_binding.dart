import 'package:get/get.dart';
import '../controllers/admin_dashboard_controller.dart';
import 'package:hotel_management/app/modules/auth/controllers/hotel_controller.dart';
import 'package:hotel_management/app/modules/auth/controllers/booking_controller.dart';
import 'package:hotel_management/app/modules/auth/controllers/food_menu_controller.dart';
import 'package:hotel_management/app/modules/auth/controllers/food_order_controller.dart';
import 'package:hotel_management/app/modules/auth/controllers/hotel_registration_controller.dart';

class AdminDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminDashboardController>(() => AdminDashboardController());
    Get.lazyPut<HotelController>(() => HotelController());
    Get.lazyPut<BookingController>(() => BookingController());
    Get.lazyPut<FoodMenuController>(() => FoodMenuController());
    Get.lazyPut<FoodOrderController>(() => FoodOrderController());
    Get.lazyPut<HotelRegistrationController>(
      () => HotelRegistrationController(),
    );
  }
}
