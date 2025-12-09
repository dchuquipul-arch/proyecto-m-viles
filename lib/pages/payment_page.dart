import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/payment.dart';
import '../services/culqi_service.dart';
import '../services/payment_service.dart';
import '../widgets/credit_card_form.dart';

/// Pantalla de pago con tarjeta de crédito
class PaymentPage extends StatefulWidget {
  final Product product;
  final String userId;
  final String userEmail;

  const PaymentPage({
    super.key,
    required this.product,
    required this.userId,
    required this.userEmail,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final CulqiService _culqiService = CulqiService();
  final PaymentService _paymentService = PaymentService();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _culqiService.dispose();
    _paymentService.dispose();
    super.dispose();
  }

  /// Procesa el pago completo: tokenización + envío al backend
  Future<void> _processPayment(CreditCardFormData formData) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Paso 1: Tokenizar la tarjeta con Culqi
      final tokenResponse = await _culqiService.createToken(formData.toCardData());

      // Paso 2: Enviar el token al backend para procesar el pago
      final paymentResult = await _paymentService.processPayment(
        token: tokenResponse.id,
        amount: _getAmountInCents(),
        email: formData.email,
        productId: widget.product.id,
        userId: widget.userId,
      );

      if (!mounted) return;

      if (paymentResult.success && paymentResult.payment != null) {
        // Pago exitoso
        _showSuccessDialog(paymentResult.payment!);
      } else {
        // Error en el pago
        setState(() {
          _errorMessage = paymentResult.errorMessage ?? 'El pago no pudo ser procesado.';
        });
      }
    } on CulqiException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.userMessage ?? e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Ocurrió un error inesperado. Por favor intenta nuevamente.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Convierte el precio del producto a centavos
  int _getAmountInCents() {
    return (widget.product.price * 100).round();
  }

  /// Muestra el diálogo de pago exitoso
  void _showSuccessDialog(Payment payment) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 64,
        ),
        title: const Text('¡Pago exitoso!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tu pago ha sido procesado correctamente.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            _buildPaymentDetail('Producto', widget.product.name),
            _buildPaymentDetail('Monto', payment.formattedAmount),
            _buildPaymentDetail('Estado', payment.status.displayName),
            _buildPaymentDetail('ID de pago', payment.id),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar diálogo
              Navigator.of(context).pop(payment); // Regresar con el pago
            },
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Realizar pago'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Resumen del producto
            _buildProductSummary(colorScheme),

            const SizedBox(height: 24),

            // Mensaje de error
            if (_errorMessage != null) ...[
              _buildErrorBanner(colorScheme),
              const SizedBox(height: 16),
            ],

            // Título de la sección de pago
            Text(
              'Datos de la tarjeta',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Formulario de tarjeta
            CreditCardForm(
              onSubmit: _processPayment,
              isLoading: _isLoading,
              initialEmail: widget.userEmail,
              submitButtonText: 'Pagar ${_formatPrice(widget.product.price)}',
            ),

            const SizedBox(height: 24),

            // Tarjetas de prueba (solo para desarrollo)
            _buildTestCardsInfo(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildProductSummary(ColorScheme colorScheme) {
    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Imagen del producto
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.product.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: colorScheme.surfaceContainerHigh,
                  child: Icon(
                    Icons.image,
                    color: colorScheme.outline,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Detalles del producto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.product.category,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.outline,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatPrice(widget.product.price),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorBanner(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: colorScheme.error,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: colorScheme.onErrorContainer,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() {
                _errorMessage = null;
              });
            },
            color: colorScheme.onErrorContainer,
          ),
        ],
      ),
    );
  }

  Widget _buildTestCardsInfo(ColorScheme colorScheme) {
    return Card(
      elevation: 0,
      color: colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: colorScheme.onSecondaryContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  'Tarjetas de prueba',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTestCard('Aprobada:', '4111 1111 1111 1111', colorScheme),
            _buildTestCard('Rechazada:', '4000 0000 0000 0002', colorScheme),
            const SizedBox(height: 8),
            Text(
              'CVV: cualquier 3 dígitos • Fecha: cualquier fecha futura',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSecondaryContainer.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestCard(String label, String number, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSecondaryContainer,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            number,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
              color: colorScheme.onSecondaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    return 'S/ ${price.toStringAsFixed(2)}';
  }
}
