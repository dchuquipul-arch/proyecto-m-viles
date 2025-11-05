import 'package:flutter/material.dart';

// Pantalla de confirmación de pedido
class OrderConfirmationPage extends StatelessWidget {
  const OrderConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Estructura base de la pantalla
    return Scaffold(
      backgroundColor: const Color(0xFF2D3748),
      // Barra superior con título
      appBar: AppBar(
        title: const Text('Confirmación'),
        backgroundColor: const Color(0xFF1A202C),
        foregroundColor: Colors.white,
      ),
      // Contenido centrado
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          // Mensaje de confirmación con acción para seguir comprando
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono de éxito
              const Icon(Icons.check_circle, color: Colors.greenAccent, size: 96),
              const SizedBox(height: 16),
              // Título
              const Text('¡Pedido confirmado!',
                  style: TextStyle(
                      color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              // Mensaje secundario
              const Text('Gracias por tu compra.',
                  style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 24),
              // Botón para regresar al listado de productos
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context, '/menu', (route) => route.isFirst),
                  icon: const Icon(Icons.storefront),
                  label: const Text('Seguir comprando'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}