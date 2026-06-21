import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_app/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _SplashLogo(),
            // SizedBox(height: 20),
            // Text(
            //   'Cookiee',
            //   style: TextStyle(
            //     fontSize: 28,
            //     fontWeight: FontWeight.bold,
            //     letterSpacing: 1.2,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class _SplashLogo extends StatelessWidget {
  const _SplashLogo();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'lib/assets/images/splash.png',
      // width: 120,
      // height: 120,
      // fit: BoxFit.contain,
    );
  }
}
