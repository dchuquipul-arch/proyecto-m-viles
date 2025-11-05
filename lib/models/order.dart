import 'package:hello_world/services/cart_service.dart';

// Ítem de un pedido (producto, cantidad y precio)
class OrderItem {
  final String productId;
  final String name;
  final String imageUrl;
  final int quantity;
  final double unitPrice;
  const OrderItem({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.unitPrice,
  });
  double get lineTotal => unitPrice * quantity;
}

// Modelo de pedido con items y metadatos
class Order {
  final String id;
  final DateTime createdAt;
  final List<OrderItem> items;
  final double total;
  final String? shippingAddress;
  final String? paymentMethod;

  const Order({
    required this.id,
    required this.createdAt,
    required this.items,
    required this.total,
    this.shippingAddress,
    this.paymentMethod,
  });

  // Crea una orden a partir de líneas del carrito
  factory Order.fromCart({
    required String id,
    required List<CartLine> lines,
    required double total,
    String? address,
    String? payment,
  }) {
    return Order(
      id: id,
      createdAt: DateTime.now(),
      items: lines
          .map((l) => OrderItem(
                productId: l.product.id,
                name: l.product.name,
                imageUrl: l.product.imageUrl,
                quantity: l.quantity,
                unitPrice: l.product.price,
              ))
          .toList(),
      total: total,
      shippingAddress: address,
      paymentMethod: payment,
    );
  }
}
