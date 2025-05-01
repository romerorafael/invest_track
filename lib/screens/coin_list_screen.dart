import 'package:flutter/material.dart';
import 'package:invest_track/models/coin.model.dart';
import 'package:invest_track/services/coingecko_service.dart';
import 'package:invest_track/widgets/coin_card.dart';

class CoinListScreen extends StatefulWidget {
  const CoinListScreen({super.key});

  @override
  State<CoinListScreen> createState() => _CoinListScreenState();
}

class _CoinListScreenState extends State<CoinListScreen> {
  final CoinGeckoService _service = CoinGeckoService();
  final List<Coin> _coins = [];
  int _currentPage = 1;
  bool _loading = false;
  bool _hasMore = true;

  // Cores personalizáveis para o botão "Carregar Mais"
  final Color _loadMoreButtonBackgroundColor = Colors.blue; // Cor de fundo padrão
  final Color _loadMoreButtonTextColor = Colors.white; // Cor do texto padrão

  @override
  void initState() {
    super.initState();
    _loadMoreCoins();
  }

  Future<void> _loadMoreCoins() async {
    if (_loading || !_hasMore) return;
    setState(() => _loading = true);

    try {
      final newCoins = await _service.fetchTopCoins(limit: 20, page: _currentPage);
      setState(() {
        _coins.addAll(newCoins);
        _currentPage++;
        _hasMore = newCoins.isNotEmpty;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _coins.length,
              itemBuilder: (context, index) {
                final coin = _coins[index];
                return CoinCard(coin: coin);
              },
            ),
          ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(),
            )
          else if (_hasMore)
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextButton(
                onPressed: _loadMoreCoins,
                style: TextButton.styleFrom(
                  backgroundColor: _loadMoreButtonBackgroundColor, // Usa a cor de fundo personalizável
                  foregroundColor: _loadMoreButtonTextColor, // Usa a cor do texto personalizável
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: const Text("Carregar Mais", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ),
            ),
        ],
      ),
    );
  }
}
