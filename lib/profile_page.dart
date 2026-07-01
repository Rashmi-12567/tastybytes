import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'recently_deleted_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int recipeCount = 0;
  int favoriteCount = 0;
  int ratingCount = 0;

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  Future<void> loadStats() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    // My Recipes Count
    final recipes = await FirebaseFirestore.instance
        .collection("recipes")
        .where("createdBy", isEqualTo: uid)
        .get();

    // Favorites Count
    final favorites = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("favorites")
        .get();

    // Ratings Count
    final ratings = await FirebaseFirestore.instance
        .collection("recipe_ratings")
        .get();

    int totalRatings = 0;

    for (var doc in ratings.docs) {
      final data = doc.data();

      totalRatings +=
          (data["ratingCount"] ?? 0) as int;
    }

    setState(() {
      recipeCount = recipes.docs.length;
      favoriteCount = favorites.docs.length;
      ratingCount = totalRatings;
    });
  }

  Widget statCard(
    String value,
    String title,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 30,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),

      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              !snapshot.data!.exists ||
              snapshot.data!.data() == null) {
            return const Center(
              child: Text("User data not found"),
            );
          }

          final data =
              snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 50),

                  // Profile Avatar
                  const CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.orange,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    data["username"] ?? "User",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    user.email ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Statistics Cards
                  Row(
                    children: [
                      statCard(
                        recipeCount.toString(),
                        "Recipes",
                        Icons.restaurant_menu,
                        Colors.orange,
                      ),
                      statCard(
                        favoriteCount.toString(),
                        "Favorites",
                        Icons.favorite,
                        Colors.red,
                      ),
                      statCard(
                        ratingCount.toString(),
                        "Ratings",
                        Icons.star,
                        Colors.amber,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Achievement Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.emoji_events,
                          color: Colors.amber,
                          size: 45,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Food Explorer 🍲",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Keep discovering and sharing delicious recipes!",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Account Information
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.person,
                            color: Colors.orange,
                          ),
                          title: const Text("Username"),
                          subtitle: Text(
                            data["username"] ?? "",
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(
                            Icons.email,
                            color: Colors.orange,
                          ),
                          title: const Text("Email"),
                          subtitle: Text(
                            user.email ?? "",
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                  Container(
  width: double.infinity,
  margin: const EdgeInsets.only(top: 20),
  child: ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.orange,
      minimumSize:
          const Size(double.infinity, 55),
    ),
    icon: const Icon(Icons.delete),
    label: const Text(
      "Recently Deleted",
      style: TextStyle(fontSize: 16),
    ),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const RecentlyDeletedPage(),
        ),
      );
    },
  ),
),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () async {
                        await FirebaseAuth.instance
                            .signOut();
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}