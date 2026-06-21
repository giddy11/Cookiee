import 'package:flutter/material.dart';

class ProfileDetails extends StatelessWidget {
  final String name;
  final String email;

  const ProfileDetails({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name.isNotEmpty ? name : 'Guest User',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            email.isNotEmpty ? email : '',
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF00BCD4),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Private Chef\nPassionate about food and life 🍕🍔🌶️📸',
            style: TextStyle(
              fontSize: 13.5,
              color: Color(0xFF9E9E9E),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'More...',
              style: TextStyle(
                fontSize: 13.5,
                color: Color(0xFF3DAA6E),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
