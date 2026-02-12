import 'package:get/get.dart';
import 'package:hotel_management/app/modules/hotel_admin/dashboard/controllers/add_view_controller.dart';

class AddRoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddRoomController>(() => AddRoomController());
  }
}
