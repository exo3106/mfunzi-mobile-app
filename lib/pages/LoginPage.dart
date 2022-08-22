/*
  Flutter UI
  ----------
  lib/screens/simple_login.dart
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../res/custom_colors.dart';
import '../services/auth.dart';
import '../utils/validator.dart';
import 'RegisterPage.dart';
import 'home/screens/HomePage.dart';

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

  @override
  void initState() {
    _isSigningIn= false;
    _validate = false;
    super.initState();

    // // Start listening to changes on the form fields
    // _email.addListener(_printLatestValue);
    // _pass.addListener(_printLatestValue);
  }
  @override
  void dispose() {
    _emailAddress.dispose();
    _pass.dispose();
    _isSigningIn=true;
    _validate= false;
    super.dispose();
  }

   loginButton(SnackBar snackBar){
    return _isSigningIn ? const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
              const SnackBar(content: Text('Invalid Credentials')),
            );
          }
        }
      },
      child:Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
          padding: const EdgeInsets.fromLTRB(90, 10, 90, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children:const [
              Icon(Icons.arrow_right_alt,color: Colors.white),
              Text(' Login',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
      )
    ],
      )

    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final snackBar =  SnackBar(
      backgroundColor: CustomColors.firebaseNavyLightInput,
      content: Text('Login Successfully '+ _emailAddress.text,style: TextStyle(
          color: CustomColors.firebaseBackground
      ),),
    );
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            SizedBox(height: screenHeight * .12),
            const Text(
              "Welcome,",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * .01),
            Text(
              "Sign in to continue!",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black.withOpacity(.6),
              ),
            ),
            SizedBox(height: screenHeight * .12),
            Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        controller: _emailAddress,
                        validator: (value) => Validator.validateEmail(email:_emailAddress.text.trim()),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined,color:Color(0xFFFFCA28)),
                          labelText: 'Email',
                          border: OutlineInputBorder(
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
                        decoration:  const InputDecoration(
                          prefixIcon: Icon(Icons.lock,color: Color(0xFFFFCA28),),
                          labelText: 'Password',
                          border:
                          OutlineInputBorder(
                            borderSide: BorderSide(
                              color:Color(0xFFFFCA28),
                            ),
                            borderRadius: BorderRadius.only(topLeft:Radius.circular(10),topRight:Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * .075,
                      ),
                      loginButton(snackBar),
                      SizedBox(
                        height: screenHeight * .15,
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        ),
                        child: RichText(
                          text: const TextSpan(
                            text: "I'm a new user, ",
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: "Sign Up",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ]
                )
              ),
            ],
          ),
        ),
      )
    );
  }
}

