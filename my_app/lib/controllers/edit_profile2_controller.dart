import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../controllers/profile2_controller.dart';
import '../services/storage_service.dart';

class EditProfile2Controller extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final ImagePicker _imagePicker = ImagePicker();

  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final bioController = TextEditingController();
  final dateOfBirthController = TextEditingController();

  final gender = ''.obs;
  final Rx<DateTime?> dateOfBirth = Rx<DateTime?>(null);
  final profileImagePath = ''.obs;
  final isSaving = false.obs;

  final genderOptions = ['Male', 'Female'];
  static final _displayFormat = DateFormat('dd/MM/yyyy');

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  void loadProfile() {
    fullNameController.text = _storageService.userName;
    emailController.text = _storageService.userEmail;
    phoneNumberController.text = _storageService.phoneNumber;
    bioController.text = _storageService.bio;
    gender.value = _storageService.gender;
    profileImagePath.value = _storageService.profileImagePath;

    final storedDob = _storageService.dateOfBirth;
    if (storedDob.isNotEmpty) {
      final parsed = DateTime.tryParse(storedDob);
      if (parsed != null) {
        dateOfBirth.value = parsed;
        dateOfBirthController.text = _displayFormat.format(parsed);
      }
    }
  }

  void updateGender(String? value) => gender.value = value ?? '';

  Future<void> selectDateOfBirth(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: dateOfBirth.value ?? DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      dateOfBirth.value = picked;
      dateOfBirthController.text = _displayFormat.format(picked);
    }
  }

  String? validateDateOfBirth(String? value) {
    if (dateOfBirth.value == null || value == null || value.isEmpty) {
      return 'Please select your date of birth';
    }
    if (dateOfBirth.value!.isAfter(DateTime.now())) {
      return 'Date of birth cannot be in the future';
    }
    return null;
  }

  Future<void> pickProfileImage(ImageSource source) async {
    final pickedFile = await _imagePicker.pickImage(
      source: source,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      profileImagePath.value = pickedFile.path;
    }
  }

  ImageProvider? get profileImageProvider {
    final path = profileImagePath.value;
    if (path.isEmpty) return null;
    if (kIsWeb) return NetworkImage(path);
    return FileImage(File(path));
  }

  Future<void> saveProfile() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    isSaving.value = true;
    try {
      await _storageService.saveProfileDetails(
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        phoneNumber: phoneNumberController.text.trim(),
        bio: bioController.text.trim(),
        gender: gender.value,
        dateOfBirth: dateOfBirth.value?.toIso8601String() ?? '',
        profileImagePath: profileImagePath.value,
      );

      if (Get.isRegistered<Profile2Controller>()) {
        Get.find<Profile2Controller>().loadProfile();
      }

      Get.back();
      Get.snackbar(
        'Profile updated',
        'Your changes have been saved.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save profile: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    bioController.dispose();
    dateOfBirthController.dispose();
    super.onClose();
  }
}
