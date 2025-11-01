import 'package:flutter/material.dart';
import 'package:hello_world/services/checkout_service.dart';
import 'package:hello_world/services/cart_service.dart';
import 'package:hello_world/services/orders_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final checkout = CheckoutService();
    final cart = CartService();
    final orders = OrdersService();

    return Scaffold(
      backgroundColor: const Color(0xFF2D3748),
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: const Color(0xFF1A202C),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text('Cuenta de compra',
                style: TextStyle(color: Colors.white70, fontSize: 13)),
          ),

          ValueListenableBuilder<String?>(
            valueListenable: checkout.shippingAddress,
            builder: (context, address, _) => ListTile(
              title: const Text('Dirección de envío',
                  style: TextStyle(color: Colors.white)),
              subtitle: Text(address ?? 'No especificada',
                  style: const TextStyle(color: Colors.white70)),
              trailing: const Icon(Icons.edit, color: Colors.white70),
              onTap: () async {
                final controller = TextEditingController(text: address ?? '');
                final result = await showDialog<String>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Editar dirección de envío'),
                    content: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                          hintText: 'Calle 123, Ciudad, País'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx, controller.text.trim());
                        },
                        child: const Text('Guardar'),
                      ),
                    ],
                  ),
                );
                if ((result ?? '').isNotEmpty) {
                  checkout.setShippingAddress(result!);
                  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                    const SnackBar(content: Text('Dirección actualizada')),
                  );
                }
              },
            ),
          ),

          ValueListenableBuilder<String?>(
            valueListenable: checkout.paymentMethod,
            builder: (context, method, _) => ListTile(
              title: const Text('Método de pago preferido',
                  style: TextStyle(color: Colors.white)),
              subtitle: Text(method ?? 'No seleccionado',
                  style: const TextStyle(color: Colors.white70)),
              trailing: const Icon(Icons.credit_card, color: Colors.white70),
              onTap: () async {
                final options = const ['Tarjeta', 'Yape/Plin', 'Contra entrega'];
                final selected = await showModalBottomSheet<String>(
                  context: context,
                  backgroundColor: const Color(0xFF1A202C),
                  builder: (ctx) => SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 8),
                        const Text('Selecciona un método',
                            style: TextStyle(color: Colors.white70)),
                        ...options.map((o) => ListTile(
                              title: Text(o,
                                  style:
                                      const TextStyle(color: Colors.white)),
                              onTap: () => Navigator.pop(ctx, o),
                            )),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                );
                if (selected != null) {
                  checkout.setPaymentMethod(selected);
                  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                    SnackBar(content: Text('Método de pago: $selected')),
                  );
                }
              },
            ),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text('Datos y almacenamiento',
                style: TextStyle(color: Colors.white70, fontSize: 13)),
          ),

          ListTile(
            title: const Text('Vaciar carrito',
                style: TextStyle(color: Colors.white)),
            subtitle: const Text('Elimina todos los productos del carrito',
                style: TextStyle(color: Colors.white70)),
            trailing: const Icon(Icons.delete_outline, color: Colors.white70),
            onTap: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Vaciar carrito'),
                  content: const Text(
                      '¿Seguro que deseas eliminar todos los productos del carrito?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Vaciar'),
                    ),
                  ],
                ),
              );
              if (ok == true) {
                cart.clear();
                ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                  const SnackBar(content: Text('Carrito vaciado')),
                );
              }
            },
          ),

          ListTile(
            title: const Text('Borrar historial de pedidos',
                style: TextStyle(color: Colors.white)),
            subtitle: const Text('Elimina todos los pedidos locales',
                style: TextStyle(color: Colors.white70)),
            trailing: const Icon(Icons.history_toggle_off,
                color: Colors.white70),
            onTap: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Borrar historial'),
                  content: const Text(
                      '¿Seguro que deseas eliminar todos los pedidos guardados en este dispositivo?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Borrar'),
                    ),
                  ],
                ),
              );
              if (ok == true) {
                orders.orders.value = [];
                ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                  const SnackBar(content: Text('Historial de pedidos borrado')),
                );
              }
            },
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
