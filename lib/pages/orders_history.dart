import 'package:flutter/material.dart';
import 'package:hello_world/services/orders_service.dart';
import 'package:hello_world/models/order.dart';

// Listado del historial de pedidos
class OrdersHistoryPage extends StatelessWidget {
  const OrdersHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ordersService = OrdersService();
    // Estructura base
    return Scaffold(
      backgroundColor: const Color(0xFF2D3748),
      // Barra superior
      appBar: AppBar(
        title: const Text('Mis pedidos'),
        backgroundColor: const Color(0xFF1A202C),
        foregroundColor: Colors.white,
      ),
      // Lista reactiva de pedidos
      body: ValueListenableBuilder<List<Order>>(
        valueListenable: ordersService.orders,
        builder: (context, orders, _) {
          if (orders.isEmpty) {
            // Mensaje cuando no hay historial
            return const Center(
              child: Text('Aún no tienes pedidos', style: TextStyle(color: Colors.white70)),
            );
          }
          // Listado de pedidos
          return ListView.separated(
            itemCount: orders.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final o = orders[index];
              // Ítem de pedido con total y navegación a detalle
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