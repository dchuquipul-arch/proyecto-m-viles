class PaymentUtils {
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
    return cvv.length >= 3 &&
        cvv.length <= 4 &&
        RegExp(r'^[0-9]+$').hasMatch(cvv);
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
}
