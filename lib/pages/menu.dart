import 'package:flutter/material.dart';
import 'package:hello_world/models/product.dart';
import 'package:hello_world/services/firebase_products_service.dart';
import 'package:hello_world/services/cart_service.dart';

// Página principal del menú de productos
class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = CartService();
    // Estructura base de la pantalla
    return Scaffold(
      backgroundColor: const Color(0xFF2D3748),
      // Barra superior con título y acceso al carrito
      appBar: AppBar(
        title: const Text('Natura CO'),
        backgroundColor: const Color(0xFF1A202C),
        foregroundColor: Colors.white,
        actions: [
          // Escucha cambios del carrito para mostrar el contador
          ValueListenableBuilder<List<CartLine>>(
            valueListenable: cart.lines,
            builder: (context, lines, _) {
              final count = cart.itemsCount();
              // Icono del carrito con badge de cantidad
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
      // Menú lateral compacto
      drawer: _buildCompactDrawer(context),
      // Contenido principal: buscador + grilla de productos
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Container(
                  height: 44,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  // Campo de texto para buscar productos
                  child: const TextField(
                    cursorColor: Color(0xFF2D3748),
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(color: Color(0xFF2D3748)),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Buscar...',
                      hintStyle: TextStyle(color: Color(0xFF718096)),
                      prefixIcon: Icon(Icons.search, color: Color(0xFF718096)),
                      prefixIconConstraints: BoxConstraints(minWidth: 44),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Grid de productos con StreamBuilder para Firebase
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: FirebaseProductsService().getAllStream(),
              builder: (context, snapshot) {
                // Mientras carga
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  );
                }
                
                // Si hay error
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.white, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          'Error al cargar productos',
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${snapshot.error}',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
                
                final products = snapshot.data ?? [];
                
                // Si no hay productos
                if (products.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined, color: Colors.white, size: 48),
                        SizedBox(height: 16),
                        Text(
                          'No hay productos disponibles',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }
                
                // Mostrar productos
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.68,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final p = products[index];
                      // Tarjeta individual del producto
                      return _buildProductCard(
                        context,
                        product: p,
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/product',
                          arguments: p.id,
                        ),
                        onAdd: () {
                          cart.add(p);
                          ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                            const SnackBar(content: Text('Producto agregado al carrito')),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Drawer lateral compacto con accesos rápidos
  Widget _buildCompactDrawer(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Drawer(
        backgroundColor: const Color(0xFF1A202C),
        child: Column(
          children: [
            Container(
              height: 120,
              padding: const EdgeInsets.all(16),
              child: const Column(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.spa,
                      size: 20,
                      color: Color(0xFF1A202C),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'DB',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Inicio
                  _buildCompactDrawerItem(
                    icon: Icons.home,
                    isSelected: true,
                    onTap: () => Navigator.pop(context),
                  ),
                  // Carrito
                  _buildCompactDrawerItem(
                    icon: Icons.shopping_cart,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/cart');
                    },
                  ),
                  // Perfil
                  _buildCompactDrawerItem(
                    icon: Icons.people,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/appointment');
                    },
                  ),
                  // Órdenes
                  _buildCompactDrawerItem(
                    icon: Icons.analytics,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/orders');
                    },
                  ),
                ],
              ),
            ),

            Column(
              children: [
                // Ajustes
                _buildCompactDrawerItem(
                  icon: Icons.settings,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
                // Cerrar sesión
                _buildCompactDrawerItem(
                  icon: Icons.exit_to_app,
                  onTap: () => _showLogoutDialog(context),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Item del drawer con estado de selección
  Widget _buildCompactDrawerItem({
    required IconData icon,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 48,
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: IconButton(
        icon: Icon(icon,
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
            size: 20),
        onPressed: onTap,
        style: IconButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFF2D3748) : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  // Tarjeta visual para cada producto en el grid
  Widget _buildProductCard(
    BuildContext context, {
    required Product product,
    required VoidCallback onTap,
    required VoidCallback onAdd,
  }) {
    // Navega al detalle al tocar
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                image: DecorationImage(
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'S/ ${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF4A5568),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                  ),
                  SizedBox(height: 8),
                  // Botón para agregar al carrito
                  _AddButton(onPressed: onAdd),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Navigator.pop(context);
    showDialog(
      context: context,
      // Diálogo de confirmación de cierre de sesión
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}

// Botón reutilizable para agregar productos al carrito
class _AddButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _AddButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 30,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2D3748),
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        onPressed: onPressed,
        child: const Text(
          'Agregar',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}