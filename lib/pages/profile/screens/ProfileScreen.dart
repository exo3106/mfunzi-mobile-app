
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mfunzi/res/custom_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/auth.dart';
import '../../../services/storageAPI.dart';
import '../../../utils/profileImagePicker.dart';
import '../../loginPage.dart';
import '../../home/screens/HomePage.dart';
import '../components/MFProfileComponent.dart';

class ProfileScreen extends StatefulWidget{
  ProfileScreen({Key? key, required this.id,required this.email,}) : super(key: key);
  late final String email;
  late final String id;


  @override
  ProfileScreenState createState() => ProfileScreenState();
}
class ProfileScreenState extends State<ProfileScreen>{
  late bool _isSigningIn= true;
  Uint8List? _profile;
  bool isLoading = false;
  late var userData = {};
  _buildAppBar() {
    return AppBar(
      backgroundColor: CustomColors.firebaseNavy,
      title: const Text(
        'Profile',
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
    );
  }


  getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    String? userId = user?.uid.toString();
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('mfunzi_users')
          .doc(userId)
          .get();

      userData = userSnap.data()!;
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
  //Update Language
  updateLanguage(Locale locale){
    Get.back();
    Get.updateLocale(locale);
  }
  void initState(){
    _isSigningIn= true;
    _profile;
    _buildAppBar();
    getUserData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    ):Scaffold(
      key: UniqueKey(),
        appBar: _buildAppBar(),
        backgroundColor: CustomColors.firebaseNavyLight,
        body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                children: <Widget>[
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:  NetworkImage(
                            userData['profileUrl']!,
                          ),
                        ),
                  const SizedBox(height:12),
                  Text(
                    widget.email,
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                    width: 200,
                    child: Divider(
                      color: Colors.white,
                    ),
                  ),
                  // we will be creating a new widget name info card
                  InfoCard(text:"username".tr + widget.email.replaceAll("@gmail.com",""), icon: Icons.person,onTap: (){
                  },color: CustomColors.firebaseNavy),
                  InfoCard(text:"bio".tr + userData['bio'], icon: Icons.interests,onTap: (){
                  },color: CustomColors.firebaseNavy),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: (){
                          updateLanguage(const Locale('sw',"TZ"));
                        },
                        child: RichText(
                          text: const TextSpan(
                            text: "Swahili",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          updateLanguage(const Locale('en',"US"));
                        },
                        child: RichText(
                          text: const TextSpan(
                            text: "English",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25,right:25),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton(
                            style: ButtonStyle(
                              backgroundColor:MaterialStateProperty.all(Colors.blueAccent),
                              shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                ),
                              ),
                            ),
                            onPressed: (){
                              Navigator.of(context)
                                  .pushReplacement(
                                MaterialPageRoute(builder: (context) => HomeScreen(user: FirebaseAuth.instance.currentUser)),
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.edit,color: Colors.white),
                                    Text('edit-profile'.tr,
                                      style:const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            style: ButtonStyle(
                              backgroundColor:MaterialStateProperty.all(Colors.blueAccent),
                              shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              FirebaseAuth auth = FirebaseAuth.instance;
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.clear();
                              const CircularProgressIndicator();
                              await auth.signOut();
                              Future.delayed(const Duration(milliseconds: 3000),(){
                                setState(() {
                                  _isSigningIn = false;
                                  Navigator.pop(context);
                                  Navigator.of(context)
                                      .pushReplacement(
                                    MaterialPageRoute(builder: (context) => LoginScreen()),
                                  );
                                });

                              });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.logout,color: Colors.white),
                                    Text('logout'.tr,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ]),
                  )
                ],
              ),
            )
        )
    );
  }
}