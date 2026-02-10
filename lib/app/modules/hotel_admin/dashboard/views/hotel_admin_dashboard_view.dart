import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/app/core/constants/app_constants.dart';
import '../controllers/hotel_admin_dashboard_controller.dart';

class HotelAdminDashboardView
    extends GetView<HotelAdminDashboardController> {
  const HotelAdminDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.adminAccent2,
      appBar: AppBar(
        title: const Text('Hotel Admin Dashboard'),
        backgroundColor: AppColors.adminPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _dashboardCard(
              icon: Icons.hotel,
              title: 'Add Hotel',
              subtitle: 'Register a new hotel',
              onTap: controller.goToAddHotel,
            ),
            const SizedBox(height: 16),
            _dashboardCard(
              icon: Icons.restaurant_menu,
              title: 'Add Menu Item',
              subtitle: 'Manage food & drinks',
              onTap: () {
                /// Replace with selected hotel id later
                const hotelId = 'HOTEL_ID_HERE';
                controller.goToAddMenu(hotelId);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _dashboardCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.adminPrimary.withOpacity(0.1),
                child: Icon(icon, size: 30, color: AppColors.adminPrimary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
