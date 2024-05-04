import 'package:flutter/material.dart';
import '../services/exchange_service.dart';

class ExchangeRatePage extends StatefulWidget {
  @override
  _ExchangeRatePageState createState() => _ExchangeRatePageState();
}

class _ExchangeRatePageState extends State<ExchangeRatePage> {
  double exchangeRate = 0;
  String baseCurrency = 'EUR';
  String targetCurrency = 'USD';
  TextEditingController amountController = TextEditingController();
  String amountText = '';

  Future<void> fetchExchangeRate() async {
    final rate = await ExchangeService.fetchExchangeRate(
        baseCurrency, targetCurrency);
    setState(() {
      exchangeRate = rate;
    });
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
        title: Text(
          'Exchange Rate',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchExchangeRate,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '1 $baseCurrency = ${exchangeRate.toStringAsFixed(2)} $targetCurrency',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Amount:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    onChanged: (newValue) {
                      setState(() {
                        amountText = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      final temp = baseCurrency;
                      baseCurrency = targetCurrency;
                      targetCurrency = temp;
                    });
                    fetchExchangeRate();
                  },
                  child: Text('Switch Direction'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: targetCurrency,
              onChanged: (String? newValue) {
                setState(() {
                  targetCurrency = newValue!;
                });
                fetchExchangeRate();
              },
              items: <String>['USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  amountController.clear();
                  amountText = '';
                });
              },
              child: Text('Clear'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
                textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              '${amountText.isEmpty ? '' : amountText} $baseCurrency = ${(double.parse(amountText.isEmpty ? '0' : amountText) * exchangeRate).toStringAsFixed(2)} $targetCurrency',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}