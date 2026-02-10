import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/app/core/constants/app_constants.dart';
import 'package:hotel_management/app/data/models/food_menu_model.dart';
import 'package:hotel_management/app/modules/auth/controllers/food_menu_controller.dart';
import 'package:hotel_management/app/routes/app_pages.dart';

class FoodMenuView extends GetView<FoodMenuController> {
  const FoodMenuView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hotelId = Get.arguments as String? ?? '';
    if (hotelId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.loadMenuForHotel(hotelId);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.adminAccent2,
      appBar: AppBar(
        title: const Text('Food Menu'),
        backgroundColor: AppColors.adminPrimary,
        actions: [
          if (hotelId.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () =>
                  Get.toNamed(Routes.ADMIN_ADD_MENU_ITEM, arguments: hotelId),
            ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.menuItems.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.menuItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.restaurant_menu, size: 64, color: AppColors.grey),
                const SizedBox(height: 16),
                Text(
                  hotelId.isEmpty
                      ? 'Select a hotel to view menu'
                      : 'No menu items yet',
                  style: TextStyle(color: AppColors.grey),
                ),
                if (hotelId.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => Get.toNamed(
                      Routes.ADMIN_ADD_MENU_ITEM,
                      arguments: hotelId,
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Item'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.adminPrimary,
                    ),
                  ),
                ],
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.menuItems.length,
          itemBuilder: (context, index) {
            final item = controller.menuItems[index];
            return _MenuItemCard(
              item: item,
              onToggle: () =>
                  controller.toggleAvailability(item.id, !item.isAvailable),
              onDelete: () => controller.deleteMenuItem(item.id),
            );
          },
        );
      }),
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final FoodMenuModel item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _MenuItemCard({
    required this.item,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(
          item.itemName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: item.isAvailable ? null : TextDecoration.lineThrough,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${item.category} • ₹${item.price.toStringAsFixed(0)}'),
            if (item.description != null) Text(item.description!),
            Wrap(
              spacing: 4,
              children: [
                if (item.isVegetarian) const Chip(label: Text('Veg')),
                if (item.isVegan) const Chip(label: Text('Vegan')),
                if (item.spiceLevel != null)
                  Chip(label: Text(item.spiceLevel!)),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                item.isAvailable ? Icons.visibility_off : Icons.visibility,
                size: 20,
              ),
              onPressed: onToggle,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
