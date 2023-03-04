
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

@immutable
class Forum {
  const Forum( {
    required this.postId,
    required this.title,
    required this.post,
    required this.category,
    required this.likes,
    required this.user_id,
    required this.email,
    required this.profileUrl,
  });

  Forum.fromJson(Map<String, Object?> json)
      : this(
      postId: json['post_id']! as String,
      title: json['title']! as String,
      post: json['post']! as String,
      category:json['category']! as String,
      likes:json['likes']! as List,
      user_id:json['uid']! as String,
      email:json['email']! as String,
      profileUrl:json['profileUrl']! as String,
  );
  final String postId;
  final String title;
  final String post;
  final  String category;
  final  List likes;
  final String user_id;
  final String email;
  final String profileUrl;

  Map<String, Object?> toJson() {
    return {
      'post_id':postId,
      'title': title,
      'post': post,
      'category': category,
      'likes': [],
      'user_id' : user_id,
      'email' : email,
      'profileUrl':profileUrl
    };
  }

  Forum.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
        :this(
        postId: doc.data()!['post_id']! as String,
        title: doc.data()!['title'],
        post:doc.data()!['post']! as String,
        category:doc.data()!['category'] as String,
        likes:doc.data()!['likes'] as List,
        user_id:doc.data()!['user_id'] as String,
        email:doc.data()!['user_id'] as String,
        profileUrl:doc.data()!['profileUrl'] as String,

    );
  static Future<void> addPost(String postId, String title, String post, String category, String userId,String email,String profileUrl)async{
    try{
      Forum forumPost = Forum(
          postId: postId,
          title: title,
          post: post,
          category: category,
          likes: const [],
          user_id: userId,
          email: email, profileUrl:profileUrl
      );

      await FirebaseFirestore.instance.collection("forum_post").doc(postId).set(
          forumPost.toJson()
      );
    }catch(error){
      print(error);
    }

  }
}