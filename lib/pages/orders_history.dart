import 'package:flutter/material.dart';
import 'package:hello_world/services/orders_service.dart';
import 'package:hello_world/models/order.dart';

class OrdersHistoryPage extends StatelessWidget {
  const OrdersHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ordersService = OrdersService();
    return Scaffold(
      backgroundColor: const Color(0xFF2D3748),
      appBar: AppBar(
        title: const Text('Mis pedidos'),
        backgroundColor: const Color(0xFF1A202C),
        foregroundColor: Colors.white,
      ),
      body: ValueListenableBuilder<List<Order>>(
        valueListenable: ordersService.orders,
        builder: (context, orders, _) {
          if (orders.isEmpty) {
            return const Center(
              child: Text('Aún no tienes pedidos', style: TextStyle(color: Colors.white70)),
            );
          }
          return ListView.separated(
            itemCount: orders.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final o = orders[index];
              return ListTile(
                title: Text('Pedido #${o.id}', style: const TextStyle(color: Colors.white)),
                subtitle: Text(
                  '${o.items.length} items · ${o.createdAt}',
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: Text(
                  'S/ ${o.total.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
                ),
                onTap: () => Navigator.pushNamed(context, '/order', arguments: o.id),
              );
            },
          );
        },
      ),
    );
  }
}