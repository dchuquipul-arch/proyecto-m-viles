import 'package:flutter/material.dart';
import 'package:hello_world/services/checkout_service.dart';
import 'package:hello_world/services/cart_service.dart';
import 'package:hello_world/models/order.dart';
import 'package:hello_world/services/orders_service.dart';

// Checkout: pantalla de revisión antes de confirmar
class CheckoutReviewPage extends StatelessWidget {
  const CheckoutReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final checkout = CheckoutService();
    final cart = CartService();

    // Estructura base de la pantalla
    return Scaffold(
      backgroundColor: const Color(0xFF2D3748),
      // Barra superior con título
      appBar: AppBar(
        title: const Text('Revisión'),
        backgroundColor: const Color(0xFF1A202C),
        foregroundColor: Colors.white,
      ),
      // Contenido con padding general
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bloque: dirección de envío
            ValueListenableBuilder<String?>(
              valueListenable: checkout.shippingAddress,
              builder: (_, address, __) => ListTile(
                title: const Text('Dirección de envío',
                    style: TextStyle(color: Colors.white70)),
                subtitle: Text(address ?? 'No especificada',
                    style: const TextStyle(color: Colors.white)),
                trailing: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/checkout/shipping'),
                  child: const Text('Editar'),
                ),
              ),
            ),
            const Divider(),
            // Bloque: método de pago
            ValueListenableBuilder<String?>(
              valueListenable: checkout.paymentMethod,
              builder: (_, method, __) => ListTile(
                title: const Text('Método de pago',
                    style: TextStyle(color: Colors.white70)),
                subtitle: Text(method ?? 'No seleccionado',
                    style: const TextStyle(color: Colors.white)),
                trailing: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/checkout/payment'),
                  child: const Text('Editar'),
                ),
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),
            // Título de la lista de productos
            const Text('Productos', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            // Lista de líneas del carrito
            Expanded(
              child: ValueListenableBuilder<List<CartLine>>(
                valueListenable: cart.lines,
                builder: (_, lines, __) {
                  if (lines.isEmpty) {
                    return const Center(
                        child: Text('Carrito vacío',
                            style: TextStyle(color: Colors.white70)));
                  }
                  return ListView.separated(
                    itemCount: lines.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final l = lines[i];
                      return ListTile(
                        title: Text(l.product.name,
                            style: const TextStyle(color: Colors.white)),
                        subtitle: Text('x${l.quantity}',
                            style: const TextStyle(color: Colors.white70)),
                        trailing: Text(
                          'S/ ${l.lineTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            // Resumen del total
            Row(
              children: [
                const Expanded(
                  child: Text('Total',
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.w500)),
                ),
                Text(
                  'S/ ${cart.total().toStringAsFixed(2)}',
                  style: const TextStyle(
                      color: Colors.greenAccent, fontWeight: FontWeight.bold),
                )
              ],
            ),
            const SizedBox(height: 16),
            // Botón de confirmación
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (cart.lines.value.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('El carrito está vacío')),
                    );
                    return;
                  }
                  final id = DateTime.now().millisecondsSinceEpoch.toString();
                  final order = Order.fromCart(
                    id: id,
                    lines: cart.lines.value,
                    total: cart.total(),
                    address: checkout.shippingAddress.value,
                    payment: checkout.paymentMethod.value,
                  );
                  OrdersService().add(order);
                  Navigator.pushNamed(context, '/order/confirmation');
                  cart.clear();
                  checkout.clear();
                },
                child: const Text('Confirmar pedido'),
              ),
            )
          ],
        ),
      ),
    );
  }
}