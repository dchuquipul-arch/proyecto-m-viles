import 'package:flutter/material.dart';
import 'package:hello_world/services/checkout_service.dart';
import 'package:hello_world/services/cart_service.dart';
import 'package:hello_world/services/orders_service.dart';
import 'package:hello_world/services/auth_service.dart';
import 'package:hello_world/utils/migrate_data.dart';

// Pantalla de configuración y datos locales
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isMigrating = false;
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final checkout = CheckoutService();
    final cart = CartService();
    final orders = OrdersService();
    final user = _authService.currentUser;

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
          // Sección de perfil de usuario
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A202C),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Avatar del usuario
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.green.shade700,
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : null,
                  child: user?.photoURL == null
                      ? Text(
                          user?.displayName?.substring(0, 1).toUpperCase() ??
                              user?.email?.substring(0, 1).toUpperCase() ??
                              'U',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                // Información del usuario
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.displayName ?? 'Usuario',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? '',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Encabezado: cuenta
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text('Cuenta',
                style: TextStyle(color: Colors.white70, fontSize: 13)),
          ),

          // Botón de cerrar sesión
          ListTile(
            title: const Text('Cerrar sesión',
                style: TextStyle(color: Colors.white)),
            subtitle: const Text('Salir de tu cuenta',
                style: TextStyle(color: Colors.white70)),
            trailing: const Icon(Icons.logout, color: Colors.white70),
            onTap: _signOut,
          ),

          // Encabezado: cuenta de compra
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
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

  Future<void> _signOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      // Mostrar indicador de carga
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 16),
                Text('Cerrando sesión...'),
              ],
            ),
            duration: Duration(seconds: 2),
          ),
        );
      }

      // Cerrar sesión en Firebase
      await _authService.signOut();
      
      if (!mounted) return;
      
      // El AuthWrapper detectará automáticamente que no hay usuario
      // y redirigirá a LoginPage, pero navegamos manualmente para limpiar el stack
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cerrar sesión: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
