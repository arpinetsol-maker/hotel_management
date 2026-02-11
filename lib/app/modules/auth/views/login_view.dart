import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../core/constants/app_constants.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController(text: 'arpi.netsol@gmail.com');
    final passwordController = TextEditingController(text: '123456');

    return Scaffold(
      backgroundColor: AppColors.adminAccent2,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Logo/Title
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.adminPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to continue',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.adminAccent,
                ),
              ),

              const SizedBox(height: 40),

              // Email Field
              TextField(
                cursorColor: AppColors.adminPrimary,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  fillColor: Colors.transparent,
                  labelStyle: TextStyle(color: AppColors.adminPrimary),
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email, color: AppColors.adminAccent),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide( color:AppColors.adminPrimary)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color:AppColors.adminPrimary))
                ),
              ),

              const SizedBox(height: 20),

              // Password Field
              TextField(
                cursorColor: AppColors.adminPrimary,
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide( color:AppColors.adminPrimary)),
                  fillColor: Colors.transparent,
                  labelText: 'Password',
                  labelStyle: TextStyle(color: AppColors.adminPrimary),
                  hintText: 'Enter your password',
                  prefixIcon: Icon(Icons.lock, color: AppColors.adminAccent),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color:AppColors.adminPrimary))
                ),
                ),


              const SizedBox(height: 10),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.toNamed('/forgot-password'),
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: AppColors.adminAccent),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Login Button
              Obx(() => SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                    controller.signIn(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.adminPrimary,
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Sign In'),
                ),
              )),

              const SizedBox(height: 20),

              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.adminPrimary)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OR', style: TextStyle(color: AppColors.adminPrimary)),
                  ),
                  Expanded(child: Divider(color: AppColors.adminPrimary)),
                ],
              ),

              const SizedBox(height: 20),

              // Sign in with OTP
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: () {
                    controller.signInWithOTP(emailController.text.trim());
                  },
                  icon: Icon(Icons.sms, color: AppColors.adminPrimary),
                  label: Text(
                    'Sign in with OTP',
                    style: TextStyle(color: AppColors.adminPrimary),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.adminPrimary),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  TextButton(
                    onPressed: () => Get.toNamed('/register'),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: AppColors.adminAccent,
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