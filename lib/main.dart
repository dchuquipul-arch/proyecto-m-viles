import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/menu.dart';
import 'pages/pedidos.dart';
import 'pages/product_detail.dart';
import 'pages/categories.dart';
import 'pages/search.dart';
import 'pages/cart.dart';
import 'pages/checkout_shipping.dart';
import 'pages/checkout_payment.dart';
import 'pages/checkout_review.dart';
import 'pages/order_confirmation.dart';
import 'pages/login.dart';
import 'pages/register.dart';
import 'pages/profile.dart';
import 'pages/addresses.dart';
import 'pages/address_edit.dart';
import 'pages/payment_methods.dart';
import 'pages/orders_history.dart';
import 'pages/order_detail.dart';
import 'pages/help_center.dart';
import 'pages/terms.dart';
import 'pages/privacy.dart';
import 'pages/about.dart';
import 'pages/onboarding.dart';
import 'pages/splash.dart';
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
        '/pedidos': (context) => const PantallaPedidos(),
        '/product': (context) => const ProductDetailPage(),
        '/categories': (context) => const CategoriesPage(),
        '/search': (context) => const SearchPage(),
        '/cart': (context) => const CartPage(),
        '/checkout/shipping': (context) => const CheckoutShippingPage(),
        '/checkout/payment': (context) => const CheckoutPaymentPage(),
        '/checkout/review': (context) => const CheckoutReviewPage(),
        '/order/confirmation': (context) => const OrderConfirmationPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/profile': (context) => const ProfilePage(),
        '/addresses': (context) => const AddressesPage(),
        '/address/edit': (context) => const AddressEditPage(),
        '/payment-methods': (context) => const PaymentMethodsPage(),
        '/orders': (context) => const OrdersHistoryPage(),
        '/order': (context) => const OrderDetailPage(),
        '/help': (context) => const HelpCenterPage(),
        '/terms': (context) => const TermsPage(),
        '/privacy': (context) => const PrivacyPage(),
        '/about': (context) => const AboutPage(),
        '/onboarding': (context) => const OnboardingPage(),
        '/splash': (context) => const SplashPage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}