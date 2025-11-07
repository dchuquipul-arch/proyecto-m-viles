# 🔥 Configurar Reglas de Firestore

## ❌ Problema Actual

Estás viendo este error:
```
W/Firestore: Status{code=PERMISSION_DENIED, description=Missing or insufficient permissions., cause=null}
[cloud_firestore/permission-denied] The caller does not have permission to execute the specified operation.
```

## ✅ Solución

Las reglas de seguridad de Firestore están bloqueando las escrituras. Necesitas actualizarlas.

---

## 📋 Pasos para Configurar las Reglas

### 1. Abre Firebase Console

Ve a: https://console.firebase.google.com/

### 2. Selecciona tu Proyecto

Haz clic en tu proyecto (el que creaste para esta app).

### 3. Ve a Firestore Database

En el menú lateral izquierdo:
- Haz clic en **"Compilación"** o **"Build"**
- Luego haz clic en **"Firestore Database"**

### 4. Ve a la Pestaña "Reglas" (Rules)

En la parte superior verás las pestañas:
- Datos (Data)
- **Reglas (Rules)** ← Haz clic aquí
- Índices (Indexes)
- Uso (Usage)

### 5. Edita las Reglas

Verás un editor de código con las reglas actuales. Probablemente se ven así:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if false; // ❌ ESTO BLOQUEA TODO
    }
  }
}
```

### 6. Reemplaza con las Nuevas Reglas

**Para desarrollo (permite todo):**

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true; // ✅ Permite todo (SOLO DESARROLLO)
    }
  }
}
```

### 7. Haz Clic en "Publicar" (Publish)

Botón azul en la parte superior derecha.

### 8. Confirma

Aparecerá un mensaje de confirmación. Haz clic en "Publicar" nuevamente.

---

## ⏰ Tiempo de Aplicación

Las reglas se aplican **inmediatamente**. No necesitas reiniciar tu app.

---

## ⚠️ Advertencia de Seguridad

Las reglas `allow read, write: if true` son PERFECTAS para desarrollo, pero **NO SEGURAS para producción**.

### ¿Por qué?
- Cualquier persona con acceso a tu app puede leer y escribir datos
- No hay autenticación
- No hay validación de datos

### ¿Cuándo es seguro?
- ✅ Durante el desarrollo
- ✅ Para prototipos
- ✅ Para pruebas internas
- ❌ NO para apps públicas en producción

---

## 🔒 Reglas para Producción (Futuro)

Cuando estés listo para lanzar tu app, considera estas reglas más seguras:

### Opción 1: Con Firebase Authentication

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Productos: todos leen, solo admins escriben
    match /products/{productId} {
      allow read: if true;
      allow write: if request.auth != null && 
                      request.auth.token.admin == true;
    }
    
    // Órdenes: usuarios autenticados leen/escriben las suyas
    match /orders/{orderId} {
      allow read: if request.auth != null && 
                     request.auth.uid == resource.data.userId;
      allow create: if request.auth != null && 
                       request.auth.uid == request.resource.data.userId;
    }
    
    // Citas: usuarios autenticados leen/escriben las suyas
    match /appointments/{appointmentId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
    }
  }
}
```

### Opción 2: Lectura pública, escritura por API

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Todos pueden leer
    match /products/{productId} {
      allow read: if true;
      allow write: if false; // Solo por Cloud Functions
    }
    
    match /orders/{orderId} {
      allow read: if true;
      allow create: if true; // Crear órdenes públicamente
      allow update, delete: if false;
    }
    
    match /appointments/{appointmentId} {
      allow read: if true;
      allow create: if true; // Crear citas públicamente
      allow update, delete: if false;
    }
  }
}
```

---

## 🧪 Verificar las Reglas

Después de publicar las reglas:

1. **Vuelve a ejecutar la migración** en tu app
2. **Verifica en la consola** que no haya más errores de permisos
3. **Revisa Firebase Console → Firestore Database → Datos**
   - Deberías ver la colección `products` con 7 productos

---

## 📞 ¿Necesitas Ayuda?

Si después de cambiar las reglas sigues teniendo problemas:

1. Verifica que publicaste las reglas correctamente
2. Reinicia tu app
3. Revisa que el `google-services.json` esté en el lugar correcto
4. Verifica que Firebase esté inicializado correctamente

---

## ✨ Próximos Pasos

Una vez que las reglas estén configuradas:

1. ✅ Ejecuta la migración de productos
2. ✅ Verifica que los productos aparezcan en Firebase Console
3. ✅ Prueba tu app: los productos deberían cargarse desde Firebase
4. ✅ Crea órdenes y citas: se guardarán en Firestore

---

## 📚 Documentación Oficial

- [Reglas de Seguridad de Firestore](https://firebase.google.com/docs/firestore/security/get-started)
- [Ejemplos de Reglas](https://firebase.google.com/docs/firestore/security/rules-structure)
- [Testing de Reglas](https://firebase.google.com/docs/firestore/security/test-rules-emulator)


