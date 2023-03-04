import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mfunzi/res/custom_colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mfunzi/models/forumModel.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as IMG;
import '../../../utils/validator.dart';
import 'forumPosts.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
/// The different ways that we can filter/sort movies.

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
   bool isAscending = false;
  late int likeCount;
  late bool showFileName = false;
  late bool showAlert = false;
  Widget appBarTitle = Text("Search Sample", style: new TextStyle(color: Colors.white),);
  String _email = '';
  String _id = '';
  bool isLoading = false;
  List<Forum>? retrievedForumPostList;
  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final GlobalKey<FormState> _formPDFKey = GlobalKey<FormState>();
  TextEditingController _post = TextEditingController();
  TextEditingController _title = TextEditingController();
  TextEditingController _tag = TextEditingController();
  final TextEditingController _searchQuery = TextEditingController();
  late List<Map<String, dynamic>> data = [];
  Icon actionIcon = Icon(Icons.search, color: CustomColors.firebaseNavy);
  bool isPostAvailable = false;
  File? photo;
  PlatformFile? platformFile;


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
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }



  Future savePdf(Uint8List asset, String name) async {
    try{
      var ref = await FirebaseStorage.instance.ref().child("files/$name").putData(asset);
      var downloadUrl = await ref.ref.getDownloadURL();
      print(downloadUrl);

    }catch(err){
      print(err.toString());
    }


  }
  Future<void> addPost(
      { required BuildContext context, required String a, required String b, required String c, required String uid,}) async {
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
                Column(
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:MaterialStatePropertyAll(
                          CustomColors.firebaseNavy
                        )
                      ),
                      //if user click this button, user can upload image from gallery
                      onPressed: () {
                        Navigator.pop(context);
                        getImage(ImageSource.gallery);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.image),
                          Text('From Gallery'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      //if user click this button. user can upload image from camera
                      onPressed: () {
                        Navigator.pop(context);
                        getImage(ImageSource.camera);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.camera),
                          Text('From Camera'),
                        ],
                      ),
                    ),
                  ],
                ),
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
                          await addPost(context: context,a: _title.text,
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

  XFile? image;

  final ImagePicker picker = ImagePicker();

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }

  //show popup dialog
  void myAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
  _displayPDFDialog(BuildContext context) {
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
                Material(color: Colors.white,
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: CustomColors.firebaseOrange.withOpacity(.6),
                        ),
                        child :const Padding(
                          padding:EdgeInsets.all(30),
                          child: Text(
                            "UPLOAD ARTICLES!\nOnly documents with .pdf are accepted.",
                            style: TextStyle(fontSize: 15, fontFamily: "NotoSans"),
                          ),
                        )
                    )
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: upLoadPDF(),
                ),
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
                          myAlert(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                    Icons.arrow_right_alt, color: Colors.white),
                                Text(' Upload File',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "NotoSans"
                                  ),
                                ),
                              ],
                            ),
                            //if image not null show the image
                            //if image null show text
                            image != null
                                ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  //to show image, you type like this.
                                  File(image!.path),
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                  height: 300,
                                ),
                              ),
                            )
                                : Text(
                              "No Image",
                              style: TextStyle(fontSize: 20),
                            ),

                          ],
                        )
                    ),
                    SizedBox(
                      width: 50,
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
          const Align(
              alignment: Alignment.centerLeft,
              child:Material(color: Colors.white,
                  child: Text(
                    "What's on your mind!",
                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, fontFamily: "NotoSans"),))),
          const SizedBox(height: 15),
          Material(color: Colors.white, child: TextFormField(
            style: const TextStyle(
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
              style:const TextStyle(
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
              style:const TextStyle(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        CustomColors.firebaseBackground),
                    shape: MaterialStateProperty.all(
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(5))
                      ),
                    ),
                  ),
                  onPressed: () async {

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                              Icons.arrow_right_alt, color: CustomColors.firebaseNavy),
                           Text(' Upload File',
                            style: TextStyle(
                                fontSize: 12,
                                color: CustomColors.firebaseNavy,
                                fontWeight: FontWeight.w700,
                                fontFamily: "NotoSans"
                            ),
                          ),
                        ],
                      ),

                    ],
                  )
              ),

            ],
          ),

        ],
      ),
    );
  }

  Form upLoadPDF() {
    return Form(
      key: _formPDFKey,
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Align(
            alignment: Alignment.centerLeft,
              child:Material(color: Colors.white,
              child: Text(
                "Upload PDF!",
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, fontFamily: "NotoSans"),))),
          const SizedBox(height: 15),
          Material(color: Colors.white, child:  Column(
            children: [
              InkWell(
                onTap: () async {
                  PermissionStatus result;

                  result = await Permission.storage.request();

                  if (result.isGranted) {
                    //await selectFile();
                  }

                },
                  child: const Text('Select file',style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontFamily: "NotoSans"
                  )
                ),
              ),
              if(platformFile != null)
                Text('${platformFile?.name}'),
            ],
          )
          ),
          const SizedBox(height: 10),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  @override
  void initState() {
    likeCount = 0;
    showAlert = false;
    showFileName = false;
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? const Center(
      child: CircularProgressIndicator(),
    ) : Stack(
        children: [
          Positioned(child:
          Padding(
            padding: EdgeInsets.only(top:10,left: 10,right: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(CustomColors.firebaseNavy),
                    ),
                    onPressed: () {
                      _displayDialog(context);
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 24.0,
                    ),
                    label: Text('Post'),
                  ),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(CustomColors.firebaseNavy),
                    ),
                    onPressed: () async{

                      Future.delayed(const Duration(seconds: 5),(){
                        const CircularProgressIndicator();
                      });
                      _displayPDFDialog(context);
                    },
                    icon: Icon(
                      Icons.article,
                      size: 24.0,
                    ),
                    label: Text('Article'),
                  ),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(CustomColors.firebaseNavy),
                    ),
                    onPressed: () {},
                    icon: Icon(
                      Icons.video_camera_back_outlined,
                      size: 24.0,
                    ),
                    label: Text('Video'),
                  ),
                ],
              )
            )
          ),
          Positioned(child:
            Padding(
            padding: const EdgeInsets.only(top:50,left: 10,right: 10),
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Forum Posts'),
                      IconButton(
                        onPressed: (){},
                        icon: Icon(
                          Icons.sort_outlined,
                          size: 24.0,
                          color: CustomColors.firebaseNavy,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ),
          Positioned(
              child:Padding(
            padding: EdgeInsets.only(top:105),
                child:  StreamBuilder<QuerySnapshot>(
                  stream:FirebaseFirestore.instance
                      .collection("forum_post").orderBy("title",descending:false).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(),
                      );
                    }
                    return ListView(
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                        return MFPostFeatures(snap: data);
                      }).toList(),
                    );
                  },
                ),
            )
          )

        ],
      );
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