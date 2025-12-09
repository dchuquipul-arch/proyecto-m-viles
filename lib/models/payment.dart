/// Enum que representa los posibles estados de un pago
enum PaymentStatus {
  pending,
  captured,
  declined,
  refunded;

  /// Convierte un string a PaymentStatus
  static PaymentStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return PaymentStatus.pending;
      case 'captured':
        return PaymentStatus.captured;
      case 'declined':
        return PaymentStatus.declined;
      case 'refunded':
        return PaymentStatus.refunded;
      default:
        return PaymentStatus.pending;
    }
  }

  /// Convierte el enum a string
  String toShortString() {
    return toString().split('.').last;
  }

  /// Obtiene el nombre en español para mostrar en UI
  String get displayName {
    switch (this) {
      case PaymentStatus.pending:
        return 'Pendiente';
      case PaymentStatus.captured:
        return 'Capturado';
      case PaymentStatus.declined:
        return 'Rechazado';
      case PaymentStatus.refunded:
        return 'Reembolsado';
    }
  }
}

/// Modelo que representa un pago procesado
class Payment {
  final String id;
  final String culqiChargeId;
  final int amount; // En centavos (5000 = 50.00 PEN)
  final String currency;
  final String email;
  final PaymentStatus status;
  final String productId;
  final String userId;
  final DateTime createdAt;

  const Payment({
    required this.id,
    required this.culqiChargeId,
    required this.amount,
    required this.currency,
    required this.email,
    required this.status,
    required this.productId,
    required this.userId,
    required this.createdAt,
  });

  /// Obtiene el monto formateado (ej: "S/ 50.00")
  String get formattedAmount {
    final amountInSoles = amount / 100;
    return 'S/ ${amountInSoles.toStringAsFixed(2)}';
  }

  /// Crea una instancia de Payment desde un JSON
  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as String? ?? '',
      culqiChargeId: json['culqi_charge_id'] as String? ?? '',
      amount: json['amount'] as int? ?? 0,
      currency: json['currency'] as String? ?? 'PEN',
      email: json['email'] as String? ?? '',
      status: PaymentStatus.fromString(json['status'] as String? ?? 'pending'),
      productId: json['product_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  /// Convierte la instancia a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'culqi_charge_id': culqiChargeId,
      'amount': amount,
      'currency': currency,
      'email': email,
      'status': status.toShortString(),
      'product_id': productId,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Crea una copia del Payment con campos modificados
  Payment copyWith({
    String? id,
    String? culqiChargeId,
    int? amount,
    String? currency,
    String? email,
    PaymentStatus? status,
    String? productId,
    String? userId,
    DateTime? createdAt,
  }) {
    return Payment(
      id: id ?? this.id,
      culqiChargeId: culqiChargeId ?? this.culqiChargeId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      email: email ?? this.email,
      status: status ?? this.status,
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Payment(id: $id, amount: $formattedAmount, status: ${status.displayName})';
  }
}
