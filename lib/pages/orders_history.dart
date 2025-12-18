import 'package:flutter/material.dart';
import 'package:hello_world/services/firebase_orders_service.dart';
import 'package:hello_world/models/order.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Listado del historial de pedidos
class OrdersHistoryPage extends StatelessWidget {
  const OrdersHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Inicia sesión para ver tus pedidos')),
      );
    }

    // Estructura base
    return Scaffold(
      backgroundColor: const Color(0xFF2D3748),
      // Barra superior
      appBar: AppBar(
        title: const Text('Mis pedidos'),
        backgroundColor: const Color(0xFF1A202C),
        foregroundColor: Colors.white,
      ),
      // Lista reactiva de pedidos desde Firebase
      body: StreamBuilder<List<Order>>(
        stream: FirebaseOrdersService().getUserOrdersStream(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            // Mensaje cuando no hay historial
            return const Center(
              child: Text(
                'Aún no tienes pedidos',
                style: TextStyle(color: Colors.white70),
              ),
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
                title: Text(
                  'Pedido #${o.id.substring(0, 8)}...', // Mostrar ID corto
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  '${o.items.length} items · ${_formatDate(o.createdAt)}',
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'S/ ${o.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      o.paymentMethod ?? 'Pago',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                onTap: () =>
                    Navigator.pushNamed(context, '/order', arguments: o.id),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
