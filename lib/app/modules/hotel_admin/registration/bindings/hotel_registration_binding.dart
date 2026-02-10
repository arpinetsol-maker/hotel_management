import 'package:get/get.dart';
import '../controllers/hotel_registration_controller.dart';

class HotelRegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HotelRegistrationController>(
          () => HotelRegistrationController(),
    );
  }
}