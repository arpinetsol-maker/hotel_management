import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/app/core/constants/app_constants.dart';
import 'package:hotel_management/app/modules/auth/controllers/food_menu_controller.dart';

class AddMenuItemView extends GetView<FoodMenuController> {
  const AddMenuItemView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hotelId = Get.arguments as String? ?? '';
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    final spiceController = TextEditingController();
    var isVegetarian = false.obs;
    var isVegan = false.obs;
    var isGlutenFree = false.obs;
    var isAvailable = true.obs;
    final timesController = TextEditingController(
      text: 'breakfast,lunch,dinner',
    );

    return Scaffold(
      backgroundColor: AppColors.adminAccent2,
      appBar: AppBar(
        title: const Text('Add Menu Item'),
        backgroundColor: AppColors.adminPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _field(nameController, 'Item name', Icons.restaurant),
            _field(
              categoryController,
              'Category (e.g. Main, Dessert)',
              Icons.category,
            ),
            _field(
              descriptionController,
              'Description',
              Icons.description,
              maxLines: 2,
            ),
            _field(
              priceController,
              'Price',
              Icons.currency_rupee,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            _field(
              spiceController,
              'Spice level (mild/medium/hot/extra_hot)',
              Icons.local_fire_department,
            ),
            _field(
              timesController,
              'Available times (comma: breakfast,lunch,dinner)',
              Icons.schedule,
            ),
            const SizedBox(height: 12),
            Obx(
              () => Column(
                children: [
                  CheckboxListTile(
                    value: isVegetarian.value,
                    onChanged: (v) => isVegetarian.value = v ?? false,
                    title: const Text('Vegetarian'),
                  ),
                  CheckboxListTile(
                    value: isVegan.value,
                    onChanged: (v) => isVegan.value = v ?? false,
                    title: const Text('Vegan'),
                  ),
                  CheckboxListTile(
                    value: isGlutenFree.value,
                    onChanged: (v) => isGlutenFree.value = v ?? false,
                    title: const Text('Gluten free'),
                  ),
                  CheckboxListTile(
                    value: isAvailable.value,
                    onChanged: (v) => isAvailable.value = v ?? true,
                    title: const Text('Available'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          if (nameController.text.trim().isEmpty ||
                              categoryController.text.trim().isEmpty ||
                              priceController.text.trim().isEmpty) {
                            Get.snackbar('Error', 'Fill name, category, price');
                            return;
                          }
                          final price = double.tryParse(
                            priceController.text.trim(),
                          );
                          if (price == null) {
                            Get.snackbar('Error', 'Invalid price');
                            return;
                          }
                          final times = timesController.text
                              .split(',')
                              .map((e) => e.trim())
                              .where((e) => e.isNotEmpty)
                              .toList();
                          if (times.isEmpty) times.add('breakfast');

                          controller.addMenuItem({
                            'hotel_id': hotelId,
                            'item_name': nameController.text.trim(),
                            'category': categoryController.text.trim(),
                            'description':
                                descriptionController.text.trim().isEmpty
                                ? null
                                : descriptionController.text.trim(),
                            'price': price,
                            'is_vegetarian': isVegetarian.value,
                            'is_vegan': isVegan.value,
                            'is_gluten_free': isGlutenFree.value,
                            'spice_level': spiceController.text.trim().isEmpty
                                ? null
                                : spiceController.text.trim(),
                            'is_available': isAvailable.value,
                            'available_times': times,
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.adminPrimary,
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Save Item'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String label,
    IconData icon, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
