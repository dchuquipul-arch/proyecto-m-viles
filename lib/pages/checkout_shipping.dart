import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hello_world/services/cart_service.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

// Pantalla de Formulario de Pedido con Integración API
class CheckoutShippingPage extends StatefulWidget {
  const CheckoutShippingPage({super.key});

  @override
  State<CheckoutShippingPage> createState() => _CheckoutShippingPageState();
}

class _CheckoutShippingPageState extends State<CheckoutShippingPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controladores para los datos
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Diseño Premium Claro
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Completar Pedido',
          style: TextStyle(
            color: Color(0xFF1A202C),
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1A202C)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Tus Datos'),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _nameController,
                label: 'Nombre Completo',
                icon: Icons.person_outline,
                validator: (v) =>
                    v?.isEmpty == true ? 'Ingresa tu nombre' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _phoneController,
                label: 'Teléfono / Celular',
                icon: Icons.phone_android_outlined,
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    v?.isEmpty == true ? 'Ingresa tu teléfono' : null,
              ),

              const SizedBox(height: 32),
              _buildSectionTitle('Entrega'),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _addressController,
                label: 'Dirección de Entrega',
                icon: Icons.location_on_outlined,
                validator: (v) =>
                    v?.isEmpty == true ? 'Ingresa tu dirección' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _notesController,
                label: 'Notas Adicionales (Opcional)',
                icon: Icons.note_alt_outlined,
                maxLines: 3,
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A202C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _isLoading ? null : _submitOrder,
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Confirmar y Enviar Pedido',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: Color(0xFF2D3748),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A202C).withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        style: const TextStyle(
          color: Color(0xFF2D3748),
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFFA0AEC0)),
          prefixIcon: Icon(icon, color: const Color(0xFFA0AEC0)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1A202C), width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1),
          ),
        ),
      ),
    );
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final cart = CartService();
    final items = cart.lines.value;

    try {
      // 1. Construir el payload JSON
      final orderData = {
        "fecha": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "nombre_cliente": _nameController.text.trim(),
        "contacto": _phoneController.text.trim(),
        "productos": items
            .map(
              (line) => {
                "nombre": line.product.name,
                "cantidad": line.quantity,
                "precio": line.product.price,
                "subtotal": line.lineTotal,
              },
            )
            .toList(),
        "total_items": cart.itemsCount(),
        "total_pagar": cart.total(),
        "metodo_entrega": "Delivery",
        "direccion": _addressController.text.trim(),
        "notas": _notesController.text.trim(),
      };

      // 2. Enviar POST al webhook
      final url = Uri.parse('http://n8n.benjadev.xyz:5678/webhook/alerta');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderData),
      );

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Éxito
        _showSuccessDialog(cart);
      } else {
        // Error del servidor
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al enviar pedido: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error de conexión: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog(CartService cart) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Column(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 60),
            SizedBox(height: 16),
            Text(
              '¡Pedido Enviado!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'Hemos recibido tu orden correctamente. Nos pondremos en contacto contigo pronto.',
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A202C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // Cerrar diálogo
                cart.clear(); // Limpiar carrito
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/menu',
                  (route) => false,
                );
              },
              child: const Text(
                'Volver al Inicio',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
