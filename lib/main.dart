import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'pages/login_page.dart';
import 'pages/register_page.dart';

void main() async {
  // Asegura que Flutter esté inicializado
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa Firebase
  await Firebase.initializeApp();
  
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
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
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
        '/settings': (context) => const SettingsPage()
      },
    );
  }
}

// Widget que maneja el estado de autenticación
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Esperando conexión
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Si hay error
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        // Si el usuario está autenticado, mostrar la página principal
        if (snapshot.hasData) {
          return const MyHomePage();
        }

        // Si no está autenticado, mostrar la página de login
        return const LoginPage();
      },
    );
  }
}