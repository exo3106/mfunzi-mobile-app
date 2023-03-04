import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../../res/custom_colors.dart';
import 'mFAcademicComponent.dart';
import 'fFCampusComponent.dart';
import '../../knowledgebase/MFKnowledgeBase.dart';
import 'mFResources.dart';


class MFFeatures extends StatefulWidget {
  const MFFeatures({Key? key}) : super(key: key);

  @override
  _MFFeaturesState createState() => _MFFeaturesState();
}

class _MFFeaturesState extends State<MFFeatures> {

      void navigationPage(String route) {
        switch(route){
          case "campus":
            Navigator.pushAndRemoveUntil<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => MFCampusComponent(),
              ),
                  (route) => true,//if you want to disable back feature set to false
            );
            break;
          case "academic":
            Navigator.pushAndRemoveUntil<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => MFAcademicComponent(),
              ),
                  (route) => true,//if you want to disable back feature set to false
            );
            break;
          case "helpdesk":
            Navigator.pushAndRemoveUntil<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => MFKnowkdgeBaseComponent(),
              ),(route) => true,//if you want to disable back feature set to false
            );
            break;
          case "resources":
            Navigator.pushAndRemoveUntil<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => MFResources(),
              ),(route) => true,//if you want to disable back feature set to false
            );
            break;
        }

        // Navigator.of(context).push(
        //     MaterialPageRoute(builder: (context) => CameraScreen ()));
      }

  @override
  Widget build(BuildContext context) {
    return _buildGridLayout();
  }

  Widget _buildGridLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ResponsiveGridRow(
          children: [
            ResponsiveGridCol(
              xs: 6,
              md: 3,
              child:Padding(
                padding: const EdgeInsets.all(5),
                child:
                InkWell(
                  onTap: () => navigationPage("campus"),
                  child:  Container(
                    height: 100,
                    alignment: const Alignment(0, 0),
                    decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/icon/images/Back-To-School.jpg'),
                          fit: BoxFit.fitWidth,
                          opacity:.1,
                        ),
                        color: CustomColors.firebaseOrange,
                        borderRadius: const BorderRadius.all(Radius.circular(5))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding:const  EdgeInsets.only(right: 15),
                          child: Image.asset('assets/icon/icons/ic_university.png',width: 40,height: 40,color: CustomColors.firebaseBackground,),
                        ),
                        Text('campus'.tr.toUpperCase(), style: TextStyle(
                            fontSize: 12,
                            color: CustomColors.firebaseBackground,
                            fontWeight: FontWeight.w700,
                            fontFamily: "NotoSans")),
                      ],
                    ),
                  ),
                )
              ),
            ),
            ResponsiveGridCol(
              xs: 6,
              md: 3,
              child:Padding(
                  padding: const EdgeInsets.all(5),
                  child:
                  InkWell(
                    onTap: () => navigationPage("resources"),
                    child:  Container(
                      height: 100,
                      alignment: const Alignment(0, 0),
                      decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage('assets/icon/images/School-Educational-Illustrations.jpg'),
                            fit: BoxFit.fitWidth,
                              opacity:.1,
                            ),
                          color: CustomColors.firebaseOrange,
                          borderRadius: const BorderRadius.all(Radius.circular(5))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child:Padding(padding:const  EdgeInsets.only(right: 15),
                              child: Image.asset('assets/icon/icons/ic_resources.png',width: 40,height: 40,color: CustomColors.firebaseBackground,),
                            ),
                          ),
                          Text('resources'.tr.toUpperCase(),style: TextStyle(
                              fontSize: 12,
                              color: CustomColors.firebaseBackground,
                              fontWeight: FontWeight.w700,
                              fontFamily: "NotoSans")),
                        ],
                      ),
                    ),
                  )
              ),
            ),
            ResponsiveGridCol(
              xs: 6,
              md: 3,
              child:Padding(
                  padding: const EdgeInsets.all(5),
                  child:   InkWell(
                  onTap: () => navigationPage("academic"),
                  child:Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/icon/images/University-Life-Illustration.jpg'),
                          fit: BoxFit.fitWidth,
                          opacity:.1,
                        ),
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    height: 100,
                    alignment: const Alignment(0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(padding:const  EdgeInsets.only(bottom: 5,),
                          child: Image.asset('assets/icon/icons/ic_academic.png',width: 40,height: 40,color: CustomColors.firebaseBackground,),
                        ),
                        Text('academic-life'.tr.toUpperCase(), style: TextStyle(
                            fontSize: 12,
                            color: CustomColors.firebaseBackground,
                            fontWeight: FontWeight.w700,
                            fontFamily: "NotoSans")),
                      ],
                    ),
                  )
                  )
              ),
            ),
            ResponsiveGridCol(
              xs: 6,
              md: 3,
              child:Padding(
                  padding: const EdgeInsets.all(5),
                  child:    InkWell(
                  onTap: () => navigationPage("helpdesk"),
                  child:Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/icon/images/Plumber-Vector-Illustration.jpg'),
                          fit: BoxFit.fitWidth,
                          opacity:.1,
                        ),
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    height: 100,
                    alignment: const Alignment(0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(padding:const  EdgeInsets.only(bottom: 5,),
                          child: Image.asset('assets/icon/icons/ic_help.png',width: 40,height: 40,color: CustomColors.firebaseBackground,),
                        ),
                        Text('help-desk'.tr.toUpperCase(),style: TextStyle(
                            fontSize: 12,
                            color: CustomColors.firebaseBackground,
                            fontWeight: FontWeight.w700,
                            fontFamily: "NotoSans")),
                      ],
                    ),
                  )
                )
              ),
            )
          ],
        ),
      ],
    );
  }
}