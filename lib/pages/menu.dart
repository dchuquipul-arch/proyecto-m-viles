import 'package:flutter/material.dart';
import 'package:hello_world/models/product.dart';
import 'package:hello_world/services/firebase_products_service.dart';
import 'package:hello_world/services/cart_service.dart';
import 'package:hello_world/services/auth_service.dart';

// Página principal del menú de productos con búsqueda funcional
class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final cart = CartService();

    // Diseño Premium: Fondo claro y limpio
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Natura CO',
          style: TextStyle(
            color: Color(0xFF1A202C),
            fontWeight: FontWeight.w800,
            fontSize: 22,
            letterSpacing: -0.5,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1A202C)),
        actions: [
          ValueListenableBuilder<List<CartLine>>(
            valueListenable: cart.lines,
            builder: (context, lines, _) {
              final count = cart.itemsCount();
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_bag_outlined, size: 28),
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
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '$count',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      drawer: _buildCompactDrawer(context),
      body: Column(
        children: [
          // Barra de búsqueda moderna
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFEDF2F7),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
                cursorColor: const Color(0xFF2D3748),
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(
                  color: Color(0xFF2D3748),
                  fontWeight: FontWeight.w500,
                ),
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Color(0xFFA0AEC0),
                  ),
                  hintText: '¿Qué estás buscando hoy?',
                  hintStyle: TextStyle(color: Color(0xFFA0AEC0)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  isCollapsed: false,
                ),
              ),
            ),
          ),

          // Grid de productos
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: FirebaseProductsService().getAllStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final products = snapshot.data ?? [];

                // Filtrado de productos
                final filteredProducts = products.where((product) {
                  final nameLower = product.name.toLowerCase();
                  final categoryLower = product.category.toLowerCase();
                  return nameLower.contains(_searchQuery) ||
                      categoryLower.contains(_searchQuery);
                }).toList();

                if (filteredProducts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off_rounded,
                          size: 60,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No hay productos disponibles'
                              : 'No encontramos resultados para "$_searchQuery"',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.65, // Más alto para mejor imagen
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final p = filteredProducts[index];
                    return _buildProductCard(context, product: p, cart: cart);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactDrawer(BuildContext context) {
    return Drawer(
      width: 90,
      backgroundColor: const Color(0xFF1A202C),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white,
              child: Icon(Icons.spa, color: Color(0xFF1A202C)),
            ),
            const SizedBox(height: 40),
            _DrawerItem(
              icon: Icons.home_rounded,
              isSelected: true,
              onTap: () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Icons.shopping_bag_outlined,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/cart');
              },
            ),
            _DrawerItem(
              icon: Icons.person_outline,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/appointment');
              },
            ),
            _DrawerItem(
              icon: Icons.analytics_outlined,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/orders');
              },
            ),
            const Spacer(),
            _DrawerItem(
              icon: Icons.settings_outlined,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
            _DrawerItem(
              icon: Icons.logout_rounded,
              onTap: () => _showLogoutDialog(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context, {
    required Product product,
    required CartService cart,
  }) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/product', arguments: product.id),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1A202C).withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen con estilo
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  color: const Color(0xFFF7FAFC),
                  image: DecorationImage(
                    image: NetworkImage(product.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 12,
                      top: 12,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                          icon: const Icon(
                            Icons.favorite_border,
                            size: 20,
                            color: Color(0xFFA0AEC0),
                          ),
                          onPressed: () {}, // Funcionalidad futura
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Información
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF718096),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF2D3748),
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'S/ ${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          cart.add(product);
                          ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                            SnackBar(
                              content: const Text('Agregado al carrito'),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: const Color(0xFF2D3748),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2D3748),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que deseas salir?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53E3E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            onPressed: () async {
              Navigator.pop(context);
              await AuthService().signOut();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              }
            },
            child: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isSelected;

  const _DrawerItem({
    required this.icon,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
          size: 24,
        ),
        style: IconButton.styleFrom(
          backgroundColor: isSelected
              ? Colors.white.withOpacity(0.1)
              : Colors.transparent,
          padding: const EdgeInsets.all(12),
        ),
      ),
    );
  }
}
