import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_message.dart';

class ChatbotService {
  // Configuración del API de Natura Co
  static const String apiUrl = 'https://natura-co.benjadev.xyz/api/v1/chat/';

  final List<ChatMessage> _conversationHistory = [];
  String? _sessionId;

  // Generar o obtener el sessionId
  String get sessionId {
    _sessionId ??= const Uuid().v4();
    return _sessionId!;
  }

  // Obtener el historial de conversación
  List<ChatMessage> get conversationHistory =>
      List.unmodifiable(_conversationHistory);

  // Agregar mensaje al historial
  void addMessage(ChatMessage message) {
    _conversationHistory.add(message);
  }

  // Limpiar historial y crear nueva sesión
  void clearHistory() {
    _conversationHistory.clear();
    _sessionId = null; // Generar nuevo sessionId en el próximo mensaje
  }

  // Obtener el token de autenticación de Firebase
  Future<String?> _getAuthToken() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('❌ No hay usuario autenticado');
        throw Exception('Usuario no autenticado');
      }

      print('✅ Usuario autenticado: ${user.email}');

      // Forzar renovación del token para asegurar que esté actualizado
      final token = await user.getIdToken(true);

      if (token != null) {
        print('✅ Token obtenido exitosamente (${token.length} caracteres)');
        // Mostrar los primeros caracteres del token para debug
        print('🔑 Token preview: ${token.substring(0, 20)}...');
        // Mostrar el token completo para debugging
        print('🔑 TOKEN COMPLETO:\n$token \n');
      }

      return token;
    } catch (e) {
      print('❌ Error al obtener token: $e');
      return null;
    }
  }

  // Enviar mensaje y obtener respuesta
  Future<ChatMessage> sendMessage(String userMessage) async {
    print('\n📤 Enviando mensaje: "$userMessage"');

    // Agregar mensaje del usuario al historial
    final userChatMessage = ChatMessage(
      content: userMessage,
      role: MessageRole.user,
    );
    addMessage(userChatMessage);

    try {
      // Obtener token de autenticación
      print('🔐 Obteniendo token de autenticación...');
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('No se pudo obtener el token de autenticación');
      }

      print('📡 SessionId: $sessionId');
      print('🌐 Enviando request a: $apiUrl');

      // Realizar petición al endpoint
      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({'sessionId': sessionId, 'message': userMessage}),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception(
                'Tiempo de espera agotado. Por favor, intenta de nuevo.',
              );
            },
          );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Verificar que la respuesta sea exitosa
        if (responseData['success'] != true) {
          print('❌ Backend retornó success=false');
          throw Exception(
            responseData['message'] ?? 'Error desconocido del servidor',
          );
        }

        // Extraer el output del array de data
        final data = responseData['data'];
        String botResponse;

        if (data is List && data.isNotEmpty && data[0]['output'] != null) {
          botResponse = data[0]['output'];
        } else if (data is Map && data['output'] != null) {
          botResponse = data['output'];
        } else {
          print('❌ Estructura de respuesta inesperada: $data');
          botResponse = 'Lo siento, no pude procesar tu mensaje.';
        }

        print('✅ Respuesta del bot recibida');

        final assistantMessage = ChatMessage(
          content: botResponse,
          role: MessageRole.assistant,
        );
        addMessage(assistantMessage);

        return assistantMessage;
      } else if (response.statusCode == 401) {
        print('❌ Error 401: No autorizado');
        print('❌ Response body: ${response.body}');

        // Intentar extraer el mensaje de error del backend
        try {
          final errorData = jsonDecode(response.body);
          final errorMessage = errorData['message'] ?? 'Error de autenticación';
          throw Exception(errorMessage);
        } catch (e) {
          throw Exception('Error de autenticación. Verifica tu sesión.');
        }
      } else if (response.statusCode == 429) {
        throw Exception(
          'Demasiadas solicitudes. Por favor, espera un momento.',
        );
      } else {
        print('❌ Error ${response.statusCode}: ${response.body}');
        throw Exception('Error del servidor (${response.statusCode})');
      }
    } on http.ClientException catch (e) {
      print('❌ Error de conexión: $e');
      final errorMessage = ChatMessage(
        content: 'Error de conexión. Verifica tu internet e intenta de nuevo.',
        role: MessageRole.assistant,
      );
      addMessage(errorMessage);
      return errorMessage;
    } catch (e) {
      print('❌ Error general: $e');
      final errorMessage = ChatMessage(
        content: e.toString().contains('Exception:')
            ? e.toString().replaceAll('Exception: ', '')
            : 'Lo siento, hubo un error al procesar tu mensaje. Por favor, intenta de nuevo.',
        role: MessageRole.assistant,
      );
      addMessage(errorMessage);
      return errorMessage;
    }
  }

  // Obtener sugerencias de preguntas
  List<String> getSuggestedQuestions() {
    return [
      '¿Qué productos tienen disponibles?',
      '¿Cómo puedo hacer un pedido?',
      '¿Cuál es el tiempo de envío?',
      '¿Tienen promociones activas?',
      'Quiero agendar una cita',
      '¿Cuáles son los métodos de pago?',
    ];
  }

  // Verificar estado de la conexión
  Future<bool> checkConnection() async {
    try {
      final token = await _getAuthToken();
      if (token == null) return false;

      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({'sessionId': sessionId, 'message': 'ping'}),
          )
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
