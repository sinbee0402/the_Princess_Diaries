import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:princess_diaries/domain/model/post.dart';

class PostDb {
  final db = FirebaseFirestore.instance;

  Future<List<Post>> getPosts() async {
    final posts = db.collection('Posts').snapshots();
    // final posts = await db.collection('Posts').get().then(
    //   (value) {
    //     print("Successfully completed");
    //     for (var docSnapshot in value.docs) {
    //       print('${docSnapshot.id} => ${docSnapshot.data()}');
    //     }
    //   },
    //   onError: (e) => print('Error completing: $e'),
    // );
    return posts;
  }

  Future<Post?> getPostById(int id) async {
    final post = await db.collection('Posts').doc('$id');
    post.get().then(
      (value) {
        final data = value.data() as Map<String, dynamic>;
        return Post.fromJson(data);
      },
      onError: (e) => print('Error getting document: $e'),
    );
  }

  Future<void> insertPost(Post post) async {
    await db.collection('Posts').doc('${post.id}').set({
      'emoji':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e6/Noto_Emoji_KitKat_263a.svg/220px-Noto_Emoji_KitKat_263a.svg.png',
      'date': post.date,
      'title': post.title,
      'content': post.content,
    });
  }

  Future<void> deletetPost(Post post) async {
    await db.collection('Posts').doc('${post.id}').delete();
  }

  Future<void> updateNote(Post post) async {
    await db.collection('Posts').doc('${post.id}').update({
      'emoji':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e6/Noto_Emoji_KitKat_263a.svg/220px-Noto_Emoji_KitKat_263a.svg.png',
      'date': post.date,
      'title': post.title,
      'content': post.content,
    });
  }
}
