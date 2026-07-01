import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "https://www.themealdb.com/api/json/v1/1";

  static Future<List<dynamic>> getRecipes(String query) async {
    final response = await http.get(
      Uri.parse("$baseUrl/search.php?s=$query"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["meals"] ?? [];
    } else {
      throw Exception("Failed to load recipes");
    }
  }
}