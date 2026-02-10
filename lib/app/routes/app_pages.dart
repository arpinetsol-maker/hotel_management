import 'package:get/get.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import 'package:hotel_management/app/modules/auth/views/verify_otp.dart';
import 'package:hotel_management/app/modules/auth/bindings/auth_bindling.dart';
import 'package:hotel_management/app/modules/user/home/user_home.dart';
import 'package:hotel_management/app/modules/auth/bindings/user_home_binding.dart';
import 'package:hotel_management/app/modules/auth/bindings/admin_dashboard_binding.dart';
import 'package:hotel_management/app/modules/main_admin/dashboard/hotel_admin_dashboard_view.dart';
import 'package:hotel_management/app/modules/main_admin/dashboard/add_hotel_view.dart';
import 'package:hotel_management/app/modules/main_admin/dashboard/hotel_registrations_view.dart';
import 'package:hotel_management/app/modules/main_admin/dashboard/food_menu_view.dart';
import 'package:hotel_management/app/modules/main_admin/dashboard/add_menu_item_view.dart';
import 'package:hotel_management/app/modules/main_admin/dashboard/food_orders_admin_view.dart';
import 'package:hotel_management/app/modules/user/notifications/notifications_view.dart';
import 'package:hotel_management/app/modules/user/orders/my_food_orders_view.dart';
import 'package:hotel_management/app/modules/user/registration/hotel_registration_form_view.dart';
import '../modules/hotel_admin/registration/views/hotel_registration_form_view.dart';
import '../modules/hotel_admin/registration/views/hotel_registration_list_view.dart';
import '../modules/hotel_admin/registration/bindings/hotel_registration_binding.dart';
import '../modules/main_admin/registration/views/main_admin_pending_requests_view.dart';
import '../modules/main_admin/registration/views/main_admin_registration_detail_view.dart';
import '../modules/main_admin/registration/bindings/main_admin_registration_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    // Auth Routes
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.VERIFY_OTP,
      page: () => const VerifyOtpView(),
      binding: AuthBinding(),
    ),

    // User Panel Routes
    GetPage(
      name: Routes.USER_HOME,
      page: () => const UserHomeView(),
      binding: UserHomeBinding(),
    ),

    // Admin Panel Routes
    GetPage(
      name: Routes.ADMIN_DASHBOARD,
      page: () => const AdminDashboardView(),
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: Routes.ADMIN_ADD_HOTEL,
      page: () => const AddHotelView(),
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: Routes.ADMIN_REGISTRATIONS,
      page: () => const HotelRegistrationsView(),
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: Routes.ADMIN_FOOD_MENU,
      page: () => const FoodMenuView(),
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: Routes.ADMIN_ADD_MENU_ITEM,
      page: () => const AddMenuItemView(),
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: Routes.ADMIN_FOOD_ORDERS,
      page: () => const FoodOrdersAdminView(),
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: Routes.USER_NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: UserHomeBinding(),
    ),
    GetPage(
      name: Routes.USER_MY_FOOD_ORDERS,
      page: () => const MyFoodOrdersView(),
      binding: UserHomeBinding(),
    ),
    GetPage(
      name: Routes.USER_HOTEL_REGISTRATION,
      page: () => const HotelRegistrationFormView(),
      binding: UserHomeBinding(),
    ),

    // Hotel Admin Panel Routes
    GetPage(
      name: Routes.HOTEL_ADMIN_HOME,
      page: () => const HotelAdminHomeView(),
      binding: HotelAdminBinding(),
    ),
  ];
}
