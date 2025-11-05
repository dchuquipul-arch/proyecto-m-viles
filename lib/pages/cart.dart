import 'package:flutter/material.dart';
import 'package:hello_world/services/cart_service.dart';

// Página del carrito de compras
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = CartService();
    // Contenedor base de la pantalla
    return Scaffold(
      backgroundColor: const Color(0xFF2D3748),
      // Barra superior con título
      appBar: AppBar(
        title: const Text('Carrito'),
        backgroundColor: const Color(0xFF1A202C),
        foregroundColor: Colors.white,
      ),
      // Reactivo a cambios en el carrito
      body: ValueListenableBuilder<List<CartLine>>(
        valueListenable: cart.lines,
        builder: (context, lines, _) {
          if (lines.isEmpty) {
            // Mensaje cuando no hay productos
            return const Center(
              child: Text('Tu carrito está vacío',
                  style: TextStyle(color: Colors.white70)),
            );
          }
          // Listado de líneas del carrito + barra inferior de total/acción
          return Column(
            children: [
              // Lista de productos en el carrito
              Expanded(
                child: ListView.separated(
                  itemCount: lines.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final line = lines[index];
                    // Fila de producto con imagen, nombre, cantidad y total
                    return ListTile(
                      isThreeLine: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(line.product.imageUrl),
                      ),
                      title: Text(line.product.name,
                          style: const TextStyle(color: Colors.white)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 6),
                          // Controles de cantidad centrados con mejor diseño
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white24),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () => cart.decrement(line.product.id),
                                    icon: const Icon(Icons.remove),
                                    color: Colors.white,
                                    splashRadius: 18,
                                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      '${line.quantity}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => cart.increment(line.product.id),
                                    icon: const Icon(Icons.add),
                                    color: Colors.white,
                                    splashRadius: 18,
                                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Precio total de la línea y acción para quitar
                      trailing: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'S/ ${line.lineTotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Barra inferior con total y botón de continuar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Muestra el total acumulado
                    Expanded(
                      child: Text(
                        'Total: S/ ${cart.total().toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    // Avanza al flujo de checkout (envío)
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