import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentSheet extends StatefulWidget {
  final String postId;

  const CommentSheet({super.key, required this.postId});

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  final _commentController = TextEditingController();

  void _sendComment() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && _commentController.text.trim().isNotEmpty) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final userName = userDoc['name'] ?? 'Anon';

      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .collection('comments')
          .add({
        'text': _commentController.text.trim(),
        'author': userName,
        'timestamp': Timestamp.now(),
      });

      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: 400,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(widget.postId)
                    .collection('comments')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  final docs = snapshot.data?.docs ?? [];
                  return ListView(
                    children: docs.map((doc) {
                      return ListTile(
                        title: Text(doc['author']),
                        subtitle: Text(doc['text']),
                        trailing: Text(
                          (doc['timestamp'] as Timestamp).toDate().toString(),
                          style: TextStyle(fontSize: 10),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(hintText: 'Escribe un comentario...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendComment,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}