import 'package:flutter/material.dart';
import 'dart:convert';


class UserRecipeDetailPage extends StatelessWidget {
final Map<String, dynamic> recipe;

const UserRecipeDetailPage({
super.key,
required this.recipe,
});

@override
Widget build(BuildContext context) {
final ingredients =
(recipe["ingredients"] ?? "")
.toString()
.split("\n");


final instructions =
    (recipe["instructions"] ?? "")
        .toString()
        .split("\n");

return Scaffold(
  backgroundColor: const Color(0xFFFFF8F0),

  body: CustomScrollView(
    slivers: [
      SliverAppBar(
        expandedHeight: 350,
        pinned: true,
        backgroundColor: Colors.orange,

        flexibleSpace: FlexibleSpaceBar(
          background: Stack(
            fit: StackFit.expand,
            children: [
              recipe["imageBase64"] != null &&
        recipe["imageBase64"]
            .toString()
            .isNotEmpty
    ? Image.memory(
        base64Decode(
          recipe["imageBase64"],
        ),
        fit: BoxFit.cover,
      )
    : Container(
        color: Colors.orange.shade100,
        child: const Icon(
          Icons.restaurant,
          size: 120,
          color: Colors.orange,
        ),
      ),

              Container(
                decoration:
                    const BoxDecoration(
                  gradient:
                      LinearGradient(
                    begin:
                        Alignment.topCenter,
                    end: Alignment
                        .bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black87,
                    ],
                  ),
                ),
              ),

              Positioned(
                left: 20,
                bottom: 40,
                right: 20,
                child: Text(
                  recipe["name"] ?? "",
                  style:
                      const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      SliverToBoxAdapter(
        child: Padding(
          padding:
              const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.all(
                        20),
                decoration:
                    BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius
                          .circular(25),
                  boxShadow: const [
                    BoxShadow(
                      color:
                          Colors.black12,
                      blurRadius: 10,
                      offset:
                          Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceAround,
                  children: [
                    Column(
                      children: [
                        const Icon(
                          Icons.category,
                          color:
                              Colors.orange,
                        ),
                        const SizedBox(
                            height: 5),
                        Text(
                          recipe["category"] ??
                              "",
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ],
                    ),

                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey
                          .shade300,
                    ),

                    Column(
                      children: [
                        const Icon(
                          Icons.timer,
                          color:
                              Colors.green,
                        ),
                        const SizedBox(
                            height: 5),
                        Text(
                          recipe["time"] ??
                              "",
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(
                  height: 25),

              const Text(
                "🥕 Ingredients",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                  height: 15),

              Container(
                padding:
                    const EdgeInsets.all(
                        20),
                decoration:
                    BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius
                          .circular(25),
                  boxShadow: const [
                    BoxShadow(
                      color:
                          Colors.black12,
                      blurRadius: 10,
                      offset:
                          Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children:
                      ingredients.map((item) {
                    if (item
                        .trim()
                        .isEmpty) {
                      return const SizedBox();
                    }

                    return Padding(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors
                                .green,
                          ),
                          const SizedBox(
                              width: 10),
                          Expanded(
                            child: Text(
                              item,
                              style:
                                  const TextStyle(
                                fontSize:
                                    16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(
                  height: 25),

              const Text(
                "👨‍🍳 Cooking Steps",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                  height: 15),

              ListView.builder(
                itemCount:
                    instructions.length,
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                itemBuilder:
                    (context, index) {
                  if (instructions[index]
                      .trim()
                      .isEmpty) {
                    return const SizedBox();
                  }

                  return Container(
                    margin:
                        const EdgeInsets.only(
                      bottom: 15,
                    ),
                    padding:
                        const EdgeInsets.all(
                            16),
                    decoration:
                        BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius
                              .circular(
                                  20),
                      boxShadow: const [
                        BoxShadow(
                          color:
                              Colors.black12,
                          blurRadius: 8,
                          offset:
                              Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              Colors.orange,
                          child: Text(
                            "${index + 1}",
                            style:
                                const TextStyle(
                              color: Colors
                                  .white,
                            ),
                          ),
                        ),

                        const SizedBox(
                            width: 15),

                        Expanded(
                          child: Text(
                            instructions[
                                index],
                            style:
                                const TextStyle(
                              fontSize:
                                  16,
                              height:
                                  1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(
                  height: 30),
            ],
          ),
        ),
      ),
    ],
  ),
);


}
}
