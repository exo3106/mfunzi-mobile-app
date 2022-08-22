import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mfunzi/pages/RegisterPage.dart';
import 'package:mfunzi/pages/home/screens/HomePage.dart';
import 'package:mfunzi/pages/splash_screen.dart';
import 'package:mfunzi/pages/splash_screen2.dart';
import 'package:mfunzi/services/auth.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseOptions firebaseOptions = const FirebaseOptions(
      appId: '1:331461582634:android:588cadd7663ef306dbc853',
      apiKey: 'AIzaSyAaib8CNfpUa7q7ko9uTd4DKBAVvAzAeeI',
      projectId: 'mfunzi-home',
      messagingSenderId: '331461582634',
      storageBucket:'mfunzi-home.appspot.com'
  );
  await Firebase.initializeApp(
      options: firebaseOptions
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  void navigationPage(BuildContext context) {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const RegisterScreen(),
      ),
          (route) => false,//if you want to disable back feature set to false
    );
  }
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'MFUNZI App',
      debugShowCheckedModeBanner: false,
        home:HomeScreen()
      // home:  FutureBuilder(
      //   future: AuthMethods().getCurrentUser(),
      //   builder: (context, AsyncSnapshot<dynamic> snapshot) {
      //     if (snapshot.hasData) {
      //       return UserSplash(user: snapshot.data);
      //     }else{
      //       return SplashPage();
      //     }
      //   },
      // ),
    );
  }
}
