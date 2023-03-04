import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:mfunzi/pages/loginPage.dart';
import 'package:mfunzi/pages/profile/screens/ProfileScreen.dart';
import 'package:mfunzi/res/custom_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../../models/MFCommonModels.dart';
import '../../../services/auth.dart';
import '../../../utils/profileImagePicker.dart';

class MFHomeDrawerComponent extends StatefulWidget {
  const MFHomeDrawerComponent({Key? key}) : super(key: key);

  @override
  State<MFHomeDrawerComponent> createState() => _MFHomeDrawerComponentState();
}

class _MFHomeDrawerComponentState extends State<MFHomeDrawerComponent> {
  List<MFDrawerModel> options = getDrawerOptions();
  int selectedIndex = -1;
  String _email='';
  late var userData = {};
  bool isLoading = false;
  String _id='';
  bool _isSigningIn= false;
  @override
  void initState() {
    super.initState();
    _isSigningIn = true;
    _loadData();
    _getUserData();
  }
  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = (prefs.getString('email')??'');
      _id = (prefs.getString('uid')??'');
    });
  }
  //Get User Information
  _getUserData() async {
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
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    ):
    Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children:[
                    DrawerHeader(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              userData['profileUrl']!,
                            ),
                          ),
                          SizedBox(width: 10,),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children:  <Widget>[
                                Text(_email, style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: CustomColors.firebaseBackground)),
                                Text(_email.replaceAll("@gmail.com",""), style: TextStyle(fontSize: 12,color: CustomColors.firebaseBackground)),
                                const SizedBox(height: 8,),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.pushAndRemoveUntil<dynamic>(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) => ProfileScreen(email:_email,id:_id,),
                                      ),
                                          (route) => true,//if you want to disable back feature set to false
                                    );
                                  },
                                  child:Text("profile".tr, style: TextStyle(fontSize: 15,color: CustomColors.firebaseOrange)),
                                ),
                              ]
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: CustomColors.firebaseNavy,
                          image: DecorationImage(
                              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.dstATop),
                              image: NetworkImage(
                                userData['profileUrl']!,
                              ),
                              fit: BoxFit.cover)
                      ),
                    ),
                    ListTile(
                      title:Row(
                      children: [
                      Image.asset('assets/icon/icons/ic_Send.png',width: 35,height: 35,color: CustomColors.firebaseNavy,),
                        const SizedBox(
                            width: 10,
                            ),
                          Text("share-app".tr,style: TextStyle(color: CustomColors.firebaseNavy,fontWeight: FontWeight.bold),)
                          ],
                        ) ,
                      onTap: ()async{
                        await FlutterShare.share(
                            title: 'Share with Friends',
                            text: 'Copy the link to share with your friends',
                            linkUrl: 'https://flutter.dev/',
                            chooserTitle: 'Kudos');
                      },
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Image.asset('assets/icon/icons/ic_Logout.png',width: 35,height: 35,color: CustomColors.firebaseNavy,),
                          const SizedBox(
                            width: 10,
                          ),
                          Text("logout".tr, style:TextStyle(color: CustomColors.firebaseNavy,fontWeight: FontWeight.bold),)
                        ],
                      ),
                      onTap: ()async {
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
                    ),
              ],
            ),
        ]
    );
  }
}

