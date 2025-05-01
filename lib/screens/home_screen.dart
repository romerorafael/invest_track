// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invest_track/providers/auth_state_provider.dart';
import 'package:invest_track/providers/user_provider.dart';
import 'package:invest_track/screens/coin_list_screen.dart';
import 'package:invest_track/services/auth_service.dart';
import 'package:invest_track/widgets/drawer_header.dart';
import 'package:invest_track/screens/profile_screen.dart';

class _PageConfig {
  final Widget widget;
  final String title;

  _PageConfig({required this.widget, required this.title});
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0; // Índice da página atual
  late final List<_PageConfig> _pageConfigs;

  @override
    void initState() {
    super.initState();
    _pageConfigs = <_PageConfig>[
      _PageConfig(
        widget: _buildHomePageBody(ref.read(userProvider)),
        title: 'Home',
      ),
      _PageConfig(
        widget: const ProfileScreen(),
        title: 'Perfil',
      ),
      _PageConfig(
        widget: const CoinListScreen(),
        title: 'Criptos',
      ),
      // _PageConfig(
      //   widget: const OutraTela(),
      //   title: 'Outra Tela',
      // ),
    ];
  }

  Widget _buildHomePageBody(AsyncValue<Map<String, dynamic>> userAsyncValue) {
    return userAsyncValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text('Erro ao carregar os dados do usuário: $error'),
      ),
      data: (userData) {
        final displayName = userData['displayName'] ?? 'Usuário';
        final email = userData['email'] ?? '';
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Bem-vindo, $displayName', style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 10),
              Text(email, style: const TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Fechar o drawer ao selecionar um item
  }

  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(userProvider);
    final userData = userAsyncValue.valueOrNull;
    final favoriteColorHex = userData?['favoriteColor'] ?? 'ff2196f3';
    final favoriteColor = Color(int.parse(favoriteColorHex, radix: 16));
    final displayName = userData?['displayName'] ?? 'Usuário';
    final email = userData?['email'] ?? '';
    final photoBase64 = userData?['photoBase64'] ?? '';
    final authNotifier = ref.read(authNotifierProvider.notifier);
    
    return Scaffold(
      appBar: AppBar(title: Text(_pageConfigs[_selectedIndex].title)), // Título da AppBar pode mudar
      drawer: CustomDrawer(
        userName: displayName,
        userEmail: email,
        headerBackgroundColor: favoriteColor,
        profileInitial: displayName.isNotEmpty ? displayName[0] : 'U',
        photoBase64: photoBase64,
        onHomeTap: () {
          _onItemTapped(0); // Navegar para a tela de home
        },
        onProfileTap: () {
          _onItemTapped(1); // Navegar para a tela de perfil
        },
        onCoinsTap: () {
          _onItemTapped(2); // Navegar para a tela de perfil
        },
        onLogoutTap: () async {
          await authNotifier.signOut(context);
        },
      ),
      body: _pageConfigs[_selectedIndex].widget,// Exibe o widget da página selecionada
    );
  }
}