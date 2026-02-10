import 'package:get/get.dart';
import 'package:hotel_management/app/data/repositories/auth_repository.dart';
import 'package:hotel_management/app/data/models/user_model.dart';
import 'package:hotel_management/app/core/services/storage_service.dart';
import 'package:hotel_management/app/routes/app_pages.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  /// 🔴 STATIC MAIN ADMIN CREDENTIALS
  static const String _mainAdminEmail = 'arpi.netsol@gmail.com';
  static const String _mainAdminPassword = '123456';

  /// Route resolver
  String _routeForUserType(String? userType) {
    switch (userType) {
      case 'admin':
        return Routes.ADMIN_DASHBOARD;
      case 'hotel_admin':
        return Routes.HOTEL_ADMIN_DASHBOARD;
      case 'main_admin':
        return Routes.MAIN_ADMIN_PENDING_REQUESTS;
      default:
        return Routes.USER_HOME;
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  // ✅ CHECK AUTH STATUS (AUTO LOGIN)
  Future<void> checkAuthStatus() async {
    try {
      if (!StorageService.isLoggedIn()) {
        Get.offAllNamed(Routes.LOGIN);
        return;
      }

      final user = await _authRepository.getCurrentUser();
      if (user == null) {
        Get.offAllNamed(Routes.LOGIN);
        return;
      }

      currentUser.value = user;

      final storedType = StorageService.getUserType();
      Get.offAllNamed(_routeForUserType(storedType ?? user.userType));
    } catch (_) {
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  // ✅ SIGN UP
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    String userType = 'user',
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final user = await _authRepository.signUp(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
        userType: userType,
      );

      if (user != null) {
        currentUser.value = user;
        Get.snackbar('Success', 'Account created successfully');
        Get.offAllNamed(_routeForUserType(userType));
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ SIGN IN (UPDATED)
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      /// 🔴 MAIN ADMIN STATIC LOGIN
      if (email == _mainAdminEmail && password == _mainAdminPassword) {
        StorageService.setLoggedIn(true);
        StorageService.saveUserType('main_admin');

        Get.offAllNamed(Routes.MAIN_ADMIN_PENDING_REQUESTS);
        return;
      }

      /// 🔵 NORMAL USERS
      final user = await _authRepository.signIn(
        email: email,
        password: password,
      );

      if (user == null) {
        Get.snackbar('Error', 'Invalid email or password');
        return;
      }

      currentUser.value = user;

      final userType =
          StorageService.getUserType() ?? user.userType;

      Get.snackbar('Success', 'Logged in successfully');
      Get.offAllNamed(_routeForUserType(userType));
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Invalid email or password');
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ OTP SIGN IN
  Future<void> signInWithOTP(String email) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _authRepository.signInWithOTP(email);
      Get.snackbar('Success', 'OTP sent to your email');
      Get.toNamed(Routes.VERIFY_OTP, arguments: email);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ VERIFY OTP
  Future<void> verifyOTP({
    required String email,
    required String token,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final user =
      await _authRepository.verifyOTP(email: email, token: token);

      if (user != null) {
        currentUser.value = user;

        final userType =
            StorageService.getUserType() ?? user.userType;

        Get.snackbar('Success', 'Logged in successfully');
        Get.offAllNamed(_routeForUserType(userType));
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Invalid OTP');
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ UPDATE PROFILE
  Future<void> updateProfile({
    String? fullName,
    String? phone,
    String? profileImagePath,
  }) async {
    try {
      isLoading.value = true;

      if (currentUser.value == null) return;

      final updatedUser = await _authRepository.updateProfile(
        userId: currentUser.value!.id,
        fullName: fullName,
        phone: phone,
        profileImagePath: profileImagePath,
      );

      if (updatedUser != null) {
        currentUser.value = updatedUser;
        Get.snackbar('Success', 'Profile updated successfully');
      }
    } catch (_) {
      Get.snackbar('Error', 'Failed to update profile');
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ SIGN OUT
  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      currentUser.value = null;
      StorageService.clearAll();
      Get.offAllNamed(Routes.LOGIN);
    } catch (_) {
      Get.snackbar('Error', 'Failed to sign out');
    }
  }

  // ✅ RESET PASSWORD
  Future<void> resetPassword(String email) async {
    try {
      isLoading.value = true;
      await _authRepository.resetPassword(email);
      Get.snackbar('Success', 'Password reset link sent');
      Get.back();
    } catch (_) {
      Get.snackbar('Error', 'Failed to send reset link');
    } finally {
      isLoading.value = false;
    }
  }
}
