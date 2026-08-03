import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/delivery_details_model.dart';
import '../routes/app_routes.dart';
import 'cart_controller.dart';

class CheckoutController extends GetxController {
  final CartController cartController = Get.find<CartController>();

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  final RxBool isFormValid = false.obs;

  void revalidate() {
    isFormValid.value = formKey.currentState?.validate() ?? false;
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required';
    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) return 'Delivery address is required';
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone number is required';
    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length < 7) return 'Enter a valid phone number';
    return null;
  }

  void proceedToPayment() {
    if (!(formKey.currentState?.validate() ?? false)) return;
    Get.toNamed(
      Routes.payment,
      arguments: DeliveryDetails(
        name: nameController.text.trim(),
        address: addressController.text.trim(),
        phone: phoneController.text.trim(),
      ),
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
