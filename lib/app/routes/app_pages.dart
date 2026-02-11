import 'package:get/get.dart';
import 'package:hotel_management/app/modules/hotel_admin/registration/bindings/hotel_registration_binding.dart';
import 'package:hotel_management/app/modules/main_admin/dashboard/bindings/main_admin_dashboard_binding.dart';
import 'package:hotel_management/app/modules/main_admin/dashboard/views/main_admin_dashboard_view.dart';
import 'package:hotel_management/app/modules/main_admin/registration/bindings/main_admin_approved_hotels_binding.dart';
import 'package:hotel_management/app/modules/main_admin/registration/views/main_admin_approved_hotels_view.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import 'package:hotel_management/app/modules/auth/views/verify_otp.dart';
import 'package:hotel_management/app/modules/auth/bindings/auth_bindling.dart';
import 'package:hotel_management/app/modules/user/home/user_home.dart';
import 'package:hotel_management/app/modules/auth/bindings/user_home_binding.dart';

import 'package:hotel_management/app/modules/user/orders/my_food_orders_view.dart';
import '../modules/main_admin/registration/views/main_admin_pending_requests_view.dart';
import '../modules/main_admin/registration/views/main_admin_registration_detail_view.dart';
import '../modules/main_admin/registration/bindings/main_admin_registration_binding.dart';
import 'package:hotel_management/app/modules/hotel_admin/dashboard/views/hotel_admin_dashboard_view.dart';
import 'package:hotel_management/app/modules/hotel_admin/dashboard/bindings/hotel_admin_dashboard_binding.dart';
import 'package:hotel_management/app/modules/hotel_admin/registration/views/hotel_registration_form_view.dart';
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
// ================= HOTEL ADMIN =================
    GetPage(
      name: Routes.HOTEL_ADMIN_DASHBOARD,
      page: () => const HotelAdminDashboardView(),
      binding: HotelAdminDashboardBinding(),
    ),

    // ================= MAIN ADMIN =================

    /// Pending hotel registration requests
    GetPage(
      name: Routes.MAIN_ADMIN_PENDING_REQUESTS,
      page: () => const MainAdminPendingRequestsView(),
      binding: MainAdminRegistrationBinding(),
    ),

    /// View + approve/reject single registration
    GetPage(
      name: Routes.MAIN_ADMIN_REGISTRATION_DETAILS,
      page: () => const MainAdminRegistrationDetailView(),
      binding: MainAdminRegistrationBinding(),
    ),
    GetPage(
      name: Routes.HOTEL_ADMIN_REGISTRATION_FORM,
      page: () => const HotelRegistrationFormView(),
      binding: HotelRegistrationBinding(),
    ),
    GetPage(
      name: Routes.MAIN_ADMIN_APPROVED_HOTELS,
      page: () => const MainAdminApprovedHotelsView(),
      binding: MainAdminApprovedHotelsBinding()
    ),


  ];
}
