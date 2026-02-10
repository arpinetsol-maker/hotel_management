import 'package:get/get.dart';
import 'package:hotel_management/app/core/services/supabase_service.dart';
import 'package:hotel_management/app/data/models/food_order_model.dart';
import 'package:hotel_management/app/data/repositories/food_order_repository.dart';

class FoodOrderController extends GetxController {
  final FoodOrderRepository _repo = FoodOrderRepository();

  final RxList<FoodOrderModel> userOrders = <FoodOrderModel>[].obs;
  final RxList<FoodOrderModel> hotelOrders = <FoodOrderModel>[].obs;
  final RxBool isLoading = false.obs;

  Future<void> loadUserOrders() async {
    final uid = SupabaseService.currentUserid;
    if (uid == null) return;
    try {
      isLoading.value = true;
      userOrders.value = await _repo.getUserOrders(uid);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load orders');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadHotelOrders(String hotelId) async {
    try {
      isLoading.value = true;
      hotelOrders.value = await _repo.getHotelOrders(hotelId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load orders');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createOrder(Map<String, dynamic> orderData) async {
    try {
      isLoading.value = true;
      final order = await _repo.createOrder(orderData);
      if (order != null) {
        userOrders.insert(0, order);
        Get.snackbar('Success', 'Order placed');
        Get.back();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to place order');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      isLoading.value = true;
      final order = await _repo.updateOrderStatus(orderId, status);
      if (order != null) {
        final i = hotelOrders.indexWhere((e) => e.id == orderId);
        if (i >= 0) hotelOrders[i] = order;
        Get.snackbar('Success', 'Order status updated');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update status');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      isLoading.value = true;
      final order = await _repo.cancelOrder(orderId);
      if (order != null) {
        final i = userOrders.indexWhere((e) => e.id == orderId);
        if (i >= 0) userOrders[i] = order;
        Get.snackbar('Success', 'Order cancelled');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to cancel order');
    } finally {
      isLoading.value = false;
    }
  }
}
