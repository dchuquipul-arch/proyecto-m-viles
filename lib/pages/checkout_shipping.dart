import 'package:flutter/material.dart';
import 'package:hello_world/services/checkout_service.dart';

class CheckoutShippingPage extends StatelessWidget {
  const CheckoutShippingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final checkout = CheckoutService();
    final controller = TextEditingController(text: checkout.shippingAddress.value ?? '');
    return Scaffold(
      backgroundColor: const Color(0xFF2D3748),
      appBar: AppBar(
        title: const Text('Envío'),
        backgroundColor: const Color(0xFF1A202C),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dirección de envío',
                style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Calle 123, Ciudad, País',
                filled: true,
              ),
            ),
            const Spacer(),
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