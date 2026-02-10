import 'package:get/get.dart';
import 'package:hotel_management/app/data/models/food_menu_model.dart';
import 'package:hotel_management/app/data/repositories/food_menu_repository.dart';

class FoodMenuController extends GetxController {
  final FoodMenuRepository _repo = FoodMenuRepository();

  final RxList<FoodMenuModel> menuItems = <FoodMenuModel>[].obs;
  final Rx<FoodMenuModel?> selectedItem = Rx<FoodMenuModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString selectedHotelId = ''.obs;

  Future<void> loadMenuForHotel(String hotelId) async {
    if (hotelId.isEmpty) return;
    try {
      isLoading.value = true;
      selectedHotelId.value = hotelId;
      menuItems.value = await _repo.getAllHotelMenuItems(hotelId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load menu');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addMenuItem(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      final item = await _repo.addMenuItem(data);
      if (item != null) {
        menuItems.add(item);
        Get.snackbar('Success', 'Menu item added');
        Get.back();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add menu item');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateMenuItem(String id, Map<String, dynamic> updates) async {
    try {
      isLoading.value = true;
      final item = await _repo.updateMenuItem(id, updates);
      if (item != null) {
        final i = menuItems.indexWhere((e) => e.id == id);
        if (i >= 0) menuItems[i] = item;
        Get.snackbar('Success', 'Menu item updated');
        Get.back();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update menu item');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteMenuItem(String id) async {
    try {
      isLoading.value = true;
      final ok = await _repo.deleteMenuItem(id);
      if (ok) {
        menuItems.removeWhere((e) => e.id == id);
        Get.snackbar('Success', 'Menu item deleted');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete menu item');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleAvailability(String id, bool available) async {
    try {
      final item = await _repo.toggleAvailability(id, available);
      if (item != null) {
        final i = menuItems.indexWhere((e) => e.id == id);
        if (i >= 0) menuItems[i] = item;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update availability');
    }
  }
}
