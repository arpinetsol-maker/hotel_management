import '../../core/services/supabase_service.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  final _supabase = SupabaseService.client;

  // Get user notifications
  Future<List<NotificationModel>> getUserNotifications(String userId) async {
    try {
      final response = await _supabase
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Get user notifications error: $e');
      rethrow;
    }
  }

  // Get unread notifications
  Future<List<NotificationModel>> getUnreadNotifications(String userId) async {
    try {
      final response = await _supabase
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .eq('is_read', false)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Get unread notifications error: $e');
      rethrow;
    }
  }

  // Mark notification as read
  Future<NotificationModel?> markAsRead(String notificationId) async {
    try {
      final response = await _supabase
          .from('notifications')
          .update({'is_read': true})
          .eq('id', notificationId)
          .select()
          .single();

      return NotificationModel.fromJson(response);
    } catch (e) {
      print('Mark as read error: $e');
      rethrow;
    }
  }

  // Mark all as read
  Future<void> markAllAsRead(String userId) async {
    try {
      await _supabase
          .from('notifications')
          .update({'is_read': true})
          .eq('user_id', userId)
          .eq('is_read', false);
    } catch (e) {
      print('Mark all as read error: $e');
      rethrow;
    }
  }

  // Delete notification
  Future<bool> deleteNotification(String notificationId) async {
    try {
      await _supabase.from('notifications').delete().eq('id', notificationId);
      return true;
    } catch (e) {
      print('Delete notification error: $e');
      return false;
    }
  }

  // Get unread count
  Future<int> getUnreadCount(String userId) async {
    try {
      final response = await _supabase
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .eq('is_read', false);

      return (response as List).length;
    } catch (e) {
      print('Get unread count error: $e');
      return 0;
    }
  }
}