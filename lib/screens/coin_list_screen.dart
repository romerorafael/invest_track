// lib/screens/coin_list_screen.dart

import 'package:flutter/material.dart';
import 'package:invest_track/screens/coin_detail_sreen.dart';
import '../services/coingecko_service.dart';

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
      appBar: AppBar(title: const Text('Top Criptos')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _coins.length,
              itemBuilder: (context, index) {
                final coin = _coins[index];
                return ListTile(
                  leading: Image.network(coin.image, width: 32, height: 32),
                  title: Text('${coin.name} (${coin.symbol.toUpperCase()})'),
                  subtitle: Text('\$${coin.currentPrice.toStringAsFixed(2)}'),
                  trailing: Text(
                    '${coin.priceChangePercentage24h.toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: coin.priceChangePercentage24h >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CoinDetailScreen(coin: coin),
                    ),
                  ),
                );
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
              child: ElevatedButton(
                onPressed: _loadMoreCoins,
                child: const Text('Carregar mais'),
              ),
            ),
        ],
      ),
    );
  }
}