import 'package:flutter/material.dart';
import 'package:hello_world/services/cart_service.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = CartService();
    return Scaffold(
      backgroundColor: const Color(0xFF2D3748),
      appBar: AppBar(
        title: const Text('Carrito'),
        backgroundColor: const Color(0xFF1A202C),
        foregroundColor: Colors.white,
      ),
      body: ValueListenableBuilder<List<CartLine>>(
        valueListenable: cart.lines,
        builder: (context, lines, _) {
          if (lines.isEmpty) {
            return const Center(
              child: Text('Tu carrito está vacío',
                  style: TextStyle(color: Colors.white70)),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: lines.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final line = lines[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(line.product.imageUrl),
                      ),
                      title: Text(line.product.name,
                          style: const TextStyle(color: Colors.white)),
                      subtitle: Text(
                        'Cantidad: ${line.quantity}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'S/ ${line.lineTotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () => cart.remove(line.product.id),
                            child: const Text('Quitar'),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Total: S/ ${cart.total().toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        '/checkout/shipping',
                      ),
                      child: const Text('Continuar'),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}