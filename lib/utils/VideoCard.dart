import 'package:flutter/material.dart';

import '../pages/home/comonents/mVideoPlayerUI.dart';
import '../res/custom_colors.dart';

class VideoCardWidget extends StatelessWidget {
  const VideoCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: CustomColors.firebaseNavy,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 30),
            const ListTile(
              leading: Icon(Icons.play_arrow,color:Colors.white,size: 60,),
              title: Text('Welcome to Mfunzi',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontFamily: "NotoSans"
                ),
              ),
              subtitle: Text('We strive to safeguard our community.',
                    style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontFamily: "NotoSans"
                )
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('WATCH',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: "NotoSans"
                      )
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MFVideoPlayerUIComponent(),
                    ),
                  )
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      );
  }
}
