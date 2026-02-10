import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/app/modules/auth/controllers/user_home_controller.dart';
import 'package:hotel_management/app/modules/auth/controllers/hotel_controller.dart';
import 'package:hotel_management/app/modules/auth/views/login_view.dart';
import '../../../core/constants/app_constants.dart';

class UserHomeView extends GetView<UserHomeController> {
  const UserHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hotelController = Get.find<HotelController>();

    return Scaffold(
      backgroundColor: AppColors.userSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.userPrimary,
        title: Text('LuxStay', style: TextStyle(color: AppColors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: AppColors.white),
            onPressed: () { Get.to(() => LoginView());},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => hotelController.loadHotels(refresh: true),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  onChanged: (value) => hotelController.searchHotels(value),
                  decoration: InputDecoration(
                    hintText: 'Search hotels...',
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: AppColors.userPrimary),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Featured Hotels
              Text(
                'Featured Hotels',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.userPrimary,
                ),
              ),

              const SizedBox(height: 16),

              Obx(() {
                if (hotelController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (hotelController.featuredHotels.isEmpty) {
                  return Center(
                    child: Text('No featured hotels found'),
                  );
                }

                return SizedBox(
                  height: 240,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: hotelController.featuredHotels.length,
                    itemBuilder: (context, index) {
                      final hotel = hotelController.featuredHotels[index];
                      return Container(
                        width: 200,
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 120,
                              decoration: BoxDecoration(
                                color: AppColors.userAccent,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.hotel,
                                  size: 48,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    hotel.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on,
                                          size: 14,
                                          color: AppColors.grey
                                      ),
                                      SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          hotel.city,
                                          style: TextStyle(
                                            color: AppColors.grey,
                                            fontSize: 12,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '₹${hotel.pricePerNight}/night',
                                        style: TextStyle(
                                          color: AppColors.userAccent2,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.star,
                                              size: 16,
                                              color: Colors.amber
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            hotel.rating.toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }),

              const SizedBox(height: 24),

              // All Hotels
              Text(
                'All Hotels',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.userPrimary,
                ),
              ),

              const SizedBox(height: 16),

              Obx(() {
                if (hotelController.hotels.isEmpty) {
                  return Center(
                    child: Text('No hotels found'),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: hotelController.hotels.length,
                  itemBuilder: (context, index) {
                    final hotel = hotelController.hotels[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.userAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.hotel,
                            color: AppColors.white,
                          ),
                        ),
                        title: Text(
                          hotel.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Text(
                              '${hotel.city}, ${hotel.state}',
                              style: TextStyle(color: AppColors.grey),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '₹${hotel.pricePerNight}/night',
                              style: TextStyle(
                                color: AppColors.userAccent2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, size: 16, color: Colors.amber),
                            SizedBox(width: 4),
                            Text(
                              hotel.rating.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
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
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.selectedIndex.value,
        onTap: controller.changeTab,
        selectedItemColor: AppColors.userPrimary,
        unselectedItemColor: AppColors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      )),
    );
  }
}