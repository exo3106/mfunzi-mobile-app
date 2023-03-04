import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mfunzi/res/custom_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mfunzi/models/forumModel.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uuid/uuid.dart';
import '../../../utils/profileImagePicker.dart';
import '../../../utils/validator.dart';


enum ForumQuery {
  gender,
  sports,
  academic,
}


class MFForumFeatures extends StatefulWidget{
  const MFForumFeatures({
    Key? key,
  }) : super(key: key);

  @override
  _MFForumFeaturesState createState() => _MFForumFeaturesState();

}

class _MFForumFeaturesState extends State<MFForumFeatures> {
  bool _validate = true;
  String _email = '';
  String _id = '';
  bool isLoading = false;
  List<Forum>? retrievedForumPostList;
  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final GlobalKey<FormState> _searchKey = GlobalKey<FormState>();
  TextEditingController _post = TextEditingController();
  TextEditingController _title = TextEditingController();
  TextEditingController _tag = TextEditingController();
  bool isPostAvailable = false;


  //Load preferences
  _loadData() async {
    setState(() {
      isLoading = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _email = (prefs.getString('email') ?? '');
        _id = (prefs.getString('uid') ?? '');
      });
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> addPost(
      { required String a, required String b, required String c, required String uid,}) async {
    if (_formKey.currentState!.validate()) {
      a = _post.text.toString();
      b = _title.text.toString();
      c = _tag.text.toString();

      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      User? userDetails = FirebaseAuth.instance.currentUser;


      if (userDetails != null) {
        var uuid = const Uuid();
        // Generate a v1 (time-based) id
        var v1 = uuid.v1();
        var postId = v1;
        var title = _title.text.toString();
        var post = _post.text.toString();
        var category = _tag.text.toString();
        var email = _email.toString();
        var profileUrl = "";
        await FirebaseFirestore.instance
            .collection("mfunzi_users")
            .where('uid', isEqualTo: userDetails.uid.toString())
            .get().then((QuerySnapshot querySnapshot) {
          //Testing if the profile can be printed
          for (var doc in querySnapshot.docs) {
            profileUrl= doc["profileUrl"];
            Forum.addPost(postId, title, post, category, _id, email,profileUrl).then((value) {
              if (kDebugMode) {
                print("Post Inserted Successfully");
              }
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Post Sent Successfully')));
            });
          }
        });

      } else {
        setState(() {
          _validate = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid info')),
        );
      }
    }
  }

  _displayDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration( milliseconds: 100),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height,
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                formClaim(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              CustomColors.firebaseNavy),
                          shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(5))
                            ),
                          ),
                        ),
                        onPressed: () async {
                          await addPost(a: _title.text,
                              b: _post.text,
                              c: _tag.text,
                              uid: _id);
                          _title.clear();
                          _post.clear();
                          _tag.clear();
                          Future.delayed(
                              const Duration(milliseconds: 3000), () {
                            const CircularProgressIndicator();
                            Navigator.of(context).pop();
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                    Icons.arrow_right_alt, color: Colors.white),
                                Text(' Send a new Post',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "NotoSans"
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )

                    ),
                    OutlinedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              CustomColors.firebaseNavy),
                          shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(5))
                            ),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(' Cancel',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "NotoSans"
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
  Form formClaim() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Align(
              alignment: Alignment.centerLeft,
              child:Material(color: Colors.white,
                  child: Text(
                    "What's on your mind!",
                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, fontFamily: "NotoSans"),))),
          const SizedBox(height: 15),
          Material(color: Colors.white, child: TextFormField(
            style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontFamily: "NotoSans"
            ),
            controller: _title,
            validator: (value) =>
                Validator.validateName(name: _title.text.trim()),
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
              ),
            ),
          )
          ),
          const SizedBox(height: 10),
          Material(color: Colors.white, child: TextFormField(
            style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontFamily: "NotoSans"
            ),
            maxLines: 2,
            controller: _post,
            validator: (value) =>
                Validator.validateName(name: _post.text.trim()),
            decoration: const InputDecoration(
              labelText: 'Post description',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
              ),
            ),
          )
          ),
          const SizedBox(height: 10),
          Material(color: Colors.white, child: TextFormField(
            style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontFamily: "NotoSans"
            ),
            controller: _tag,
            validator: (value) =>
                Validator.validateName(name: _tag.text.trim()),
            decoration: const InputDecoration(
              labelText: 'Add Tags : Gender , Education, mzumbeUni',
              alignLabelWithHint: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
              ),
            ),
          )

          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  String timeStampConverter(Timestamp date) {
    var dateToTimestamp = DateTime.parse(date.toDate().toString());
    return timeago.format(dateToTimestamp);
  }
  Timestamp dateConverter(DateTime date) {
    var dateToTimestamp = Timestamp.fromDate(date);
    return dateToTimestamp;
  }
}