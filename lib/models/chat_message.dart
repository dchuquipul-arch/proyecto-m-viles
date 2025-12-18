import 'package:uuid/uuid.dart';

enum MessageRole { user, assistant, system }

class ChatMessage {
  final String id;
  final String content;
  final MessageRole role;
  final DateTime timestamp;
  final bool isLoading;

  ChatMessage({
    String? id,
    required this.content,
    required this.role,
    DateTime? timestamp,
    this.isLoading = false,
  }) : id = id ?? const Uuid().v4(),
       timestamp = timestamp ?? DateTime.now();

  // Método para crear una copia del mensaje con cambios
  ChatMessage copyWith({
    String? id,
    String? content,
    MessageRole? role,
    DateTime? timestamp,
    bool? isLoading,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  // Convertir a Map para almacenamiento
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'role': role.toString(),
      'timestamp': timestamp.toIso8601String(),
      'isLoading': isLoading,
    };
  }

  // Crear desde Map
  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'],
      content: map['content'],
      role: MessageRole.values.firstWhere(
        (e) => e.toString() == map['role'],
        orElse: () => MessageRole.user,
      ),
      timestamp: DateTime.parse(map['timestamp']),
      isLoading: map['isLoading'] ?? false,
    );
  }
}
