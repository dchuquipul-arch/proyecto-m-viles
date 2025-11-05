import 'package:flutter/foundation.dart';
import 'package:hello_world/models/product.dart';

class CartLine {
  final Product product;
  int quantity;
  CartLine({required this.product, this.quantity = 1});

  double get lineTotal => product.price * quantity;
}

class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final ValueNotifier<List<CartLine>> lines = ValueNotifier<List<CartLine>>(<CartLine>[]);

  void add(Product product, {int qty = 1}) {
    final current = List<CartLine>.from(lines.value);
    final idx = current.indexWhere((l) => l.product.id == product.id);
    if (idx >= 0) {
      current[idx].quantity += qty;
    } else {
      current.add(CartLine(product: product, quantity: qty));
    }
    lines.value = current;
  }

  void remove(String productId) {
    final current = List<CartLine>.from(lines.value)..removeWhere((l) => l.product.id == productId);
    lines.value = current;
  }

  void clear() {
    lines.value = <CartLine>[];
  }

  double total() {
    return lines.value.fold(0.0, (sum, l) => sum + l.lineTotal);
  }

  int itemsCount() {
    return lines.value.fold(0, (sum, l) => sum + l.quantity);
  }

  // Incrementa la cantidad de una línea del carrito
  void increment(String productId, {int by = 1}) {
    if (by <= 0) return;
    final current = List<CartLine>.from(lines.value);
    final idx = current.indexWhere((l) => l.product.id == productId);
    if (idx >= 0) {
      current[idx].quantity += by;
      lines.value = current;
    }
  }

  // Decrementa la cantidad; si llega a 0, elimina la línea
  void decrement(String productId, {int by = 1}) {
    if (by <= 0) return;
    final current = List<CartLine>.from(lines.value);
    final idx = current.indexWhere((l) => l.product.id == productId);
    if (idx >= 0) {
      final newQty = current[idx].quantity - by;
      if (newQty <= 0) {
        current.removeAt(idx);
      } else {
        current[idx].quantity = newQty;
      }
      lines.value = current;
    }
  }
}
