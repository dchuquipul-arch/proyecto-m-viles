import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFavoritesService {
  static final FirebaseFavoritesService _instance =
      FirebaseFavoritesService._internal();
  factory FirebaseFavoritesService() => _instance;
  FirebaseFavoritesService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Colección de usuarios -> favoritos
  // Estructura: users/{userId}/favorites/{productId}

  /// Agrega un producto a favoritos
  Future<void> addFavorite(String userId, String productId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(productId)
          .set({
            'productId': productId,
            'addedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      print('Error adding favorite: $e');
    }
  }

  /// Elimina un producto de favoritos
  Future<void> removeFavorite(String userId, String productId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(productId)
          .delete();
    } catch (e) {
      print('Error removing favorite: $e');
    }
  }

  /// Verifica si un producto es favorito (Stream para tiempo real)
  Stream<bool> isFavoriteStream(String userId, String productId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(productId)
        .snapshots()
        .map((doc) => doc.exists);
  }

  /// Alternar favorito (toggle)
  Future<void> toggleFavorite(String userId, String productId) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(productId);

    final doc = await docRef.get();
    if (doc.exists) {
      await docRef.delete();
    } else {
      await docRef.set({
        'productId': productId,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
