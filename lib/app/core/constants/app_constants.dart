import 'package:flutter/material.dart';

class AppColors {
  // User Panel Colors
  static const Color userPrimary = Color(0xFFA8DF8E);
  static const Color userSecondary = Color(0xFFF0FFDF);
  static const Color userAccent = Color(0xFFFFD8DF);
  static const Color userAccent2 = Color(0xFFFFAAB8);

  // Admin Panel Colors
  static const Color adminPrimary = Color(0xFF0C2C55);
  static const Color adminSecondary = Color(0xFF296374);
  static const Color adminAccent = Color(0xFF629FAD);
  static const Color adminAccent2 = Color(0xFFEDEDCE);

  // Common Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color error = Color(0xFFE74C3C);
  static const Color success = Color(0xFF27AE60);
  static const Color warning = Color(0xFFF39C12);
}

class AppConstants {
  static const String appName = 'hotel_management';

  // Add your Supabase credentials here
  static const String supabaseUrl = 'https://fynuscybnasplkudtvqn.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ5bnVzY3libmFzcGxrdWR0dnFuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzAwMjE5NTUsImV4cCI6MjA4NTU5Nzk1NX0.OACfbupsZUVsVgdAEwp-YxLglEVZCTAsf1rbCGUChIw';

  // Storage Buckets
  static const String hotelImagesBucket = 'hotel-images';
  static const String profileImagesBucket = 'profile-images';

  // Image Settings
  static const int maxImageSizeMB = 5;
  static const int imageQuality = 80;

  // Pagination
  static const int pageSize = 20;

  /// Supabase magic link / email OTP length (configure in Supabase Dashboard if different).
  static const int supabaseOtpLength = 8;
}
