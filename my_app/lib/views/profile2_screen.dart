import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/profile2_controller.dart';

const _brandColor = Color(0xFF00BCD4);

class Profile2Screen extends GetView<Profile2Controller> {
  const Profile2Screen({super.key});

  ImageProvider? _avatarImage(String path) {
    if (path.isEmpty) return null;
    if (kIsWeb) return NetworkImage(path);
    return FileImage(File(path));
  }

  String _formattedDob(String isoDate) {
    if (isoDate.isEmpty) return 'Not set';
    final parsed = DateTime.tryParse(isoDate);
    if (parsed == null) return 'Not set';
    return DateFormat('dd/MM/yyyy').format(parsed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.black54),
            onPressed: controller.logout,
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(
          () => ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 56,
                      backgroundColor: _brandColor.withValues(alpha: 0.12),
                      backgroundImage: _avatarImage(
                        controller.profileImagePath.value,
                      ),
                      child: controller.profileImagePath.value.isEmpty
                          ? Text(
                              controller.fullName.value.isNotEmpty
                                  ? controller.fullName.value[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: _brandColor,
                              ),
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: controller.openEditProfile,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: _brandColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  controller.fullName.value.isNotEmpty
                      ? controller.fullName.value
                      : 'Guest User',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              if (controller.bio.value.isNotEmpty)
                Center(
                  child: Text(
                    controller.bio.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              _InfoCard(
                children: [
                  _InfoTile(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: controller.email.value,
                  ),
                  _InfoTile(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: controller.phoneNumber.value,
                  ),
                  _InfoTile(
                    icon: Icons.cake_outlined,
                    label: 'Date of Birth',
                    value: _formattedDob(controller.dateOfBirth.value),
                  ),
                  _InfoTile(
                    icon: Icons.wc_outlined,
                    label: 'Gender',
                    value: controller.gender.value,
                    isLast: true,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: controller.openEditProfile,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: _brandColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: const Icon(Icons.edit_outlined, color: _brandColor),
                  label: const Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: _brandColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: Color(0xFFF0F0F0)),
              ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: _brandColor),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Colors.black45,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isNotEmpty ? value : 'Not set',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    color: value.isNotEmpty ? Colors.black87 : Colors.black38,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
