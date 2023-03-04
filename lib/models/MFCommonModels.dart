import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mfunzi/res/custom_colors.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:mfunzi/services/auth.dart';
class MFDrawerModel {
  String? title;
  String? image;
  Image? icon;
  VoidCallback onTap;
  MFDrawerModel({ this.icon, this.title,required this.onTap});
}

List<MFDrawerModel> getDrawerOptions() {
  List<MFDrawerModel> list = [];

  list.add(MFDrawerModel(
      icon: Image.asset('assets/icon/icons/ic_Send.png',width: 35,height: 35,color: CustomColors.firebaseNavy,),
      title: 'Share App',
      onTap:() async{
        await FlutterShare.share(
            title: 'Example share',
            text: 'Example share text',
            linkUrl: 'https://flutter.dev/',
            chooserTitle: 'Example Chooser Title');
        }
      )
  );

  list.add(MFDrawerModel(
      icon: Image.asset('assets/icon/icons/ic_Logout.png',width: 35,height: 35,color: CustomColors.firebaseNavy,),
      title: 'Logout',
      onTap:() async{
          const CircularProgressIndicator();
          await AuthMethods.signOut();
        }
    ),
  );

  return list;
}
