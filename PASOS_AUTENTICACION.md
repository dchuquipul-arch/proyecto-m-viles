# 🚀 Inicio Rápido: Autenticación con Google

## ✅ Ya está implementado

Tu aplicación ya tiene:
- ✅ Página de login con Google Sign-In
- ✅ Página de registro
- ✅ Servicio de autenticación completo
- ✅ Protección de rutas
- ✅ Perfil de usuario en configuración

---

## ⚡ Pasos Rápidos para Configurar (5 minutos)

### 1️⃣ Habilitar Authentication en Firebase

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. **Build** → **Authentication** → **Comenzar**
3. Habilita:
   - ✅ **Email/Password**
   - ✅ **Google** (agrega tu email de soporte)

---

### 2️⃣ Obtener SHA-1 (CRÍTICO)

```bash
cd /home/benji/flutter_apps/proyecto-m-viles/android
./gradlew signingReport
```

**Copia el SHA-1** (busca la línea que dice `SHA1:`)

---

### 3️⃣ Agregar SHA-1 a Firebase

1. Firebase Console → ⚙️ **Configuración del proyecto**
2. Sección **"Tus apps"** → tu app Android
3. **"Agregar huella digital"** → pega el SHA-1
4. **Guardar**

---

### 4️⃣ Descargar nuevo google-services.json

1. En la misma página, haz clic en **"Descargar google-services.json"**
2. Reemplázalo en:
   ```
   /home/benji/flutter_apps/proyecto-m-viles/android/app/google-services.json
   ```

---

### 5️⃣ Ejecutar la aplicación

```bash
cd /home/benji/flutter_apps/proyecto-m-viles
flutter clean
flutter pub get
flutter run
```

---

## 🎯 ¡Listo!

Ahora tu app tiene:
- Login con email/contraseña
- Login con Google (Gmail)
- Registro de usuarios
- Recuperación de contraseña
- Perfil de usuario
- Cerrar sesión

---

## 📖 Documentación Completa

Para más detalles y solución de problemas, consulta:
- **GOOGLE_SIGNIN_SETUP.md** - Guía completa paso a paso

---

## 🐛 ¿Problemas?

**Error al iniciar sesión con Google:**
1. Verifica que agregaste el SHA-1
2. Descarga el nuevo `google-services.json`
3. Ejecuta `flutter clean` y vuelve a correr

**La app no funciona:**
```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
flutter run
```

---

## 🎨 Personalización

### Cambiar colores del login:
Edita `lib/pages/login_page.dart` líneas 132-142

### Cambiar logo:
Cambia el ícono en línea 131 de `login_page.dart`

### Agregar más campos al registro:
Edita `lib/pages/register_page.dart`

---

¡Disfruta de tu aplicación con autenticación! 🎉

