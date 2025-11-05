import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/menu.dart';
import 'pages/product_detail.dart';
import 'pages/cart.dart';
import 'pages/checkout_shipping.dart';
import 'pages/checkout_payment.dart';
import 'pages/checkout_review.dart';
import 'pages/order_confirmation.dart';
import 'pages/appointment_page.dart';
import 'pages/orders_history.dart';
import 'pages/order_detail.dart';
import 'pages/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Natura Co',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
      routes: {
        '/menu': (context) => const MenuPage(),
        '/product': (context) => const ProductDetailPage(),
        '/cart': (context) => const CartPage(),
        '/checkout/shipping': (context) => const CheckoutShippingPage(),
        '/checkout/payment': (context) => const CheckoutPaymentPage(),
        '/checkout/review': (context) => const CheckoutReviewPage(),
        '/order/confirmation': (context) => const OrderConfirmationPage(),
        '/appointment': (context) => const AppointmentPage(),
        '/orders': (context) => const OrdersHistoryPage(),
        '/order': (context) => const OrderDetailPage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}