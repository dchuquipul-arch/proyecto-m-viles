import 'package:flutter/material.dart';
import 'package:hello_world/services/checkout_service.dart';

// Pantalla de checkout: paso de dirección de envío
class CheckoutShippingPage extends StatelessWidget {
  const CheckoutShippingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final checkout = CheckoutService();
    final controller = TextEditingController(text: checkout.shippingAddress.value ?? '');
    // Estructura base de la pantalla
    return Scaffold(
      backgroundColor: const Color(0xFF2D3748),
      // Barra superior con título
      appBar: AppBar(
        title: const Text('Envío'),
        backgroundColor: const Color(0xFF1A202C),
        foregroundColor: Colors.white,
      ),
      // Contenido principal con márgenes
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Etiqueta de campo
            const Text('Dirección de envío',
                style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            // Campo de texto para la dirección
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Calle 123, Ciudad, País',
                filled: true,
              ),
            ),
            // Empuja el botón al final
            const Spacer(),
            // Botón para continuar al pago
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final value = controller.text.trim();
                  if (value.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ingresa una dirección válida')),
                    );
                    return;
                  }
                  checkout.setShippingAddress(value);
                  Navigator.pushNamed(context, '/checkout/payment');
                },
                child: const Text('Continuar a pago'),
              ),
            )
          ],
        ),
      ),
    );
  }
}