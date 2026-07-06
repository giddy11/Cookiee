import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  static const _keyHasSeenOnboarding = 'has_seen_onboarding';
  static const _keyIsLoggedIn = 'is_logged_in';
  static const _keyUserName = 'user_name';
  static const _keyUserEmail = 'user_email';

  late final SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  bool get hasSeenOnboarding => _prefs.getBool(_keyHasSeenOnboarding) ?? false;

  Future<void> setOnboardingComplete() =>
      _prefs.setBool(_keyHasSeenOnboarding, true);

  bool get isLoggedIn => _prefs.getBool(_keyIsLoggedIn) ?? false;

  String get userName => _prefs.getString(_keyUserName) ?? '';

  String get userEmail => _prefs.getString(_keyUserEmail) ?? '';

  Future<void> saveSession({required String name, required String email}) async {
    await _prefs.setBool(_keyIsLoggedIn, true);
    await _prefs.setString(_keyUserName, name);
    await _prefs.setString(_keyUserEmail, email);
  }

  Future<void> clearSession() async {
    await _prefs.setBool(_keyIsLoggedIn, false);
  }
}
