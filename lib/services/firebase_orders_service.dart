import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hello_world/models/order.dart' as model;

class FirebaseOrdersService {
  static final FirebaseOrdersService _instance = FirebaseOrdersService._internal();
  factory FirebaseOrdersService() => _instance;
  FirebaseOrdersService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'orders';

  // Crear una nueva orden
  Future<String?> createOrder(model.Order order) async {
    try {
      final docRef = await _firestore.collection(_collection).add({
        'items': order.items.map((item) => {
          'productId': item.productId,
          'name': item.name,
          'imageUrl': item.imageUrl,
          'quantity': item.quantity,
          'unitPrice': item.unitPrice,
        }).toList(),
        'total': order.total,
        'shippingAddress': order.shippingAddress,
        'paymentMethod': order.paymentMethod,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      print('Error creando orden: $e');
      return null;
    }
  }

  // Obtener todas las órdenes como Stream
  Stream<List<model.Order>> getAllStream() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return _orderFromFirestore(doc);
      }).toList();
    });
  }

  // Obtener órdenes (una sola vez)
  Future<List<model.Order>> getAll() async {
    final snapshot = await _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .get();
    
    return snapshot.docs.map((doc) => _orderFromFirestore(doc)).toList();
  }

  // Obtener una orden por ID
  Future<model.Order?> getById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) return null;
      return _orderFromFirestore(doc);
    } catch (e) {
      print('Error obteniendo orden: $e');
      return null;
    }
  }

  // Actualizar estado de orden
  Future<bool> updateStatus(String orderId, String status) async {
    try {
      await _firestore.collection(_collection).doc(orderId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Error actualizando estado: $e');
      return false;
    }
  }

  // Convertir documento de Firestore a Order
  model.Order _orderFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final itemsList = data['items'] as List<dynamic>;
    
    return model.Order(
      id: doc.id,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      items: itemsList.map((item) {
        return model.OrderItem(
          productId: item['productId'] ?? '',
          name: item['name'] ?? '',
          imageUrl: item['imageUrl'] ?? '',
          quantity: item['quantity'] ?? 0,
          unitPrice: (item['unitPrice'] ?? 0).toDouble(),
        );
      }).toList(),
      total: (data['total'] ?? 0).toDouble(),
      shippingAddress: data['shippingAddress'],
      paymentMethod: data['paymentMethod'],
    );
  }
}

