import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/quote-model.dart';

class QuoteService {
  static Future<QuoteModel?> fetchQuote() async {
    try {
      final response =
      await http.get(Uri.parse('https://zenquotes.io/api/quotes'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return QuoteModel.fromJson(data[0]);
        } else {
          print("No quote data found.");
          return null;
        }
      } else {
        print("Failed to load quote: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching quote: $e");
      return null;
    }
  }
}