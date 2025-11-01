import 'package:flutter/material.dart';
import 'package:hello_world/services/orders_service.dart';
import 'package:hello_world/models/order.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as String?;
    final Order? order = id != null ? OrdersService().getById(id) : null;
    return Scaffold(
      backgroundColor: const Color(0xFF2D3748),
      appBar: AppBar(
        title: Text('Pedido #${id ?? '-'}'),
        backgroundColor: const Color(0xFF1A202C),
        foregroundColor: Colors.white,
      ),
      body: order == null
          ? const Center(
              child: Text('Pedido no encontrado',
                  style: TextStyle(color: Colors.white70)),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: const Text('Fecha',
                        style: TextStyle(color: Colors.white70)),
                    subtitle: Text(order.createdAt.toString(),
                        style: const TextStyle(color: Colors.white)),
                  ),
                  ListTile(
                    title: const Text('Dirección de envío',
                        style: TextStyle(color: Colors.white70)),
                    subtitle: Text(order.shippingAddress ?? '-',
                        style: const TextStyle(color: Colors.white)),
                  ),
                  ListTile(
                    title: const Text('Pago',
                        style: TextStyle(color: Colors.white70)),
                    subtitle: Text(order.paymentMethod ?? '-',
                        style: const TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 8),
                  const Text('Productos',
                      style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.separated(
                      itemCount: order.items.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final it = order.items[i];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(it.imageUrl),
                          ),
                          title: Text(it.name,
                              style: const TextStyle(color: Colors.white)),
                          subtitle: Text('x${it.quantity}',
                              style: const TextStyle(color: Colors.white70)),
                          trailing: Text(
                            'S/ ${it.lineTotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Expanded(
                        child: Text('Total',
                            style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w500)),
                      ),
                      Text(
                        'S/ ${order.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}