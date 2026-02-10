import 'package:get/get.dart';

class AdminDashboardController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  // Stats
  final RxInt totalBookings = 0.obs;
  final RxDouble totalRevenue = 0.0.obs;
  final RxInt totalHotels = 0.obs;
  final RxInt totalUsers = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    loadDashboardStats();
  }

  Future<void> loadDashboardStats() async {
    // Load dashboard statistics
    // This would typically fetch from Supabase
    totalBookings.value = 234;
    totalRevenue.value = 450000;
    totalHotels.value = 45;
    totalUsers.value = 1250;
  }
}