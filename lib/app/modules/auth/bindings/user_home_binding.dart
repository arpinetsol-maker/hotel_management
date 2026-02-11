import 'package:get/get.dart';
import '../controllers/user_home_controller.dart';
import 'package:hotel_management/app/modules/auth/controllers/hotel_controller.dart';
import 'package:hotel_management/app/modules/auth/controllers/booking_controller.dart';
import 'package:hotel_management/app/modules/auth/controllers/food_order_controller.dart';
import 'package:hotel_management/app/modules/auth/controllers/notification_controller.dart';

class UserHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserHomeController>(() => UserHomeController());
    Get.lazyPut<HotelController>(() => HotelController());
    Get.lazyPut<BookingController>(() => BookingController());
    Get.lazyPut<FoodOrderController>(() => FoodOrderController());
    Get.lazyPut<NotificationController>(() => NotificationController());
  }
}
