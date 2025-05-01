// providers/auth_state_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:invest_track/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:invest_track/screens/login_screen.dart';

final authServiceProvider = Provider((ref) => AuthService());

class AuthStateNotifier extends StateNotifier<User?> {
  final Ref _ref; // Recebe o Ref no construtor

  AuthStateNotifier(this._ref) : super(FirebaseAuth.instance.currentUser);

  void setUser(User? user) {
    state = user;
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _ref.read(authServiceProvider).signOut(); // Usa _ref para ler o provider
      state = null;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      print('Erro ao fazer logout: $e');
    }
  }

  // ... outros métodos relacionados à autenticação ...
}

final authNotifierProvider = StateNotifierProvider<AuthStateNotifier, User?>(
  (ref) => AuthStateNotifier(ref), // Passa o ref para o construtor
);

final userAuthProvider = Provider<User?>((ref) => ref.watch(authNotifierProvider));