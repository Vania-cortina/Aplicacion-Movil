import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String userId;
  final String userName;
  final String content;
  final String imageUrl;
  final DateTime timestamp;

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.content,
    required this.imageUrl,
    required this.timestamp,
  });

  // Método para crear un Post
  factory Post.fromMap(Map<String, dynamic> data, String id) {
    return Post(
      id: id,
      userId: data['userId'],
      userName: data['userName'],
      content: data['content'],
      imageUrl: data['imageUrl'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  // Método para convertir el Post
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'content': content,
      'imageUrl': imageUrl,
      'timestamp': timestamp,
    };
  }
}
