import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mfunzi/res/custom_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'GridFeatures.dart';

class MFCardFeatures extends StatelessWidget {
  MFCardFeatures({Key? key ,required String email,required String id}) : super(key: key);
  String _email='';
  String _id='';

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
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
                                  padding: const EdgeInsets.only(left: 15,top: 10),
                                  child:Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:  <Widget>[
                                          Text('Welcome to Mfunzi,', style: TextStyle(fontSize: 18,
                                              color: CustomColors.firebaseBackground,
                                          fontWeight: FontWeight.bold)),
                                          Text(_email, style: const TextStyle(fontSize: 12)
                                          ),
                                        ]
                                    ),
                                ),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height * .05,
                                color: Colors.white,
                              )
                            ],
                          ),
                          // The card widget with top padding,
                          // incase if you wanted bottom padding to work,
                          // set the `alignment` of container to Alignment.bottomCenter
                          Container(
                            alignment: Alignment.topCenter,
                            padding:  EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * .10,
                                right: 20.0,
                                left: 20.0),
                            child:  MFFeatures(),
                          ),
                        ],
                      )
            )
        );
      }
    );
  }
}