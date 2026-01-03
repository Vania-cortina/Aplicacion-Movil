import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Método para iniciar sesión con correo y contraseña
  Future<User?> signIn(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Error login: $e');
      return null;
    }
  }

  // Método para registrar un nuevo usuario
  Future<bool> signUp(String email, String password, String name) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Almacena los datos del usuario
      await storeUserData(result.user!.uid, email, name);

      return true;
    } catch (e) {
      print('Error registro: $e');
      return false;
    }
  }

  // Método para almacenar datos del usuario
  Future<void> storeUserData(String uid, String email, String name) async {
    try {
      await _db.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'name': name,
        'profileImage': '', // Puedes agregar más campos si es necesario
      });
    } catch (e) {
      print('Error almacenando datos del usuario: $e');
      throw e;
    }
  }

  // Método para cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
