// lib/widgets/drawer_header.dart
import 'dart:convert';

import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final String? userName;
  final String? userEmail;
  final Color? headerBackgroundColor;
  final String? profileInitial;
  final String? photoBase64;
  final VoidCallback? onHomeTap; // Callback para a tela de perfil
  final VoidCallback? onProfileTap; // Callback para a tela de perfil
  final VoidCallback? onLogoutTap; // Callback para o logout
  final VoidCallback? onCoinsTap; // Callback para o tela de coins

  const CustomDrawer({
    super.key,
    this.userName,
    this.userEmail,
    this.headerBackgroundColor,
    this.profileInitial,
    this.photoBase64,
    this.onHomeTap,
    this.onProfileTap,
    this.onLogoutTap,
    this.onCoinsTap
  });

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoBase64 != null && photoBase64!.isNotEmpty;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
           UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: headerBackgroundColor ?? Colors.blue),
            accountName: Text(userName ?? 'Usuário'),
            accountEmail: Text(userEmail ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: hasPhoto ? MemoryImage(base64Decode(photoBase64!)) : null,
              child: !hasPhoto
                  ? Text(
                      profileInitial ?? 'U',
                      style: const TextStyle(fontSize: 40.0),
                    )
                  : null,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              if (onHomeTap != null) {
                onHomeTap!();
              }
            }
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            onTap: () {
              if (onProfileTap != null) {
                onProfileTap!();
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.money),
            title: const Text('Criptos'),
            onTap: () {
              if (onCoinsTap != null) {
                onCoinsTap!();
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () {
              if (onLogoutTap != null) {
                onLogoutTap!();
              }
            },
          ),
          // Adicione mais itens de menu aqui, se necessário
        ],
      ),
    );
  }
}