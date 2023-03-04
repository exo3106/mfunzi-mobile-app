
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

@immutable
class UserModel {
  const UserModel( {
    required this.email,
    required this.uid,
    required this.profileUrl,
    required this.username,
    required this.bio,
    required this.file

  });

  final String email;
  final String uid;
  final String profileUrl;
  final String username;
  final String bio;
  final Uint8List file;

  Map<String, Object?> toJson() {
    return {
      "email":email,
      "uid":uid,
      "profileUrl":profileUrl,
      "username":username,
      "bio":bio,
    };
  }

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      profileUrl: snapshot["profileUrl"],
      bio: snapshot["bio"],
      file: snapshot["file"]
    );
  }

  static Future<void> addUser( String email,String uid,String profileUrl,String username,String bio, Uint8List file )async{
    try{
      UserModel userData = UserModel(
          email: email,
          uid: uid,
          profileUrl: profileUrl,
          username: username,
          bio: bio, file: file
      );

      await FirebaseFirestore.instance.collection("userInfo").doc(uid).set(
          userData.toJson()
      );
    }catch(error){
      print(error);
    }

  }
}