import 'package:flutter/material.dart';
import 'package:hello_world/services/checkout_service.dart';

class CheckoutPaymentPage extends StatelessWidget {
  const CheckoutPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final checkout = CheckoutService();
    String? selected = checkout.paymentMethod.value ?? 'Tarjeta';
    final options = const ['Tarjeta', 'Yape/Plin', 'Contra entrega'];

    return StatefulBuilder(
      builder: (context, setState) {
        return Scaffold(
          backgroundColor: const Color(0xFF2D3748),
          appBar: AppBar(
            title: const Text('Pago'),
            backgroundColor: const Color(0xFF1A202C),
            foregroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Selecciona un método de pago',
                    style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 12),
                ...options.map((o) => RadioListTile<String>(
                      value: o,
                      groupValue: selected,
                      title: Text(o, style: const TextStyle(color: Colors.white)),
                      onChanged: (v) => setState(() => selected = v),
                    )),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (selected == null) return;
                      checkout.setPaymentMethod(selected!);
                      Navigator.pushNamed(context, '/checkout/review');
                    },
                    child: const Text('Continuar a revisión'),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}