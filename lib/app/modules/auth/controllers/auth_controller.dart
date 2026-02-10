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

  String _routeForUserType(String? userType) {
    switch (userType) {
      case 'admin':
        return Routes.ADMIN_DASHBOARD;
      case 'hotel_admin':
        return Routes.HOTEL_ADMIN_HOME;
      default:
        return Routes.USER_HOME;
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  //check if user log in or not
  Future<void> checkAuthStatus() async {
    try {
      if (StorageService.isLoggedIn()) {
        final user = await _authRepository.getCurrentUser();
        if (user != null) {
          currentUser.value = user;

          // Navigate based on user type
          if (user.userType == 'main_admin') {
            Get.offAllNamed(Routes.MAIN_ADMIN_DASHBOARD);
          } else if (user.userType == 'hotel_admin') {
            Get.offAllNamed(Routes.HOTEL_ADMIN_DASHBOARD);
          } else {
            Get.offAllNamed(Routes.USER_HOME);
          }
        } else {
          Get.offAllNamed(Routes.LOGIN);
        }
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    } catch (e) {
      Get.offAllNamed(Routes.LOGIN);
    }
  }


  // Sign Up
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

        // Navigate based on user type
        Get.offAllNamed(_routeForUserType(userType));
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // Sign In
  Future<void> signIn({required String email, required String password}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final user = await _authRepository.signIn(
        email: email,
        password: password,
      );

      if (user != null) {
        currentUser.value = user;
        Get.snackbar('Success', 'Logged in successfully');

        // Navigate based on user type
        Get.offAllNamed(
          _routeForUserType(StorageService.getUserType() ?? user.userType),
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Invalid email or password');
    } finally {
      isLoading.value = false;
    }
  }

  //Sign In with OTP
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

  // Verify OTP
  Future<void> verifyOTP({required String email, required String token}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final user = await _authRepository.verifyOTP(email: email, token: token);

      if (user != null) {
        currentUser.value = user;
        Get.snackbar('Success', 'Logged in successfully');

        Get.offAllNamed(
          _routeForUserType(StorageService.getUserType() ?? user.userType),
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Invalid OTP');
    } finally {
      isLoading.value = false;
    }
  }

  // Update Profile
  Future<void> updateProfile({
    String? fullName,
    String? phone,
    String? profileImagePath,
  }) async {
    try {
      isLoading.value = true;

      if (currentUser.value != null) {
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
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile');
    } finally {
      isLoading.value = false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      currentUser.value = null;
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign out');
    }
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    try {
      isLoading.value = true;
      await _authRepository.resetPassword(email);
      Get.snackbar('Success', 'Password reset link sent to your email');
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to send reset link');
    } finally {
      isLoading.value = false;
    }
  }
}
