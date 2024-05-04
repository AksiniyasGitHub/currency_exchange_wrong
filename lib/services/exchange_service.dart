import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/currency_rate.dart';

class ExchangeService {
  static Future<CurrencyRate> fetchExchangeRate(String baseCurrency) async {
    final response = await http.get(
        Uri.parse('https://api.exchangerate-api.com/v4/latest/$baseCurrency'));
    if (response.statusCode == 200) {
      return CurrencyRate.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load exchange rate');
    }
  }
}
