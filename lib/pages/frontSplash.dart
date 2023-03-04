import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mfunzi/res/custom_colors.dart';
import '../services/auth.dart';
import 'loginPage.dart';
import 'home/screens/HomePage.dart';


class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  /// This widget is the root of your application.
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }
  AnimatedTextKit animatedText() {
    return   AnimatedTextKit(
      onFinished: (){
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) {
                return FutureBuilder(
                  future: AuthMethods().getCurrentUser(),
                  builder: (context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      return HomeScreen(user: snapshot.data);
                    }else{
                      return LoginScreen();
                    }
                  },
                );
              }
          ), (route) => false,//if you want to disable back feature set to false
        );

      },
      totalRepeatCount: 1,
      animatedTexts: [
        ColorizeAnimatedText(
          'JIFUNZE',
          textStyle: _colorizeTextStyle,
          colors: _colorizeColors,
        ),
        ColorizeAnimatedText(
          'JIAMINI',
          textStyle: _colorizeTextStyle,
          colors: _colorizeColors,
        ),
        ColorizeAnimatedText(
          'ELIMIKA',
          textStyle: _colorizeTextStyle,
          colors: _colorizeColors,
        ),
        ColorizeAnimatedText(
          'MFUNZI APP',
          textStyle: _colorizeTextStyle,
          colors: _colorizeColors,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                top:MediaQuery.of(context).size.height*.2,
                  left:MediaQuery.of(context).size.width*.36,
                  width: 100,
                  height: 100,
                  child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Image.asset('assets/logos/android-chrome-192x192.png',),]
              ) ),
              Positioned(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                       // animatedText()
                        SizedBox(
                          width: 250.0,
                          child: DefaultTextStyle(
                            style: _colorizeTextStyle,
                            child: AnimatedTextKit(
                              onFinished: (){
                                Navigator.pushAndRemoveUntil<dynamic>(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                      builder: (BuildContext context) {
                                        return FutureBuilder(
                                          future: AuthMethods().getCurrentUser(),
                                          builder: (context, AsyncSnapshot<dynamic> snapshot) {
                                            if (snapshot.hasData) {
                                              return HomeScreen(user: snapshot.data);
                                            }else{
                                              return LoginScreen();
                                            }
                                          },
                                        );
                                      }
                                  ), (route) => false,//if you want to disable back feature set to false
                                );

                              },
                              totalRepeatCount: 1,
                              animatedTexts: [
                                TypewriterAnimatedText('ONESHA UJASIRI',speed: _speed, textAlign: TextAlign.center,),
                                TypewriterAnimatedText('JIFUNZE NA ELIMIKA',speed: _speed, textAlign: TextAlign.center,),
                                TypewriterAnimatedText('ONESHA UZALENDO',speed: _speed, textAlign: TextAlign.center,),
                                TypewriterAnimatedText('TUJIFUNZE KWA MAENDELEO YA WATU',speed: _speed, textAlign: TextAlign.center,),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width*.3,
                bottom: MediaQuery.of(context).size.height*.09,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/logos/vliruos-logo.png",
                        matchTextDirection: true,
                        height: 25,
                      ),
                      const SizedBox(width: 10,),
                       SvgPicture.asset(
                          "assets/logos/logo_ugent_en.svg",
                          matchTextDirection: true,
                          ),
                    ],
                  )
              )
            ],
          )

        )
    );
  }
}

class AnimatedText {
  final String label;
  final Color? color;
  final Widget child;

  const AnimatedText({
    required this.label,
    required this.color,
    required this.child,
  });
}

// Colorize Text Style
TextStyle _colorizeTextStyle = TextStyle(
  fontFamily: 'Quicksand',
  color: CustomColors.firebaseNavy,
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
);
// Colorize Text Style
const _speed = Duration(
    milliseconds: 100
);
// Colorize Colors
const _colorizeColors = [
  Color(0xFF000000),
  Color(0xFF2C384A),
  Color(0xFFF57C00),
  Color(0xFF4285F4),
];
