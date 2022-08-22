import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mfunzi/pages/LoginPage.dart';
import '../res/custom_colors.dart';


class SplashPage extends StatefulWidget {

  @override
  SplashPageState createState() => SplashPageState();
}



class SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin{

  var _visible = true;

  late AnimationController animationController;
  late Animation<double> animation;

  startTime() async {
    var _duration = const Duration(seconds: 4);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const LoginScreen(),
      ),
          (route) => false,//if you want to disable back feature set to false
    );
    // Navigator.of(context).push(
    //     MaterialPageRoute(builder: (context) => CameraScreen ()));
  }

  @override
  void initState() {
    super.initState();



    animationController = AnimationController(
        vsync: this, duration: const Duration(seconds: 1));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/icon/logo.png',
                width: animation.value * 250,
                height: animation.value * 450,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children:  <Widget>[

              Padding(padding: EdgeInsets.only(bottom: 30.0),child:Text(
                "powered by Vliruos", style: TextStyle(fontWeight: FontWeight.bold, color: CustomColors.firebaseOrange, fontSize: 19),))

            ],),
        ],
      ),
    );
  }
}
