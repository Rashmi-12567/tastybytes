import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final timeController = TextEditingController();
  final ingredientsController = TextEditingController();
  final instructionsController = TextEditingController();

  File? selectedImage;
  Uint8List? webImage;

  bool isUploading = false;

  Future<void> pickImage() async {
  final picker = ImagePicker();

  final XFile? image = await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 40,
  );

  if (image == null) return;

  if (kIsWeb) {
    webImage = await image.readAsBytes();
  } else {
    selectedImage = File(image.path);
  }

  setState(() {});
}

  

  Future<void> saveRecipe() async {
  if (nameController.text.trim().isEmpty ||
      categoryController.text.trim().isEmpty ||
      timeController.text.trim().isEmpty ||
      ingredientsController.text.trim().isEmpty ||
      instructionsController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please fill all fields"),
      ),
    );
    return;
  }

  if ((!kIsWeb && selectedImage == null) ||
      (kIsWeb && webImage == null)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please select an image"),
      ),
    );
    return;
  }

  setState(() {
    isUploading = true;
  });

  try {
    String imageBase64 = "";

    if (kIsWeb) {
      imageBase64 = base64Encode(webImage!);
    } else {
      imageBase64 = base64Encode(
        await selectedImage!.readAsBytes(),
      );
    }

    await FirebaseFirestore.instance
        .collection("recipes")
        .add({
      "name": nameController.text.trim(),
      "category": categoryController.text.trim(),
      "time": timeController.text.trim(),
      "ingredients":
          ingredientsController.text.trim(),
      "instructions":
          instructionsController.text.trim(),
      "imageBase64": imageBase64,
      "createdBy":
          FirebaseAuth.instance.currentUser?.uid,
      "createdAt": Timestamp.now(),
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Recipe Added Successfully 🍲",
        ),
      ),
    );

    Navigator.pop(context);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error: $e"),
      ),
    );
  }

  if (mounted) {
    setState(() {
      isUploading = false;
    });
  }
}
  @override
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    timeController.dispose();
    ingredientsController.dispose();
    instructionsController.dispose();
    super.dispose();
  }

  Widget buildImagePreview() {
    if (kIsWeb) {
      if (webImage == null) {
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo,
              size: 60,
              color: Colors.orange,
            ),
            SizedBox(height: 10),
            Text("Select Recipe Image"),
          ],
        );
      }

      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.memory(
          webImage!,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      );
    }

    if (selectedImage == null) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_a_photo,
            size: 60,
            color: Colors.orange,
          ),
          SizedBox(height: 10),
          Text("Select Recipe Image"),
        ],
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.file(
        selectedImage!,
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Add Recipe"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange),
                  borderRadius:
                      BorderRadius.circular(15),
                ),
                child: buildImagePreview(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Recipe Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: timeController,
              decoration: const InputDecoration(
                labelText: "Cooking Time",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: ingredientsController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Ingredients",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: instructionsController,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: "Instructions",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                onPressed:
                    isUploading ? null : saveRecipe,
                child: isUploading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Save Recipe",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}