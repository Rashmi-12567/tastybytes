import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasty_bites/services/favorites_services.dart';
import 'package:tasty_bites/screens/recipe_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FavoritesService.getFavorites(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final favorites = snapshot.data!.docs;

        if (favorites.isEmpty) {
          return const Center(
            child: Text("No favorite recipes ❤️"),
          );
        }

        return ListView.builder(
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final recipe =
                favorites[index].data() as Map<String, dynamic>;

            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
  leading: Image.network(
    recipe["strMealThumb"] ?? "",
    width: 60,
    height: 60,
    fit: BoxFit.cover,
  ),

  title: Text(recipe["strMeal"] ?? ""),
  subtitle: Text(recipe["strCategory"] ?? ""),

  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecipeDetailPage(
          recipe: recipe,
        ),
      ),
    );
  },

  trailing: IconButton(
    icon: const Icon(
      Icons.delete,
      color: Colors.red,
    ),
    onPressed: () {
      FavoritesService.removeFavorite(
        recipe["idMeal"],
      );
    },
  ),
)
            );
          },
        );
      },
    );
  }
}