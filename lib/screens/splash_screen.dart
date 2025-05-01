// lib/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'permission_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<Widget> _determineStartScreen() async {
    await Future.delayed(const Duration(seconds: 1));
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final status = await Permission.camera.status;
      if (status.isGranted) {
        return const HomeScreen();
      } else {
        return const PermissionScreen();
      }
    } else {
      return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _determineStartScreen(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snapshot.data!;
      },
    );
  }
}
