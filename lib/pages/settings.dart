import 'package:flutter/material.dart';
import 'package:hello_world/services/checkout_service.dart';
import 'package:hello_world/services/cart_service.dart';
import 'package:hello_world/services/orders_service.dart';
import 'package:hello_world/utils/migrate_data.dart';

// Pantalla de configuración y datos locales
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isMigrating = false;

  @override
  Widget build(BuildContext context) {
    final checkout = CheckoutService();
    final cart = CartService();
    final orders = OrdersService();

    // Estructura base
    return Scaffold(
      backgroundColor: const Color(0xFF2D3748),
      // Barra superior
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: const Color(0xFF1A202C),
        foregroundColor: Colors.white,
      ),
      // Lista de opciones configurables
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // Encabezado: cuenta de compra
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text('Cuenta de compra',
                style: TextStyle(color: Colors.white70, fontSize: 13)),
          ),

          // Dirección de envío editable mediante diálogo
          ValueListenableBuilder<String?>(
            valueListenable: checkout.shippingAddress,
            builder: (context, address, _) => ListTile(
              title: const Text('Dirección de envío',
                  style: TextStyle(color: Colors.white)),
              subtitle: Text(address ?? 'No especificada',
                  style: const TextStyle(color: Colors.white70)),
              trailing: const Icon(Icons.edit, color: Colors.white70),
              onTap: () async {
                final controller = TextEditingController(text: address ?? '');
                final result = await showDialog<String>(
                  context: context,
                  // Diálogo para editar dirección
                  builder: (ctx) => AlertDialog(
                    title: const Text('Editar dirección de envío'),
                    content: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                          hintText: 'Calle 123, Ciudad, País'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx, controller.text.trim());
                        },
                        child: const Text('Guardar'),
                      ),
                    ],
                  ),
                );
                if ((result ?? '').isNotEmpty) {
                  checkout.setShippingAddress(result!);
                  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                    const SnackBar(content: Text('Dirección actualizada')),
                  );
                }
              },
            ),
          ),

          // Método de pago preferido con selección en bottom sheet
          ValueListenableBuilder<String?>(
            valueListenable: checkout.paymentMethod,
            builder: (context, method, _) => ListTile(
              title: const Text('Método de pago preferido',
                  style: TextStyle(color: Colors.white)),
              subtitle: Text(method ?? 'No seleccionado',
                  style: const TextStyle(color: Colors.white70)),
              trailing: const Icon(Icons.credit_card, color: Colors.white70),
              onTap: () async {
                final options = const ['Tarjeta', 'Yape/Plin', 'Contra entrega'];
                final selected = await showModalBottomSheet<String>(
                  context: context,
                  backgroundColor: const Color(0xFF1A202C),
                  // Hoja inferior con opciones
                  builder: (ctx) => SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 8),
                        const Text('Selecciona un método',
                            style: TextStyle(color: Colors.white70)),
                        ...options.map((o) => ListTile(
                              title: Text(o,
                                  style:
                                      const TextStyle(color: Colors.white)),
                              onTap: () => Navigator.pop(ctx, o),
                            )),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                );
                if (selected != null) {
                  checkout.setPaymentMethod(selected);
                  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                    SnackBar(content: Text('Método de pago: $selected')),
                  );
                }
              },
            ),
          ),

          // Encabezado: datos y almacenamiento
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text('Datos y almacenamiento',
                style: TextStyle(color: Colors.white70, fontSize: 13)),
          ),

          // Acción: vaciar carrito con confirmación
          ListTile(
            title: const Text('Vaciar carrito',
                style: TextStyle(color: Colors.white)),
            subtitle: const Text('Elimina todos los productos del carrito',
                style: TextStyle(color: Colors.white70)),
            trailing: const Icon(Icons.delete_outline, color: Colors.white70),
            onTap: () async {
              final ok = await showDialog<bool>(
                context: context,
                // Diálogo de confirmación
                builder: (ctx) => AlertDialog(
                  title: const Text('Vaciar carrito'),
                  content: const Text(
                      '¿Seguro que deseas eliminar todos los productos del carrito?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Vaciar'),
                    ),
                  ],
                ),
              );
              if (ok == true) {
                cart.clear();
                ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                  const SnackBar(content: Text('Carrito vaciado')),
                );
              }
            },
          ),

          // Acción: borrar historial de pedidos con confirmación
          ListTile(
            title: const Text('Borrar historial de pedidos',
                style: TextStyle(color: Colors.white)),
            subtitle: const Text('Elimina todos los pedidos locales',
                style: TextStyle(color: Colors.white70)),
            trailing: const Icon(Icons.history_toggle_off,
                color: Colors.white70),
            onTap: () async {
              final ok = await showDialog<bool>(
                context: context,
                // Diálogo de confirmación
                builder: (ctx) => AlertDialog(
                  title: const Text('Borrar historial'),
                  content: const Text(
                      '¿Seguro que deseas eliminar todos los pedidos guardados en este dispositivo?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Borrar'),
                    ),
                  ],
                ),
              );
              if (ok == true) {
                orders.orders.value = [];
                ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                  const SnackBar(content: Text('Historial de pedidos borrado')),
                );
              }
            },
          ),

          // Encabezado: Firebase
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text('Firebase',
                style: TextStyle(color: Colors.white70, fontSize: 13)),
          ),

          // Acción: Migrar productos a Firebase (solo una vez)
          ListTile(
            title: const Text('Migrar productos a Firebase',
                style: TextStyle(color: Colors.white)),
            subtitle: const Text(
                'Sube los productos iniciales a Firebase (ejecutar solo una vez)',
                style: TextStyle(color: Colors.white70)),
            trailing: _isMigrating
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.cloud_upload, color: Colors.white70),
            onTap: _isMigrating ? null : _migrateProducts,
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Future<void> _migrateProducts() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Migrar productos a Firebase'),
        content: const Text(
          '¿Deseas subir los productos iniciales a Firebase?\n\n'
          'IMPORTANTE: Solo ejecuta esto UNA vez. Si ya tienes productos en Firebase, '
          'se duplicarán.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Migrar'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isMigrating = true);

    try {
      await DataMigration.migrateProducts();
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Productos migrados exitosamente a Firebase'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error al migrar productos: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isMigrating = false);
      }
    }
  }
}
