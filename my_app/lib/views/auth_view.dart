import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../widgets/auth_text_field.dart';

const _brandColor = Color(0xFF00BCD4);

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=200&h=200&fit=crop',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, st) => Container(
                          width: 90,
                          height: 90,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.restaurant,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Cookiee',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 28),
                    const _ModeToggle(),
                    const SizedBox(height: 24),
                    Obx(
                      () => controller.isLogin.value
                          ? const _LoginForm()
                          : const _RegisterForm(),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 12, 28, 24),
              child: SizedBox(
                width: double.infinity,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : (controller.isLogin.value
                              ? controller.login
                              : controller.register),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _brandColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            controller.isLogin.value ? 'Login' : 'Register',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeToggle extends GetView<AuthController> {
  const _ModeToggle();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLogin = controller.isLogin.value;
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Expanded(
              child: _ModeSegment(
                label: 'Login',
                selected: isLogin,
                onTap: () {
                  if (!isLogin) controller.toggleMode();
                },
              ),
            ),
            Expanded(
              child: _ModeSegment(
                label: 'Register',
                selected: !isLogin,
                onTap: () {
                  if (isLogin) controller.toggleMode();
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _ModeSegment extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeSegment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? _brandColor : Colors.transparent,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends GetView<AuthController> {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKeyLogin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FieldLabel(label: 'EMAIL'),
          const SizedBox(height: 6),
          AuthTextField(
            controller: controller.loginEmailController,
            hint: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            validator: controller.validateEmail,
          ),
          const SizedBox(height: 18),
          const FieldLabel(label: 'PASSWORD'),
          const SizedBox(height: 6),
          Obx(
            () => AuthTextField(
              controller: controller.loginPasswordController,
              hint: 'Enter your password',
              obscure: controller.obscureLoginPassword.value,
              validator: controller.validatePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  controller.obscureLoginPassword.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.black38,
                  size: 20,
                ),
                onPressed: controller.toggleLoginPasswordVisibility,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RegisterForm extends GetView<AuthController> {
  const _RegisterForm();

  Future<void> _pickBirthDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _brandColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) controller.setBirthDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKeyRegister,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FieldLabel(label: 'NAME'),
          const SizedBox(height: 6),
          AuthTextField(
            controller: controller.registerNameController,
            hint: 'Enter your full name',
            validator: controller.validateName,
          ),
          const SizedBox(height: 16),
          const FieldLabel(label: 'EMAIL'),
          const SizedBox(height: 6),
          AuthTextField(
            controller: controller.registerEmailController,
            hint: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            validator: controller.validateEmail,
          ),
          const SizedBox(height: 16),
          const FieldLabel(label: 'PASSWORD'),
          const SizedBox(height: 6),
          Obx(
            () => AuthTextField(
              controller: controller.registerPasswordController,
              hint: 'Create a password',
              obscure: controller.obscureRegisterPassword.value,
              validator: controller.validatePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  controller.obscureRegisterPassword.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.black38,
                  size: 20,
                ),
                onPressed: controller.toggleRegisterPasswordVisibility,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const FieldLabel(label: 'CONFIRM PASSWORD'),
          const SizedBox(height: 6),
          Obx(
            () => AuthTextField(
              controller: controller.registerConfirmPasswordController,
              hint: 'Re-enter your password',
              obscure: controller.obscureConfirmPassword.value,
              validator: controller.validateConfirmPassword,
              suffixIcon: IconButton(
                icon: Icon(
                  controller.obscureConfirmPassword.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.black38,
                  size: 20,
                ),
                onPressed: controller.toggleConfirmPasswordVisibility,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const FieldLabel(label: 'BIRTHDATE'),
          const SizedBox(height: 6),
          Obx(() {
            final date = controller.birthDate.value;
            return GestureDetector(
              onTap: () => _pickBirthDate(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: date != null
                        ? _brandColor
                        : const Color(0xFFCCCCCC),
                    width: date != null ? 1.5 : 1,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        date != null
                            ? '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}'
                            : 'Select your birth date',
                        style: TextStyle(
                          fontSize: 14,
                          color: date != null
                              ? Colors.black87
                              : Colors.black38,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: Colors.black38,
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
