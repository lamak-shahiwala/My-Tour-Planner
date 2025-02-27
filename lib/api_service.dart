import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.176.95:8000";  // Replace with your local IP

  Future<String> fetchData() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/test-db"));

      if (response.statusCode == 200) {
        return response.body;  // Successfully fetched data
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
