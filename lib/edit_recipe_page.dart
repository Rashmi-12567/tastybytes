import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditRecipePage extends StatefulWidget {
final String recipeId;
final Map<String, dynamic> recipe;

const EditRecipePage({
super.key,
required this.recipeId,
required this.recipe,
});

@override
State<EditRecipePage> createState() =>
_EditRecipePageState();
}

class _EditRecipePageState
extends State<EditRecipePage> {
late TextEditingController nameController;
late TextEditingController categoryController;
late TextEditingController timeController;
late TextEditingController ingredientsController;
late TextEditingController instructionsController;

bool isLoading = false;

@override
void initState() {
super.initState();

nameController = TextEditingController(
  text: widget.recipe["name"],
);

categoryController = TextEditingController(
  text: widget.recipe["category"],
);

timeController = TextEditingController(
  text: widget.recipe["time"],
);

ingredientsController =
    TextEditingController(
  text: widget.recipe["ingredients"],
);

instructionsController =
    TextEditingController(
  text: widget.recipe["instructions"],
);

}

Future<void> updateRecipe() async {
setState(() {
isLoading = true;
});


await FirebaseFirestore.instance
    .collection("recipes")
    .doc(widget.recipeId)
    .update({
  "name": nameController.text.trim(),
  "category":
      categoryController.text.trim(),
  "time": timeController.text.trim(),
  "ingredients":
      ingredientsController.text.trim(),
  "instructions":
      instructionsController.text.trim(),
});

if (mounted) {
  ScaffoldMessenger.of(context)
      .showSnackBar(
    const SnackBar(
      content:
          Text("Recipe Updated Successfully"),
    ),
  );

  Navigator.pop(context);
}

setState(() {
  isLoading = false;
});


}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor:
const Color(0xFFFFF3E0),


  appBar: AppBar(
    backgroundColor: Colors.orange,
    title: const Text(
      "Edit Recipe",
    ),
  ),

  body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        TextField(
          controller: nameController,
          decoration:
              const InputDecoration(
            labelText: "Recipe Name",
          ),
        ),

        const SizedBox(height: 15),

        TextField(
          controller: categoryController,
          decoration:
              const InputDecoration(
            labelText: "Category",
          ),
        ),

        const SizedBox(height: 15),

        TextField(
          controller: timeController,
          decoration:
              const InputDecoration(
            labelText:
                "Cooking Time",
          ),
        ),

        const SizedBox(height: 15),

        TextField(
          controller:
              ingredientsController,
          maxLines: 4,
          decoration:
              const InputDecoration(
            labelText:
                "Ingredients",
          ),
        ),

        const SizedBox(height: 15),

        TextField(
          controller:
              instructionsController,
          maxLines: 6,
          decoration:
              const InputDecoration(
            labelText:
                "Instructions",
          ),
        ),

        const SizedBox(height: 25),

        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.orange,
            ),
            onPressed: isLoading
                ? null
                : updateRecipe,
            child: isLoading
                ? const CircularProgressIndicator(
                    color:
                        Colors.white,
                  )
                : const Text(
                    "Update Recipe",
                    style:
                        TextStyle(
                      color:
                          Colors.white,
                      fontSize: 18,
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
