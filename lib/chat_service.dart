import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final _db = FirebaseFirestore.instance;

  Future<String> createOrGetChat(String uid1, String uid2) async {
    final chats = await _db.collection('chats')
        .where('users', arrayContains: uid1)
        .get();

    for (var doc in chats.docs) {
      final users = List<String>.from(doc['users']);
      if (users.contains(uid2)) return doc.id;
    }

    final docRef = await _db.collection('chats').add({
      'users': [uid1, uid2],
      'timestamp': FieldValue.serverTimestamp(),
    });

    return docRef.id;
  }

  Stream<List<Map<String, dynamic>>> getMessages(String chatId) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> sendMessage(String chatId, String senderId, String content) async {
    await _db.collection('chats').doc(chatId).collection('messages').add({
      'senderId': senderId,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await _db.collection('chats').doc(chatId).update({
      'lastMessage': content,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
