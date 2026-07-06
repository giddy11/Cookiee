import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../services/storage_service.dart';

class SplashController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!_storageService.hasSeenOnboarding) {
      Get.offAllNamed(Routes.onboarding);
    } else if (_storageService.isLoggedIn) {
      Get.offAllNamed(Routes.home);
    } else {
      Get.offAllNamed(Routes.auth);
    }
  }
}
