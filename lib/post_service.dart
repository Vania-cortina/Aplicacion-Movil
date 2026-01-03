import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../post_model.dart';

class PostService {
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<void> createPost(Post post, File? imageFile) async {
    String imageUrl = '';
    if (imageFile != null) {
      final ref = _storage.ref().child('posts/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(imageFile);
      imageUrl = await ref.getDownloadURL();
    }

    final doc = _db.collection('posts').doc();
    await doc.set(post.toMap()..['imageUrl'] = imageUrl);
  }

  Stream<List<Post>> getPosts() {
    return _db.collection('posts').orderBy('timestamp', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Post.fromMap(doc.data(), doc.id)).toList();
    });
  }
}