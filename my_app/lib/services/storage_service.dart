import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  static const _keyHasSeenOnboarding = 'has_seen_onboarding';
  static const _keyIsLoggedIn = 'is_logged_in';
  static const _keyUserName = 'user_name';
  static const _keyUserEmail = 'user_email';
  static const _keyPhoneNumber = 'phone_number';
  static const _keyBio = 'bio';
  static const _keyGender = 'gender';
  static const _keyDateOfBirth = 'date_of_birth';
  static const _keyProfileImagePath = 'profile_image_path';

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

  String get phoneNumber => _prefs.getString(_keyPhoneNumber) ?? '';

  String get bio => _prefs.getString(_keyBio) ?? '';

  String get gender => _prefs.getString(_keyGender) ?? '';

  /// ISO-8601 date string, or empty if never set.
  String get dateOfBirth => _prefs.getString(_keyDateOfBirth) ?? '';

  String get profileImagePath => _prefs.getString(_keyProfileImagePath) ?? '';

  Future<void> saveProfileDetails({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String bio,
    required String gender,
    required String dateOfBirth,
    required String profileImagePath,
  }) async {
    await _prefs.setString(_keyUserName, fullName);
    await _prefs.setString(_keyUserEmail, email);
    await _prefs.setString(_keyPhoneNumber, phoneNumber);
    await _prefs.setString(_keyBio, bio);
    await _prefs.setString(_keyGender, gender);
    await _prefs.setString(_keyDateOfBirth, dateOfBirth);
    await _prefs.setString(_keyProfileImagePath, profileImagePath);
  }
}
