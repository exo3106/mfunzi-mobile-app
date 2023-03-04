import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../res/custom_colors.dart';
import '../services/auth.dart';
import '../utils/validator.dart';
import 'registerPage.dart';
import 'home/screens/HomePage.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  /// Callback for when this form is submitted successfully. Parameters are (email, password)
  final Function(String? email, String? password)? onSubmitted;

  const LoginScreen({this.onSubmitted, Key? key}) : super(key: key);
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailAddress = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  late bool _isSigningIn = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late bool _validate = false;
  late final StreamSubscription<ConnectivityResult> _connectivitySubscription;
  // Platform messages are asynchronous, so we initialize in an async method.
  @override
  void initState() {
    // _connectivitySubscription;
    _isSigningIn= false;
    _validate = false;
    //initConnectivity();
    super.initState();

    // // Start listening to changes on the form fields
    // _email.addListener(_printLatestValue);
    // _pass.addListener(_printLatestValue);
  }
  @override
  void dispose() {
    _emailAddress.dispose();
    _pass.dispose();
    _isSigningIn=false;
    _validate= false;
    // _connectivitySubscription.cancel();
    super.dispose();
  }

  loginButton(SnackBar snackBar){
    return _isSigningIn ? CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(CustomColors.firebaseNavy),
    )
        : OutlinedButton(
        style: ButtonStyle(
          backgroundColor:MaterialStateProperty.all(Colors.blueAccent),
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),bottomRight:  Radius.circular(10))
            ),
          ),
        ),
        onPressed: () async {
          if (kDebugMode) {
            print(_emailAddress);
            print(_pass);
          }

          if (_formKey.currentState!.validate()) {
            // If the form is valid, display a snackbar. In the real world,
            // you'd often call a server or save the information in a database.
            User? userDetails = await AuthMethods
                .signInUsingEmailPassword(
                email: _emailAddress.text.trim(),
                password: _pass.text.trim(),
                context: context);

            if (userDetails != null) {
              late Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
              final SharedPreferences prefs = await _prefs;
              prefs.setString("email",userDetails.email.toString()).toString();
              prefs.setString("uid",userDetails.uid.toString()).toString();
              setState(() {
                _isSigningIn = true;
                _validate = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.of(context)
                  .pushReplacement(
                MaterialPageRoute(builder: (context) => HomeScreen(user: userDetails)),
              );
            }else{
              setState(() {
                _validate = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content:Text('invalid-credentials'.tr,style: const TextStyle(fontFamily:"Quicksand"),)),
              );
            }
          }
        },
        child:Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(120, 10, 120, 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.arrow_right_alt,color: Colors.white),
                  Text('login'.tr,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontFamily:"Quicksand"
                    ),
                  ),
                ],
              ),
            )
          ],
        )

    );
  }
//Update Language
  updateLanguage(Locale locale){
    Get.back();
    Get.updateLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final snackBar =  SnackBar(
      backgroundColor: CustomColors.firebaseNavyLightInput,
      content: Text('Login Successfully '+ _emailAddress.text,style: TextStyle(
          color: CustomColors.firebaseBackground
      ),),
    );

    return Sizer(
        builder: (context, orientation, deviceType){
          return  Scaffold(
            resizeToAvoidBottomInset:false,
            body:SingleChildScrollView(
                child: Container(
                  width: screenWidth,
                  height: screenHeight,
                  child:Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView(
                      children: [
                        SizedBox(height: 20),
                        Text(
                          "welcome".tr,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height:20),
                        Text(
                          "sign-in".tr,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black.withOpacity(.6),
                          ),
                        ),
                        SizedBox(height: 20),
                        Form(
                            key: _formKey,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  TextFormField(
                                    controller: _emailAddress,
                                    validator: (value) => Validator.validateEmail(email:_emailAddress.text.trim()),
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.email_outlined,color:Color(0xFFFFCA28)),
                                      labelText: 'email'.tr,
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.only(topLeft:Radius.circular(10),topRight:Radius.circular(10),
                                            bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                                      ),
                                    ),

                                  ),
                                  SizedBox(height: screenHeight * .025),
                                  TextFormField(
                                    controller: _pass,
                                    textInputAction: TextInputAction.done,
                                    obscureText: true,
                                    validator: (value) => Validator.validatePassword(password: _pass.text.trim()),
                                    decoration:  InputDecoration(
                                      prefixIcon: const Icon(Icons.lock,color: Color(0xFFFFCA28),),
                                      labelText: 'password'.tr,
                                      border:
                                      const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:Color(0xFFFFCA28),
                                        ),
                                        borderRadius: BorderRadius.only(topLeft:Radius.circular(10),topRight:Radius.circular(10),
                                            bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        "forgot-password".tr,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height:10,
                                  ),
                                  loginButton(snackBar),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const RegisterScreen(),
                                      ),
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                        text: "new-user".tr,
                                        style: TextStyle(color: Colors.black),
                                        children: [
                                          TextSpan(
                                            text: "sign-up".tr,
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height:10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: (){
                                          updateLanguage(const Locale('sw',"TZ"));
                                        },
                                        child: RichText(
                                          text: const TextSpan(
                                            text: "Swahili",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          updateLanguage(const Locale('en',"US"));
                                        },
                                        child: RichText(
                                          text: const TextSpan(
                                            text: "English",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ]
                            )
                        ),
                      ],
                    ),
                  ),
                )
            ),
          );
        }
    );
  }
}

