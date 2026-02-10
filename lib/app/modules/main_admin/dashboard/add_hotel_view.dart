import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/app/core/constants/app_constants.dart';
import 'package:hotel_management/app/core/services/supabase_service.dart';
import 'package:hotel_management/app/modules/auth/controllers/hotel_controller.dart';

class AddHotelView extends GetView<HotelController> {
  const AddHotelView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final cityController = TextEditingController();
    final stateController = TextEditingController();
    final countryController = TextEditingController(text: 'India');
    final postalController = TextEditingController();
    final ratingController = TextEditingController(text: '0.0');
    final starRatingController = TextEditingController();
    final priceController = TextEditingController();
    final totalRoomsController = TextEditingController();
    final amenitiesController = TextEditingController();
    final imagePathsController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.adminAccent2,
      appBar: AppBar(
        title: const Text('Add Hotel'),
        backgroundColor: AppColors.adminPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: nameController,
                label: 'Hotel Name',
                icon: Icons.hotel,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: descriptionController,
                label: 'Description',
                icon: Icons.description,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: emailController,
                label: 'Hotel email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: phoneController,
                label: 'Hotel phone',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: addressController,
                label: 'Address',
                icon: Icons.location_on,
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: cityController,
                      label: 'City',
                      icon: Icons.location_city,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: stateController,
                      label: 'State',
                      icon: Icons.map,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: countryController,
                      label: 'Country',
                      icon: Icons.public,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: postalController,
                      label: 'Postal code',
                      icon: Icons.markunread_mailbox,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: priceController,
                      label: 'Price per night',
                      icon: Icons.attach_money,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: totalRoomsController,
                      label: 'Total rooms',
                      icon: Icons.meeting_room,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: ratingController,
                      label: 'Rating (0-5, optional)',
                      icon: Icons.star_rate,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: starRatingController,
                      label: 'Star rating (1-5)',
                      icon: Icons.star,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: amenitiesController,
                label: 'Amenities (comma separated)',
                icon: Icons.checklist,
                hint: 'wifi, breakfast, parking',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: imagePathsController,
                label: 'Image paths (comma separated)',
                icon: Icons.image,
                hint: 'optional image paths or URLs',
              ),
              const SizedBox(height: 24),
              Obx(() {
                final isLoading = controller.isLoading.value;
                return SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: isLoading
                        ? null
                        : () async {
                            final ownerId = SupabaseService.currentUserid;
                            if (ownerId == null) {
                              Get.snackbar(
                                'Error',
                                'You must be logged in as admin to add a hotel.',
                              );
                              return;
                            }

                            if (nameController.text.trim().isEmpty ||
                                descriptionController.text.trim().isEmpty ||
                                emailController.text.trim().isEmpty ||
                                phoneController.text.trim().isEmpty ||
                                addressController.text.trim().isEmpty ||
                                cityController.text.trim().isEmpty ||
                                stateController.text.trim().isEmpty ||
                                countryController.text.trim().isEmpty ||
                                priceController.text.trim().isEmpty ||
                                totalRoomsController.text.trim().isEmpty) {
                              Get.snackbar(
                                'Error',
                                'Please fill all required fields.',
                              );
                              return;
                            }

                            final price = double.tryParse(
                              priceController.text.trim(),
                            );
                            final totalRooms = int.tryParse(
                              totalRoomsController.text.trim(),
                            );
                            final rating = double.tryParse(
                              ratingController.text.trim(),
                            );

                            if (price == null || totalRooms == null) {
                              Get.snackbar(
                                'Error',
                                'Price and total rooms must be valid numbers.',
                              );
                              return;
                            }
                            if (rating != null &&
                                (rating < 0.0 || rating > 5.0)) {
                              Get.snackbar(
                                'Error',
                                'Rating must be between 0 and 5.',
                              );
                              return;
                            }

                            final amenities = amenitiesController.text
                                .split(',')
                                .map((e) => e.trim())
                                .where((e) => e.isNotEmpty)
                                .toList();

                            final imagePaths = imagePathsController.text
                                .split(',')
                                .map((e) => e.trim())
                                .where((e) => e.isNotEmpty)
                                .toList();

                            controller.imagePaths.assignAll(imagePaths);

                            final starRating = int.tryParse(
                              starRatingController.text.trim(),
                            );

                            final hotelData = <String, dynamic>{
                              'name': nameController.text.trim(),
                              'description': descriptionController.text.trim(),
                              'email': emailController.text.trim(),
                              'phone': phoneController.text.trim(),
                              'address': addressController.text.trim(),
                              'city': cityController.text.trim(),
                              'state': stateController.text.trim(),
                              'country': countryController.text.trim(),
                              'postal_code':
                                  postalController.text.trim().isEmpty
                                  ? null
                                  : postalController.text.trim(),
                              'price_per_night': price,
                              'total_rooms': totalRooms,
                              'owner_id': ownerId,
                              if (rating != null) 'rating': rating,
                              if (starRating != null) 'star_rating': starRating,
                              'amenities': amenities,
                              'image_paths': imagePaths,
                              'is_approved': false,
                              'is_active': true,
                              'is_visible': false,
                            };

                            await controller.createHotel(hotelData);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.adminPrimary,
                    ),
                    icon: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save),
                    label: Text(isLoading ? 'Saving...' : 'Save Hotel'),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
    );
  }
}
