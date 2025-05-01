// lib/screens/register_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:invest_track/services/auth_service.dart';
import 'package:invest_track/services/firestore_service.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final AuthService _authService = AuthService();

  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  Color _selectedColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nome completo'),
                    validator: (value) => value == null || value.isEmpty ? 'Digite seu nome' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _birthDateController,
                    readOnly: true,
                    decoration: const InputDecoration(labelText: 'Data de nascimento'),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().subtract(const Duration(days: 3650)),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        _birthDateController.text = DateFormat('dd/MM/yyyy').format(picked);
                      }
                    },
                    validator: (value) => value == null || value.isEmpty ? 'Escolha a data de nascimento' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Idade'),
                    validator: (value) => value == null || value.isEmpty ? 'Digite sua idade' : null,
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Cor favorita'),
                    trailing: CircleAvatar(backgroundColor: _selectedColor),
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Escolha uma cor'),
                          content: SingleChildScrollView(
                            child: BlockPicker(
                              pickerColor: _selectedColor,
                              onColorChanged: (color) => setState(() => _selectedColor = color),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) => value != null && value.contains('@') ? null : 'Email inválido',
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      suffixIcon: IconButton(
                        icon: Icon(_passwordVisible ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() => _passwordVisible = !_passwordVisible);
                        },
                      ),
                    ),
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_confirmPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Confirmar Senha',
                      suffixIcon: IconButton(
                        icon: Icon(_confirmPasswordVisible ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() => _confirmPasswordVisible = !_confirmPasswordVisible);
                        },
                      ),
                    ),
                    validator: (value) => value == _passwordController.text ? null : 'Senhas não conferem',
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          final cred = await _authService.registerWithEmailAndPassword(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          );
                          await FirestoreService().saveUserIfNew(
                            cred!.user!,
                            fullName: _nameController.text.trim(),
                            favoriteColor: _selectedColor.value.toRadixString(16),
                          );
                          Navigator.pop(context);
                        } catch (e) {
                          _showError(context, e);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Cadastrar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha obrigatória';
    }
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z]).{6,}\$');
    if (regex.hasMatch(value)) {
      return 'Senha deve ter pelo menos 6 caracteres, 1 maiúscula e 1 minúscula';
    }
    return null;
  }

  void _showError(BuildContext context, Object error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro: ${error.toString()}')),
    );
  }
}
