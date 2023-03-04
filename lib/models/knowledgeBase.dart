import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

@immutable
class Documents {
   Documents( {
    required this.title,
    required this.description,
    required this.file,
    required this.author
  });

  late final String title;
  late final String description;
  late final File file;
  late final  String author;

   Documents.fromJson(Map<String, Object?> json): this(
     title: json['title']! as String,
     description: json['description']! as String,
     file: json['file']! as File,
     author: json['author']! as String,
   );

   Documents.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc): this(
        title: doc.data()!['title']! as String,
        description: doc.data()!['description']! as String,
        file: doc.data()!['file']! as File,
        author: doc.data()!['author']! as String,
   );
}