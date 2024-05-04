import 'package:flutter/material.dart';
import '../services/exchange_service.dart';

class ExchangeRatePage extends StatefulWidget {
  @override
  _ExchangeRatePageState createState() => _ExchangeRatePageState();
}

class _ExchangeRatePageState extends State<ExchangeRatePage> {
  String baseCurrency = 'EUR';
  String targetCurrency = 'USD';
  TextEditingController amountController = TextEditingController();
  String amountText = '';

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
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<double>(
              future: ExchangeService.fetchExchangeRate(baseCurrency, targetCurrency),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  double rate = snapshot.data ?? 0;
                  return Column(
                    children: [
                      Text(
                        '1 $baseCurrency = ${rate.toStringAsFixed(2)} $targetCurrency',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${amountText.isEmpty ? '' : amountText} $baseCurrency = ${(double.parse(amountText.isEmpty ? '0' : amountText) * rate).toStringAsFixed(2)} $targetCurrency',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                }
              },
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
          ],
        ),
      ),
    );
  }
}