import 'package:flutter/foundation.dart';
import 'package:hello_world/models/order.dart';

class OrdersService {
  static final OrdersService _instance = OrdersService._internal();
  factory OrdersService() => _instance;
  OrdersService._internal();

  final ValueNotifier<List<Order>> orders = ValueNotifier<List<Order>>(<Order>[]);

  void add(Order order) {
    final current = List<Order>.from(orders.value);
    current.insert(0, order);
    orders.value = current;
  }

  Order? getById(String id) {
    for (final o in orders.value) {
      if (o.id == id) return o;
    }
    return null;
  }
}
