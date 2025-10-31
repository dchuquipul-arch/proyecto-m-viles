import 'package:flutter/material.dart';

class AddressEditPage extends StatelessWidget {
  const AddressEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D3748),
      appBar: AppBar(
        title: const Text('Editar dirección'),
        backgroundColor: const Color(0xFF1A202C),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Formulario de dirección', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
