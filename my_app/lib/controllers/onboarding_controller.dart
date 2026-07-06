import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/onboarding_data.dart';
import '../routes/app_routes.dart';
import '../services/storage_service.dart';

class OnboardingController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final List<OnboardingItem> items = onboardingItems;

  bool get isLastPage => currentPage.value == items.length - 1;

  void onPageChanged(int index) => currentPage.value = index;

  void nextPage() {
    if (isLastPage) {
      completeOnboarding();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> completeOnboarding() async {
    await _storageService.setOnboardingComplete();
    Get.offAllNamed(Routes.auth);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
