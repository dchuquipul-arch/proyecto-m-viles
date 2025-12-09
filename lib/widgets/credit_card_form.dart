import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/culqi_service.dart';

/// Datos del formulario de tarjeta
class CreditCardFormData {
  final String cardNumber;
  final String cvv;
  final int expirationMonth;
  final int expirationYear;
  final String email;

  const CreditCardFormData({
    required this.cardNumber,
    required this.cvv,
    required this.expirationMonth,
    required this.expirationYear,
    required this.email,
  });

  /// Convierte a CardData para el servicio de Culqi
  CardData toCardData() {
    return CardData(
      cardNumber: cardNumber,
      cvv: cvv,
      expirationMonth: expirationMonth,
      expirationYear: expirationYear,
      email: email,
    );
  }
}

/// Widget de formulario para ingresar datos de tarjeta de crédito
class CreditCardForm extends StatefulWidget {
  final Function(CreditCardFormData) onSubmit;
  final bool isLoading;
  final String? initialEmail;
  final String submitButtonText;

  const CreditCardForm({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
    this.initialEmail,
    this.submitButtonText = 'Pagar',
  });

  @override
  State<CreditCardForm> createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  final _formKey = GlobalKey<FormState>();
  
  late final TextEditingController _cardNumberController;
  late final TextEditingController _expirationController;
  late final TextEditingController _cvvController;
  late final TextEditingController _emailController;

  String _cardBrand = '';

  @override
  void initState() {
    super.initState();
    _cardNumberController = TextEditingController();
    _expirationController = TextEditingController();
    _cvvController = TextEditingController();
    _emailController = TextEditingController(text: widget.initialEmail ?? '');

    _cardNumberController.addListener(_onCardNumberChanged);
  }

  @override
  void dispose() {
    _cardNumberController.removeListener(_onCardNumberChanged);
    _cardNumberController.dispose();
    _expirationController.dispose();
    _cvvController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onCardNumberChanged() {
    final cardNumber = _cardNumberController.text;
    setState(() {
      _cardBrand = CulqiService.detectCardBrand(cardNumber);
    });
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final expParts = _expirationController.text.split('/');
      final month = int.tryParse(expParts[0]) ?? 0;
      final year = int.tryParse(expParts[1]) ?? 0;

      final formData = CreditCardFormData(
        cardNumber: _cardNumberController.text.replaceAll(' ', ''),
        cvv: _cvvController.text,
        expirationMonth: month,
        expirationYear: year < 100 ? 2000 + year : year,
        email: _emailController.text,
      );

      widget.onSubmit(formData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Campo de número de tarjeta
          TextFormField(
            controller: _cardNumberController,
            decoration: InputDecoration(
              labelText: 'Número de tarjeta',
              hintText: '4111 1111 1111 1111',
              prefixIcon: const Icon(Icons.credit_card),
              suffixIcon: _cardBrand.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: _buildCardBrandIcon(),
                    )
                  : null,
              border: const OutlineInputBorder(),
              filled: true,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _CardNumberInputFormatter(),
              LengthLimitingTextInputFormatter(19), // 16 dígitos + 3 espacios
            ],
            validator: _validateCardNumber,
            enabled: !widget.isLoading,
          ),

          const SizedBox(height: 16),

          // Fila de expiración y CVV
          Row(
            children: [
              // Campo de expiración
              Expanded(
                child: TextFormField(
                  controller: _expirationController,
                  decoration: const InputDecoration(
                    labelText: 'MM/AA',
                    hintText: '12/25',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                    filled: true,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _ExpirationDateInputFormatter(),
                    LengthLimitingTextInputFormatter(5),
                  ],
                  validator: _validateExpiration,
                  enabled: !widget.isLoading,
                ),
              ),

              const SizedBox(width: 16),

              // Campo de CVV
              Expanded(
                child: TextFormField(
                  controller: _cvvController,
                  decoration: const InputDecoration(
                    labelText: 'CVV',
                    hintText: '123',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                    filled: true,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  obscureText: true,
                  validator: _validateCvv,
                  enabled: !widget.isLoading,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Campo de email
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Correo electrónico',
              hintText: 'ejemplo@correo.com',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
              filled: true,
            ),
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
            enabled: !widget.isLoading,
          ),

          const SizedBox(height: 24),

          // Botón de pagar
          FilledButton(
            onPressed: widget.isLoading ? null : _handleSubmit,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: colorScheme.primary,
            ),
            child: widget.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        widget.submitButtonText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
          ),

          const SizedBox(height: 16),

          // Información de seguridad
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shield, size: 16, color: colorScheme.outline),
              const SizedBox(width: 8),
              Text(
                'Pago seguro procesado por Culqi',
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.outline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardBrandIcon() {
    IconData iconData;
    Color color;

    switch (_cardBrand) {
      case 'Visa':
        iconData = Icons.credit_card;
        color = Colors.blue;
        break;
      case 'Mastercard':
        iconData = Icons.credit_card;
        color = Colors.orange;
        break;
      case 'American Express':
        iconData = Icons.credit_card;
        color = Colors.blueGrey;
        break;
      default:
        iconData = Icons.credit_card;
        color = Colors.grey;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(iconData, color: color, size: 20),
        if (_cardBrand.isNotEmpty)
          Text(
            _cardBrand,
            style: TextStyle(fontSize: 8, color: color),
          ),
      ],
    );
  }

  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa el número de tarjeta';
    }

    final cleanNumber = value.replaceAll(' ', '');
    if (cleanNumber.length < 13) {
      return 'El número de tarjeta es muy corto';
    }

    if (!CulqiService.validateCardNumber(cleanNumber)) {
      return 'El número de tarjeta no es válido';
    }

    return null;
  }

  String? _validateExpiration(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa la fecha';
    }

    if (!value.contains('/') || value.length != 5) {
      return 'Formato: MM/AA';
    }

    final parts = value.split('/');
    final month = int.tryParse(parts[0]) ?? 0;
    final year = int.tryParse(parts[1]) ?? 0;

    if (!CulqiService.validateExpirationDate(month, year)) {
      return 'Fecha inválida o vencida';
    }

    return null;
  }

  String? _validateCvv(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa el CVV';
    }

    if (!CulqiService.validateCvv(value)) {
      return 'CVV inválido';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa tu correo';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Correo electrónico inválido';
    }

    return null;
  }
}

/// Formateador para el número de tarjeta (agrega espacios cada 4 dígitos)
class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Formateador para la fecha de expiración (MM/AA)
class _ExpirationDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i == 2) {
        buffer.write('/');
      }
      buffer.write(text[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
