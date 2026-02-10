import 'package:get/get.dart';
import 'package:hotel_management/app/modules/main_admin/dashboard/controllers/main_admin_dashboard_controller.dart';

class MainAdminApprovalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainAdminApprovalController>(
          () => MainAdminApprovalController(),
    );
  }
}
