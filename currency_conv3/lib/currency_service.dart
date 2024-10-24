import 'dart:convert'; 
import 'package:http/http.dart' as http;

class CurrencyService {
  
  final String apiKey = '81f89368c0msh6bd45d0f60fbf94p1a679ejsn509b1db98c68';
  final String baseUrl = 'https://currency-converter-pro1.p.rapidapi.com';

  Future<Map<String, String>> fetchCurrencies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/currencies'),
      headers: {
        'x-rapidapi-key': apiKey,
        'x-rapidapi-host': 'currency-converter-pro1.p.rapidapi.com',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Map<String, String>.from(data['result']); 
    } else {
      print('Failed to load currencies: ${response.statusCode} ${response.body}');
      throw Exception('Failed to load currencies');
    }
  }
  
  Future<Map<String, dynamic>> fetchLatestRates(String base) async {
    final response = await http.get(
      Uri.parse('$baseUrl/latest?base=$base'),
      headers: {
        'x-rapidapi-key': apiKey,
        'x-rapidapi-host': 'currency-converter-pro1.p.rapidapi.com',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Failed to load rates: ${response.statusCode} ${response.body}'); 
      throw Exception('Failed to load rates');
    }
  }

  Future<double> convertCurrency(String from, String to, double amount) async {
    final response = await http.get(
      Uri.parse('$baseUrl/convert?from=$from&to=$to&amount=$amount'),
      headers: {
        'x-rapidapi-key': apiKey,
        'x-rapidapi-host': 'currency-converter-pro1.p.rapidapi.com',
      },
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result['result']; 
    } else {
      print('Failed to convert currency: ${response.statusCode} ${response.body}'); 
      throw Exception('Failed to convert currency');
    }
  }
}
