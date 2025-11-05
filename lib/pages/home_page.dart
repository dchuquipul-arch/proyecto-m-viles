import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Pantalla base con estructura visual general
    return Scaffold(
      backgroundColor: const Color(0xFF2D3748),
      // Capa apilada para colocar fondo e interfaz encima
      body: Stack(
        children: [
          // Imagen de fondo a pantalla completa
          Positioned.fill(
            child: Image.network(
              'https://i.pinimg.com/736x/b2/49/9f/b2499f35033dfbb9bfb5dcb355f18316.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Overlay oscuro para mejorar legibilidad de textos/botones
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.black45),
            ),
          ),
          // Zona segura para evitar notches/barras del sistema
          SafeArea(
            child: Padding(
              // Margen interno uniforme para el contenido
              padding: const EdgeInsets.all(20.0),
              child: Column(
                // Contenedor vertical del contenido principal
                children: [
                  // Cabecera con logo y texto de marca
                  const Column(
                    children: [
                      // Logo redondo de la marca
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.spa,
                          size: 40,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      // Separación entre logo y título
                      SizedBox(height: 15),
                      // Título principal de la marca
                      Text(
                        'Natura Co',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      // Separación entre título y subtítulo
                      SizedBox(height: 5),
                      // Subtítulo descriptivo
                      Text(
                        'Boutique',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  // Espacio antes de los botones de acción
                  const SizedBox(height: 40),
                  
                  // Fila para contener el botón principal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Botón de acción para ir al menú
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/menu'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF2D3748),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        ),
                        child: const Text('Ingresar'),
                      ),
                    ],
                  ),
                  
                  // Empuja el bloque inferior hacia la parte baja de la pantalla
                  const Spacer(),
                  
                  // Bloque inferior con lema y divisor
                  Column(
                    children: [
                      // Lema de la aplicación
                      const Text(
                        'Sientete natural, vive Natura Co',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      // Separación antes del divisor
                      const SizedBox(height: 10),
                      // Divisor decorativo bajo el lema
                      Container(
                        width: 50,
                        height: 3,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}