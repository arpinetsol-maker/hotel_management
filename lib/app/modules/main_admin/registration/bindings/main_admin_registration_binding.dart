import 'package:get/get.dart';
import '../controllers/main_admin_registration_controller.dart';

class MainAdminRegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainAdminRegistrationController>(
          () => MainAdminRegistrationController(),
      fenix: true,
    );
  }
}
