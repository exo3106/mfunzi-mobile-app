import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../res/custom_colors.dart';
import '../../../services/databaseAPI.dart';
import '../../../utils/profileImagePicker.dart';

class MFPostFeatures extends StatefulWidget{
  final snap;

  const MFPostFeatures({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  _MFPostFeaturesState createState() => _MFPostFeaturesState();

}
class _MFPostFeaturesState extends State<MFPostFeatures>{

  late bool isLiked;
  late String _email = '';
  late String _id = '';
  Map<dynamic,dynamic> userData ={};
  late var data = {};
  bool isLoading = false;
  String? userId;


  //Load preferences
  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = (prefs.getString('email') ?? '');
      _id = (prefs.getString('uid') ?? '');
      userId=FirebaseAuth.instance
          .currentUser?.uid.toString();
    });
  }

  @override
  void initState(){
    super.initState();
    isLiked=false;
    _loadData();

  }
Future<void> likePost(String postId,List likes, String uid) async {
    isLiked = false;
  try{
    if(likes.contains(uid)){
      FirebaseFirestore.instance.collection("forum_post").doc(postId)
          .update({
        "likes":FieldValue.arrayRemove([uid])
      });
      setState(() {
        isLiked = true;
      });
    }else{
      FirebaseFirestore.instance.collection("forum_post").doc(postId)
          .update({"likes":FieldValue.arrayUnion([uid])});
      setState(() {
        isLiked = false;
      });
    }
  }
  catch(error){
    print(error);
  }
}

  deletePost(String postId) async {
    try {
      await DatabaseMethods.deletePost(postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
   return Column(
     children: [
       Card(
       child: Column(
       mainAxisSize: MainAxisSize.min,
         children: <Widget>[
           // CircleAvatar(
           //   radius: 50,
           //   backgroundImage:  NetworkImage(
           //     userData['profileUrl'].toString(),
           //   ),
           // ),
           ListTile(
               title:Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   RichText(
                       text: TextSpan(
                         style: DefaultTextStyle.of(context).style,
                         children: [
                             TextSpan(
                               text: "${widget.snap["title"]}",
                             ),
                           ]
                       )
                   ),
                   widget.snap["user_id"].toString() == userId
                       ? IconButton(
                     onPressed: () {
                       showDialog(
                         useRootNavigator: false,
                         context: context,
                         builder: (context) {
                           return Dialog(
                             child: ListView(
                                 padding: const EdgeInsets.symmetric(
                                     vertical: 16),
                                 shrinkWrap: true,
                                 children: [
                                   'Delete',
                                 ].map(
                                       (e) => InkWell(
                                       child: Container(
                                         padding:
                                         const EdgeInsets.symmetric(
                                             vertical: 12,
                                             horizontal: 16),
                                         child: Text(e),
                                       ),
                                       onTap: () {
                                         deletePost(
                                           widget.snap['post_id']
                                               .toString(),
                                         );
                                         // remove the dialog box
                                         Navigator.of(context).pop();
                                       }),
                                 )
                                     .toList()),
                           );
                         },
                       );
                     },
                     icon: const Icon(Icons.more_vert),
                   ): Container()
                 ],
               ) ,
               subtitle: Column(
                 children: [
                   ReadMoreText(
                     widget.snap["post"].toString(),
                     trimMode: TrimMode.Length,
                     trimLength: 100,
                     trimLines: 4,
                     preDataText:  widget.snap["email"].toString(),
                     preDataTextStyle:const TextStyle(fontSize:13,fontWeight: FontWeight.w500),
                     style:const TextStyle(color: Colors.black),
                     colorClickableText: CustomColors.firebaseOrange,
                     trimCollapsedText: '...more',
                     trimExpandedText: '..less',
                   ),
                   const SizedBox(height:5),
                 ],
               )
           ),
         ],
       ),
        ),
       Row(
         mainAxisAlignment: MainAxisAlignment.spaceAround,
         children: <Widget>[
           Row(
             children: [
               Text("${widget.snap["likes"].length }"),
               TextButton(
                 child: isLiked? Icon(Icons.thumb_up_alt_outlined,color: CustomColors.firebaseNavyLight):Icon(Icons.thumb_up,color: CustomColors.firebaseNavyLight),
                 onPressed: () async{
                   likePost(widget.snap['post_id'].toString(),
                     widget.snap['likes'],
                     _id,
                   );
                 },
               )
             ],
           ),
           TextButton(
             child:  Icon(Icons.comment,color: CustomColors.firebaseNavyLight),
             onPressed: () { /* ... */ },
           ),
           TextButton(
             child:  Icon(Icons.share,color: CustomColors.firebaseNavyLight),
             onPressed: () { /* ... */ },
           )
         ],
       )
     ],
   );
  }

}
