import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:share_plus/share_plus.dart';

class RecipeDetailPage extends StatefulWidget {
  final Map<String, dynamic> recipe;

  const RecipeDetailPage({
    super.key,
    required this.recipe,
  });

  @override
  State<RecipeDetailPage> createState() =>
      _RecipeDetailPageState();
}

class _RecipeDetailPageState
    extends State<RecipeDetailPage> {
      Future<void> submitRating(double newRating) async {
  final recipeId = widget.recipe["idMeal"];

  final docRef = FirebaseFirestore.instance
      .collection("recipe_ratings")
      .doc(recipeId);

  final snapshot = await docRef.get();

  double currentRating = 0;
  int currentCount = 0;

  if (snapshot.exists) {
    currentRating =
        (snapshot["rating"] ?? 0).toDouble();

    currentCount =
        (snapshot["ratingCount"] ?? 0);
  }

  final totalStars =
      currentRating * currentCount +
      newRating;

  final updatedCount = currentCount + 1;

  final updatedRating =
      totalStars / updatedCount;

  await docRef.set({
    "rating": updatedRating,
    "ratingCount": updatedCount,
  });
}

void showRatingDialog() {
  double userRating = 5;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Rate Recipe"),
        content: RatingBar.builder(
          initialRating: 5,
          minRating: 1,
          allowHalfRating: true,
          itemCount: 5,
          itemBuilder: (context, _) =>
              const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            userRating = rating;
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await submitRating(userRating);

              if (mounted) {
                Navigator.pop(context);

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Thanks for rating ⭐",
                    ),
                  ),
                );
              }
            },
            child: const Text("Submit"),
          ),
        ],
      );
    },
  );
}

  String getCookingTime(String category) {
    switch (category) {
      case "Chicken":
        return "45 min";
      case "Beef":
        return "60 min";
      case "Dessert":
        return "20 min";
      case "Seafood":
        return "35 min";
      default:
        return "30 min";
    }
  }
  void shareRecipe() {
  final recipeText = '''
🍲 ${widget.recipe["strMeal"]}

Category: ${widget.recipe["strCategory"]}

Instructions:
${widget.recipe["strInstructions"]}

Shared from TastyBites ❤️
''';

  Share.share(recipeText);
}

  @override
  Widget build(BuildContext context) {
    List<Widget> ingredients = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = widget.recipe["strIngredient$i"];
      final measure = widget.recipe["strMeasure$i"];

      if (ingredient != null &&
          ingredient.toString().trim().isNotEmpty) {
        ingredients.add(
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.restaurant_menu,
                  color: Colors.orange,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "$ingredient ($measure)",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Colors.orange,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.recipe["strMeal"] ?? "",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Image.network(
                widget.recipe["strMealThumb"],
                fit: BoxFit.cover,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.recipe["strMeal"] ?? "",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

StreamBuilder<DocumentSnapshot>(
  stream: FirebaseFirestore.instance
      .collection("recipe_ratings")
      .doc(widget.recipe["idMeal"])
      .snapshots(),
  builder: (context, snapshot) {
    double rating = 0;
    int count = 0;

    if (snapshot.hasData &&
        snapshot.data!.exists) {
      final data =
          snapshot.data!.data()
              as Map<String, dynamic>;

      rating =
          (data["rating"] ?? 0).toDouble();

      count =
          data["ratingCount"] ?? 0;
    }

    return Row(
      children: [
        const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        const SizedBox(width: 5),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(" ($count ratings)"),
      ],
    );
  },
),

                  const SizedBox(height: 15),

                 Row(
  children: [
    Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "⏱ ${getCookingTime(widget.recipe["strCategory"] ?? "")}",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    const SizedBox(width: 10),

    Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        widget.recipe["strCategory"] ?? "Recipe",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ],
),
const SizedBox(height: 20),

SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    onPressed: () {
  print("Rate button clicked");
  showRatingDialog();
},
    icon: const Icon(Icons.star),
    label: const Text("Rate Recipe"),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.orange,
      foregroundColor: Colors.white,
    ),
  ),
),
SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    icon: const Icon(Icons.share),
    label: const Text("Share Recipe"),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
    ),
    onPressed: shareRecipe,
  ),
),

const SizedBox(height: 20),

                  const SizedBox(height: 30),

                  const Text(
                    "Ingredients",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  ...ingredients,

                  const SizedBox(height: 30),

                  const Text(
                    "Instructions",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      widget.recipe["strInstructions"] ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.7,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}