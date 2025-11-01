import 'package:flutter/foundation.dart';

class CheckoutService {
  static final CheckoutService _instance = CheckoutService._internal();
  factory CheckoutService() => _instance;
  CheckoutService._internal();

  final ValueNotifier<String?> shippingAddress = ValueNotifier<String?>(null);
  final ValueNotifier<String?> paymentMethod = ValueNotifier<String?>(null);

  void setShippingAddress(String address) {
    shippingAddress.value = address;
  }

  void setPaymentMethod(String method) {
    paymentMethod.value = method;
  }

  void clear() {
    shippingAddress.value = null;
    paymentMethod.value = null;
  }
}
