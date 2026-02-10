import '../../core/services/supabase_service.dart';
import '../models/food_menu_model.dart';

class FoodMenuRepository {
  final _supabase = SupabaseService.client;

  // Get food menu by hotel ID
  Future<List<FoodMenuModel>> getHotelMenu(String hotelId) async {
    try {
      final response = await _supabase
          .from('food_menu')
          .select()
          .eq('hotel_id', hotelId)
          .eq('is_available', true)
          .order('category');

      return (response as List)
          .map((json) => FoodMenuModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Get hotel menu error: $e');
      rethrow;
    }
  }

  // Get menu by category
  Future<List<FoodMenuModel>> getMenuByCategory(
      String hotelId,
      String category,
      ) async {
    try {
      final response = await _supabase
          .from('food_menu')
          .select()
          .eq('hotel_id', hotelId)
          .eq('category', category)
          .eq('is_available', true);

      return (response as List)
          .map((json) => FoodMenuModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Get menu by category error: $e');
      rethrow;
    }
  }

  // Add menu item (Hotel Admin)
  Future<FoodMenuModel?> addMenuItem(Map<String, dynamic> menuData) async {
    try {
      final data = {
        ...menuData,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabase
          .from('food_menu')
          .insert(data)
          .select()
          .single();

      return FoodMenuModel.fromJson(response);
    } catch (e) {
      print('Add menu item error: $e');
      rethrow;
    }
  }

  // Update menu item (Hotel Admin)
  Future<FoodMenuModel?> updateMenuItem(
      String menuItemId,
      Map<String, dynamic> updates,
      ) async {
    try {
      final data = {
        ...updates,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabase
          .from('food_menu')
          .update(data)
          .eq('id', menuItemId)
          .select()
          .single();

      return FoodMenuModel.fromJson(response);
    } catch (e) {
      print('Update menu item error: $e');
      rethrow;
    }
  }

  // Delete menu item (Hotel Admin)
  Future<bool> deleteMenuItem(String menuItemId) async {
    try {
      await _supabase.from('food_menu').delete().eq('id', menuItemId);
      return true;
    } catch (e) {
      print('Delete menu item error: $e');
      return false;
    }
  }

  // Toggle availability (Hotel Admin)
  Future<FoodMenuModel?> toggleAvailability(
      String menuItemId,
      bool isAvailable,
      ) async {
    try {
      final response = await _supabase
          .from('food_menu')
          .update({
        'is_available': isAvailable,
        'updated_at': DateTime.now().toIso8601String(),
      })
          .eq('id', menuItemId)
          .select()
          .single();

      return FoodMenuModel.fromJson(response);
    } catch (e) {
      print('Toggle availability error: $e');
      rethrow;
    }
  }

  // Get all menu items for hotel admin
  Future<List<FoodMenuModel>> getAllHotelMenuItems(String hotelId) async {
    try {
      final response = await _supabase
          .from('food_menu')
          .select()
          .eq('hotel_id', hotelId)
          .order('category');

      return (response as List)
          .map((json) => FoodMenuModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Get all hotel menu items error: $e');
      rethrow;
    }
  }
}