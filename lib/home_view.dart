import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../post_service.dart';
import '../post_model.dart';
import 'login_view.dart';
import 'new_post_view.dart';
import 'comment_sheet.dart';
import 'chat_list_view.dart';

class HomeView extends StatelessWidget {
  final PostService _postService = PostService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
        backgroundColor: Color(0xFF7B1FA2),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ChatListView()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => LoginView()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Post>>(
        stream: _postService.getPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Color(0xFF9C27B0)));
          }
          final posts = snapshot.data ?? [];
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                color: Color(0xFFF3E8FF),
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.userName,
                        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6A1B9A)),
                      ),
                      SizedBox(height: 5),
                      if (post.imageUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(post.imageUrl),
                        ),
                      SizedBox(height: 5),
                      Text(post.content),
                      SizedBox(height: 5),
                      Text(
                        post.timestamp.toString(),
                        style: TextStyle(fontSize: 12, color: Colors.deepPurple[200]),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.thumb_up_alt_outlined, color: Color(0xFFBA68C8)),
                            onPressed: () async {
                              final uid = FirebaseAuth.instance.currentUser?.uid;
                              if (uid != null) {
                                final ref = FirebaseFirestore.instance
                                    .collection('posts')
                                    .doc(post.id)
                                    .collection('likes')
                                    .doc(uid);
                                final exists = await ref.get();
                                if (exists.exists) {
                                  await ref.delete();
                                } else {
                                  await ref.set({'likedAt': firestore.Timestamp.now()});
                                }
                              }
                            },
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('posts')
                                .doc(post.id)
                                .collection('likes')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final count = snapshot.data!.docs.length;
                                return Text('$count Me gusta');
                              } else {
                                return Text('0 Me gusta');
                              }
                            },
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.comment, color: Colors.deepPurple[300]),
                            onPressed: () => showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) => CommentSheet(postId: post.id),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF9C27B0),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => NewPostView()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
