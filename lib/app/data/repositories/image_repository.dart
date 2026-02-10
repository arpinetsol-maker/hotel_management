import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/supabase_service.dart';

class ImageRepository {
  final _picker = ImagePicker();
  final _uuid = const Uuid();

  // Pick image from gallery
  Future<XFile?> pickImageFromGallery() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: AppConstants.imageQuality,
      );
      return image;
    } catch (e) {
      print('Pick image error: $e');
      return null;
    }
  }

  // Pick image from camera
  Future<XFile?> pickImageFromCamera() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: AppConstants.imageQuality,
      );
      return image;
    } catch (e) {
      print('Pick image error: $e');
      return null;
    }
  }

  // // Pick multiple images
  // Future<List<XFile>> pickMultipleImages() async {
  //   try {
  //     final images = await _picker.pickMultipleImages(
  //       maxWidth: 1920,
  //       maxHeight: 1080,
  //       imageQuality: AppConstants.imageQuality,
  //     );
  //     return images;
  //   } catch (e) {
  //     print('Pick multiple images error: $e');
  //     return [];
  //   }
  // }

  // Upload image to Supabase Storage
  Future<String?> uploadImage({
    required XFile image,
    required String bucket,
    String? folder,
  }) async {
    try {
      final bytes = await image.readAsBytes();
      final fileExt = image.path.split('.').last;
      final fileName = '${_uuid.v4()}.$fileExt';
      final filePath = folder != null ? '$folder/$fileName' : fileName;

      final uploadedPath = await SupabaseService.uploadImage(
        bucket: bucket,
        filePath: filePath,
        fileBytes: bytes,
      );

      return uploadedPath;
    } catch (e) {
      print('Upload image error: $e');
      return null;
    }
  }

  // Upload multiple images
  Future<List<String>> uploadMultipleImages({
    required List<XFile> images,
    required String bucket,
    String? folder,
  }) async {
    try {
      final uploadedPaths = <String>[];

      for (final image in images) {
        final path = await uploadImage(
          image: image,
          bucket: bucket,
          folder: folder,
        );
        if (path != null) {
          uploadedPaths.add(path);
        }
      }

      return uploadedPaths;
    } catch (e) {
      print('Upload multiple images error: $e');
      return [];
    }
  }

  // Get signed URL for private image
  Future<String?> getImageUrl(String bucket, String path) async {
    try {
      return await SupabaseService.getSignedUrl(bucket, path);
    } catch (e) {
      print('Get image URL error: $e');
      return null;
    }
  }

  // Get multiple signed URLs
  Future<List<String>> getImageUrls(String bucket, List<String> paths) async {
    try {
      final urls = <String>[];

      for (final path in paths) {
        final url = await SupabaseService.getSignedUrl(bucket, path);
        if (url != null) {
          urls.add(url);
        }
      }

      return urls;
    } catch (e) {
      print('Get image URLs error: $e');
      return [];
    }
  }

  // Delete image
  Future<bool> deleteImage(String bucket, String path) async {
    try {
      return await SupabaseService.deleteImage(bucket, path);
    } catch (e) {
      print('Delete image error: $e');
      return false;
    }
  }

  // Delete multiple images
  Future<bool> deleteMultipleImages(
      String bucket,
      List<String> paths,
      ) async {
    try {
      for (final path in paths) {
        await SupabaseService.deleteImage(bucket, path);
      }
      return true;
    } catch (e) {
      print('Delete multiple images error: $e');
      return false;
    }
  }
}