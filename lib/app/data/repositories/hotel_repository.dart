import 'package:hotel_management/app/core/services/supabase_service.dart';
import 'package:hotel_management/app/data/models/hotel_model.dart';

class HotelRepository {
  final _supabase = SupabaseService.client;

  // Get all hotels (with pagination)
  Future<List<HotelModel>> getAllHotels({
    int page = 0,
    int pageSize = 20,
    bool onlyApproved = false,
  }) async {
    try {
      var query = _supabase.from('hotels').select();
      if (onlyApproved) {
        query = query
            .eq('is_approved', true)
            .eq('is_visible', true)
            .eq('is_active', true);
      }
      final response = await query
          .order('created_at', ascending: false)
          .range(page * pageSize, (page + 1) * pageSize - 1);

      return (response as List)
          .map((json) => HotelModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Get all hotels error: $e');
      rethrow;
    }
  }

  // Get hotel by ID
  Future<HotelModel?> getHotelById(String hotelId) async {
    try {
      final response = await _supabase
          .from('hotels')
          .select()
          .eq('id', hotelId)
          .single();

      return HotelModel.fromJson(response);
    } catch (e) {
      print('Get hotel by ID error: $e');
      return null;
    }
  }

  // Search hotels
  Future<List<HotelModel>> searchHotels(
    String query, {
    bool onlyApproved = false,
  }) async {
    try {
      var q = _supabase
          .from('hotels')
          .select()
          .or('name.ilike.%$query%,city.ilike.%$query%,state.ilike.%$query%');
      if (onlyApproved) {
        q = q
            .eq('is_approved', true)
            .eq('is_visible', true)
            .eq('is_active', true);
      }
      final response = await q.order('rating', ascending: false);

      return (response as List)
          .map((json) => HotelModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Search hotels error: $e');
      rethrow;
    }
  }

  // Filter hotels by city
  Future<List<HotelModel>> getHotelsByCity(
    String city, {
    bool onlyApproved = false,
  }) async {
    try {
      var q = _supabase.from('hotels').select().eq('city', city);
      if (onlyApproved) {
        q = q
            .eq('is_approved', true)
            .eq('is_visible', true)
            .eq('is_active', true);
      }
      final response = await q.order('rating', ascending: false);

      return (response as List)
          .map((json) => HotelModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Get hotels by city error: $e');
      rethrow;
    }
  }

  // Get hotels by owner (for admin)
  Future<List<HotelModel>> getHotelsByOwner(String ownerId) async {
    try {
      final response = await _supabase
          .from('hotels')
          .select()
          .eq('owner_id', ownerId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => HotelModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Get hotels by owner error: $e');
      rethrow;
    }
  }

  // Create hotel (admin only)
  Future<HotelModel?> createHotel(Map<String, dynamic> hotelData) async {
    try {
      final data = {
        ...hotelData,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabase
          .from('hotels')
          .insert(data)
          .select()
          .single();

      return HotelModel.fromJson(response);
    } catch (e) {
      print('Create hotel error: $e');
      rethrow;
    }
  }

  // Update hotel (admin only)
  Future<HotelModel?> updateHotel(
    String hotelId,
    Map<String, dynamic> updates,
  ) async {
    try {
      final data = {...updates, 'updated_at': DateTime.now().toIso8601String()};

      final response = await _supabase
          .from('hotels')
          .update(data)
          .eq('id', hotelId)
          .select()
          .single();

      return HotelModel.fromJson(response);
    } catch (e) {
      print('Update hotel error: $e');
      rethrow;
    }
  }

  // Delete hotel (admin only)
  Future<bool> deleteHotel(String hotelId) async {
    try {
      await _supabase.from('hotels').delete().eq('id', hotelId);
      return true;
    } catch (e) {
      print('Delete hotel error: $e');
      return false;
    }
  }

  // Get featured hotels
  Future<List<HotelModel>> getFeaturedHotels({
    bool onlyApproved = false,
  }) async {
    try {
      var q = _supabase.from('hotels').select().gte('rating', 4.5);
      if (onlyApproved) {
        q = q
            .eq('is_approved', true)
            .eq('is_visible', true)
            .eq('is_active', true);
      }
      final response = await q.order('rating', ascending: false).limit(10);

      return (response as List)
          .map((json) => HotelModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Get featured hotels error: $e');
      rethrow;
    }
  }

  Future<HotelModel?> getHotelByRegistrationRequestId(String requestId) async {
    try {
      final response = await _supabase
          .from('hotels')
          .select()
          .eq('registration_request_id', requestId)
          .maybeSingle();
      if (response == null) return null;
      return HotelModel.fromJson(response);
    } catch (e) {
      print('Get hotel by registration request error: $e');
      return null;
    }
  }
}
