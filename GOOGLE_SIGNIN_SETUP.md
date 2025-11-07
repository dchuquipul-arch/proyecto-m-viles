# 🔐 Guía de Configuración de Google Sign-In con Firebase Authentication

Esta guía te ayudará a configurar la autenticación con Google en tu aplicación Flutter Natura Co.

---

## ✅ Cambios Ya Implementados

Ya se han realizado los siguientes cambios en tu aplicación:

### 1. Dependencias agregadas ✅
- `firebase_auth: ^5.3.1` - Para autenticación con Firebase
- `google_sign_in: ^6.2.1` - Para autenticación con Google

### 2. Archivos creados ✅
- **`lib/services/auth_service.dart`** - Servicio completo de autenticación
- **`lib/pages/login_page.dart`** - Página de inicio de sesión
- **`lib/pages/register_page.dart`** - Página de registro
- **`lib/main.dart`** - Actualizado con flujo de autenticación (AuthWrapper)
- **`lib/pages/settings.dart`** - Actualizado con perfil de usuario y cerrar sesión

### 3. Características implementadas ✅
- ✅ Registro con email y contraseña
- ✅ Inicio de sesión con email y contraseña
- ✅ Inicio de sesión con Google (Google Sign-In)
- ✅ Registro con Google
- ✅ Recuperación de contraseña
- ✅ Cerrar sesión
- ✅ Protección de rutas (solo usuarios autenticados pueden acceder a la app)
- ✅ Perfil de usuario en configuración
- ✅ Manejo de errores en español

---

## 📋 Pasos de Configuración (IMPORTANTES)

### 1️⃣ Habilitar Authentication en Firebase Console

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto
3. En el menú lateral, ve a **Build** → **Authentication**
4. Haz clic en **"Comenzar"** (Get Started)
5. Habilita los siguientes métodos de inicio de sesión:

#### a) Email/Password
- Haz clic en **"Email/Password"**
- Activa el switch para **"Email/Password"**
- Haz clic en **"Guardar"**

#### b) Google Sign-In
- Haz clic en **"Google"**
- Activa el switch para **"Google"**
- Configura el nombre público del proyecto
- Agrega tu email de soporte (requerido)
- Haz clic en **"Guardar"**

---

### 2️⃣ Obtener el SHA-1 de tu aplicación (CRÍTICO)

Para que Google Sign-In funcione, necesitas registrar la huella digital SHA-1 de tu aplicación:

#### En Linux/Mac:
```bash
cd /home/benji/flutter_apps/proyecto-m-viles/android
./gradlew signingReport
```

#### Busca en la salida:
```
Variant: debug
Config: debug
Store: ~/.android/debug.keystore
Alias: AndroidDebugKey
MD5: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
SHA1: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
SHA-256: XXXX...
```

**Copia el valor de SHA1** (la línea completa de 20 pares de caracteres hexadecimales)

---

### 3️⃣ Agregar SHA-1 a Firebase

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto
3. Haz clic en el ícono de **configuración** (⚙️) → **Configuración del proyecto**
4. Desplázate a la sección **"Tus apps"**
5. Selecciona tu app Android (`com.example.hello_world`)
6. En la sección **"Huellas digitales de certificado SHA"**, haz clic en **"Agregar huella digital"**
7. Pega el **SHA-1** que copiaste
8. Haz clic en **"Guardar"**

---

### 4️⃣ Descargar el nuevo google-services.json

**⚠️ IMPORTANTE:** Después de agregar el SHA-1, debes descargar un nuevo archivo `google-services.json`:

1. En la misma página de **Configuración del proyecto**
2. Busca tu app Android
3. Haz clic en **"Descargar google-services.json"**
4. **Reemplaza** el archivo existente en:
   ```
   /home/benji/flutter_apps/proyecto-m-viles/android/app/google-services.json
   ```

---

### 5️⃣ Verificar la configuración de Android

Tu archivo `android/app/build.gradle.kts` ya está configurado con:

```kotlin
android {
    defaultConfig {
        applicationId = "com.example.hello_world"
        minSdk = 21  // ✅ Requerido para Google Sign-In
        ...
    }
}

// ✅ Plugin de servicios de Google aplicado
apply(plugin = "com.google.gms.google-services")
```

---

## 🚀 Probar la Aplicación

### 1. Instalar dependencias
```bash
cd /home/benji/flutter_apps/proyecto-m-viles
flutter pub get
```

### 2. Limpiar y reconstruir (IMPORTANTE después de agregar SHA-1)
```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
```

### 3. Ejecutar la aplicación
```bash
flutter run
```

---

## 📱 Flujo de la Aplicación

### Primera vez (sin sesión):
1. Se muestra la **Página de Login**
2. Opciones:
   - Iniciar sesión con email/contraseña
   - Iniciar sesión con Google (botón azul con logo de Google)
   - Ir a registro

### Registro:
1. Clic en **"Regístrate"**
2. Completa el formulario o usa **"Continuar con Google"**
3. Al completar, automáticamente inicia sesión

### Dentro de la app (autenticado):
1. Acceso completo a todas las páginas
2. En **Configuración**:
   - Ver perfil de usuario (nombre, email, foto)
   - Cerrar sesión

### Cerrar sesión:
1. Ir a **Configuración** → **Cerrar sesión**
2. Confirmar
3. Regresa a la página de Login

---

## 🔍 Verificación

### ✅ Checklist de pruebas:

1. **Registro con email:**
   - [ ] Crear cuenta con email y contraseña
   - [ ] Iniciar sesión con las credenciales creadas

2. **Login con email:**
   - [ ] Iniciar sesión con email existente
   - [ ] Probar contraseña incorrecta (debe mostrar error)
   - [ ] Probar recuperación de contraseña

3. **Google Sign-In:**
   - [ ] Hacer clic en "Continuar con Google"
   - [ ] Seleccionar cuenta de Google
   - [ ] Verificar que inicia sesión correctamente
   - [ ] Verificar que aparece la foto y nombre de Google

4. **Perfil de usuario:**
   - [ ] Ir a Configuración
   - [ ] Verificar que aparece nombre y email
   - [ ] Verificar avatar (foto o inicial)

5. **Cerrar sesión:**
   - [ ] Cerrar sesión desde Configuración
   - [ ] Verificar que regresa a Login
   - [ ] Verificar que no puede acceder a rutas protegidas

---

## ⚠️ Solución de Problemas

### Error: "PlatformException(sign_in_failed)"

**Causa:** El SHA-1 no está registrado o el `google-services.json` no está actualizado.

**Solución:**
1. Genera el SHA-1 con `./gradlew signingReport`
2. Agrégalo en Firebase Console
3. Descarga el nuevo `google-services.json`
4. Reemplaza el archivo en `android/app/`
5. Ejecuta:
   ```bash
   flutter clean
   cd android
   ./gradlew clean
   cd ..
   flutter run
   ```

---

### Error: "API key not found"

**Causa:** El archivo `google-services.json` no está en la ubicación correcta.

**Solución:**
1. Verifica que el archivo existe en: `/home/benji/flutter_apps/proyecto-m-viles/android/app/google-services.json`
2. Descarga de nuevo desde Firebase Console si es necesario
3. Ejecuta `flutter clean` y vuelve a compilar

---

### Error: "Missing API key" o problemas de OAuth

**Causa:** El `client_id` de OAuth no está configurado correctamente.

**Solución:**
1. Ve a Firebase Console → Authentication → Proveedores de acceso → Google
2. Verifica que **Web SDK configuration** tenga un **Web client ID**
3. Si no existe, haz clic en **"Configurar OAuth consent screen"**
4. Completa la información requerida
5. Vuelve a Firebase y verifica que Google esté habilitado

---

### El botón de Google no hace nada

**Solución:**
1. Verifica que tengas internet
2. Revisa los logs en el terminal: `flutter run --verbose`
3. Verifica que el SHA-1 esté agregado correctamente
4. Asegúrate de que el `google-services.json` sea la versión más reciente

---

### La app se cierra al hacer clic en "Continuar con Google"

**Causa:** Normalmente es el SHA-1.

**Solución:**
1. Genera el SHA-1 de **debug** (la clave de desarrollo)
2. Agrégalo en Firebase Console
3. Descarga nuevo `google-services.json`
4. Limpia y reconstruye:
   ```bash
   flutter clean
   rm -rf android/build
   rm -rf build
   flutter pub get
   flutter run
   ```

---

## 🎯 Cliente OAuth Web (Para pruebas en navegador)

Si quieres que funcione en Flutter Web también:

1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Selecciona tu proyecto de Firebase
3. Ve a **APIs & Services** → **Credentials**
4. Copia el **Client ID** del tipo **Web application**
5. Agrégalo en tu código (si necesitas soporte web):
   ```dart
   GoogleSignIn(
     clientId: 'TU_WEB_CLIENT_ID.apps.googleusercontent.com',
   )
   ```

---

## 📊 Estructura de Usuarios en Firebase

Los usuarios autenticados se guardan en Firebase Authentication con esta información:

```json
{
  "uid": "identificador_unico",
  "email": "usuario@gmail.com",
  "displayName": "Nombre del Usuario",
  "photoURL": "https://lh3.googleusercontent.com/...",
  "emailVerified": true,
  "providerData": [
    {
      "providerId": "google.com",
      "uid": "google_uid",
      "displayName": "Nombre del Usuario",
      "email": "usuario@gmail.com",
      "photoURL": "https://..."
    }
  ]
}
```

---

## 🔒 Reglas de Seguridad (Opcional pero Recomendado)

Actualiza las reglas de Firestore para que solo usuarios autenticados puedan leer/escribir:

Ve a **Firestore Database** → **Reglas** y usa:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Solo usuarios autenticados pueden leer
    match /{document=**} {
      allow read: if request.auth != null;
    }
    
    // Productos: todos pueden leer, solo admins escribir (ajusta según necesites)
    match /products/{productId} {
      allow read: if request.auth != null;
      allow write: if false; // O agrega lógica de admin
    }
    
    // Órdenes: solo el dueño puede ver sus órdenes
    match /orders/{orderId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if false; // O agrega lógica según necesites
    }
    
    // Citas: solo el dueño puede ver sus citas
    match /appointments/{appointmentId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if false;
    }
  }
}
```

**⚠️ IMPORTANTE:** Las reglas actuales permiten acceso total (para desarrollo). Actualízalas antes de lanzar a producción.

---

## 🎉 ¡Listo!

Una vez completados estos pasos, tu aplicación Natura Co tendrá:

✅ Registro e inicio de sesión con email/contraseña  
✅ Inicio de sesión con Google (Gmail)  
✅ Recuperación de contraseña  
✅ Protección de rutas  
✅ Perfil de usuario  
✅ Cerrar sesión  
✅ Integración completa con Firebase Authentication  

---

## 📞 Siguiente Pasos (Opcional)

1. **Verificación de email:** Enviar email de verificación después del registro
2. **Más proveedores:** Facebook, Twitter, Apple Sign-In
3. **Perfil de usuario en Firestore:** Guardar información adicional del usuario
4. **Roles y permisos:** Implementar sistema de roles (admin, usuario)
5. **Foto de perfil editable:** Permitir que el usuario cambie su foto

---

## 📚 Recursos Adicionales

- [Firebase Authentication Docs](https://firebase.google.com/docs/auth)
- [Google Sign-In Flutter Plugin](https://pub.dev/packages/google_sign_in)
- [FlutterFire Docs](https://firebase.flutter.dev/)

---

¿Problemas? Revisa la sección de **Solución de Problemas** o verifica los logs con `flutter run --verbose` 🔍

