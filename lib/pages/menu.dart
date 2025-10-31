import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D3748),
      appBar: AppBar(
        title: const Text('Natura CO'),
        backgroundColor: const Color(0xFF1A202C),
        foregroundColor: Colors.white,
      ),
      drawer: _buildCompactDrawer(context),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar...',
                  hintStyle: TextStyle(color: Color(0xFF718096)),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF718096)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
          ),

          // Grid de productos
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: 6,
                itemBuilder: (context, index) => _buildProductCard(),
              ),
            ),
          ),
        ],
      ),
      // ELIMINADA: bottomNavigationBar
    );
  }

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
                  _buildCompactDrawerItem(
                    icon: Icons.home,
                    isSelected: true,
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildCompactDrawerItem(
                    icon: Icons.shopping_bag,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/products');
                    },
                  ),
                  _buildCompactDrawerItem(
                    icon: Icons.shopping_cart,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/cart');
                    },
                  ),
                  _buildCompactDrawerItem(
                    icon: Icons.people,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
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
                _buildCompactDrawerItem(
                  icon: Icons.settings,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
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

  Widget _buildProductCard() {
    return Container(
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
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&h=300&fit=crop'
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          const Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\$228.00',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Playera manga corta',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF4A5568),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 8),
                _AddButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Navigator.pop(context);
    showDialog(
      context: context,
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

class _AddButton extends StatelessWidget {
  const _AddButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 30,
      decoration: BoxDecoration(
        color: const Color(0xFF2D3748),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Center(
        child: Text(
          'Agregar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}