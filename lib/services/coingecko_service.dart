// lib/services/coingecko_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class CoinGeckoService {
  static const String _baseUrl = 'https://api.coingecko.com/api/v3';

  Future<List<Coin>> fetchTopCoins({int limit = 10, int page = 1}) async {
    final url = Uri.parse(
      '$_baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$limit&page=$page&sparkline=false',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Coin.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar moedas');
    }
  }
}

class Coin {
  final String id;
  final String name;
  final String symbol;
  final String image;
  final double currentPrice;
  final double priceChangePercentage24h;

  Coin({
    required this.id,
    required this.name,
    required this.symbol,
    required this.image,
    required this.currentPrice,
    required this.priceChangePercentage24h,
  });

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      image: json['image'],
      currentPrice: (json['current_price'] ?? 0).toDouble(),
      priceChangePercentage24h: (json['price_change_percentage_24h'] ?? 0).toDouble(),
    );
  }
}
