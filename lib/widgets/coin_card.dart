import 'package:flutter/material.dart';
import 'package:invest_track/models/coin.model.dart';
import 'package:invest_track/screens/coin_detail_sreen.dart'; // Importe a tela de detalhes

class CoinCard extends StatelessWidget {
  final Coin coin;

  const CoinCard({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CoinDetailScreen(coin: coin),
          ),
        );
      },
      child: Card(
        elevation: 4, // Adiciona uma sombra sutil
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), // Margens para os cards
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Bordas arredondadas
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Image.network(coin.image, width: 48, height: 48), // Aumenta o tamanho da imagem
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${coin.name} (${coin.symbol.toUpperCase()})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500, // Adiciona um peso à fonte
                      ),
                    ),
                    Text(
                      '\$${coin.currentPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _buildPercentageChange(), // Widget para a porcentagem de mudança
            ],
          ),
        ),
      ),
    );
  }

  // Widget para construir a parte da porcentagem de mudança com estilo e ícone
  Widget _buildPercentageChange() {
    final isPositive = coin.priceChangePercentage24h >= 0;
    return Row(
      children: [
        Icon(
          isPositive ? Icons.arrow_upward : Icons.arrow_downward,
          color: isPositive ? Colors.green : Colors.red,
          size: 20, // Define um tamanho para o ícone
        ),
        const SizedBox(width: 4), // Espaçamento entre o ícone e o texto
        Text(
          '${coin.priceChangePercentage24h.toStringAsFixed(2)}%',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500, // Adiciona peso à fonte
            color: isPositive ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }
}
