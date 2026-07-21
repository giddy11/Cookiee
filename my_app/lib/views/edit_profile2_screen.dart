import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/edit_profile2_controller.dart';

const _brandColor = Color(0xFF00BCD4);

class EditProfile2Screen extends GetView<EditProfile2Controller> {
  const EditProfile2Screen({super.key});

  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  controller.pickProfileImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  controller.pickProfileImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration({required String label, IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Center(
                    child: GestureDetector(
                      onTap: () => _showImageSourceSheet(context),
                      child: Obx(
                        () => Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: controller.profileImageProvider,
                              child: controller.profileImageProvider == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 44,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            const Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: _brandColor,
                                child: Icon(
                                  Icons.edit,
                                  size: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: controller.fullNameController,
                    keyboardType: TextInputType.name,
                    decoration: _inputDecoration(
                      label: 'Full Name',
                      icon: Icons.person_outline,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDecoration(
                      label: 'Email',
                      icon: Icons.email_outlined,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value.trim())) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => DropdownButtonFormField<String>(
                      initialValue: controller.gender.value.isNotEmpty
                          ? controller.gender.value
                          : null,
                      decoration: _inputDecoration(
                        label: 'Gender',
                        icon: Icons.wc_outlined,
                      ),
                      items: controller.genderOptions.map((option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: controller.updateGender,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: _inputDecoration(
                      label: 'Phone Number',
                      icon: Icons.phone_outlined,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your phone number';
                      }
                      final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
                      if (digitsOnly.length < 7) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => controller.selectDateOfBirth(context),
                    child: IgnorePointer(
                      child: TextFormField(
                        controller: controller.dateOfBirthController,
                        decoration: _inputDecoration(
                          label: 'Date of Birth (dd/MM/yyyy)',
                          icon: Icons.calendar_today_outlined,
                        ),
                        validator: controller.validateDateOfBirth,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.bioController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    maxLength: 150,
                    decoration: _inputDecoration(label: 'Bio'),
                    validator: (value) {
                      if (value != null && value.length > 150) {
                        return 'Bio cannot exceed 150 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.isSaving.value
                            ? null
                            : controller.saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _brandColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: controller.isSaving.value
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
