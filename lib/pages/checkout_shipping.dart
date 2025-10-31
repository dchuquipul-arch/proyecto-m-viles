import 'package:flutter/material.dart';

class CheckoutShippingPage extends StatelessWidget {
  const CheckoutShippingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D3748),
      appBar: AppBar(
        title: const Text('Envío'),
        backgroundColor: const Color(0xFF1A202C),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Dirección de envío', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}