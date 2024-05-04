import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/currency_rate.dart';

class ExchangeService {
  static Future<double> fetchExchangeRate(
      String baseCurrency, String targetCurrency) async {
    final response = await http.get(
        Uri.parse('https://api.exchangerate-api.com/v4/latest/$baseCurrency'));
    final responseData = json.decode(response.body);
    return responseData['rates'][targetCurrency];
  }
}