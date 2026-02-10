import 'package:get/get.dart';
import 'package:hotel_management/app/data/models/booking_model.dart';
import 'package:hotel_management/app/data/repositories/booking_repository.dart';
import 'package:hotel_management/app/modules/auth/controllers/auth_controller.dart';

class BookingController extends GetxController {
  final BookingRepository _bookingRepository = BookingRepository();
  final AuthController _authController = Get.find<AuthController>();

  final RxList<BookingModel> myBookings = <BookingModel>[].obs;
  final RxList<BookingModel> upcomingBookings = <BookingModel>[].obs;
  final RxList<BookingModel> bookingHistory = <BookingModel>[].obs;
  final RxList<BookingModel> allBookings = <BookingModel>[].obs;

  final Rx<BookingModel?> selectedBooking = Rx<BookingModel?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMyBookings();
  }

  // Load user bookings
  Future<void> loadMyBookings() async {
    try {
      final userId = _authController.currentUser.value?.id;
      if (userId == null) return;

      isLoading.value = true;
      final bookings = await _bookingRepository.getUserBooking(userId);
      myBookings.value = bookings;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load bookings');
    } finally {
      isLoading.value = false;
    }
  }

  // Load upcoming bookings
  Future<void> loadUpcomingBookings() async {
    try {
      final userId = _authController.currentUser.value?.id;
      if (userId == null) return;

      isLoading.value = true;
      final bookings = await _bookingRepository.getUpcomingBookings(userId);
      upcomingBookings.value = bookings;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load upcoming bookings');
    } finally {
      isLoading.value = false;
    }
  }

  // Load booking history
  Future<void> loadBookingHistory() async {
    try {
      final userId = _authController.currentUser.value?.id;
      if (userId == null) return;

      isLoading.value = true;
      final bookings = await _bookingRepository.getBookingHistory(userId);
      bookingHistory.value = bookings;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load booking history');
    } finally {
      isLoading.value = false;
    }
  }

  // Create booking
  Future<void> createBooking({
    required String hotelId,
    required String roomId,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required int numberOfGuests,
    required double totalPrice,
  }) async {
    try {
      final userId = _authController.currentUser.value?.id;
      if (userId == null) {
        Get.snackbar('Error', 'Please login to book');
        return;
      }

      isLoading.value = true;

      final bookingData = {
        'user_id': userId,
        'hotel_id': hotelId,
        'room_id': roomId,
        'check_in_date': checkInDate.toIso8601String(),
        'check_out_date': checkOutDate.toIso8601String(),
        'number_of_guests': numberOfGuests,
        'total_price': totalPrice,
      };

      final booking = await _bookingRepository.createBooking(bookingData);

      if (booking != null) {
        myBookings.insert(0, booking);
        Get.snackbar('Success', 'Booking created successfully');
        Get.back();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create booking');
    } finally {
      isLoading.value = false;
    }
  }

  // Get booking by ID
  Future<void> getBookingById(String bookingId) async {
    try {
      isLoading.value = true;
      final booking = await _bookingRepository.getBookingById(bookingId);
      selectedBooking.value = booking;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load booking details');
    } finally {
      isLoading.value = false;
    }
  }

  // Cancel booking
  Future<void> cancelBooking(String bookingId) async {
    try {
      isLoading.value = true;
      final booking = await _bookingRepository.cancelBooking(bookingId);

      if (booking != null) {
        final index = myBookings.indexWhere((b) => b.id == bookingId);
        if (index != -1) {
          myBookings[index] = booking;
        }
        Get.snackbar('Success', 'Booking cancelled successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to cancel booking');
    } finally {
      isLoading.value = false;
    }
  }

  // Admin: Load all bookings
  Future<void> loadAllBookings({int page = 0}) async {
    try {
      isLoading.value = true;
      final bookings = await _bookingRepository.getAllBookings(page: page);

      if (page == 0) {
        allBookings.value = bookings;
      } else {
        allBookings.addAll(bookings);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load bookings');
    } finally {
      isLoading.value = false;
    }
  }

  // Admin: Update booking status
  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      isLoading.value = true;
      final booking = await _bookingRepository.updateBookingStatus(
        bookingId,
        status,
      );

      if (booking != null) {
        final index = allBookings.indexWhere((b) => b.id == bookingId);
        if (index != -1) {
          allBookings[index] = booking;
        }
        Get.snackbar('Success', 'Booking status updated');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update status');
    } finally {
      isLoading.value = false;
    }
  }

  // Admin: Update payment status
  Future<void> updatePaymentStatus(String bookingId, String status) async {
    try {
      isLoading.value = true;
      final booking = await _bookingRepository.updatePaymentStatus(
        bookingId,
        status,
      );

      if (booking != null) {
        final index = allBookings.indexWhere((b) => b.id == bookingId);
        if (index != -1) {
          allBookings[index] = booking;
        }
        Get.snackbar('Success', 'Payment status updated');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update payment status');
    } finally {
      isLoading.value = false;
    }
  }
}