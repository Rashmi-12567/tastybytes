import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ❤️ ADD FAVORITE
  static Future<void> addFavorite(Map<String, dynamic> recipe) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await _firestore
        .collection("users")
        .doc(uid)
        .collection("favorites")
        .doc(recipe["idMeal"])
        .set(recipe);
  }

  // 📥 GET FAVORITES (REAL TIME)
  static Stream<QuerySnapshot> getFavorites() {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return _firestore
        .collection("users")
        .doc(uid)
        .collection("favorites")
        .snapshots();
  }

  // ❌ REMOVE FAVORITE
  static Future<void> removeFavorite(String idMeal) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await _firestore
        .collection("users")
        .doc(uid)
        .collection("favorites")
        .doc(idMeal)
        .delete();
  }

  static Future<void> toggleFavorite(recipe) async {}
}