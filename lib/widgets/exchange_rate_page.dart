import 'package:flutter/material.dart';
import '../services/exchange_service.dart';
import '../models/currency_rate.dart';

class ExchangeRatePage extends StatefulWidget {
  @override
  _ExchangeRatePageState createState() => _ExchangeRatePageState();
}

class _ExchangeRatePageState extends State<ExchangeRatePage> {
  String baseCurrency = 'EUR';
  String targetCurrency = 'USD';
  TextEditingController amountController = TextEditingController();
  CurrencyRate? currentRate;
  String? errorMessage; // Добавлено для хранения сообщения об ошибке

  Future<void> fetchExchangeRate() async {
    try {
      final rate = await ExchangeService.fetchExchangeRate(baseCurrency);
      setState(() {
        currentRate = rate;
        errorMessage = null; // Сброс ошибки при успешном запросе
      });
    } catch (e) {
      print('Failed to load exchange rate: $e'); // Логирование ошибки
      setState(() {
        errorMessage = 'Failed to load data: $e'; // Сохранение ошибки для отображения
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchExchangeRate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exchange Rate'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchExchangeRate,
          ),
        ],
      ),
      body: Center(
        child: errorMessage != null
            ? Text(errorMessage!, style: TextStyle(color: Colors.red, fontSize: 18)) // Отображение ошибки если она есть
            : currentRate == null
            ? CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '1 $baseCurrency = ${currentRate!.rates[targetCurrency]?.toStringAsFixed(2) ?? 'Unavailable'} $targetCurrency',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}