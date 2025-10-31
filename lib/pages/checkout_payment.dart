import 'package:flutter/material.dart';

class CheckoutPaymentPage extends StatelessWidget {
  const CheckoutPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D3748),
      appBar: AppBar(
        title: const Text('Pago'),
        backgroundColor: const Color(0xFF1A202C),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Método de pago', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}