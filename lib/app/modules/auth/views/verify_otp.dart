import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../core/constants/app_constants.dart';

class VerifyOtpView extends GetView<AuthController> {
  const VerifyOtpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final otpController = TextEditingController();
    final email = Get.arguments as String;

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
              const SizedBox(height: 40),

              // Title
              Text(
                'Verify OTP',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.userPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter the ${AppConstants.supabaseOtpLength}-digit code sent to\n$email',
                style: TextStyle(fontSize: 16, color: AppColors.grey),
              ),

              const SizedBox(height: 40),

              // OTP Field (Supabase magic link OTP)
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: AppConstants.supabaseOtpLength,
                decoration: InputDecoration(
                  labelText: 'OTP Code',
                  hintText:
                      'Enter ${AppConstants.supabaseOtpLength}-digit code',
                  prefixIcon: Icon(Icons.pin, color: AppColors.userPrimary),
                ),
              ),

              const SizedBox(height: 30),

              // Verify Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            controller.verifyOTP(
                              email: email,
                              token: otpController.text.trim(),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.userPrimary,
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Verify & Continue'),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Resend OTP
              Center(
                child: TextButton(
                  onPressed: () {
                    controller.signInWithOTP(email);
                  },
                  child: Text(
                    'Resend OTP',
                    style: TextStyle(
                      color: AppColors.userAccent2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
