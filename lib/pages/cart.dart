import 'package:flutter/material.dart';
import 'package:hello_world/services/cart_service.dart';

// Pantalla del carrito de compras mejorada
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = CartService();

    // Diseño Premium: Fondo claro
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Tu Bolsa',
          style: TextStyle(
            color: Color(0xFF1A202C),
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1A202C)),
      ),
      body: ValueListenableBuilder<List<CartLine>>(
        valueListenable: cart.lines,
        builder: (context, lines, _) {
          if (lines.isEmpty) {
            return _buildEmptyState(context);
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: lines.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final line = lines[index];
                    return _buildCartItem(cart, line);
                  },
                ),
              ),
              _buildSummarySection(context, cart),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Tu bolsa está vacía',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '¡Descubre nuestros productos naturales!',
            style: TextStyle(color: Color(0xFF718096)),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A202C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Ir a comprar'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartService cart, CartLine line) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A202C).withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del producto
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFF7FAFC),
              image: DecorationImage(
                image: NetworkImage(line.product.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Detalles
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        line.product.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 18,
                        color: Color(0xFFA0AEC0),
                      ),
                      onPressed: () => cart.remove(line.product.id),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  line.product.category,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF718096),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'S/ ${line.lineTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A202C),
                      ),
                    ),
                    // Control de cantidad
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDF2F7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          _buildQtyBtn(
                            icon: Icons.remove,
                            onTap: () => cart.decrement(line.product.id),
                          ),
                          Container(
                            width: 32,
                            alignment: Alignment.center,
                            child: Text(
                              '${line.quantity}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                          ),
                          _buildQtyBtn(
                            icon: Icons.add,
                            onTap: () => cart.increment(line.product.id),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyBtn({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 16, color: const Color(0xFF4A5568)),
        ),
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context, CartService cart) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A202C).withOpacity(0.05),
            offset: const Offset(0, -4),
            blurRadius: 16,
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Subtotal',
                  style: TextStyle(color: Color(0xFF718096)),
                ),
                Text(
                  'S/ ${cart.total().toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Envío', style: TextStyle(color: Color(0xFF718096))),
                Text(
                  'Calculado luego',
                  style: TextStyle(color: Color(0xFF718096)),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A202C),
                  ),
                ),
                Text(
                  'S/ ${cart.total().toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A202C),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/checkout/shipping'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A202C),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continuar Compra',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
