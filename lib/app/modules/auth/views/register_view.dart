import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'package:hotel_management/app/core/constants/app_constants.dart';
import 'package:hotel_management/app/routes/app_pages.dart';

/// Registration type: main admin (direct login only), hotel admin, or user.
enum RegistrationType { mainAdmin, hotelAdmin, user }

class RegisterView extends GetView<AuthController> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final phoneController = TextEditingController();
    final selectedType = RegistrationType.user.obs;

    return Scaffold(
      backgroundColor: AppColors.userSecondary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.userPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.userPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose account type and sign up',
                style: TextStyle(fontSize: 16, color: AppColors.grey),
              ),
              const SizedBox(height: 24),

              // Account type: Main Admin | Hotel Admin | User
              Text(
                'Account type',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Column(
                  children: [
                    _TypeChip(
                      label: 'Main Admin',
                      subtitle: 'Direct login only',
                      icon: Icons.admin_panel_settings,
                      value: RegistrationType.mainAdmin,
                      selected:
                          selectedType.value == RegistrationType.mainAdmin,
                      onTap: () =>
                          selectedType.value = RegistrationType.mainAdmin,
                    ),
                    const SizedBox(height: 8),
                    _TypeChip(
                      label: 'Hotel Admin',
                      subtitle: 'Register your hotel',
                      icon: Icons.hotel,
                      value: RegistrationType.hotelAdmin,
                      selected:
                          selectedType.value == RegistrationType.hotelAdmin,
                      onTap: () =>
                          selectedType.value = RegistrationType.hotelAdmin,
                    ),
                    const SizedBox(height: 8),
                    _TypeChip(
                      label: 'User',
                      subtitle: 'Book hotels & order food',
                      icon: Icons.person,
                      value: RegistrationType.user,
                      selected: selectedType.value == RegistrationType.user,
                      onTap: () => selectedType.value = RegistrationType.user,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Main Admin: direct login only (static – no registration form)
              Obx(() {
                if (selectedType.value != RegistrationType.mainAdmin) {
                  return _RegistrationForm(
                    nameController: nameController,
                    emailController: emailController,
                    passwordController: passwordController,
                    confirmPasswordController: confirmPasswordController,
                    phoneController: phoneController,
                    isLoading: controller.isLoading.value,
                    isHotelAdmin:
                        selectedType.value == RegistrationType.hotelAdmin,
                    onRegister: () {
                      if (passwordController.text !=
                          confirmPasswordController.text) {
                        Get.snackbar('Error', 'Passwords do not match');
                        return;
                      }
                      final userType =
                          selectedType.value == RegistrationType.hotelAdmin
                          ? 'hotel_admin'
                          : 'user';
                      controller.signUp(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                        fullName: nameController.text.trim(),
                        phone: phoneController.text.trim().isEmpty
                            ? null
                            : phoneController.text.trim(),
                        userType: userType,
                      );
                    },
                  );
                }
                return _MainAdminDirectLogin();
              }),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: AppColors.userAccent2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final RegistrationType value;
  final bool selected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.userPrimary.withOpacity(0.15)
          : AppColors.userSecondary,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? AppColors.userPrimary
                  : AppColors.grey.withOpacity(0.3),
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: selected ? AppColors.userPrimary : AppColors.grey,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? AppColors.userPrimary
                            : AppColors.black,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: AppColors.grey),
                    ),
                  ],
                ),
              ),
              if (selected)
                Icon(
                  Icons.check_circle,
                  color: AppColors.userPrimary,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MainAdminDirectLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.userAccent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.userAccent2.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.userPrimary, size: 24),
              const SizedBox(width: 8),
              Text(
                'Main Admin',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.userPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Main admin access uses direct login only. There is no public registration for this role.',
            style: TextStyle(color: AppColors.grey, height: 1.4),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Get.offNamed(Routes.LOGIN),
              icon: const Icon(Icons.login),
              label: const Text('Go to Login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.userPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RegistrationForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController phoneController;
  final bool isLoading;
  final bool isHotelAdmin;
  final VoidCallback onRegister;

  const _RegistrationForm({
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.phoneController,
    required this.isLoading,
    required this.isHotelAdmin,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isHotelAdmin)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Register as Hotel Admin. After sign up you can add hotels or submit a hotel registration request.',
              style: TextStyle(fontSize: 13, color: AppColors.grey),
            ),
          ),
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Full Name',
            hintText: 'Enter your full name',
            prefixIcon: Icon(Icons.person, color: AppColors.userPrimary),
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Phone (optional)',
            hintText: 'Enter your phone number',
            prefixIcon: Icon(Icons.phone, color: AppColors.userPrimary),
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'Enter your email',
            prefixIcon: Icon(Icons.email, color: AppColors.userPrimary),
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Enter your password',
            prefixIcon: Icon(Icons.lock, color: AppColors.userPrimary),
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: confirmPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            hintText: 'Re-enter your password',
            prefixIcon: Icon(Icons.lock_outline, color: AppColors.userPrimary),
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: isLoading ? null : onRegister,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.userPrimary,
            ),
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    isHotelAdmin
                        ? 'Create Hotel Admin Account'
                        : 'Create User Account',
                  ),
          ),
        ),
      ],
    );
  }
}
