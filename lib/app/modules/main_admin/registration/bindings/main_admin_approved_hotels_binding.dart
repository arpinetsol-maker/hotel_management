import 'package:get/get.dart';
import '../controllers/main_admin_approved_hotels_controller.dart';

class MainAdminApprovedHotelsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainAdminApprovedHotelsController());
  }
}
