import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cryptocurrency.dart';

class CryptoService {
  static const String baseUrl = 'https://api.coingecko.com/api/v3';

  // Get top cryptocurrencies
  Future<List<Cryptocurrency>> getTopCryptocurrencies({int limit = 50}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$limit&page=1&sparkline=false'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Cryptocurrency.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load cryptocurrencies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  // Get specific cryptocurrency data
  Future<Cryptocurrency?> getCryptocurrency(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/coins/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Cryptocurrency.fromJson({
          'id': data['id'],
          'name': data['name'],
          'symbol': data['symbol'],
          'image': data['image']['large'],
          'current_price': data['market_data']['current_price']['usd'],
          'price_change_24h': data['market_data']['price_change_24h'],
          'price_change_percentage_24h': data['market_data']['price_change_percentage_24h'],
          'market_cap': data['market_data']['market_cap']['usd'],
          'total_volume': data['market_data']['total_volume']['usd'],
        });
      } else {
        throw Exception('Failed to load cryptocurrency: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch cryptocurrency data: $e');
    }
  }

  // Search cryptocurrencies
  Future<List<Cryptocurrency>> searchCryptocurrencies(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search?query=$query'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> coins = data['coins'] ?? [];
        
        // Get detailed info for first 10 results
        final List<Cryptocurrency> results = [];
        for (int i = 0; i < (coins.length > 10 ? 10 : coins.length); i++) {
          final coin = coins[i];
          try {
            final crypto = await getCryptocurrency(coin['id']);
            if (crypto != null) {
              results.add(crypto);
            }
          } catch (e) {
            // Skip failed requests
            continue;
          }
        }
        return results;
      } else {
        throw Exception('Failed to search cryptocurrencies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search: $e');
    }
  }

  // Get price history for chart
  Future<List<List<dynamic>>> getPriceHistory(String id, {int days = 7}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/coins/$id/market_chart?vs_currency=usd&days=$days'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return List<List<dynamic>>.from(data['prices'] ?? []);
      } else {
        throw Exception('Failed to load price history: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch price history: $e');
    }
  }

  // Get trending cryptocurrencies
  Future<List<Cryptocurrency>> getTrending() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search/trending'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> coins = data['coins'] ?? [];
        
        final List<Cryptocurrency> results = [];
        for (final item in coins) {
          final coin = item['item'];
          try {
            final crypto = await getCryptocurrency(coin['id']);
            if (crypto != null) {
              results.add(crypto);
            }
          } catch (e) {
            continue;
          }
        }
        return results;
      } else {
        throw Exception('Failed to load trending: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch trending: $e');
    }
  }
}