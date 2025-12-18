import 'package:flutter/material.dart';
import 'package:hello_world/models/product.dart';
import 'package:hello_world/services/firebase_products_service.dart';
import 'package:hello_world/services/cart_service.dart';
import 'package:hello_world/services/firebase_favorites_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Pantalla de detalle de producto mejorada
class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Recuperamos argumentos
    final args = ModalRoute.of(context)?.settings.arguments;
    final cart = CartService();

    // Lógica para obtener el producto (objeto o ID)
    if (args is Product) {
      return _buildPremiumProductDetail(context, args, cart);
    }

    if (args is String) {
      return FutureBuilder<Product?>(
        future: FirebaseProductsService().getById(args),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: Color(0xFFF9FAFB),
              body: Center(
                child: CircularProgressIndicator(color: Color(0xFF1A202C)),
              ),
            );
          }
          if (snapshot.hasError || snapshot.data == null) {
            return const Scaffold(
              backgroundColor: Color(0xFFF9FAFB),
              body: Center(child: Text('Producto no encontrado')),
            );
          }
          return _buildPremiumProductDetail(context, snapshot.data!, cart);
        },
      );
    }

    return const Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      body: Center(child: Text('Producto no encontrado')),
    );
  }

  Widget _buildPremiumProductDetail(
    BuildContext context,
    Product product,
    CartService cart,
  ) {
    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar transparente para que la imagen luzca
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF1A202C),
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ValueListenableBuilder<List<CartLine>>(
              valueListenable: cart.lines,
              builder: (context, lines, _) {
                final count = cart.itemsCount();
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.shopping_bag_outlined,
                        color: Color(0xFF1A202C),
                        size: 20,
                      ),
                      onPressed: () => Navigator.pushNamed(context, '/cart'),
                    ),
                    if (count > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE53E3E),
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          // child: Text('$count', style: const TextStyle(fontSize: 8, color: Colors.white)), // Opcional
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen Hero
            Container(
              height: 480, // Imagen muy alta para impacto visual
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF7FAFC),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
                child: Hero(
                  tag: product.id, // Asegurar que sea el mismo tag en Menu
                  child: Image.network(product.imageUrl, fit: BoxFit.cover),
                ),
              ),
            ),

            // Contenido
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.category.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF718096),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A202C),
                                height: 1.1,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Precio destacado
                      Text(
                        'S/ ${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Descripción
                  const Text(
                    'Descripción',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A202C),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Color(0xFF4A5568),
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 100), // Espacio para el botón flotante
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar personalizado (Botón flotante grande)
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: SafeArea(
          child: Row(
            children: [
              // Botón de corazón (favorito)
              Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: StreamBuilder<bool>(
                  stream: FirebaseAuth.instance.currentUser != null
                      ? FirebaseFavoritesService().isFavoriteStream(
                          FirebaseAuth.instance.currentUser!.uid,
                          product.id,
                        )
                      : Stream.value(false),
                  builder: (context, snapshot) {
                    final isFav = snapshot.data ?? false;
                    return IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : const Color(0xFFA0AEC0),
                      ),
                      onPressed: () async {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Inicia sesión para dar like'),
                            ),
                          );
                          return;
                        }
                        await FirebaseFavoritesService().toggleFavorite(
                          user.uid,
                          product.id,
                        );
                      },
                    );
                  },
                ),
              ),

              // Botón Agregar al carrito grande
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    cart.add(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Producto agregado a la bolsa',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: const Color(0xFF1A202C),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        action: SnackBarAction(
                          label: 'VER BOLSA',
                          textColor: Colors.white70,
                          onPressed: () =>
                              Navigator.pushNamed(context, '/cart'),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A202C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Agregar a la bolsa',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
