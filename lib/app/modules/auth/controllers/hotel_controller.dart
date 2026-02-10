import 'package:get/get.dart';
import 'package:hotel_management/app/data/models/hotel_model.dart';
import 'package:hotel_management/app/data/repositories/hotel_repository.dart';
import 'package:hotel_management/app/data/repositories/image_repository.dart';
import 'package:hotel_management/app/core/constants/app_constants.dart';

class HotelController extends GetxController {
  final HotelRepository _hotelRepository = HotelRepository();
  final ImageRepository _imageRepository = ImageRepository();

  final bool onlyApproved;

  HotelController({this.onlyApproved = false});

  final RxList<HotelModel> hotels = <HotelModel>[].obs;
  final RxList<HotelModel> featuredHotels = <HotelModel>[].obs;
  final RxList<HotelModel> searchResults = <HotelModel>[].obs;
  final Rx<HotelModel?> selectedHotel = Rx<HotelModel?>(null);

  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString searchQuery = ''.obs;
  final RxInt currentPage = 0.obs;
  RxList<String> imagePaths = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadHotels();
    loadFeaturedHotels();
  }

  // Load all hotels
  Future<void> loadHotels({bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage.value = 0;
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }

      final newHotels = await _hotelRepository.getAllHotels(
        page: currentPage.value,
        pageSize: AppConstants.pageSize,
        onlyApproved: onlyApproved,
      );

      if (refresh) {
        hotels.value = newHotels;
      } else {
        hotels.addAll(newHotels);
      }

      currentPage.value++;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load hotels');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  // Load featured hotels
  Future<void> loadFeaturedHotels() async {
    try {
      final hotels = await _hotelRepository.getFeaturedHotels(
        onlyApproved: onlyApproved,
      );
      featuredHotels.value = hotels;
    } catch (e) {
      print('Error loading featured hotels: $e');
    }
  }

  // Search hotels
  Future<void> searchHotels(String query) async {
    try {
      searchQuery.value = query;

      if (query.isEmpty) {
        searchResults.clear();
        return;
      }

      isLoading.value = true;
      final results = await _hotelRepository.searchHotels(
        query,
        onlyApproved: onlyApproved,
      );
      searchResults.value = results;
    } catch (e) {
      Get.snackbar('Error', 'Failed to search hotels');
    } finally {
      isLoading.value = false;
    }
  }

  // Get hotels by city
  Future<void> getHotelsByCity(String city) async {
    try {
      isLoading.value = true;
      final cityHotels = await _hotelRepository.getHotelsByCity(
        city,
        onlyApproved: onlyApproved,
      );
      hotels.value = cityHotels;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load hotels');
    } finally {
      isLoading.value = false;
    }
  }

  // Get hotel by ID
  Future<void> getHotelById(String hotelId) async {
    try {
      isLoading.value = true;
      final hotel = await _hotelRepository.getHotelById(hotelId);
      selectedHotel.value = hotel;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load hotel details');
    } finally {
      isLoading.value = false;
    }
  }

  // Get hotel images with signed URLs
  Future<List<String>> getHotelImages(List<String> imagePaths) async {
    try {
      return await _imageRepository.getImageUrls(
        AppConstants.hotelImagesBucket,
        imagePaths,
      );
    } catch (e) {
      return [];
    }
  }

  // Create hotel (Admin only)
  Future<void> createHotel(Map<String, dynamic> hotelData) async {
    try {
      isLoading.value = true;
      final hotel = await _hotelRepository.createHotel(hotelData);

      if (hotel != null) {
        hotels.insert(0, hotel);
        Get.snackbar('Success', 'Hotel created successfully');
        Get.back();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create hotel');
    } finally {
      isLoading.value = false;
    }
  }

  // Update hotel (Admin only)
  Future<void> updateHotel(String hotelId, Map<String, dynamic> updates) async {
    try {
      isLoading.value = true;
      final hotel = await _hotelRepository.updateHotel(hotelId, updates);

      if (hotel != null) {
        final index = hotels.indexWhere((h) => h.id == hotelId);
        if (index != -1) {
          hotels[index] = hotel;
        }
        selectedHotel.value = hotel;
        Get.snackbar('Success', 'Hotel updated successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update hotel');
    } finally {
      isLoading.value = false;
    }
  }

  // Delete hotel (Admin only)
  Future<void> deleteHotel(String hotelId) async {
    try {
      isLoading.value = true;
      final success = await _hotelRepository.deleteHotel(hotelId);

      if (success) {
        hotels.removeWhere((h) => h.id == hotelId);
        Get.snackbar('Success', 'Hotel deleted successfully');
        Get.back();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete hotel');
    } finally {
      isLoading.value = false;
    }
  }

  // Clear search
  void clearSearch() {
    searchQuery.value = '';
    searchResults.clear();
  }
}
