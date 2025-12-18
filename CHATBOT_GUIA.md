# Chatbot - Guía de Implementación

## 📱 Descripción

Se ha añadido un chatbot moderno y funcional a la aplicación Natura Co. El chatbot está diseñado con una interfaz premium y puede integrarse con diferentes backends.

## ✨ Características

- **Interfaz moderna y atractiva** con gradientes y animaciones suaves
- **Botón flotante** accesible desde la página principal
- **Soporte para Markdown** en las respuestas del asistente
- **Indicador de escritura** animado mientras el bot responde
- **Preguntas sugeridas** para facilitar la interacción
- **Historial de conversación** persistente durante la sesión
- **Múltiples opciones de backend** (OpenAI, backend personalizado, o modo de prueba)

## 🗂️ Archivos Creados

1. **`lib/models/chat_message.dart`**
   - Modelo de datos para los mensajes del chat
   - Soporta roles: usuario, asistente, sistema
   - Incluye timestamp y estado de carga

2. **`lib/services/chatbot_service.dart`**
   - Servicio principal del chatbot
   - Gestión del historial de conversación
   - Integración con APIs externas

3. **`lib/pages/chatbot_page.dart`**
   - Interfaz de usuario del chat
   - Diseño premium con gradientes y animaciones
   - Burbujas de mensajes diferenciadas por rol

4. **`lib/widgets/chatbot_floating_button.dart`**
   - Botón flotante animado
   - Acceso rápido al chatbot desde cualquier página

## 🔧 Configuración

### ✅ Configuración Actual (Endpoint Real)

El chatbot está **completamente configurado** y conectado al endpoint de producción:

- **URL**: `http://natura-co.benjadev.xyz/api/v1/chat`
- **Autenticación**: Token de Firebase (automático)
- **SessionId**: Generado automáticamente con UUID
- **Formato de Request**:
  ```json
  {
    "sessionId": "uuid-generado",
    "message": "mensaje del usuario"
  }
  ```
- **Headers**:
  ```
  Content-Type: application/json
  Authorization: Bearer {firebase-token}
  ```
- **Formato de Response**:
  ```json
  {
    "output": "respuesta del bot"
  }
  ```

### 🔐 Autenticación

El chatbot obtiene automáticamente el token de autenticación de Firebase del usuario actual. Esto significa:

1. ✅ **No necesitas configurar API keys manualmente**
2. ✅ **El token se renueva automáticamente**
3. ✅ **Cada usuario tiene su propia sesión autenticada**
4. ✅ **El sessionId mantiene el contexto de la conversación**

### 🔄 Gestión de Sesiones

- Cada conversación tiene un `sessionId` único
- El `sessionId` se mantiene durante toda la conversación
- Al limpiar el historial (botón refresh), se genera un nuevo `sessionId`
- El backend puede usar el `sessionId` para mantener contexto entre mensajes

### ⚠️ Manejo de Errores

El chatbot maneja automáticamente:

- **401 Unauthorized**: Sesión expirada, solicita reiniciar sesión
- **429 Too Many Requests**: Demasiadas solicitudes, pide esperar
- **Timeout (30s)**: Tiempo de espera agotado
- **Network errors**: Problemas de conexión
- **Otros errores**: Mensajes genéricos de error

## 🎨 Personalización

### Cambiar Colores del Gradiente

En `lib/pages/chatbot_page.dart` y `lib/widgets/chatbot_floating_button.dart`, busca:

```dart
gradient: const LinearGradient(
  colors: [Color(0xFF667EEA), Color(0xFF764BA2)], // Cambia estos colores
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
),
```

### Modificar Preguntas Sugeridas

En `lib/services/chatbot_service.dart`, método `getSuggestedQuestions()`:

```dart
List<String> getSuggestedQuestions() {
  return [
    '¿Qué productos tienen disponibles?',
    '¿Cómo puedo hacer un pedido?',
    // Añade o modifica preguntas aquí
  ];
}
```

### Personalizar Respuestas del Modo de Prueba

En `lib/services/chatbot_service.dart`, método `_getMockResponse()`:

```dart
final responses = {
  'palabra_clave': 'Respuesta personalizada',
  // Añade más respuestas aquí
};
```

## 🚀 Uso

### Acceder al Chatbot

1. **Desde el botón flotante**: En la página principal (MenuPage), verás un botón flotante con un ícono de chat en la esquina inferior derecha.
2. **Desde código**: Navega usando:
   ```dart
   Navigator.pushNamed(context, '/chatbot');
   ```

### Interactuar con el Chatbot

1. Escribe tu mensaje en el campo de texto
2. Presiona el botón de enviar o Enter
3. El bot mostrará un indicador de "escribiendo..."
4. Recibirás la respuesta en formato de burbuja
5. Puedes usar las preguntas sugeridas para comenzar

## 🔐 Seguridad

⚠️ **IMPORTANTE**: Nunca subas tu API key a un repositorio público.

Mejores prácticas:
1. Usa variables de entorno
2. Almacena la API key en el backend
3. Implementa autenticación para las llamadas al chatbot
4. Limita el uso con rate limiting

## 📊 Próximas Mejoras

- [ ] Persistencia del historial en Firebase
- [ ] Soporte para imágenes en mensajes
- [ ] Respuestas con botones de acción
- [ ] Integración con el sistema de pedidos
- [ ] Notificaciones push para respuestas
- [ ] Análisis de sentimiento
- [ ] Soporte multiidioma

## 🐛 Solución de Problemas

### El bot no responde

1. Verifica la conexión a internet
2. Revisa la consola para errores
3. Confirma que la API key es válida (si usas OpenAI)
4. Verifica que el backend esté activo (si usas backend personalizado)

### Errores de compilación

1. Ejecuta `flutter pub get`
2. Limpia el proyecto: `flutter clean`
3. Reconstruye: `flutter run`

### El botón flotante no aparece

1. Verifica que `ChatbotFloatingButton` esté importado en la página
2. Confirma que el `floatingActionButton` esté añadido al Scaffold

## 📝 Notas

- ✅ El chatbot está **configurado y listo para producción**
- ✅ Se conecta al endpoint real: `http://natura-co.benjadev.xyz/api/v1/chat`
- ✅ Usa autenticación automática con Firebase
- ✅ Genera y mantiene sessionId para contexto de conversación
- ⚠️ El historial se limpia al cerrar la aplicación (no hay persistencia local)
- 💡 Considera implementar persistencia en Firebase para mantener historial entre sesiones

## 🔒 Seguridad Implementada

- ✅ Token de Firebase enviado en cada request
- ✅ Timeout de 30 segundos para evitar esperas infinitas
- ✅ Manejo de errores de autenticación (401)
- ✅ Manejo de rate limiting (429)
- ✅ Validación de respuestas del servidor
- ✅ No se exponen API keys en el código

## 🤝 Contribuir

Para mejorar el chatbot:
1. Añade más respuestas en el modo de prueba
2. Mejora la UI/UX
3. Implementa nuevas funcionalidades
4. Optimiza el rendimiento

---

**Desarrollado para Natura Co** 🌿
