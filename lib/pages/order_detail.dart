import 'package:flutter/material.dart';
import 'package:hello_world/services/firebase_orders_service.dart';
import 'package:hello_world/models/order.dart';

// Pantalla de detalle de un pedido
class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as String?;

    if (id == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF2D3748),
        body: Center(
          child: Text(
            'Error: No se especificó el pedido',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    // Estructura base
    return Scaffold(
      backgroundColor: const Color(0xFF2D3748),
      // Barra superior con el ID del pedido
      appBar: AppBar(
        title: Text('Pedido #${id.substring(0, 8)}...'),
        backgroundColor: const Color(0xFF1A202C),
        foregroundColor: Colors.white,
      ),
      // FutureBuilder para obtener el pedido
      body: FutureBuilder<Order?>(
        future: FirebaseOrdersService().getById(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          final order = snapshot.data;

          if (order == null) {
            return const Center(
              child: Text(
                'Pedido no encontrado',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            // Información del pedido + lista de productos + total
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: const Text(
                    'Fecha',
                    style: TextStyle(color: Colors.white70),
                  ),
                  subtitle: Text(
                    order.createdAt.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  title: const Text(
                    'Dirección de envío',
                    style: TextStyle(color: Colors.white70),
                  ),
                  subtitle: Text(
                    order.shippingAddress ?? '-',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  title: const Text(
                    'Pago',
                    style: TextStyle(color: Colors.white70),
                  ),
                  subtitle: Text(
                    order.paymentMethod ?? '-',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 8),
                // Lista de productos del pedido
                const Text(
                  'Productos',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.separated(
                    itemCount: order.items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final it = order.items[i];
                      // Ítem de producto
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(it.imageUrl),
                          onBackgroundImageError: (_, __) =>
                              const Icon(Icons.image),
                        ),
                        title: Text(
                          it.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          'x${it.quantity}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: Text(
                          'S/ ${it.lineTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                // Resumen del total
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Total',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      'S/ ${order.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
