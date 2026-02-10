import '../../core/services/supabase_service.dart';
import '../models/food_order_model.dart';

class FoodOrderRepository {
  final _supabase = SupabaseService.client;

  // Create food order
  Future<FoodOrderModel?> createOrder(Map<String, dynamic> orderData) async {
    try {
      final data = {
        ...orderData,
        'status': 'pending',
        'payment_status': 'pending',
        'ordered_at': DateTime.now().toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabase
          .from('food_orders')
          .insert(data)
          .select()
          .single();

      return FoodOrderModel.fromJson(response);
    } catch (e) {
      print('Create food order error: $e');
      rethrow;
    }
  }

  // Get user orders
  Future<List<FoodOrderModel>> getUserOrders(String userId) async {
    try {
      final response = await _supabase
          .from('food_orders')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => FoodOrderModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Get user orders error: $e');
      rethrow;
    }
  }

  // Get hotel orders (Hotel Admin)
  Future<List<FoodOrderModel>> getHotelOrders(String hotelId) async {
    try {
      final response = await _supabase
          .from('food_orders')
          .select()
          .eq('hotel_id', hotelId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => FoodOrderModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Get hotel orders error: $e');
      rethrow;
    }
  }

  // Update order status (Hotel Admin)
  Future<FoodOrderModel?> updateOrderStatus(
      String orderId,
      String status,
      ) async {
    try {
      final updates = {
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (status == 'delivered') {
        updates['delivered_at'] = DateTime.now().toIso8601String();
      }

      final response = await _supabase
          .from('food_orders')
          .update(updates)
          .eq('id', orderId)
          .select()
          .single();

      return FoodOrderModel.fromJson(response);
    } catch (e) {
      print('Update order status error: $e');
      rethrow;
    }
  }

  // Update payment status
  Future<FoodOrderModel?> updatePaymentStatus(
      String orderId,
      String paymentStatus,
      ) async {
    try {
      final response = await _supabase
          .from('food_orders')
          .update({
        'payment_status': paymentStatus,
        'updated_at': DateTime.now().toIso8601String(),
      })
          .eq('id', orderId)
          .select()
          .single();

      return FoodOrderModel.fromJson(response);
    } catch (e) {
      print('Update payment status error: $e');
      rethrow;
    }
  }

  // Cancel order
  Future<FoodOrderModel?> cancelOrder(String orderId) async {
    try {
      final response = await _supabase
          .from('food_orders')
          .update({
        'status': 'cancelled',
        'updated_at': DateTime.now().toIso8601String(),
      })
          .eq('id', orderId)
          .select()
          .single();

      return FoodOrderModel.fromJson(response);
    } catch (e) {
      print('Cancel order error: $e');
      rethrow;
    }
  }

  // Get pending orders for hotel
  Future<List<FoodOrderModel>> getPendingOrders(String hotelId) async {
    try {
      final response = await _supabase
          .from('food_orders')
          .select()
          .eq('hotel_id', hotelId)
          .inFilter('status', ['pending', 'preparing', 'ready'])
          .order('ordered_at', ascending: true);

      return (response as List)
          .map((json) => FoodOrderModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Get pending orders error: $e');
      rethrow;
    }
  }
}