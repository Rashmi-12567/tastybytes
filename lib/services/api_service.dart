import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Search recipes
  static Future<List<Map<String, dynamic>>> getRecipes(
      String query) async {
    try {
      final url = Uri.parse(
        "https://www.themealdb.com/api/json/v1/1/search.php?s=$query",
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["meals"] != null) {
          return List<Map<String, dynamic>>.from(
            data["meals"],
          );
        }
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  // Get random recipes
  static Future<List<Map<String, dynamic>>>
      getRandomRecipes() async {
    List<Map<String, dynamic>> recipes = [];

    try {
      for (int i = 0; i < 12; i++) {
        final response = await http.get(
          Uri.parse(
            "https://www.themealdb.com/api/json/v1/1/random.php",
          ),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          if (data["meals"] != null) {
            recipes.add(
              Map<String, dynamic>.from(
                data["meals"][0],
              ),
            );
          }
        }
      }
    } catch (e) {
      return [];
    }

    return recipes;
  }
}