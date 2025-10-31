import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D3748),
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: const Color(0xFF1A202C),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: Color(0xFF2D3748),
                  child: Icon(Icons.person, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nombre Apellido',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'usuario@correo.com',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4A5568),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '+51 999 999 999',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4A5568),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _sectionTitle('Cuenta'),
          _tile(context, Icons.location_on, 'Direcciones', '/addresses'),
          _tile(context, Icons.credit_card, 'Métodos de pago', '/payment-methods'),
          _tile(context, Icons.favorite, 'Favoritos', '/favorites'),
          const SizedBox(height: 16),
          _sectionTitle('Compras'),
          _tile(context, Icons.receipt_long, 'Mis pedidos', '/orders'),
          _tile(context, Icons.shopping_cart, 'Carrito', '/cart'),
          const SizedBox(height: 16),
          _sectionTitle('Aplicación'),
          _tile(context, Icons.settings, 'Configuración', '/settings'),
          _tile(context, Icons.help_outline, 'Centro de ayuda', '/help'),
          _tile(context, Icons.privacy_tip_outlined, 'Privacidad', '/privacy'),
          _tile(context, Icons.description_outlined, 'Términos', '/terms'),
          _tile(context, Icons.info_outline, 'Acerca de', '/about'),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _tile(BuildContext context, IconData icon, String title, String route) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF2D3748)),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF2D3748),
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF718096)),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }
}