import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/payment.dart';

/// Excepción personalizada para errores del servicio de pagos
class PaymentException implements Exception {
  final String message;
  final int? statusCode;

  PaymentException({required this.message, this.statusCode});

  @override
  String toString() => message;
}

/// Resultado de una operación de pago
class PaymentResult {
  final bool success;
  final Payment? payment;
  final String? errorMessage;

  const PaymentResult({
    required this.success,
    this.payment,
    this.errorMessage,
  });

  factory PaymentResult.success(Payment payment) {
    return PaymentResult(success: true, payment: payment);
  }

  factory PaymentResult.failure(String errorMessage) {
    return PaymentResult(success: false, errorMessage: errorMessage);
  }
}

/// Servicio para comunicarse con el backend Django para procesar pagos
class PaymentService {
  // URL base del backend Django
  // IMPORTANTE: Cambiar a tu URL de producción cuando corresponda
  static const String _baseUrl = 'http://10.0.2.2:8000/api/v1';

  final http.Client _client;

  PaymentService({http.Client? client}) : _client = client ?? http.Client();

  /// Procesa un pago enviando el token de Culqi al backend
  /// 
  /// [token] - Token generado por Culqi (tkn_xxx)
  /// [amount] - Monto en centavos (5000 = 50.00 PEN)
  /// [email] - Email del cliente
  /// [productId] - ID del producto que se está comprando
  /// [userId] - ID del usuario que realiza la compra
  Future<PaymentResult> processPayment({
    required String token,
    required int amount,
    required String email,
    required String productId,
    required String userId,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/payments/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'token': token,
          'amount': amount,
          'email': email,
          'product_id': productId,
          'user_id': userId,
        }),
      );

      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseBody['success'] == true) {
          final paymentData = responseBody['data'] as Map<String, dynamic>;
          final payment = Payment.fromJson(paymentData);
          return PaymentResult.success(payment);
        } else {
          return PaymentResult.failure(
            responseBody['message'] as String? ?? 'El pago no pudo ser procesado.',
          );
        }
      } else {
        return PaymentResult.failure(
          _getErrorMessage(responseBody, response.statusCode),
        );
      }
    } on FormatException {
      return PaymentResult.failure('Respuesta inválida del servidor.');
    } catch (e) {
      return PaymentResult.failure(
        'No se pudo conectar con el servidor. Verifica tu conexión a internet.',
      );
    }
  }

  /// Obtiene los detalles de un pago específico
  Future<Payment> getPayment(String paymentId) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/payments/$paymentId/'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
        return Payment.fromJson(responseBody['data'] ?? responseBody);
      } else {
        throw PaymentException(
          message: 'No se pudo obtener el pago.',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is PaymentException) rethrow;
      throw PaymentException(
        message: 'Error de conexión al obtener el pago.',
      );
    }
  }

  /// Obtiene el historial de pagos de un usuario
  Future<List<Payment>> getUserPayments(String userId) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/payments/user/$userId/'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
        final paymentsData = responseBody['data'] as List<dynamic>? ?? [];

        return paymentsData
            .map((json) => Payment.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw PaymentException(
          message: 'No se pudo obtener el historial de pagos.',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is PaymentException) rethrow;
      throw PaymentException(
        message: 'Error de conexión al obtener el historial.',
      );
    }
  }

  /// Genera un mensaje de error amigable basado en la respuesta
  String _getErrorMessage(Map<String, dynamic> response, int statusCode) {
    final message = response['message'] as String?;
    final error = response['error'] as String?;

    if (message != null) return message;
    if (error != null) return error;

    switch (statusCode) {
      case 400:
        return 'Datos de pago inválidos.';
      case 401:
        return 'No autorizado. Por favor inicia sesión nuevamente.';
      case 403:
        return 'No tienes permiso para realizar esta operación.';
      case 404:
        return 'Recurso no encontrado.';
      case 500:
        return 'Error interno del servidor. Intenta más tarde.';
      default:
        return 'Ocurrió un error inesperado (código: $statusCode).';
    }
  }

  void dispose() {
    _client.close();
  }
}
