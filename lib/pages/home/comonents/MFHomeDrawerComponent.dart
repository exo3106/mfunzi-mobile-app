import 'package:flutter/material.dart';
import 'package:mfunzi/res/custom_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../../models/MFCommonModels.dart';

class MFHomeDrawerComponent extends StatefulWidget {
  @override
  State<MFHomeDrawerComponent> createState() => _MFHomeDrawerComponentState();
}

class _MFHomeDrawerComponentState extends State<MFHomeDrawerComponent> {
  List<MFDrawerModel> options = getDrawerOptions();
  int selectedIndex = -1;
  String _email='';
  String _id='';

  @override
  void initState() {
    super.initState();
    _loadData();
  }
  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = (prefs.getString('email')??'');
      _id = (prefs.getString('uid')??'');
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5, right: 8, top: 20),
          child:Column(
          children:[
          Padding(
              padding: EdgeInsets.only(top: 20),
                  child:Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                          Image.asset('assets/icon/faces/face_1.png', height: 50, width: 50, fit: BoxFit.cover),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children:  <Widget>[
                              Text(_email, style: TextStyle(fontSize: 12)),
                              Text(_email.replaceAll(_email, "@gmail.com"), style: TextStyle(fontSize: 12)),
                            ]
                      ),
                      IconButton(
                        icon: Image.asset('assets/icon/icons/ic_CloseSquare.png', height: 16, width: 16, fit: BoxFit.cover, color: CustomColors.firebaseNavy),
                        onPressed: () {
                          //finish(context);
                        },
                      ),
                    ],
                  ),
              )
            ],
          ),

        ),
        Expanded(child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
              ListView.builder(
                itemCount: options.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return  ListTile(
                    hoverColor: CustomColors.firebaseGrey,
                    leading: options[index].icon,
                    title: Text(
                    options[index].title.toString(),
                    style: TextStyle(color: CustomColors.firebaseNavy, fontSize: 15),
                    ),
                  );
                },
              )
            ]
          ),
        )
      ]
    );
  }
}

