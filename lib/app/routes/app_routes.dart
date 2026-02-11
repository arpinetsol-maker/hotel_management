part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  // Auth Routes
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const VERIFY_OTP = '/verify-otp';
  static const FORGOT_PASSWORD = '/forgot-password';

  // User Panel Routes
  static const USER_HOME = '/user/home';
  static const HOTEL_DETAIL = '/user/hotel-detail';
  static const BOOKING = '/user/booking';
  static const MY_BOOKINGS = '/user/my-bookings';
  static const PROFILE = '/user/profile';

  // Admin Panel Routes
  static const ADMIN_DASHBOARD = '/admin/dashboard';
  static const ADMIN_HOTELS = '/admin/hotels';
  static const ADMIN_BOOKINGS = '/admin/bookings';
  static const ADMIN_USERS = '/admin/users';
  static const ADMIN_ADD_HOTEL = '/admin/hotels/add';
  static const ADMIN_REGISTRATIONS = '/admin/registrations';
  static const ADMIN_FOOD_MENU = '/admin/food-menu';
  static const ADMIN_ADD_MENU_ITEM = '/admin/menu/add';
  static const ADMIN_FOOD_ORDERS = '/admin/food-orders';
  static const USER_NOTIFICATIONS = '/user/notifications';
  static const USER_MY_FOOD_ORDERS = '/user/my-food-orders';
  static const USER_HOTEL_REGISTRATION = '/user/hotel-registration';

  // Hotel Admin Panel Routes
  static const HOTEL_ADMIN_HOME = '/hotel-admin/home';
  // Hotel Admin Routes
  static const HOTEL_ADMIN_DASHBOARD = '/hotel-admin/dashboard';
  static const HOTEL_ADMIN_REGISTER = '/hotel-admin/register';
  static const HOTEL_ADMIN_REGISTRATIONS = '/hotel-admin/registrations';
  static const HOTEL_ADMIN_REGISTRATION_STATUS = '/hotel-admin/registration-status';
  static const HOTEL_ADMIN_REGISTRATION_FORM ='/hotel-admin/registartion-form';


// Main Admin Routes
  static const MAIN_ADMIN_DASHBOARD = '/main-admin/dashboard';
  static const MAIN_ADMIN_PENDING_REQUESTS = '/main-admin/pending-requests';
  static const MAIN_ADMIN_REGISTRATION_DETAILS = '/main-admin/registration-details';
  static const MAIN_ADMIN_APPROVED_HOTELS ='/main-admin/approved-hotels';
}
