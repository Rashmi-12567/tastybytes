import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecentlyDeletedPage extends StatelessWidget {
  const RecentlyDeletedPage({super.key});

  Future<void> restoreRecipe(
    String docId,
    Map<String, dynamic> recipe,
  ) async {
    await FirebaseFirestore.instance
        .collection("recipes")
        .add({
      ...recipe,
    });

    await FirebaseFirestore.instance
        .collection("deleted_recipes")
        .doc(docId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Recently Deleted",
        ),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("deleted_recipes")
            .orderBy(
              "deletedAt",
              descending: true,
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "No deleted recipes",
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final recipe =
                  docs[index].data()
                      as Map<String, dynamic>;

              return Card(
                margin:
                    const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(
                    recipe["name"] ?? "",
                  ),
                  subtitle: Text(
                    recipe["category"] ?? "",
                  ),
                  trailing:
                      ElevatedButton.icon(
                    icon: const Icon(
                      Icons.restore,
                    ),
                    label:
                        const Text("Restore"),
                    onPressed: () async {
                      await restoreRecipe(
                        docs[index].id,
                        recipe,
                      );

                      ScaffoldMessenger.of(
                              context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Recipe Restored",
                          ),
                        ),
                      );
                    },
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