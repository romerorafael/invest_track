// lib/services/coingecko_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:invest_track/models/coin.model.dart';

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

