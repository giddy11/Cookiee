import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../services/storage_service.dart';

class AuthController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  final formKeyLogin = GlobalKey<FormState>();
  final formKeyRegister = GlobalKey<FormState>();

  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  final registerNameController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final registerConfirmPasswordController = TextEditingController();

  final RxBool isLogin = true.obs;
  final RxBool isLoading = false.obs;
  final RxBool obscureLoginPassword = true.obs;
  final RxBool obscureRegisterPassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;
  final Rx<DateTime?> birthDate = Rx<DateTime?>(null);

  void toggleMode() => isLogin.value = !isLogin.value;

  void toggleLoginPasswordVisibility() =>
      obscureLoginPassword.value = !obscureLoginPassword.value;

  void toggleRegisterPasswordVisibility() =>
      obscureRegisterPassword.value = !obscureRegisterPassword.value;

  void toggleConfirmPasswordVisibility() =>
      obscureConfirmPassword.value = !obscureConfirmPassword.value;

  void setBirthDate(DateTime date) => birthDate.value = date;

  static final RegExp _emailPattern =
      RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

  String? validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Email is required';
    if (!_emailPattern.hasMatch(email)) return 'Enter a valid email address';
    return null;
  }

  String? validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Password is required';
    if (password.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value != registerPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Name is required';
    if (name.length < 2) return 'Name is too short';
    return null;
  }

  Future<void> login() async {
    if (!formKeyLogin.currentState!.validate()) return;

    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 600));

    await _storageService.saveSession(
      name: _storageService.userName,
      email: loginEmailController.text.trim(),
    );

    isLoading.value = false;
    Get.offAllNamed(Routes.home);
  }

  Future<void> register() async {
    if (!formKeyRegister.currentState!.validate()) return;
    if (birthDate.value == null) {
      Get.snackbar(
        'Missing birth date',
        'Please select your birth date to continue.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 600));

    await _storageService.saveSession(
      name: registerNameController.text.trim(),
      email: registerEmailController.text.trim(),
    );

    isLoading.value = false;
    Get.offAllNamed(Routes.home);
  }

  @override
  void onClose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    registerNameController.dispose();
    registerEmailController.dispose();
    registerPasswordController.dispose();
    registerConfirmPasswordController.dispose();
    super.onClose();
  }
}
