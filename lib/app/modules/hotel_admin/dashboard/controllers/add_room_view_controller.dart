import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddRoomController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  final isLoading = false.obs;
  final isAvailable = true.obs;

  // Controllers
  final roomNumber = TextEditingController();
  final roomType = TextEditingController();
  final description = TextEditingController();
  final price = TextEditingController();
  final capacity = TextEditingController();

  // Image
  final Rx<File?> image = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  // Pick image
  Future<void> pickImage() async {
    final XFile? picked =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      image.value = File(picked.path);
    }
  }

  // Upload image
  Future<String?> _uploadImage(String roomId) async {
    if (image.value == null) return null;

    final Uint8List bytes = await image.value!.readAsBytes();
    final userId = _supabase.auth.currentUser!.id;

    final path = '$userId/rooms/$roomId.png';

    await _supabase.storage.from('room-images').uploadBinary(
      path,
      bytes,
      fileOptions: const FileOptions(contentType: 'image/png'),
    );

    return path;
  }

  // Submit room
  Future<void> submitRoom(String hotelId) async {
    try {
      isLoading.value = true;

      final String id = const Uuid().v4();
      final imagePath = await _uploadImage(id);

      await _supabase.from('rooms').insert({
        'id': id,
        'hotel_id': hotelId,
        'room_number': roomNumber.text.trim(),
        'room_type': roomType.text.trim(),
        'description': description.text.trim(),
        'price_per_nig': double.parse(price.text),
        'capacity': int.parse(capacity.text),
        'image_paths': imagePath != null ? [imagePath] : [],
        'is_available': isAvailable.value,
      });

      Get.back();
      Get.snackbar(
        'Success',
        'Room added successfully',
        backgroundColor: AppColors.success,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
