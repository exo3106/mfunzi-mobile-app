import 'package:flutter/cupertino.dart';
import 'package:mfunzi/res/custom_colors.dart';

class MFDrawerModel {
  String? title;
  String? image;
  Image? icon;

  MFDrawerModel({ this.icon, this.title});
}

List<MFDrawerModel> getDrawerOptions() {
  List<MFDrawerModel> list = [];

  list.add(MFDrawerModel(icon: Image.asset('assets/icon/icons/ic_Send.png',width: 35,height: 35,color: CustomColors.firebaseNavy,), title: 'Share App'));
  list.add(MFDrawerModel(icon: Image.asset('assets/icon/icons/ic_Logout.png',width: 35,height: 35,color: CustomColors.firebaseNavy,), title: 'Logout'));

  return list;
}
