import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hello_world/models/product.dart';

class FirebaseProductsService {
  static final FirebaseProductsService _instance = FirebaseProductsService._internal();
  factory FirebaseProductsService() => _instance;
  FirebaseProductsService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'products';

  // Obtener todos los productos activos como Stream
  Stream<List<Product>> getAllStream() {
    return _firestore
        .collection(_collection)
        .where('active', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Product(
          id: doc.id,
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          price: (data['price'] ?? 0).toDouble(),
          category: data['category'] ?? '',
        );
      }).toList();
    });
  }

  // Obtener todos los productos (una sola vez)
  Future<List<Product>> getAll() async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('active', isEqualTo: true)
        .get();
    
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Product(
        id: doc.id,
        name: data['name'] ?? '',
        description: data['description'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
        price: (data['price'] ?? 0).toDouble(),
        category: data['category'] ?? '',
      );
    }).toList();
  }

  // Obtener un producto por ID
  Future<Product?> getById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) return null;
      
      final data = doc.data()!;
      return Product(
        id: doc.id,
        name: data['name'] ?? '',
        description: data['description'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
        price: (data['price'] ?? 0).toDouble(),
        category: data['category'] ?? '',
      );
    } catch (e) {
      print('Error obteniendo producto: $e');
      return null;
    }
  }

  // Agregar un producto (para admin)
  Future<String?> addProduct(Product product) async {
    try {
      final docRef = await _firestore.collection(_collection).add({
        'name': product.name,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'category': product.category,
        'active': true,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      print('Error agregando producto: $e');
      return null;
    }
  }

  // Actualizar un producto
  Future<bool> updateProduct(String id, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection(_collection).doc(id).update({
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Error actualizando producto: $e');
      return false;
    }
  }
}

