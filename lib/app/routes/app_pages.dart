import 'package:get/get.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import 'package:hotel_management/app/modules/auth/views/verify_otp.dart';
import 'package:hotel_management/app/modules/auth/bindings/auth_bindling.dart';
import 'package:hotel_management/app/modules/user/home/user_home.dart';
import 'package:hotel_management/app/modules/auth/bindings/user_home_binding.dart';
import 'package:hotel_management/app/modules/auth/bindings/admin_dashboard_binding.dart';
import 'package:hotel_management/app/modules/user/orders/my_food_orders_view.dart';
import '../modules/main_admin/registration/views/main_admin_pending_requests_view.dart';
import '../modules/main_admin/registration/views/main_admin_registration_detail_view.dart';
import '../modules/main_admin/registration/bindings/main_admin_registration_binding.dart';
import 'package:hotel_management/app/modules/hotel_admin/dashboard/views/hotel_admin_dashboard_view.dart';
import 'package:hotel_management/app/modules/hotel_admin/dashboard/bindings/hotel_admin_dashboard_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    // Auth Routes
    GetPage(
      name: '/hotel-admin/dashboard',
      page: () => const HotelAdminDashboardView(),
      binding: HotelAdminDashboardBinding(),
    ),

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


  ];
}
