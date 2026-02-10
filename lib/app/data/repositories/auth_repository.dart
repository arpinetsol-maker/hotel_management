import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hotel_management/app/core/services/supabase_service.dart';
import 'package:hotel_management/app/core/services/storage_service.dart';
import 'package:hotel_management/app/data/models/user_model.dart';

class AuthRepository {
  final _supabase = SupabaseService.client;
  static SupabaseService? _client;

  //signup with email & password
  // Profile row is created by DB trigger (handle_new_user) from auth.users + raw_user_meta_data.
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    String userType = 'user',
  }) async {
    try {
      final authResponse = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          if (phone != null && phone.isNotEmpty) 'phone': phone,
          'user_type': userType,
        },
      );
      if (authResponse.user != null) {
        final u = authResponse.user!;
        final meta = u.userMetadata ?? {};
        final now = DateTime.now().toIso8601String();

        // Wait a moment for trigger to complete
        await Future.delayed(const Duration(milliseconds: 500));

        // Check if profile was created by trigger
        var userData = await _supabase
            .from('users')
            .select()
            .eq('id', u.id)
            .maybeSingle();

        // If trigger didn't create the row (e.g., trigger not set up or failed), create it manually
        if (userData == null) {
          print('Trigger did not create user profile, creating manually...');
          try {
            final manualUserData = <String, dynamic>{
              'id': u.id,
              'email': u.email ?? email,
              'full_name': meta['full_name'] ?? fullName,
              'user_type': meta['user_type'] ?? userType,
              'created_at': now,
              'updated_at': now,
            };
            if (phone != null && phone.isNotEmpty) {
              manualUserData['phone'] = meta['phone'] ?? phone;
            }
            await _supabase.from('users').insert(manualUserData);
            userData = manualUserData;
          } catch (e) {
            print('Manual insert also failed: $e');
            // Build from auth user metadata as fallback
            userData = <String, dynamic>{
              'id': u.id,
              'email': u.email ?? email,
              'full_name': meta['full_name'] ?? fullName,
              'phone': meta['phone'] ?? phone,
              'user_type': meta['user_type'] ?? userType,
              'created_at': now,
              'updated_at': now,
            };
          }
        }

        await StorageService.saveUserType(userData['user_type'] ?? userType);
        await StorageService.setLoggedIn(true);
        await StorageService.saveUserData(userData);
        return UserModel.fromJson(userData);
      }
      return null;
    } catch (e) {
      print('signup error:$e');
      rethrow;
    }
  }

  //signin method
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (authResponse.user != null) {
        final userData = await _supabase
            .from('users')
            .select()
            .eq('id', authResponse.user!.id)
            .single();

        await StorageService.saveUserType(userData['user_type'] ?? 'user');
        await StorageService.setLoggedIn(true);
        await StorageService.saveUserData(userData);

        return UserModel.fromJson(userData);
      }
      return null;
    } catch (e) {
      print('signin error: $e');
      rethrow;
    }
  }

  //verify otp
  Future<UserModel?> verifyOTP({
    required String email,
    required String token,
  }) async {
    try {
      final authResponse = await _supabase.auth.verifyOTP(
        type: OtpType.email,
        email: email,
        token: token,
      );
      if (authResponse.user != null) {
        final authUserId = authResponse.user!.id;
        var userData = await _supabase
            .from('users')
            .select()
            .eq('id', authUserId)
            .maybeSingle();

        if (userData == null) {
          // No row for this auth user (e.g. first OTP login or manually created user with different id).
          // Check for existing row by email (manually created user).
          final existingByEmail = await _supabase
              .from('users')
              .select()
              .eq('email', email)
              .maybeSingle();
          if (existingByEmail != null) {
            // Replace manual user row so id matches auth: delete old, insert with auth id and same profile.
            await _supabase.from('users').delete().eq('email', email);
            userData = {
              'id': authUserId,
              'email': email,
              'full_name': existingByEmail['full_name'],
              'phone': existingByEmail['phone'],
              'profile_image_path': existingByEmail['profile_image_path'],
              'user_type': existingByEmail['user_type'] ?? 'user',
              'created_at':
                  existingByEmail['created_at'] ??
                  DateTime.now().toIso8601String(),
            };
            await _supabase.from('users').insert(userData);
          } else {
            userData = {
              'id': authUserId,
              'email': email,
              'user_type': 'user',
              'created_at': DateTime.now().toIso8601String(),
            };
            await _supabase.from('users').insert(userData);
          }
          await StorageService.saveUserType(userData['user_type'] ?? 'user');
          await StorageService.setLoggedIn(true);
          await StorageService.saveUserData(userData);
          return UserModel.fromJson(userData);
        } else {
          await StorageService.saveUserType(userData['user_type'] ?? 'user');
          await StorageService.setLoggedIn(true);
          await StorageService.saveUserData(userData);
          return UserModel.fromJson(userData);
        }
      }
      return null;
    } catch (e) {
      print('Verify OTP error: $e');
      rethrow;
    }
  }

  //GET CURRENT USER
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        final userData = await _supabase
            .from('users')
            .select()
            .eq('id', user.id)
            .single();
        return UserModel.fromJson(userData);
      }
      return null;
    } catch (e) {
      print('Get current user error: $e');
      return null;
    }
  }

  // Update User Profile
  Future<UserModel?> updateProfile({
    required String userId,
    String? fullName,
    String? phone,
    String? profileImagePath,
  }) async {
    try {
      final updates = {
        'full_name': fullName,
        'phone': phone,
        'profile_image_path': profileImagePath,
        'updated_at': DateTime.now().toIso8601String(),
      };
      // Remove null values
      updates.removeWhere((key, value) => value == null);

      await _supabase.from('users').update(updates).eq('id', userId);

      final userData = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      await StorageService.saveUserData(userData);
      return UserModel.fromJson(userData);
    } catch (e) {
      print('Update profile error: $e');
      rethrow;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      await StorageService.clearAll();
    } catch (e) {
      print('Sign out error: $e');
      rethrow;
    }
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      print('Reset password error: $e');
      rethrow;
    }
  }

  // SEND OTP TO EMAIL
  Future<void> signInWithOTP(String email) async {
    try {
      await _supabase.auth.signInWithOtp(email: email);
    } catch (e) {
      print('Send OTP error: $e');
      rethrow;
    }
  }
}
