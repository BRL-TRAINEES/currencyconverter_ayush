import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'currency_service.dart'; 


final currencyProvider = FutureProvider<Map<String, String>>((ref) async {
  return CurrencyService().fetchCurrencies();
});


final conversionResultProvider = StateProvider<String?>((ref) => null);

class HomeScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final currencyAsyncValue = ref.watch(currencyProvider);
    final conversionResult = ref.watch(conversionResultProvider);

    
    String? fromCurrency;
    String? toCurrency;
    double amount = 0.0;

    Future<void> convertCurrency() async {
      if (fromCurrency != null && toCurrency != null) {
        try {
          final service = CurrencyService();
          double conversion = await service.convertCurrency(fromCurrency!, toCurrency!, amount);
          ref.read(conversionResultProvider.notifier).state = '$amount $fromCurrency = $conversion $toCurrency';
        } catch (e) {
          ref.read(conversionResultProvider.notifier).state = 'Error converting currency: $e';
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Currency Converter')),
      body: currencyAsyncValue.when(
        data: (currencyData) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                DropdownButton<String>(
                  value: fromCurrency,
                  hint: const Text('Select From Currency'),
                  isExpanded: true,
                  items: currencyData.entries
                      .map((entry) => DropdownMenuItem<String>(
                            value: entry.key,
                            child: Text(entry.value),
                          ))
                      .toList(),
                  onChanged: (value) {
                    fromCurrency = value;
                  },
                ),
                DropdownButton<String>(
                  value: toCurrency,
                  hint: const Text('Select To Currency'),
                  isExpanded: true,
                  items: currencyData.entries
                      .map((entry) => DropdownMenuItem<String>(
                            value: entry.key,
                            child: Text(entry.value),
                          ))
                      .toList(),
                  onChanged: (value) {
                    toCurrency = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    amount = double.tryParse(value) ?? 0.0;
                  },
                ),
                ElevatedButton(
                  onPressed: convertCurrency,
                  child: const Text('Convert'),
                ),
                if (conversionResult != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    conversionResult,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
