import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mfunzi/res/custom_colors.dart';
import 'package:mfunzi/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/VideoCard.dart';
import '../../../utils/carousel_slider.dart';
import '../../../utils/profileImagePicker.dart';
import 'gridFeatures.dart';

class MFCardFeatures extends StatefulWidget {
  const MFCardFeatures({Key? key}) : super(key: key);

  @override
  State<MFCardFeatures> createState() => MFCardFeaturesState();
}

class MFCardFeaturesState extends State<MFCardFeatures> {
  late String _email ="";
  late String _id ="";
  bool isLoading = false;
  late User? userData = AuthMethods().getCurrentUser();

  _loadData() async {
    setState(() {
      isLoading = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _email = (prefs.getString('email')??'');
        _id = (prefs.getString('uid')??'');
      });
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
  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    }
    if (hour < 17) {
      return 'Afternoon';
    }
    return 'Evening';
  }
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  @override
  Widget build(BuildContext context) {

    return isLoading? const Center(
      child: CircularProgressIndicator(),
    ):LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: Stack(
                    children: <Widget>[
                      // The containers in the background
                      Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.height,
                            height: MediaQuery.of(context).size.height * .15,
                            color: CustomColors.firebaseNavyLight,
                            child:Padding(
                              padding: const EdgeInsets.only(left: 30,top: 10),
                              child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:  <Widget>[
                                    Text( '${greeting()} ${'kiunganishi'.tr} ${'welcome-message'.tr}', style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                        fontFamily: "NotoSans"
                                    ),
                                    ),
                                    Text(_email.replaceAll("@gmail.com",""), style: const TextStyle(
                                        fontSize: 30,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "NotoSans"
                                    )
                                    ),
                                  ]
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        padding:  EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .05,
                            right: 10.0,
                            left: 10.0
                        ),
                        child:Column(
                          children: [
                            CarouselHome(),
                            Align(
                              alignment: Alignment.centerLeft,
                                  child:Text('tools'.tr, style: TextStyle(
                                    fontSize: 15,
                                    color: CustomColors.firebaseNavy,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "NotoSans"
                                ),
                              ),
                            ),
                            const MFFeatures(),
                            Align(
                              alignment: Alignment.centerLeft,
                              child:Text('tools-video'.tr, style: TextStyle(
                                  fontSize: 15,
                                  color: CustomColors.firebaseNavy,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "NotoSans"
                              ),
                              ),
                            ),
                            const VideoCardWidget()
                          ],
                        ) ,
                      ),
                    ],
                  )
              )
          );
        }
    );
  }
}