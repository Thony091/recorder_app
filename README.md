# Recorder App - Descripción de la Aplicación
Este proyecto fue creado con **Flutter SDK versión 3.27.1**.

Para evitar problemas de compilación, debes tener **Java 17 instalado**.

Recorder App es una aplicación móvil desarrollada en **Flutter**, diseñada para gestionar recordatorios con notificaciones push locales. Los usuarios pueden crear, editar y eliminar recordatorios con fechas y horas específicas, e incluso sincronizarlos en tiempo real gracias a su integración con Firebase Authentication y Firestore.

---

## 🔹 Cuentas de Prueba
Para acceder rápidamente a la aplicación sin necesidad de crear una cuenta, puedes usar las siguientes credenciales de prueba:

|    Correo Electrónico   	|      Contraseña   	|

|     usuario@test.com	    |        123456       |

|    usuario2@test.com	    |        654321       |


📌 Estas cuentas ya están registradas y contienen recordatorios preconfigurados para probar la funcionalidad de la aplicación.

---

## 🔹 Funcionalidades Principales

### 1️⃣ Creación de Recordatorios con Notificaciones Programadas
✔️ Permite crear recordatorios con fecha y hora exactas.

✔️ Las notificaciones se programan localmente en el dispositivo.

✔️ Se pueden definir frecuencias (único, diario, semanal).

✔️ Interfaz estilo iOS con CupertinoDatePicker para seleccionar fecha y hora.

---

### 2️⃣ Edición y Eliminación de Recordatorios
✔️ Se pueden modificar los datos de un recordatorio existente.

✔️ Se puede cambiar la hora y fecha y actualizar la notificación.

✔️ Los recordatorios pueden eliminarse fácilmente.

✔️ Sincronización con Firestore, lo que permite recuperar la información en otro dispositivo.

---

### 3️⃣ Sincronización en Tiempo Real con Firestore
✔️ Cada recordatorio creado se almacena en Firebase Firestore.

✔️ Si el usuario inicia sesión en otro dispositivo, los recordatorios se recuperan automáticamente.

✔️ Autenticación con Firebase Authentication para mantener los datos del usuario seguros.

---

### 4️⃣ Lista de Recordatorios con Estado de Notificación
✔️ Lista de recordatorios con estado visual (pendiente, completado, omitido).

✔️ Botón de acción rápida para marcar un recordatorio como completado o eliminado.

✔️ Animaciones fluidas en la lista de recordatorios.

---

### 5️⃣ Notificaciones Push Locales
✔️ Integración con flutter_local_notifications para mostrar notificaciones en segundo plano.

✔️ Compatibilidad con Android e iOS.

✔️ Acción al tocar la notificación → Abre la aplicación y permite editar el recordatorio.

---

### 6️⃣ Guardar y Ver Películas Favoritas
✔️ Los usuarios pueden guardar sus recordatorios favoritos tocando un **icono de marcador**.  
✔️ Los recordatorios guardados se almacenan en una lista llamada **"Favoritos"**.  
✔️ Esta lista es accesible desde la pagina inicial.  
✔️ El estado de los recordatorios favoritos se mantiene **persistente** usando almacenamiento local.  

---

## 🔹 Cómo Funciona
1️⃣ **El usuario inicia sesión** → Se cargan los recordatorios desde Firestore.

2️⃣ **El usuario crea un recordatorio** → Se programa una notificación local.

3️⃣ **El usuario edita un recordatorio** → Se actualiza la notificación y la base de datos.

4️⃣ **El usuario elimina un recordatorio** → Se borra de Firestore y se cancela la notificación.

5️⃣ **El usuario recibe una notificación** → Al tocarla, abre la app y permite editar el recordatorio.

## 🔹 Tecnologías Utilizadas
✅ **Flutter (Dart)** → Para el desarrollo de la interfaz de usuario.

✅ **Riverpod** → Para la gestión del estado.

✅ **GoRouter** → Para la navegación y deep linking.

✅ **Firebase Authentication** → Para el inicio de sesión de usuarios.

✅ **Cloud Firestore** → Para el almacenamiento en la nube de los recordatorios.

✅ **flutter_local_notifications** → Para notificaciones push locales.

✅ **timezone y flutter_timezone** → Para manejar correctamente las zonas horarias en notificaciones programadas.

## 🔹 Guía para ejecutar el proyecto en Android

1️⃣ Requisitos previos
Antes de empezar, asegúrate de tener instaladas las siguientes herramientas:



|   Herramienta   	|    Versión Requerida  	|       Descargar           |

|   Flutter	        |         3.27.1          |       flutter.dev         |

|   Android Studio	|    Última versión       |  	developer.android.com   |

|   Java JDK	      |           17	          |      oracle.com/java/     |



2️⃣ Descargar el proyecto Recorder App:

Descarga el proyecto desde el repositorio de GitHub.

git clone https://github.com/Thony091/recorder_app.git

3️⃣ Abrir el proyecto en Visual Studio Code o Android Studio

Abre la carpeta del proyecto en VS Code o Android Studio.

4️⃣ Instalar las dependencias del proyecto

Ejecuta el siguiente comando en la terminal para instalar las dependencias:

- flutter pub get

5️⃣ Compilar y ejecutar el proyecto

Ejecuta este comando en la terminal:

- flutter run

📌 Nota: Preguntará por el dispositivo Android en el que deseas ejecutarlo.

## 🔹 Guía para generar un APK
Para generar un APK, ejecuta el siguiente comando en la terminal:

- flutter build apk

El archivo APK se generará en la carpeta build/app/outputs/apk/release/

## 🔹 Si Todo Falla: Descargar el APK desde GitHub
Si no puedes ejecutar la app, descarga el APK desde GitHub Releases.

📌 Enlace de descarga:

➡ [📥 Descargar última versión del APK](https://github.com/Thony091/recorder_app/releases/tag/apk)

Instrucciones:

1️⃣ Ve al enlace de arriba.

2️⃣ Descarga el archivo app-release.apk.

3️⃣ Instálalo en tu dispositivo Android.


## 🔹 Tareas Pendientes en el Proyecto
🚧 Optimización del sistema de notificaciones:

- Asegurar que las notificaciones persistan después del reinicio del dispositivo.

🚧 Mejora de la lógica de edición de recordatorios:

- Implementar persistencia en Firestore al editar un recordatorio.

🚧 Manejo avanzado de la zona horaria:

- Optimizar el uso de timezone para asegurar que las notificaciones se envíen en la hora correcta.

🚧 Interfaz de usuario y experiencia:

- Mejorar la experiencia de usuario en la edición de recordatorios.

## 📌 Resumen
Recorder App es una aplicación interactiva que permite crear, editar y eliminar recordatorios con notificaciones push locales, integrándose con Firebase Authentication y Firestore para almacenamiento en la nube y sincronización en tiempo real. 🚀📅