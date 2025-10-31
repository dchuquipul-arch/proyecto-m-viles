import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF2D3748),
      body: Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
