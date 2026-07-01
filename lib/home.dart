import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasty_bites/add_recipe_page.dart';
import 'package:tasty_bites/favorite.dart';

import 'package:tasty_bites/services/api_service.dart';
import 'package:tasty_bites/services/favorites_services.dart';
import 'package:tasty_bites/screens/recipe_detail_page.dart';
import 'package:tasty_bites/my_recipes_page.dart';
import 'package:tasty_bites/profile_page.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  String username = "User";

  List recipes = [];
  bool isLoading = false;

  int currentIndex = 0;

  TextEditingController searchController = TextEditingController();

  @override
  
  void initState() {
    super.initState();
    getUserName();
    fetchRecipes();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // 👤 USER NAME
  Future<void> getUserName() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

    if (snapshot.exists && mounted) {
      setState(() {
        username = snapshot["username"] ?? "User";
      });
    }
  }

  // 🍲 LOAD RECIPES
  Future<void> fetchRecipes() async {
  setState(() => isLoading = true);

  try {
    final data =
        await ApiService.getRandomRecipes();

    setState(() {
      recipes = data;
      isLoading = false;
    });
  } catch (e) {
    setState(() {
      recipes = [];
      isLoading = false;
    });
  }
}
  // 🔍 SEARCH
  void searchRecipes(String query) async {
    if (query.trim().isEmpty) return;

    setState(() => isLoading = true);

    try {
      final data = await ApiService.getRecipes(query.trim());

      setState(() {
        recipes = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        recipes = [];
        isLoading = false;
      });
    }
  }

  // 🏷️ CATEGORY BUTTON
  Widget categoryButton(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        onPressed: () => searchRecipes(category),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(category),
      ),
    );
  }

  // 🍲 HOME UI
  Widget buildHome() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
  width: double.infinity,
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    gradient: const LinearGradient(
      colors: [
        Colors.orange,
        Colors.deepOrange,
      ],
    ),
    borderRadius:
        BorderRadius.circular(25),
  ),
  child: Column(
    crossAxisAlignment:
        CrossAxisAlignment.start,
    children: [
      Text(
        "Hello, $username 👋",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight:
              FontWeight.bold,
        ),
      ),
      const SizedBox(height: 5),
      const Text(
        "Discover delicious recipes today",
        style: TextStyle(
          color: Colors.white70,
          fontSize: 16,
        ),
      ),
    ],
  ),
),

          const SizedBox(height: 15),

          TextField(
            controller: searchController,
            onSubmitted: searchRecipes,
            decoration: InputDecoration(
  hintText: "Search recipes...",
  filled: true,
  fillColor: Colors.white,
  prefixIcon:
      const Icon(Icons.search),
  suffixIcon: IconButton(
    icon: const Icon(Icons.send),
    onPressed: () =>
        searchRecipes(
            searchController.text),
  ),
  border: OutlineInputBorder(
    borderRadius:
        BorderRadius.circular(30),
    borderSide: BorderSide.none,
  ),
),
          ),

          const SizedBox(height: 20),
          SizedBox(
  height: 50,
  child: ListView(
    scrollDirection: Axis.horizontal,
    children: [
      categoryButton("Chicken"),
      categoryButton("Beef"),
      categoryButton("Seafood"),
      categoryButton("Dessert"),
      categoryButton("Pasta"),
      categoryButton("Vegetarian"),
    ],
  ),
),

const SizedBox(height: 15),

          Expanded(
  child: isLoading
      ? const Center(
          child: CircularProgressIndicator(),
        )
      : recipes.isEmpty
          ? const Center(
              child: Text("No recipes found"),
            )
          : GridView.builder(
              padding: const EdgeInsets.only(top: 10),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 2.0,
              ),
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe =
                    Map<String, dynamic>.from(
                  recipes[index],
                );

                return InkWell(
                  borderRadius:
                      BorderRadius.circular(20),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            RecipeDetailPage(
                          recipe: recipe,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 5,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                              20),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Expanded(
                          flex: 6,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    const BorderRadius
                                        .only(
                                  topLeft:
                                      Radius.circular(
                                          20),
                                  topRight:
                                      Radius.circular(
                                          20),
                                ),
                                child: Image.network(
                                  recipe[
                                          "strMealThumb"] ??
                                      "",
                                  width:
                                      double.infinity,
                                  height:
                                      double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child:
                                    CircleAvatar(
                                  radius: 18,
                                  backgroundColor:
                                      Colors.white,
                                  child:
                                      IconButton(
                                    icon:
                                        const Icon(
                                      Icons
                                          .favorite_border,
                                      size: 18,
                                      color: Colors
                                          .red,
                                    ),
                                    onPressed:
                                        () async {
                                      await FavoritesService
                                          .addFavorite(
                                              recipe);

                                      ScaffoldMessenger.of(
                                              context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text(
                                            "Added to Favorites ❤️",
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding:
                                const EdgeInsets
                                    .all(10),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text(
                                  recipe[
                                          "strMeal"] ??
                                      "",
                                  maxLines: 1,
                                  overflow:
                                      TextOverflow
                                          .ellipsis,
                                  style:
                                      const TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                    horizontal:
                                        10,
                                    vertical: 4,
                                  ),
                                  decoration:
                                      BoxDecoration(
                                    color: Colors
                                        .orange,
                                    borderRadius:
                                        BorderRadius.circular(
                                            20),
                                  ),
                                  child: Text(
                                    recipe["strCategory"] ??
                                        "",
                                    style:
                                        const TextStyle(
                                      color: Colors
                                          .white,
                                      fontSize:
                                          12,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  children:
                                      const [
                                    Icon(
                                      Icons.star,
                                      color: Colors
                                          .orange,
                                      size: 16,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      "4.8",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),

      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("🍲 TastyBites"),
        actions: [
          IconButton(
            onPressed: fetchRecipes,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
body: currentIndex == 0
    ? buildHome()
    : currentIndex == 1
        ? const FavoritesPage()
        : currentIndex == 2
            ? const MyRecipesPage()
            : const ProfilePage(),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
  BottomNavigationBarItem(
    icon: Icon(Icons.home),
    label: "Home",
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.favorite),
    label: "Favorites",
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.restaurant_menu),
    label: "My Recipes",
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.person),
    label: "Profile",
  ),
],
      ),
      
     floatingActionButton:
    FloatingActionButton.extended(
  backgroundColor: Colors.orange,
  icon: const Icon(Icons.add),
  label: const Text("Add Recipe"),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const AddRecipePage(),
      ),
    );
  },
),
    );
  }
}