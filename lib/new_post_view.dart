// views/new_post_view.dart
import 'package:flutter/material.dart';
import '../post_model.dart';
import '../post_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewPostView extends StatefulWidget {
  @override
  _NewPostViewState createState() => _NewPostViewState();
}

class _NewPostViewState extends State<NewPostView> {
  final _contentController = TextEditingController();
  final _postService = PostService();

  // Función para asegurarse de que el documento del usuario exista en Firestore
  Future<void> _ensureUserExists() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final userDoc = await userDocRef.get();

    // Si el documento no existe, crearlo con valores predeterminados
    if (!userDoc.exists) {
      await userDocRef.set({
        'name': user.displayName ?? 'Usuario',
        'email': user.email,

      });
    }
  }

  // Función para enviar la publicación
  Future<void> _submitPost() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Asegurarse de que el documento del usuario exista en Firestore
    await _ensureUserExists();

    // Obtener el nombre del usuario desde Firestore
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final userName = userDoc['name'] ?? 'Usuario';

    // Crear el modelo de la publicación
    final post = Post(
      id: '',
      userId: user.uid,
      userName: userName,
      content: _contentController.text.trim(),
      imageUrl: '',
      timestamp: DateTime.now(),
    );

    // Llamar al servicio para crear la publicación
    await _postService.createPost(post, null);

    // Volver a la pantalla anterior
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nueva publicación')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            TextField(
              controller: _contentController,
              maxLines: 3,
              decoration: InputDecoration(hintText: '¿Qué estás pensando?'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitPost,  // Acción para enviar la publicación
              child: Text('Publicar'),
            ),
          ],
        ),
      ),
    );
  }
}
