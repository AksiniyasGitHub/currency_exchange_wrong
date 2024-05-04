import 'dart:convert';

class CurrencyRate {
  final String baseCurrency;
  final Map<String, double> rates;

  CurrencyRate({required this.baseCurrency, required this.rates});

  factory CurrencyRate.fromJson(Map<String, dynamic> json) {
    Map<String, double> convertedRates = {};
    json['rates'].forEach((key, dynamic value) {
      // Преобразуем все числовые значения к типу double
      convertedRates[key] = (value is int) ? value.toDouble() : (value as double);
    });
    return CurrencyRate(
      baseCurrency: json['base'],
      rates: convertedRates,
    );
  }

  static CurrencyRate fromJsonString(String jsonString) {
    return CurrencyRate.fromJson(json.decode(jsonString));
  }
}