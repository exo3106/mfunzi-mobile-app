import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:mfunzi/res/custom_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/auth.dart';
import '../../../utils/stragefiles.dart';
import '../../profile/screens/ProfileScreen.dart';
import 'mFVideoPlayer.dart';

enum Menu { profile, logout, info }

class MFVideoPlayerUIComponent extends StatefulWidget{
  MFVideoPlayerUIComponent({Key? key}) : super(key: key);
  late String email='';
  late String id='';

  @override
  _MFVideoPlayerUIComponentState createState() => _MFVideoPlayerUIComponentState();

}

class _MFVideoPlayerUIComponentState extends State<MFVideoPlayerUIComponent>{


  @override
  void initState() {
    super.initState();
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
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.firebaseNavy,
        title: const Text("Resources"),
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
      body: SizedBox(
        child:SizedBox(
            child: Column(
              children: [
            Padding(
            padding:const EdgeInsets.all(10),
              child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        color: CustomColors.firebaseOrange.withOpacity(.6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                                child : Padding(
                                    padding:const EdgeInsets.only(left:10),
                                    child:Text('more-info'.tr, style: TextStyle(
                                        fontSize: 15,
                                        color: CustomColors.firebaseNavy,
                                        fontWeight: FontWeight.w300,
                                        fontFamily: "NotoSans"
                                    ),
                                    )
                                )
                            ),
                          Padding(
                          padding: const EdgeInsets.only(right:10),
                            child:TextButton(
                                child:  Text('visit-site'.tr,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: CustomColors.firebaseNavy,
                                        fontWeight: FontWeight.w300,
                                        fontFamily: "NotoSans"
                                    )
                                ),
                                onPressed: (){},
                                // onPressed: (){} => Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (_) => MFVideoPlayerUIComponent(),
                                //   ),
                                // )
                            ),
                          )
                        ],
                      ),
                    ),
                ),
                const SizedBox(
                  height: 200,
                  child: Padding(padding: EdgeInsets.only(left: 10,right: 10),
                  child: VideoPlayer()
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top:10,bottom: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        child : Padding(
                            padding:const EdgeInsets.only(left:10),
                            child:Text('other-resources'.tr, style: TextStyle(
                                fontSize: 15,
                                color: CustomColors.firebaseNavy,
                                fontWeight: FontWeight.w700,
                                fontFamily: "NotoSans"
                            ),
                            )
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Container(
                    child: const StorageFiles(),
                  )
                )
              ],
            ),
        )
      )
    );
  }

}