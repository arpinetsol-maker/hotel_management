import 'package:hotel_management/app/core/services/supabase_service.dart';
import 'package:hotel_management/app/data/models/hotel_registration_model.dart';

class HotelRegistrationRepository {
  final _supabase = SupabaseService.client;

  // Submit hotel registration request (Hotel Admin)
  Future<HotelRegistrationRequestModel?> submitRegistration(
    Map<String, dynamic> registrationData,
  ) async {
    try {
      final data = {
        ...registrationData,
        'status': 'pending',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabase
          .from('hotel_registration_requests')
          .insert(data)
          .select()
          .single();

      return HotelRegistrationRequestModel.fromJson(response);
    } catch (e) {
      print('Submit registration error: $e');
      rethrow;
    }
  }

  // Get own registration requests (Hotel Admin)
  Future<List<HotelRegistrationRequestModel>> getMyRegistrations(
    String hotelAdminId,
  ) async {
    try {
      final response = await _supabase
          .from('hotel_registration_requests')
          .select()
          .eq('hotel_admin_id', hotelAdminId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => HotelRegistrationRequestModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Get my registrations error: $e');
      rethrow;
    }
  }

  // Get all pending registrations (Main Admin)
  Future<List<HotelRegistrationRequestModel>> getPendingRegistrations() async {
    try {
      final response = await _supabase
          .from('hotel_registration_requests')
          .select()
          .eq('status', 'pending')
          .order('created_at', ascending: true);

      return (response as List)
          .map((json) => HotelRegistrationRequestModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Get pending registrations error: $e');
      rethrow;
    }
  }

  // Get all registrations (Main Admin)
  Future<List<HotelRegistrationRequestModel>> getAllRegistrations({
    String? status,
  }) async {
    try {
      var query = _supabase.from('hotel_registration_requests').select();

      if (status != null) {
        query = query.eq('status', status);
      }

      final response = await query.order('created_at', ascending: false);

      return (response as List)
          .map((json) => HotelRegistrationRequestModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Get all registrations error: $e');
      rethrow;
    }
  }

  // Approve registration (Main Admin)
  Future<HotelRegistrationRequestModel?> approveRegistration(
    String requestId,
    String mainAdminId, {
    String? adminNotes,
  }) async {
    try {
      final response = await _supabase
          .from('hotel_registration_requests')
          .update({
            'status': 'approved',
            'reviewed_by': mainAdminId,
            'reviewed_at': DateTime.now().toIso8601String(),
            'admin_notes': adminNotes,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', requestId)
          .select()
          .single();

      return HotelRegistrationRequestModel.fromJson(response);
    } catch (e) {
      print('Approve registration error: $e');
      rethrow;
    }
  }

  // Reject registration (Main Admin)
  Future<HotelRegistrationRequestModel?> rejectRegistration(
    String requestId,
    String mainAdminId,
    String rejectionReason, {
    String? adminNotes,
  }) async {
    try {
      final response = await _supabase
          .from('hotel_registration_requests')
          .update({
            'status': 'rejected',
            'reviewed_by': mainAdminId,
            'reviewed_at': DateTime.now().toIso8601String(),
            'rejection_reason': rejectionReason,
            'admin_notes': adminNotes,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', requestId)
          .select()
          .single();

      return HotelRegistrationRequestModel.fromJson(response);
    } catch (e) {
      print('Reject registration error: $e');
      rethrow;
    }
  }

  // Update registration (Hotel Admin - only if pending)
  Future<HotelRegistrationRequestModel?> updateRegistration(
    String requestId,
    Map<String, dynamic> updates,
  ) async {
    try {
      final data = {...updates, 'updated_at': DateTime.now().toIso8601String()};

      final response = await _supabase
          .from('hotel_registration_requests')
          .update(data)
          .eq('id', requestId)
          .select()
          .single();

      return HotelRegistrationRequestModel.fromJson(response);
    } catch (e) {
      print('Update registration error: $e');
      rethrow;
    }
  }

  // Get registration by ID
  Future<HotelRegistrationRequestModel?> getRegistrationById(
    String requestId,
  ) async {
    try {
      final response = await _supabase
          .from('hotel_registration_requests')
          .select()
          .eq('id', requestId)
          .single();

      return HotelRegistrationRequestModel.fromJson(response);
    } catch (e) {
      print('Get registration by ID error: $e');
      return null;
    }
  }
}
