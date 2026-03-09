# ❄️ ICE NET

**Ice Net** es una aplicación móvil desarrollada con **Flutter** que permite a los usuarios interactuar socialmente mediante publicaciones, comentarios y mensajes privados.  
Inspirada en los principios de **sencillez, conectividad y estética moderna**, la aplicación utiliza una gama cromática de **lilas y morados** para ofrecer una experiencia visual relajada y contemporánea.

---

# 📱 Características principales

- Crear y visualizar **publicaciones**
- Interactuar con **likes y comentarios**
- **Perfil de usuario** editable
- **Mensajería privada** entre usuarios
- Interfaz moderna y responsive
- Sincronización en **tiempo real**

---

# 🏗 Arquitectura general

La aplicación utiliza **Firebase** como backend y **Flutter** para el desarrollo del frontend.

### Backend (Firebase)
- **Firebase Authentication**  
  Autenticación mediante correo electrónico y contraseña.

- **Cloud Firestore**  
  Base de datos en tiempo real con persistencia local activada.

- **Firebase Storage**  
  Almacenamiento de contenido de publicaciones.

- **Firebase Cloud Messaging**  
  Preparado para notificaciones push.

### Frontend
La interfaz está construida en **Flutter** y organizada mediante vistas separadas por funcionalidades.

---

# ⚙️ Funcionalidades implementadas

## 📝 Publicaciones
Los usuarios pueden crear publicaciones que se muestran en el **Home** en orden cronológico descendente.  
Cada publicación incluye:

- Nombre del usuario
- Fecha
- Botones de interacción

---

## ❤️ Interacciones

Los usuarios pueden:

- Dar **like** a publicaciones
- Dejar **comentarios**

Los likes se almacenan en una **subcolección `likes`** por publicación.  
Los comentarios se muestran en un **modal inferior** accesible desde el ícono correspondiente.

---

## 👤 Perfil de usuario

Cada usuario dispone de una vista de perfil donde puede:

- Visualizar su información
- Editar su nombre

Los cambios se actualizan tanto en **Firebase Authentication** como en **Firestore** para mantener consistencia.

---

## 💬 Chat privado

La aplicación incluye un sistema de **mensajería uno-a-uno**.

Características:

- Chats identificados mediante un **chatID**
- El chatID se genera combinando los **UID de los usuarios**
- Los mensajes se almacenan en **Firestore**
- Cada conversación contiene una **subcolección `messages`**

---

# 📂 Estructura del proyecto

El proyecto está organizado en tres tipos principales de archivos `.dart`:
- **views** → Interfaces de usuario  
- **services** → Lógica de negocio e integración con Firebase  
- **models** → Modelos de datos utilizados en la aplicación  

---

# 🛠 Tecnologías utilizadas

- Flutter 3.7
- Dart
- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- Firebase Cloud Messaging

---

# 🎨 Diseño de la aplicación

La aplicación mantiene una **coherencia visual** mediante un tema personalizado utilizando **ThemeData**.

Elementos estilizados:

- Botones
- Campos de texto
- AppBars
- Colores principales en **tonos lila y morado**

El diseño prioriza:

- Usabilidad
- Accesibilidad
- Adaptabilidad a dispositivos Android

---

# 🚀 Escalabilidad

Ice Net está preparada para escalar gracias a la infraestructura de Firebase.

Futuras mejoras posibles:

- Notificaciones push para mensajes e interacciones
- Sistema de **seguidores o amigos**
- **Búsqueda de usuarios**
- **Filtrado de publicaciones**
- Sistema de **recomendaciones**

---

# 🔐 Seguridad y validaciones

La aplicación incluye medidas básicas de seguridad:

- Validación de formularios
- Restricción de acceso mediante **reglas de seguridad de Firebase**
- Reglas de escritura para evitar manipulación de datos de otros usuarios

---

# 📌 Conclusión

**Ice Net** es una base funcional para una red social móvil moderna.  
Su estructura modular facilita el mantenimiento, la escalabilidad y la extensión de funcionalidades sin comprometer la experiencia de usuario.

El proyecto sigue buenas prácticas en:

- arquitectura de aplicaciones Flutter
- diseño de interfaces
- uso seguro de servicios en la nube

---

# 👩‍💻 Autor
Cortina Chavez Vania

Proyecto desarrollado como aplicación móvil utilizando **Flutter y Firebase**.
