import 'package:flutter/material.dart';
import 'package:hello_world/models/product.dart';
import 'package:hello_world/services/firebase_products_service.dart';
import 'package:hello_world/services/cart_service.dart';

// Pantalla de detalle de producto
class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final cart = CartService();
    
    // Si el argumento es un Product, mostrarlo directamente
    if (args is Product) {
      return _buildProductDetail(context, args, cart);
    }
    
    // Si es un String (ID), cargar desde Firebase
    if (args is String) {
      return FutureBuilder<Product?>(
        future: FirebaseProductsService().getById(args),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: const Color(0xFF2D3748),
              appBar: AppBar(
                title: const Text('Detalle de producto'),
                backgroundColor: const Color(0xFF1A202C),
                foregroundColor: Colors.white,
              ),
              body: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            );
          }
          
          if (snapshot.hasError || snapshot.data == null) {
            return Scaffold(
              backgroundColor: const Color(0xFF2D3748),
              appBar: AppBar(
                title: const Text('Detalle de producto'),
                backgroundColor: const Color(0xFF1A202C),
                foregroundColor: Colors.white,
              ),
              body: const Center(
                child: Text(
                  'Producto no encontrado',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }
          
          return _buildProductDetail(context, snapshot.data!, cart);
        },
      );
    }
    
    // Si no hay argumentos válidos
    return Scaffold(
      backgroundColor: const Color(0xFF2D3748),
      appBar: AppBar(
        title: const Text('Detalle de producto'),
        backgroundColor: const Color(0xFF1A202C),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Producto no encontrado',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
  
  Widget _buildProductDetail(BuildContext context, Product product, CartService cart) {
    // Estructura base
    return Scaffold(
      backgroundColor: const Color(0xFF2D3748),
      // Barra superior con acceso al carrito
      appBar: AppBar(
        title: const Text('Detalle de producto'),
        backgroundColor: const Color(0xFF1A202C),
        foregroundColor: Colors.white,
        actions: [
          // Badge del carrito en AppBar
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
      // Detalle con scroll
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen principal
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(product.imageUrl, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 16),
            // Nombre
            Text(product.name,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // Categoría
            Text(product.category,
                style:
                    const TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 12),
            // Precio
            Text('S/ ${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            // Descripción
            Text(product.description,
                style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
      // Acciones inferiores: ver carrito y agregar
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                // Ir al carrito
                child: OutlinedButton(
                  onPressed: () => Navigator.pushNamed(context, '/cart'),
                  child: const Text('Ver carrito'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                // Agregar al carrito
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    cart.add(product);
                    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                      const SnackBar(
                          content: Text('Producto agregado al carrito')),
                    );
                  },
                  label: const Text('Agregar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}