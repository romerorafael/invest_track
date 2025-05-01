// lib/screens/permission_screen.dart

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'home_screen.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      _navigateToHome();
    } else {
      setState(() => _checking = false);
    }
  }

  Future<void> _requestPermission() async {
     final result = await Permission.camera.request();
    if (result.isGranted) {
      _navigateToHome();
    } else if (result.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Permissão necessária. Abra as configurações para conceder acesso.'),
          action: SnackBarAction(
            label: 'Configurações',
            onPressed: () {
              openAppSettings(); // Importar 'package:permission_handler/permission_handler.dart'
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permissão necessária para usar a câmera')),
      );
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _checking
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt, size: 100),
                    const SizedBox(height: 20),
                    const Text(
                      'Precisamos da sua permissão para acessar a câmera',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _requestPermission,
                      child: const Text('Permitir acesso'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
