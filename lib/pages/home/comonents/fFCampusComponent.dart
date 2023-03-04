import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mfunzi/res/custom_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/auth.dart';
import '../../profile/screens/ProfileScreen.dart';

enum Menu { profile, logout, info }

class MFCampusComponent extends StatefulWidget {
  MFCampusComponent({Key? key}) : super(key: key);

  late String email="";
  late  String id ="";
  @override
  State<MFCampusComponent> createState() => _MFCampusComponentState();
}

class _MFCampusComponentState extends State<MFCampusComponent> {
  late InAppWebViewController inAppWebViewController;
  late double _progress;
  @override
  void initState() {
    super.initState();
    _progress = 0;
    _loadData();
  }
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


  PopupMenuButton _openOptions(){
    return PopupMenuButton<Menu>(
      // Callback that sets the selected popup menu item.
        onSelected: (Menu item) {
          setState(() {
          });
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
          PopupMenuItem<Menu>(
            value: Menu.profile,
            child: const Text('Profile'),
            onTap: navigationPage("profile"),
          ),
          PopupMenuItem<Menu>(
            value: Menu.info,
            child:  const Text('Info and Help'),
            onTap: navigationPage("info"),
          ),
          PopupMenuItem<Menu>(
            value: Menu.logout,
            child: const Text('Logout'),
            onTap: navigationPage("logout"),
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:false,
      appBar: AppBar(
        backgroundColor: CustomColors.firebaseNavy,
        title: const Text("Mzumbe Campus"),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: CustomColors.firebaseBackground),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Image.asset('assets/icon/icons/ic_option.png',width: 20,height: 20,color: CustomColors.firebaseBackground,),
            onPressed: () => _openOptions(),
          )
        ],
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: Uri.parse("https://site.mzumbe.ac.tz/")),
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

