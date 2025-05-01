// lib/screens/profile_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import '../widgets/image_picker_avatar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _ageController = TextEditingController();
  Color _selectedColor = Colors.blue;
  String _photoBase64 = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data()!;

    _nameController.text = data['displayName'] ?? '';
    _emailController.text = data['email'] ?? '';
    _birthDateController.text = data['birthDate'] ?? '';
    _ageController.text = data['age'] ?? '';
    _photoBase64 = data['photoBase64'] ?? '';
    _selectedColor = Color(int.tryParse(data['favoriteColor'] ?? 'ff2196f3', radix: 16) ?? 0xff2196f3);

    setState(() {});
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'displayName': _nameController.text.trim(),
        'birthDate': _birthDateController.text.trim(),
        'age': _ageController.text.trim(),
        'favoriteColor': _selectedColor.value.toRadixString(16),
        'photoBase64': _photoBase64,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado com sucesso')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                  child: ImagePickerAvatar(
                    base64Image: _photoBase64,
                    onImageSelected: (file, base64) {
                      _photoBase64 = base64;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nome completo'),
                  validator: (v) => v == null || v.isEmpty ? 'Digite seu nome' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'Email (não editável)'),
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
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Idade'),
                  validator: (v) => v == null || v.isEmpty ? 'Digite sua idade' : null,
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Cor favorita'),
                  trailing: CircleAvatar(backgroundColor: _selectedColor),
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Escolha uma cor'),
                        content: SingleChildScrollView(
                          child: BlockPicker(
                            pickerColor: _selectedColor,
                            onColorChanged: (c) => setState(() => _selectedColor = c),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Salvar alterações'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
