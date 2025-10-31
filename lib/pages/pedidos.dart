import 'package:flutter/material.dart';

class PantallaPedidos extends StatelessWidget {
  const PantallaPedidos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D3748),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A202C),
        title: const Text(
          'Pedidos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      drawer: _buildCompactDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar',
                  hintStyle: TextStyle(color: Color(0xFF718096)),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF718096)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _listaPedidos.length,
                itemBuilder: (context, index) => _OrderItem(pedido: _listaPedidos[index]),
              ),
            ),
            const _OrderSummary(),
          ],
        ),
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
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                  _buildCompactDrawerItem(
                    icon: Icons.shopping_bag,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                  _buildCompactDrawerItem(
                    icon: Icons.shopping_cart,
                    isSelected: true,
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildCompactDrawerItem(
                    icon: Icons.people,
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildCompactDrawerItem(
                    icon: Icons.analytics,
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                _buildCompactDrawerItem(
                  icon: Icons.settings,
                  onTap: () => Navigator.pop(context),
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

final List<Map<String, String>> _listaPedidos = [
  {
    'codigo': 'TBT 113134546',
    'producto': 'Ekos Pulpa hidratante para manos castaña',
  },
  {
    'codigo': 'TBT 113134545',
    'producto': 'Ekos Frescor eau de toilette maracuyá',
  },
  {
    'codigo': 'TBT 113134544',
    'producto': 'Ekos Néctar hidratante para manos maracuyá',
  },
];

class _OrderItem extends StatelessWidget {
  final Map<String, String> pedido;

  const _OrderItem({required this.pedido});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pedido['codigo']!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  pedido['producto']!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF718096)),
            onPressed: () => _mostrarEstadoPedido(context, pedido),
          ),
        ],
      ),
    );
  }

  void _mostrarEstadoPedido(BuildContext context, Map<String, String> pedido) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Estado del Pedido: ${pedido['codigo']}'),
        content: Text('Producto: ${pedido['producto']}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(color: Color(0xFFE2E8F0), height: 30),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              _SummaryRow(title: 'Total', value: '560.25 Soles'),
              SizedBox(height: 12),
              _SummaryRow(title: 'Pedidos', value: '14'),
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF2D3748),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Historial',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String title;
  final String value;

  const _SummaryRow({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}