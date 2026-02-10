import 'package:get/get.dart';
import 'package:hotel_management/app/core/services/supabase_service.dart';
import 'package:hotel_management/app/data/models/notification_model.dart';
import 'package:hotel_management/app/data/repositories/notification_repository.dart';

class NotificationController extends GetxController {
  final NotificationRepository _repo = NotificationRepository();

  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxInt unreadCount = 0.obs;
  final RxBool isLoading = false.obs;

  Future<void> loadNotifications() async {
    final uid = SupabaseService.currentUserid;
    if (uid == null) return;
    try {
      isLoading.value = true;
      notifications.value = await _repo.getUserNotifications(uid);
      unreadCount.value = await _repo.getUnreadCount(uid);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load notifications');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      final n = await _repo.markAsRead(id);
      if (n != null) {
        final i = notifications.indexWhere((e) => e.id == id);
        if (i >= 0) notifications[i] = n;
        if (unreadCount.value > 0) unreadCount.value--;
      }
    } catch (e) {}
  }

  Future<void> markAllAsRead() async {
    final uid = SupabaseService.currentUserid;
    if (uid == null) return;
    try {
      await _repo.markAllAsRead(uid);
      for (var i = 0; i < notifications.length; i++) {
        if (!notifications[i].isRead) {
          notifications[i] = notifications[i].copyWith(isRead: true);
        }
      }
      unreadCount.value = 0;
    } catch (e) {}
  }
}
