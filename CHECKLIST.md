# ✅ CHECKLIST - Configuración Firebase

## 📋 Lista de Verificación Rápida

### 🔥 Firebase Console

- [ ] **1. Crear/abrir proyecto en Firebase Console**
      https://console.firebase.google.com/

- [ ] **2. Agregar app Android**
      - Package name: `natura.co`
      - Descargar `google-services.json`

- [ ] **3. Copiar google-services.json a:**
      ```
      /home/benji/flutter_apps/proyecto-m-viles/android/app/google-services.json
      ```

- [ ] **4. Habilitar Firestore Database**
      - Modo: "Modo de prueba"
      - Región: `southamerica-east1`

- [ ] **5. Configurar reglas de Firestore**
      ```
      rules_version = '2';
      service cloud.firestore {
        match /databases/{database}/documents {
          match /{document=**} {
            allow read, write: if true;
          }
        }
      }
      ```

### 📱 Ejecutar la App

- [ ] **6. Verificar que google-services.json esté en su lugar**
      ```bash
      ls -la android/app/google-services.json
      ```

- [ ] **7. Ejecutar la app**
      ```bash
      flutter run
      ```

- [ ] **8. Migrar productos a Firebase**
      - Abrir Settings en la app
      - Presionar "Migrar productos a Firebase"
      - Esperar confirmación

### ✓ Verificación Final

- [ ] **9. Ver productos en Firebase Console**
      - Firestore Database → `products`
      - Deberías ver 7 productos

- [ ] **10. Ver productos en la app**
      - Menu → Los productos se cargan

- [ ] **11. Probar crear una cita**
      - Verificar en Firebase → `appointments`

- [ ] **12. Probar crear una orden**
      - Verificar en Firebase → `orders`

---

## 🎉 ¡Completado!

Si todos los items están marcados, tu app está lista. 🚀

**¿Problemas?** Revisa `PASOS_SIGUIENTES.md` para solución de problemas.

