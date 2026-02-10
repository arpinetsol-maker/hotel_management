import 'package:get_storage/get_storage.dart';

class StorageService {
  static final _box = GetStorage();

  //keys
  static const String _userTypeKey = 'user-type';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userDataKey = 'user_data';

  // user type
  static Future<void> saveUserType(String type) async {
    await _box.write(_userTypeKey, type);
  }

  static String? getUserType() {
    final v = _box.read(_userTypeKey);
    return v is String ? v : v?.toString();
  }

  /// Main admin role (system-level admin).
  static bool isMainAdmin() {
    return getUserType() == 'admin';
  }

  /// Hotel admin role (manages their own hotel after approval).
  static bool isHotelAdmin() {
    return getUserType() == 'hotel_admin';
  }

  static bool isUser() {
    return getUserType() == 'user';
  }

  //sae user data status
  static Future<void> saveUserData(Map<String, dynamic> data) async {
    await _box.write(_userDataKey, data);
  }

  static Map<String, dynamic>? getUserData() {
    final v = _box.read(_userDataKey);
    return v is Map<String, dynamic>
        ? v
        : (v is Map ? v.cast<String, dynamic>() : null);
  }

  //login status
  static Future<void> setLoggedIn(bool value) async {
    await _box.write(_isLoggedInKey, value);
  }

  static bool isLoggedIn() {
    return _box.read(_isLoggedInKey) ?? false;
  }

  //clear all data
  static Future<void> clearAll() async {
    await _box.erase();
  }

  //initialize
  static Future<void> init() async {
    await GetStorage.init();
  }
}
