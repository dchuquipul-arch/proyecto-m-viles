import 'dart:convert';
import 'package:http/http.dart' as http;

/// Excepción personalizada para errores de Culqi
class CulqiException implements Exception {
  final String message;
  final String? userMessage;
  final String? type;

  CulqiException({
    required this.message,
    this.userMessage,
    this.type,
  });

  @override
  String toString() => userMessage ?? message;
}

/// Modelo para los datos de la tarjeta
class CardData {
  final String cardNumber;
  final String cvv;
  final int expirationMonth;
  final int expirationYear;
  final String email;

  const CardData({
    required this.cardNumber,
    required this.cvv,
    required this.expirationMonth,
    required this.expirationYear,
    required this.email,
  });

  /// Convierte los datos de la tarjeta a JSON para la API de Culqi
  Map<String, dynamic> toJson() {
    return {
      'card_number': cardNumber.replaceAll(' ', ''),
      'cvv': cvv,
      'expiration_month': expirationMonth.toString().padLeft(2, '0'),
      'expiration_year': expirationYear.toString(),
      'email': email,
    };
  }
}

/// Respuesta de tokenización exitosa
class TokenResponse {
  final String id;
  final String type;
  final String email;
  final String cardNumber; // Últimos 4 dígitos
  final String cardBrand;

  const TokenResponse({
    required this.id,
    required this.type,
    required this.email,
    required this.cardNumber,
    required this.cardBrand,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      email: json['email'] as String? ?? '',
      cardNumber: json['card_number'] as String? ?? '',
      cardBrand: json['iin']?['card_brand'] as String? ?? 'Unknown',
    );
  }
}

/// Servicio para interactuar con la API de Culqi (tokenización de tarjetas)
class CulqiService {
  // URL base de la API de Culqi para tokenización
  static const String _baseUrl = 'https://secure.culqi.com/v2';

  // Public key de Culqi (modo test)
  // IMPORTANTE: Reemplazar con tu propia public key
  static const String _publicKey = 'pk_test_huoGUNrhA7fH5Bdn';

  final http.Client _client;

  CulqiService({http.Client? client}) : _client = client ?? http.Client();

  /// Tokeniza los datos de una tarjeta de crédito/débito
  /// Retorna el token que debe enviarse al backend para procesar el pago
  Future<TokenResponse> createToken(CardData cardData) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/tokens'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_publicKey',
        },
        body: jsonEncode(cardData.toJson()),
      );

      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201) {
        return TokenResponse.fromJson(responseBody);
      } else {
        // Manejar errores de Culqi
        throw _handleCulqiError(responseBody, response.statusCode);
      }
    } on CulqiException {
      rethrow;
    } catch (e) {
      throw CulqiException(
        message: 'Error de conexión: $e',
        userMessage: 'No se pudo conectar con el servicio de pagos. '
            'Verifica tu conexión a internet.',
      );
    }
  }

  /// Maneja los errores de la API de Culqi y retorna una excepción amigable
  CulqiException _handleCulqiError(
      Map<String, dynamic> response, int statusCode) {
    final type = response['type'] as String?;
    final merchantMessage = response['merchant_message'] as String?;
    final userMessage = response['user_message'] as String?;

    // Mensajes de error comunes y sus traducciones/mejoras
    String friendlyMessage;

    switch (type) {
      case 'parameter_error':
        friendlyMessage = _getParameterErrorMessage(merchantMessage);
        break;
      case 'card_error':
        friendlyMessage = userMessage ?? 'La tarjeta fue rechazada. '
            'Verifica los datos o intenta con otra tarjeta.';
        break;
      case 'authentication_error':
        friendlyMessage = 'Error de autenticación con el servicio de pagos.';
        break;
      case 'rate_limit_error':
        friendlyMessage = 'Demasiados intentos. Espera un momento e intenta nuevamente.';
        break;
      default:
        friendlyMessage = userMessage ?? 'Ocurrió un error al procesar la tarjeta.';
    }

    return CulqiException(
      message: merchantMessage ?? 'Error desconocido',
      userMessage: friendlyMessage,
      type: type,
    );
  }

  /// Traduce mensajes de error de parámetros
  String _getParameterErrorMessage(String? message) {
    if (message == null) return 'Datos de tarjeta inválidos.';

    if (message.contains('card_number')) {
      return 'El número de tarjeta no es válido.';
    } else if (message.contains('cvv')) {
      return 'El código CVV no es válido.';
    } else if (message.contains('expiration')) {
      return 'La fecha de vencimiento no es válida.';
    } else if (message.contains('email')) {
      return 'El correo electrónico no es válido.';
    }

    return 'Por favor verifica los datos de tu tarjeta.';
  }

  /// Valida el número de tarjeta usando el algoritmo de Luhn
  static bool validateCardNumber(String cardNumber) {
    final cleanNumber = cardNumber.replaceAll(' ', '');

    if (cleanNumber.length < 13 || cleanNumber.length > 19) {
      return false;
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(cleanNumber)) {
      return false;
    }

    // Algoritmo de Luhn
    int sum = 0;
    bool isEven = false;

    for (int i = cleanNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cleanNumber[i]);

      if (isEven) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }

      sum += digit;
      isEven = !isEven;
    }

    return sum % 10 == 0;
  }

  /// Valida el CVV
  static bool validateCvv(String cvv) {
    return cvv.length >= 3 && cvv.length <= 4 && RegExp(r'^[0-9]+$').hasMatch(cvv);
  }

  /// Valida la fecha de expiración
  static bool validateExpirationDate(int month, int year) {
    if (month < 1 || month > 12) return false;

    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;

    // Convertir año de 2 dígitos a 4 dígitos si es necesario
    final fullYear = year < 100 ? 2000 + year : year;

    if (fullYear < currentYear) return false;
    if (fullYear == currentYear && month < currentMonth) return false;

    return true;
  }

  /// Detecta el tipo de tarjeta basado en el número
  static String detectCardBrand(String cardNumber) {
    final cleanNumber = cardNumber.replaceAll(' ', '');

    if (cleanNumber.startsWith('4')) {
      return 'Visa';
    } else if (RegExp(r'^5[1-5]').hasMatch(cleanNumber) ||
        RegExp(r'^2[2-7]').hasMatch(cleanNumber)) {
      return 'Mastercard';
    } else if (cleanNumber.startsWith('34') || cleanNumber.startsWith('37')) {
      return 'American Express';
    } else if (cleanNumber.startsWith('36') ||
        cleanNumber.startsWith('38') ||
        cleanNumber.startsWith('39')) {
      return 'Diners Club';
    }

    return 'Tarjeta';
  }

  /// Formatea el número de tarjeta para mostrar (agrega espacios)
  static String formatCardNumber(String cardNumber) {
    final cleanNumber = cardNumber.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < cleanNumber.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(cleanNumber[i]);
    }

    return buffer.toString();
  }

  void dispose() {
    _client.close();
  }
}
