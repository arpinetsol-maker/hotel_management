import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/app/modules/auth/controllers/admin_dashboard_controller.dart';
import 'package:hotel_management/app/modules/auth/controllers/hotel_controller.dart';
import 'package:hotel_management/app/modules/auth/views/login_view.dart';
import 'package:hotel_management/app/routes/app_pages.dart';
import '../../../core/constants/app_constants.dart';

class AdminDashboardView extends GetView<AdminDashboardController> {
  const AdminDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hotelController = Get.find<HotelController>();

    return Scaffold(
      backgroundColor: AppColors.adminAccent2,
      appBar: AppBar(
        backgroundColor: AppColors.adminPrimary,
        title: Text(
          'Hotel Admin Dashboard',
          style: TextStyle(color: AppColors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.app_registration, color: AppColors.white),
            tooltip: 'Registration requests',
            onPressed: () => Get.toNamed(Routes.ADMIN_REGISTRATIONS),
          ),
          IconButton(
            icon: Icon(Icons.notifications, color: AppColors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.person, color: AppColors.white),
            onPressed: () {
              Get.to(() => LoginView());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.adminSecondary, AppColors.adminAccent],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Back, Admin!',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Manage your hotels and bookings',
                          style: TextStyle(
                            color: AppColors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.dashboard,
                    size: 60,
                    color: AppColors.white.withOpacity(0.3),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Stats Grid
            Obx(
              () => GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                childAspectRatio: 1.5,
                children: [
                  _buildStatCard(
                    'Total Bookings',
                    controller.totalBookings.value.toString(),
                    Icons.receipt_long,
                    AppColors.adminSecondary,
                  ),
                  _buildStatCard(
                    'Revenue',
                    '₹${(controller.totalRevenue.value / 1000).toStringAsFixed(0)}K',
                    Icons.attach_money,
                    Colors.green,
                  ),
                  _buildStatCard(
                    'Total Hotels',
                    controller.totalHotels.value.toString(),
                    Icons.hotel,
                    AppColors.adminAccent,
                  ),
                  _buildStatCard(
                    'Active Users',
                    controller.totalUsers.value.toString(),
                    Icons.people,
                    Colors.orange,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Recent Hotels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Hotels',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.adminPrimary,
                  ),
                ),
                TextButton(onPressed: () {}, child: Text('View All')),
              ],
            ),

            const SizedBox(height: 16),

            Obx(() {
              if (hotelController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (hotelController.hotels.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.hotel_outlined,
                        size: 64,
                        color: AppColors.grey,
                      ),
                      SizedBox(height: 16),
                      Text('No hotels yet'),
                      SizedBox(height: 16),
                      Text(
                        'Hotels are created from approved hotel-admin registration requests.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: hotelController.hotels.take(5).length,
                itemBuilder: (context, index) {
                  final hotel = hotelController.hotels[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.adminAccent,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: hotel.imagePaths.isNotEmpty
                              ? Image.network(
                                  hotel.imagePaths.first,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.broken_image,
                                      color: Colors.white,
                                    );
                                  },
                                )
                              : const Icon(Icons.hotel, color: Colors.white),
                        ),
                      ),

                      title: Text(
                        hotel.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('${hotel.city}, ${hotel.state}'),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'menu') {
                            Get.toNamed(
                              Routes.ADMIN_FOOD_MENU,
                              arguments: hotel.id,
                            );
                          } else if (value == 'orders') {
                            Get.toNamed(
                              Routes.ADMIN_FOOD_ORDERS,
                              arguments: hotel.id,
                            );
                          } else if (value == 'edit') {
                            // TODO: Edit hotel
                          } else if (value == 'delete') {
                            hotelController.deleteHotel(hotel.id);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'menu',
                            child: Row(
                              children: [
                                Icon(Icons.restaurant_menu, size: 20),
                                SizedBox(width: 8),
                                Text('Food Menu'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'orders',
                            child: Row(
                              children: [
                                Icon(Icons.receipt_long, size: 20),
                                SizedBox(width: 8),
                                Text('Food Orders'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 20),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 20, color: Colors.red),
                                SizedBox(width: 8),
                                Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed(Routes.ADMIN_REGISTRATIONS);
        },
        backgroundColor: AppColors.adminSecondary,
        icon: Icon(Icons.app_registration),
        label: Text('Registrations'),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Icon(Icons.trending_up, color: Colors.green, size: 20),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.adminPrimary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(color: AppColors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
