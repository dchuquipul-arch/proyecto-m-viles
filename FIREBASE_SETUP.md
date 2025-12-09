# 🔥 Guía de Configuración de Firebase - Natura CO

## ✅ Pasos Completados

Ya se han implementado los siguientes cambios en tu aplicación:

1. ✅ Dependencias de Firebase agregadas en `pubspec.yaml`
2. ✅ Configuración de Gradle actualizada
3. ✅ `main.dart` actualizado para inicializar Firebase
4. ✅ Servicios de Firebase creados:
   - `firebase_products_service.dart`
   - `firebase_orders_service.dart`
   - `firebase_appointments_service.dart`
5. ✅ Script de migración de datos creado (`utils/migrate_data.dart`)
6. ✅ Páginas actualizadas para usar Firebase:
   - `menu.dart` - Productos desde Firebase
   - `product_detail.dart` - Detalles desde Firebase
   - `appointment_page.dart` - Guarda citas en Firebase
   - `checkout_review.dart` - Guarda órdenes en Firebase

---

## 📋 Pasos Pendientes (IMPORTANTE)

### 1. Descargar `google-services.json` desde Firebase Console

**Tu packageName es:** `natura.co`

#### Pasos:
1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Crea un nuevo proyecto o usa uno existente
3. Haz clic en el ícono de Android para agregar una app Android
4. Ingresa el nombre del paquete: `natura.co`
5. Descarga el archivo `google-services.json`
6. **IMPORTANTE:** Coloca el archivo en esta ubicación exacta:
   ```
   /home/benji/flutter_apps/proyecto-m-viles/android/app/google-services.json
   ```

### 2. Configurar Firestore Database en Firebase Console

1. Ve a Firebase Console → Firestore Database
2. Haz clic en "Crear base de datos"
3. Selecciona "Modo de prueba" (para desarrollo) o configura reglas personalizadas
4. Elige la ubicación más cercana (ej: southamerica-east1)
5. Haz clic en "Habilitar"

### 3. Migrar los Productos Iniciales a Firebase

Después de tener Firebase configurado, necesitas ejecutar la migración UNA SOLA VEZ:

#### Opción A: Desde settings.dart (RECOMENDADO)

Ya preparé un botón en tu página de settings. Solo necesitas:

1. Ejecutar la app: `flutter run`
2. Ir a Settings (Configuración)
3. Buscar el botón "Migrar Productos a Firebase"
4. Presionar el botón
5. Esperar a que se complete la migración

#### Opción B: Ejecutar manualmente desde código

Puedes agregar temporalmente esta línea en `main.dart` después de `Firebase.initializeApp()`:

```dart
await DataMigration.migrateProducts();
```

**IMPORTANTE:** Ejecuta la migración solo UNA vez, luego elimina este código.

---

## 📁 Estructura de Firestore

Tu base de datos tendrá estas colecciones:

### `products`
```
{
  "name": "Nombre del producto",
  "description": "Descripción",
  "imageUrl": "URL de la imagen",
  "price": 50.00,
  "category": "Categoría",
  "active": true,
  "createdAt": timestamp
}
```

### `orders`
```
{
  "items": [
    {
      "productId": "id",
      "name": "Nombre",
      "imageUrl": "url",
      "quantity": 2,
      "unitPrice": 50.00
    }
  ],
  "total": 100.00,
  "shippingAddress": "Dirección",
  "paymentMethod": "Método",
  "status": "pending",
  "createdAt": timestamp,
  "updatedAt": timestamp
}
```

### `appointments`
```
{
  "name": "Nombre completo",
  "phone": "Teléfono",
  "email": "correo@ejemplo.com",
  "service": "Tipo de servicio",
  "date": timestamp,
  "time": "14:30",
  "notes": "Notas opcionales",
  "status": "pending",
  "createdAt": timestamp
}
```

---

## 🚀 Comandos para Ejecutar

```bash
# Limpiar proyecto (opcional, si hay problemas)
cd /home/benji/flutter_apps/proyecto-m-viles
flutter clean
flutter pub get

# Ejecutar la aplicación
flutter run

# Si hay problemas con Gradle
cd android
./gradlew clean
cd ..
flutter run
```

---

## 🔍 Verificación

Después de ejecutar la app:

1. **Verifica la conexión:** La app debería iniciar sin errores de Firebase
2. **Verifica Firestore:** Ve a Firebase Console → Firestore Database
3. **Migra los productos:** Usa el botón en Settings
4. **Verifica los productos:** Deberías ver 7 productos en la colección `products`
5. **Prueba la app:** 
   - Los productos deberían cargarse en el menú
   - Puedes agregar citas (se guardarán en Firestore)
   - Puedes crear órdenes (se guardarán en Firestore)

---

## ⚠️ Solución de Problemas

### Error: "Default FirebaseApp is not initialized"
- Asegúrate de tener el archivo `google-services.json` en la ubicación correcta
- Reinicia la aplicación

### Error: "Missing google-services.json"
- Descarga el archivo desde Firebase Console
- Colócalo en `android/app/google-services.json`

### No se cargan los productos
- Ejecuta la migración de datos
- Verifica en Firebase Console que los productos existan
- Verifica las reglas de Firestore (deben permitir lectura)

### Error de permisos en Firestore (COMÚN)

**ERROR:** `PERMISSION_DENIED - Missing or insufficient permissions`

**SOLUCIÓN:**

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto
3. Ve a **Firestore Database** → **Reglas** (Rules)
4. Reemplaza las reglas actuales con:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true; // Solo para desarrollo
    }
  }
}
```

5. Haz clic en **"Publicar"** (Publish)
6. Las reglas se aplican inmediatamente

**📖 Ver guía detallada:** `FIRESTORE_REGLAS.md`

---

## 📞 Siguiente Pasos (Opcional)

1. **Agregar autenticación:** Usa Firebase Auth para login de usuarios
2. **Storage:** Sube imágenes a Firebase Storage
3. **Reglas de seguridad:** Configura reglas de Firestore para producción
4. **Índices:** Firestore puede pedirte crear índices para queries complejas

---

## ✨ ¡Todo Listo!

Una vez que completes estos pasos, tu aplicación Natura CO estará completamente integrada con Firebase. 🎉

