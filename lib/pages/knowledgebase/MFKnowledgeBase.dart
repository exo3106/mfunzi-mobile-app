import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mfunzi/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../res/custom_colors.dart';
import '../profile/screens/ProfileScreen.dart';

// This is the type used by the popup menu below.
enum Options { profile, logout, info }

@immutable
class MFKnowkdgeBaseComponent extends StatefulWidget{
  MFKnowkdgeBaseComponent({Key? key}) : super(key: key);
  late String email="";
  late  String id ="";
  @override
  _MFKnowkdgeBaseComponentState createState() => _MFKnowkdgeBaseComponentState();

}

class _MFKnowkdgeBaseComponentState extends State<MFKnowkdgeBaseComponent>{
  var _popupMenuItemIndex = 0;
  final Stream<QuerySnapshot> _streamImages = FirebaseFirestore.instance.collection('knowledge').snapshots();
  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Mfunzi App'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Mfuzi App is a community app.'),
                Text('that aims ....'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      widget.email = (prefs.getString('email')??'');
      widget.id = (prefs.getString('uid')??'');
    });
  }
  navigationPage(String route) {
    switch(route){
      case "profile":
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => ProfileScreen(email:widget.email,id:widget.id),
          ),
              (route) => true,//if you want to disable back feature set to false
        );
        break;
      case "info":
        _showDialog();
        break;
      case "logout":
        AuthMethods.signOut();
        break;
    }

    // Navigator.of(context).push(
    //     MaterialPageRoute(builder: (context) => CameraScreen ()));
  }


  _buildAppBar() {
    return AppBar(
      backgroundColor: CustomColors.firebaseNavy,
      title: const Text(
        'Knowledge base',
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
      actions: [
        PopupMenuButton(
          onSelected: (value) {
            _onMenuItemSelected(value as int);
          },
          itemBuilder: (ctx) => [
            _buildPopupMenuItem('Profile', Icons.person_rounded, Options.profile.index),
            _buildPopupMenuItem('Info', Icons.info, Options.info.index),
            _buildPopupMenuItem('Logout', Icons.arrow_circle_right, Options.logout.index),
          ],
        )
      ],
    );
  }

  PopupMenuItem _buildPopupMenuItem(
      String title, IconData iconData, int position) {
    return PopupMenuItem(
      value: position,
      child:  Row(
        children: [
          Icon(iconData, color: Colors.black,),
          Text(title),
        ],
      ),
    );
  }

  _onMenuItemSelected(int value) {
    setState(() {
      _popupMenuItemIndex = value;
    });

    if (value == Options.profile.index) {
      navigationPage("profile");
    } else if (value == Options.info.index) {
      navigationPage("info");
    } else if (value == Options.logout.index) {
      setState(() async{
        await AuthMethods.signOut();
      });
    }
  }

  @override
  void initState(){
    _loadData();
    return super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          children: [
                Container(
                    child: StreamBuilder(
                    stream: _streamImages,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container( child: Center(child:CircularProgressIndicator()));
                      } else {
                        return Container(
                            width: 150,
                            height:200,
                            child: CarouselSlider(
                              options: CarouselOptions(height: 50.0),
                              items: snapshot.data?.docs.map((DocumentSnapshot document) {
                                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                        width: MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                                        child:Image.network(data['imageUrl'],fit: BoxFit.cover, width: 1000)
                                    );
                                  },
                                );
                              }).toList(),
                            )
                        );
                      }
                    }
                ),
                )
          ],
        )
      ],
    );;
  }
}