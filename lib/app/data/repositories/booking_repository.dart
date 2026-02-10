import 'package:hotel_management/app/core/services/supabase_service.dart';
import 'package:hotel_management/app/data/models/booking_model.dart';

class BookingRepository{
  final _supabase= SupabaseService.client;

  //create booking
Future<BookingModel?> createBooking (Map<String,dynamic>bookingData) async{
    try{
      final data={
        ...bookingData,
        'status': 'pending',
        'payment_status': 'pending',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };
      final response =
      await _supabase.from('bookings').insert(data).select().single();

      return BookingModel.fromJson(response);
    } catch (e) {
      print('Create booking error: $e');
      rethrow;
    }
    }
//get user booking
  Future<List<BookingModel>> getUserBooking (String userId) async{
    try {
      final response=await _supabase.from('bookings').select().eq('user_id', userId) .order('created_at', ascending: false);
      return (response as List)
          .map((json) => BookingModel.fromJson(json))
          .toList();
    }catch(e){
      print('Get user bookings error: $e');
      rethrow;
    }
    }
  // Get all bookings (admin)
  Future<List<BookingModel>> getAllBookings({
    int page = 0,
    int pageSize = 20,
  }) async {
    try {
      final response = await _supabase
          .from('bookings')
          .select()
          .order('created_at', ascending: false)
          .range(page * pageSize, (page + 1) * pageSize - 1);

      return (response as List)
          .map((json) => BookingModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Get all bookings error: $e');
      rethrow;
    }
  }

  // Get booking by ID
  Future<BookingModel?> getBookingById(String bookingId) async {
    try {
      final response =
      await _supabase.from('bookings').select().eq('id', bookingId).single();

      return BookingModel.fromJson(response);
    } catch (e) {
      print('Get booking by ID error: $e');
      return null;
    }
  }

  // Update booking status
  Future<BookingModel?> updateBookingStatus(
      String bookingId,
      String status,
      ) async {
    try {
      final response = await _supabase
          .from('bookings')
          .update({
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
      })
          .eq('id', bookingId)
          .select()
          .single();

      return BookingModel.fromJson(response);
    } catch (e) {
      print('Update booking status error: $e');
      rethrow;
    }
  }

  // Update payment status
  Future<BookingModel?> updatePaymentStatus(
      String bookingId,
      String paymentStatus,
      ) async {
    try {
      final response = await _supabase
          .from('bookings')
          .update({
        'payment_status': paymentStatus,
        'updated_at': DateTime.now().toIso8601String(),
      })
          .eq('id', bookingId)
          .select()
          .single();

      return BookingModel.fromJson(response);
    } catch (e) {
      print('Update payment status error: $e');
      rethrow;
    }
  }

  // Cancel booking
  Future<BookingModel?> cancelBooking(String bookingId) async {
    try {
      final response = await _supabase
          .from('bookings')
          .update({
        'status': 'cancelled',
        'updated_at': DateTime.now().toIso8601String(),
      })
          .eq('id', bookingId)
          .select()
          .single();

      return BookingModel.fromJson(response);
    } catch (e) {
      print('Cancel booking error: $e');
      rethrow;
    }
  }

  // Get bookings by hotel (for hotel owner/admin)
  Future<List<BookingModel>> getBookingsByHotel(String hotelId) async {
    try {
      final response = await _supabase
          .from('bookings')
          .select()
          .eq('hotel_id', hotelId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => BookingModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Get bookings by hotel error: $e');
      rethrow;
    }
  }

  // Get upcoming bookings
  Future<List<BookingModel>> getUpcomingBookings(String userId) async {
    try {
      final now = DateTime.now().toIso8601String();
      final response = await _supabase
          .from('bookings')
          .select()
          .eq('user_id', userId)
          .gte('check_in_date', now)
          .eq('status', 'confirmed')
          .order('check_in_date', ascending: true);

      return (response as List)
          .map((json) => BookingModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Get upcoming bookings error: $e');
      rethrow;
    }
  }

  // Get booking history
  Future<List<BookingModel>> getBookingHistory(String userId) async {
    try {
      final now = DateTime.now().toIso8601String();
      final response = await _supabase
          .from('bookings')
          .select()
          .eq('user_id', userId)
          .lt('check_out_date', now)
          .order('check_out_date', ascending: false);

      return (response as List)
          .map((json) => BookingModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Get booking history error: $e');
      rethrow;
    }
  }
}


