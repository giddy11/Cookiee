import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../services/storage_service.dart';

class Profile2Controller extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  final fullName = ''.obs;
  final email = ''.obs;
  final phoneNumber = ''.obs;
  final bio = ''.obs;
  final gender = ''.obs;
  final dateOfBirth = ''.obs;
  final profileImagePath = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  void loadProfile() {
    fullName.value = _storageService.userName;
    email.value = _storageService.userEmail;
    phoneNumber.value = _storageService.phoneNumber;
    bio.value = _storageService.bio;
    gender.value = _storageService.gender;
    dateOfBirth.value = _storageService.dateOfBirth;
    profileImagePath.value = _storageService.profileImagePath;
  }

  Future<void> openEditProfile() async {
    await Get.toNamed(Routes.editProfile2);
    loadProfile();
  }

  Future<void> logout() async {
    await _storageService.clearSession();
    Get.offAllNamed(Routes.auth);
  }
}
