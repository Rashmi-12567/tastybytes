import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_recipe_detail_page.dart';
import 'dart:convert';
import 'edit_recipe_page.dart';

class MyRecipesPage extends StatelessWidget {
  const MyRecipesPage({super.key});

  Future<void> deleteRecipe(
    String docId,
    Map<String, dynamic> recipe,
  ) async {
    // Move to deleted_recipes
    await FirebaseFirestore.instance
        .collection("deleted_recipes")
        .add({
      ...recipe,
      "deletedAt": Timestamp.now(),
    });

    // Delete from recipes
    await FirebaseFirestore.instance
        .collection("recipes")
        .doc(docId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),

      appBar: AppBar(
        title: const Text("My Recipes"),
        backgroundColor: Colors.orange,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("recipes")
            .orderBy(
              "createdAt",
              descending: true,
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "No recipes added yet 🍲",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final recipe =
                  docs[index].data()
                      as Map<String, dynamic>;

              return Card(
                elevation: 4,
                margin:
                    const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(18),
                ),
                child: InkWell(
                  borderRadius:
                      BorderRadius.circular(18),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            UserRecipeDetailPage(
                          recipe: recipe,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Recipe Image
                        ClipRRect(
  borderRadius: BorderRadius.circular(12),
  child: recipe["imageBase64"] != null
      ? Image.memory(
          base64Decode(recipe["imageBase64"]),
          width: 90,
          height: 90,
          fit: BoxFit.cover,
        )
      : Container(
          width: 90,
          height: 90,
          color: Colors.orange.shade100,
          child: const Icon(
            Icons.restaurant,
            size: 40,
            color: Colors.orange,
          ),
        ),
),
                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                recipe["name"] ?? "",
                                style:
                                    const TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),

                              const SizedBox(
                                  height: 6),

                              Container(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration:
                                    BoxDecoration(
                                  color: Colors.orange
                                      .shade100,
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                              20),
                                ),
                                child: Text(
                                  recipe["category"] ??
                                      "",
                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.orange,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                  height: 8),

                              Row(
                                children: [
                                  const Icon(
                                    Icons.timer,
                                    size: 18,
                                    color:
                                        Colors.grey,
                                  ),
                                  const SizedBox(
                                      width: 5),
                                  Text(
                                    recipe["time"] ??
                                        "",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        PopupMenuButton(
                          itemBuilder: (context) =>
                              [
                            const PopupMenuItem(
  value: "edit",
  child: Row(
    children: [
      Icon(
        Icons.edit,
        color: Colors.blue,
      ),
      SizedBox(width: 10),
      Text("Edit"),
    ],
  ),
),

const PopupMenuItem(
  value: "delete",
  child: Row(
    children: [
      Icon(
        Icons.delete,
        color: Colors.red,
      ),
      SizedBox(width: 10),
      Text("Delete"),
    ],
  ),
),
                          ],
                          onSelected: (value) async {
                            if (value == "edit") {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => EditRecipePage(
        recipeId: docs[index].id,
        recipe: recipe,
      ),
    ),
  );
}
                            if (value ==
                                "delete") {
                              final confirm =
                                  await showDialog<
                                      bool>(
                                context: context,
                                builder:
                                    (context) =>
                                        AlertDialog(
                                  title: const Text(
                                      "Delete Recipe"),
                                  content:
                                      const Text(
                                    "Move recipe to Recently Deleted?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () {
                                        Navigator.pop(
                                            context,
                                            false);
                                      },
                                      child:
                                          const Text(
                                              "Cancel"),
                                    ),
                                    ElevatedButton(
                                      style:
                                          ElevatedButton
                                              .styleFrom(
                                        backgroundColor:
                                            Colors
                                                .red,
                                      ),
                                      onPressed:
                                          () {
                                        Navigator.pop(
                                            context,
                                            true);
                                      },
                                      child:
                                          const Text(
                                        "Delete",
                                        style:
                                            TextStyle(
                                          color: Colors
                                              .white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm ==
                                  true) {
                                await deleteRecipe(
                                  docs[index].id,
                                  recipe,
                                );

                                if (context
                                    .mounted) {
                                  ScaffoldMessenger
                                          .of(
                                              context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Recipe moved to Recently Deleted",
                                      ),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}