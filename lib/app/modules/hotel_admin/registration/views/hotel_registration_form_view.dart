import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/app/core/constants/app_constants.dart';
import 'package:hotel_management/app/modules/hotel_admin/registration/controllers/hotel_registration_controller.dart';

class HotelRegistrationFormView extends GetView<HotelRegistrationController> {
  const HotelRegistrationFormView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final cityController = TextEditingController();
    final stateController = TextEditingController();
    final countryController = TextEditingController(text: 'India');
    final postalController = TextEditingController();
    final descController = TextEditingController();
    final roomsController = TextEditingController();
    final starController = TextEditingController();
    final websiteController = TextEditingController(); // ✅ NEW

    return Scaffold(
      backgroundColor: AppColors.userSecondary,
      appBar: AppBar(
        title: const Text('Register Your Hotel'),
        backgroundColor: AppColors.userPrimary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: (){
            Get.toNamed('/login');
          },icon: Icon(Icons.logout_outlined),),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ================= HOTEL IMAGE PICKER =================
            Text(
              'Hotel Image (Optional)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Obx(() {
              final File? image = controller.selectedImage.value;
              return GestureDetector(
                onTap: controller.pickHotelImage,
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.userPrimary),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: image == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt,
                          size: 40, color: AppColors.userPrimary),
                      const SizedBox(height: 8),
                      const Text('Tap to upload hotel image'),
                    ],
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      image,
                      fit: BoxFit.none,
                      width: double.infinity,
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 16),

            // ================= BASIC FIELDS =================
            _field(nameController, 'Hotel name', Icons.hotel),
            _field(emailController, 'Hotel email', Icons.email,
                keyboardType: TextInputType.emailAddress),
            _field(phoneController, 'Hotel phone', Icons.phone,
                keyboardType: TextInputType.phone),
            _field(addressController, 'Address', Icons.location_on, maxLines: 2),
            _field(cityController, 'City', Icons.location_city),
            _field(stateController, 'State', Icons.map),
            _field(countryController, 'Country', Icons.public),
            _field(postalController, 'Postal code', Icons.markunread_mailbox),
            _field(descController, 'Description (optional)', Icons.description,
                maxLines: 3),
            _field(roomsController, 'Total rooms', Icons.meeting_room,
                keyboardType: TextInputType.number),
            _field(starController, 'Star rating (optional)', Icons.star,
                keyboardType: TextInputType.number),

            // ================= WEBSITE (OPTIONAL) =================
            _field(
              websiteController,
              'Hotel Website (optional)',
              Icons.link,
              keyboardType: TextInputType.url,
            ),

            const SizedBox(height: 24),

            // ================= SUBMIT BUTTON =================
            Obx(() => SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () {
                  if (nameController.text.trim().isEmpty ||
                      emailController.text.trim().isEmpty ||
                      phoneController.text.trim().isEmpty ||
                      addressController.text.trim().isEmpty ||
                      cityController.text.trim().isEmpty ||
                      stateController.text.trim().isEmpty ||
                      roomsController.text.trim().isEmpty) {
                    Get.snackbar(
                        'Error', 'Fill all required fields');
                    return;
                  }

                  final rooms =
                  int.tryParse(roomsController.text.trim());
                  if (rooms == null || rooms < 1) {
                    Get.snackbar('Error',
                        'Total rooms must be a positive number');
                    return;
                  }

                  controller.submitRegistration({
                    'hotel_name': nameController.text.trim(),
                    'hotel_email': emailController.text.trim(),
                    'hotel_phone': phoneController.text.trim(),
                    'address': addressController.text.trim(),
                    'city': cityController.text.trim(),
                    'state': stateController.text.trim(),
                    'country': countryController.text.trim(),
                    'postal_code':
                    postalController.text.trim().isEmpty
                        ? null
                        : postalController.text.trim(),
                    'description':
                    descController.text.trim().isEmpty
                        ? null
                        : descController.text.trim(),
                    'total_rooms': rooms,
                    'star_rating':
                    int.tryParse(starController.text.trim()),
                    'website_url':
                    websiteController.text.trim(), // ✅ NEW
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.userPrimary,
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit Registration Request'),
              ),
            )),
          ],
        ),
      ),
    );
  }

  // ================= TEXT FIELD WIDGET =================
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
          prefixIcon: Icon(icon, color: AppColors.userPrimary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
