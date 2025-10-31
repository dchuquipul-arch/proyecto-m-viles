import 'package:flutter/material.dart';

class CheckoutReviewPage extends StatelessWidget {
  const CheckoutReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D3748),
      appBar: AppBar(
        title: const Text('Revisión'),
        backgroundColor: const Color(0xFF1A202C),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Revisión del pedido', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}