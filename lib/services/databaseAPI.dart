import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/forumModel.dart';

class DatabaseMethods {

  Future<Stream<QuerySnapshot>> getUserByUserName(String username) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getAllUsers() async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("is_staff", isEqualTo: true).snapshots();
  }

  static Future addUserInfoToDB(String userId,
      Map<String, dynamic> userInfoMap) async {
    return FirebaseFirestore.instance
        .collection("mfunzi_users")
        .doc(userId)
        .set(userInfoMap);
  }
  // Delete Post
  static Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await FirebaseFirestore.instance.collection('forum_post').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  static Future<List<Forum>> retrieveForumPost() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection("forum").get();
    return snapshot.docs.map((docSnapshot) => Forum.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
  static Future<bool> checkIfPostExists(String fetchedUser) async{
    DocumentSnapshot post = await FirebaseFirestore.instance.collection("forum_post")
        .doc(fetchedUser).get();
    return post.exists;
  }
  static Future<Iterable<Forum>> retrieveForumPostItem(String uid) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = (await FirebaseFirestore.instance.collection("forum_post").doc(uid).get()) as QuerySnapshot<Map<String, dynamic>>;
    return snapshot.docs.map((value) => Forum.fromDocumentSnapshot(value)).toList();
  }
  static Future<void> getUserData (String email) async {

    await FirebaseFirestore.instance
        .collection('mfunzi_users')
        .where("email", isEqualTo: email)
        .get().then((data) =>
        data.docs.map((doc) => doc.get("username"))
    );
  }
}
