import 'package:flutter/material.dart';
import 'package:hello_world/models/product.dart';
import 'package:hello_world/services/products_service.dart';
import 'package:hello_world/services/cart_service.dart';

class ProductsListPage extends StatelessWidget {
  const ProductsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final products = ProductsService().getAll();
    final cart = CartService();

    return Scaffold(
      backgroundColor: const Color(0xFF2D3748),
      appBar: AppBar(
        title: const Text('Productos'),
        backgroundColor: const Color(0xFF1A202C),
        foregroundColor: Colors.white,
        actions: [
          ValueListenableBuilder<List<CartLine>>(
            valueListenable: cart.lines,
            builder: (context, lines, _) {
              final count = cart.itemsCount();
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () => Navigator.pushNamed(context, '/cart'),
                  ),
                  if (count > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: CircleAvatar(
                        radius: 9,
                        backgroundColor: Colors.redAccent,
                        child: Text(
                          '$count',
                          style: const TextStyle(fontSize: 11, color: Colors.white),
                        ),
                      ),
                    )
                ],
              );
            },
          )
        ],
      ),
      body: ListView.separated(
        itemCount: products.length,
        separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.black26),
        itemBuilder: (context, index) {
          final Product p = products[index];
          return ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(p.imageUrl)),
            title: Text(p.name, style: const TextStyle(color: Colors.white)),
            subtitle: Text(
              p.category,
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: Text(
              'S/ ${p.price.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
            ),
            onTap: () => Navigator.pushNamed(
              context,
              '/product',
              arguments: p.id,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/cart'),
        icon: const Icon(Icons.shopping_cart_checkout),
        label: const Text('Ver carrito'),
      ),
    );
  }
}