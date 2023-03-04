import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:mfunzi/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../res/custom_colors.dart';
import '../../profile/screens/ProfileScreen.dart';

// This is the type used by the popup menu below.
enum Options { profile, logout, info }

@immutable
class MFResources extends StatefulWidget{
  MFResources({Key? key}) : super(key: key);

  late String email="";
  late  String id ="";
  @override
  _MFResourcesState createState() => _MFResourcesState();

}

class _MFResourcesState extends State<MFResources>{
  var _popupMenuItemIndex = 0;
  late InAppWebViewController inAppWebViewController;
  late double _progress;
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
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
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
      title: Text(
        'resources'.tr,
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
    _progress = 0;
    _loadData();
    return super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  _buildAppBar(),
      body:Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                  url: Uri.parse("https://ujuziseti.com/")),
              onWebViewCreated: (InAppWebViewController controller){
                inAppWebViewController = controller;
              },
              onProgressChanged: (InAppWebViewController controller, int progress){
                setState(() {
                  _progress = progress/100;
                });
              },
            ),
            _progress < 1 ? SizedBox(height :3, child:LinearProgressIndicator(
              value: _progress,
              backgroundColor: CustomColors.firebaseOrange.withOpacity(.5),

            )): const SizedBox()
          ]
      ),
    );
  }
}