// lib/screens/coin_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:invest_track/models/coin.model.dart';

class CoinDetailScreen extends StatelessWidget {
  final Coin coin;

  const CoinDetailScreen({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(coin.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                coin.image,
                height: 80,
              ),
            ),
            const SizedBox(height: 20),
            Text('Símbolo: ${coin.symbol.toUpperCase()}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Preço atual: \$${coin.currentPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text(
              'Variação 24h: ${coin.priceChangePercentage24h.toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 18,
                color: coin.priceChangePercentage24h >= 0 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
