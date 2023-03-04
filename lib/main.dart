import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mfunzi/pages/registerPage.dart';
import 'package:mfunzi/pages/frontSplash.dart';
import 'package:mfunzi/utils/localization.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  FirebaseOptions firebaseOptions = const FirebaseOptions(
    appId: '1:810194260656:android:1c306ba39b55166109e175',
    apiKey: 'AIzaSyBkZhDm5rZTIHClTQhVNxwLxuDbS-Bl_uI',
    projectId: 'mfunzi-app-264be',
    messagingSenderId: '331461582634',
    storageBucket:'mfunzi-app-264be.appspot.com',
  );
  await Firebase.initializeApp(
      options: firebaseOptions
  );
  runApp(const MfunziApp());
}
class MfunziApp extends StatefulWidget{
  const MfunziApp({Key? key}) : super(key: key);

  @override
  _MfunziAppState createState()=> _MfunziAppState();
}
class _MfunziAppState extends State<MfunziApp> {
  bool isDarkModeEnabled = false;
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: SystemUiOverlay.values);
    return  GetMaterialApp(
      theme: ThemeData(fontFamily:"Quicksand"),
      darkTheme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(color: Color(0xFF253341)),
        scaffoldBackgroundColor: const Color(0xFF15202B),
      ),
      themeMode: isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      translations: LocaleString(),
      locale: const Locale('sw','TZ'),
      title: 'MFUNZI App',
      home: Scaffold(body:SplashScreenPage()),
    );
  }
}
