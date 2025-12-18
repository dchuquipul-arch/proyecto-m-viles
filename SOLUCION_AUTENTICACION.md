# Guía de Solución: Error de Autenticación Firebase

## 🔴 Problema Identificado

El backend Django está rechazando el token de Firebase con el mensaje:
```json
{"success":false,"message":"Autenticación fallida","data":null}
```

## 🔍 Causas Posibles

### 1. **Configuración de Firebase en Django**
El `FirebaseAuthMiddleware` puede estar:
- Usando credenciales incorrectas de Firebase
- No inicializado correctamente
- Validando contra un proyecto de Firebase diferente

### 2. **Formato del Token**
- El token de Firebase puede no ser el esperado
- Puede necesitar configuración adicional de scopes

### 3. **CORS o Headers**
- El header `Authorization` puede no estar llegando correctamente
- Problemas de CORS en el backend

## ✅ Soluciones

### Solución 1: Verificar FirebaseAuthMiddleware

Revisa tu archivo `infrastructure/firebase/auth_middleware.py`:

```python
import firebase_admin
from firebase_admin import credentials, auth
from rest_framework.response import Response
from rest_framework import status

class FirebaseAuthMiddleware:
    @staticmethod
    def authenticate_request(request):
        # Obtener el token del header
        auth_header = request.headers.get('Authorization')
        
        if not auth_header or not auth_header.startswith('Bearer '):
            return (False, None, Response({
                'success': False,
                'message': 'Token no proporcionado',
                'data': None
            }, status=status.HTTP_401_UNAUTHORIZED))
        
        token = auth_header.split('Bearer ')[1]
        
        try:
            # Verificar el token con Firebase
            decoded_token = auth.verify_id_token(token)
            return (True, decoded_token, None)
        except Exception as e:
            print(f"Error al verificar token: {e}")  # ← AGREGAR ESTE LOG
            return (False, None, Response({
                'success': False,
                'message': f'Autenticación fallida: {str(e)}',  # ← MÁS DETALLE
                'data': None
            }, status=status.HTTP_401_UNAUTHORIZED))
```

### Solución 2: Inicializar Firebase en Django

Asegúrate de que Firebase esté inicializado en tu `settings.py` o en el inicio de la app:

```python
# En settings.py o __init__.py de tu app
import firebase_admin
from firebase_admin import credentials
import os

# Ruta al archivo de credenciales de Firebase
cred_path = os.path.join(BASE_DIR, 'path/to/serviceAccountKey.json')

if not firebase_admin._apps:
    cred = credentials.Certificate(cred_path)
    firebase_admin.initialize_app(cred)
```

### Solución 3: Verificar el Proyecto de Firebase

Asegúrate de que:
1. El archivo `serviceAccountKey.json` en Django sea del **mismo proyecto** que la app Flutter
2. Las credenciales no estén expiradas
3. El proyecto de Firebase tenga Authentication habilitado

### Solución 4: Agregar Logs Detallados

En tu `ChatView`, agrega logs para debugging:

```python
def post(self, request: Request) -> Response:
    # Log del header de autorización
    auth_header = request.headers.get('Authorization', 'No header')
    print(f"🔑 Authorization header: {auth_header[:50]}...")  # Primeros 50 caracteres
    
    # Authenticate the request
    is_authenticated, decoded_token, error_response = (
        FirebaseAuthMiddleware.authenticate_request(request)
    )
    
    if not is_authenticated:
        print(f"❌ Autenticación fallida")
        return error_response
    
    print(f"✅ Usuario autenticado: {decoded_token.get('email')}")
    # ... resto del código
```

## 🧪 Prueba Rápida

### En Flutter (temporal):

Agrega este código en `chatbot_service.dart` para ver el token completo:

```dart
// En _getAuthToken(), después de obtener el token:
if (token != null) {
  print('✅ Token obtenido exitosamente (${token.length} caracteres)');
  print('🔑 Token completo: $token');  // ← TEMPORAL: ver token completo
}
```

Luego compara este token con lo que recibe Django.

## 📋 Checklist de Verificación

- [ ] Firebase está inicializado en Django
- [ ] El `serviceAccountKey.json` es del proyecto correcto
- [ ] El middleware tiene logs para debugging
- [ ] El header `Authorization` llega correctamente
- [ ] El token de Firebase es válido (no expirado)
- [ ] El proyecto de Firebase tiene Authentication habilitado
- [ ] Las reglas de CORS permiten el header `Authorization`

## 🔧 Configuración Recomendada de CORS (Django)

```python
# settings.py
CORS_ALLOW_HEADERS = [
    'accept',
    'accept-encoding',
    'authorization',  # ← Importante
    'content-type',
    'dnt',
    'origin',
    'user-agent',
    'x-csrftoken',
    'x-requested-with',
]

CORS_ALLOW_CREDENTIALS = True
```

## 📞 Próximos Pasos

1. Agrega los logs sugeridos en Django
2. Ejecuta la app y envía un mensaje
3. Revisa los logs del servidor Django
4. Comparte los logs para más ayuda

---

**Nota**: El problema NO está en el código Flutter, está en la validación del token en Django.
