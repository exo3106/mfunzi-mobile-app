import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mfunzi/pages/home/comonents/MFVideoPlayer.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../../res/custom_colors.dart';


class MFFeatures extends StatefulWidget {
  const MFFeatures({Key? key}) : super(key: key);

  @override
  _MFFeaturesState createState() => _MFFeaturesState();
}

class _MFFeaturesState extends State<MFFeatures> {
  void _handleCampus(){
    if (kDebugMode) {
      print("Container Clicked");
    }
  }
  @override
  Widget build(BuildContext context) {
    return _buildGridLayout();
  }

  Widget _buildGridList() {
    return ResponsiveGridList(
        rowMainAxisAlignment: MainAxisAlignment.center,
        desiredItemWidth: 100,
        minSpacing: 10,
        children: [
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10,
          11,
          12,
          13,
          14,
          15,
          16,
          17,
          18,
          19,
          20
        ].map((i) {
          return Container(
            height: ((i % 5) + 1) * 100.0,
            alignment: const Alignment(0, 0),
            color: Colors.cyan,
            child: Text(i.toString()),
          );
        }).toList());
  }

  Widget _buildGridLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ResponsiveGridRow(
          children: [
            ResponsiveGridCol(
              lg: 12,
              child:Padding(
                padding: const EdgeInsets.all(5),
                child:
                InkWell(
                  onTap: () => _handleCampus(),
                  child:  Container(
                    height: 100,
                    alignment: const Alignment(0, 0),
                    decoration: BoxDecoration(
                        color: CustomColors.firebaseOrange,
                        borderRadius: const BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding:const  EdgeInsets.only(right: 15),
                          child: Image.asset('assets/icon/icons/ic_Home.png',width: 40,height: 40,color: CustomColors.firebaseBackground,),
                        ),
                        Text('MZUMBE CAMPUS', style: TextStyle(fontSize: 20,
                            color: CustomColors.firebaseBackground,
                            fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                )

              ),
            ),
            ResponsiveGridCol(
              xs: 6,
              md: 3,
              child:
              Card(
                child: Column(
                  children: <Widget>[
                    Text("Academic Life"),
                    Container(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.asset('assets/icon/icons/ic_academic.png')),
                    ),

                  ],
                ),


                margin: EdgeInsets.only(left: 20.0, right: 20.0,top : 5.0),

              )
            ),
            ResponsiveGridCol(
              xs: 6,
              md: 3,
              child:Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    height: 100,
                    alignment: const Alignment(0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(padding:const  EdgeInsets.only(bottom: 5,),
                          child: Image.asset('assets/icon/icons/ic_Home.png',width: 20,height: 20,color: CustomColors.firebaseBackground,),
                        ),
                        Text('HELP DESK', style: TextStyle(fontSize: 15,
                            color: CustomColors.firebaseBackground,
                            fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
              ),
            ),
            ResponsiveGridCol(
              lg: 12,
              child:Padding(
                padding: const EdgeInsets.all(5),
                child:  Container(
                  height: 180,
                  alignment: const Alignment(0, 0),
                  child: const VideoPlayer(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}