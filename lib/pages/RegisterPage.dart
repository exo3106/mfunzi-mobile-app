import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../res/custom_colors.dart';
import '../services/auth.dart';
import '../services/databaseAPI.dart';
import '../utils/Utils.dart';
import '../utils/validator.dart';
import 'LoginPage.dart';


class RegisterScreen extends StatefulWidget {
  /// Callback for when this form is submitted successfully. Parameters are (email, password)
  final Function(String? email, String? password)? onSubmitted;

  const RegisterScreen({this.onSubmitted, Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailAddress = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmpass = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late bool _validate = false;

  OutlinedButton registerNewUserButton(SnackBar snackBar){
    return OutlinedButton(
      style: ButtonStyle(
        backgroundColor:MaterialStateProperty.all(Colors.redAccent),
        shape: MaterialStateProperty.all(
          const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),bottomRight:  Radius.circular(10))
          ),
        ),
      ),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          // If the form is valid, display a snackbar. In the real world,
          // you'd often call a server or save the information in a database.
          User? userInfo = await AuthMethods
              .createUserUsingEmailPassword(
              email: _emailAddress.text.trim(),
              password: _pass.text.trim(),
              context: context);

          if (userInfo != null) {
            String getUserProfile = "https://www.pinclipart.com/picdir/big/73-739007_icon-profile-picture-circle-png-clipart.png";
            Map<String, dynamic> userInfoMap = {
              "email": userInfo.email,
              "username": userInfo.email.toString().replaceAll("@gmail.com", ""),
              "name": userInfo.email.toString().replaceAll("@gmail.com", ""),
              "user_id":userInfo.uid,
              'groups': [],
              "is_staff": false
            };
            await DatabaseMethods.addUserInfoToDB(userInfo.uid, userInfoMap);


            // await DatabaseRefDoc(uid:userInfo.uid).updateUserInfo(email:userInfo.email, name:getRandomString(5).toString());
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            //Send Email Verification

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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(90, 10, 90, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children:const [
            Icon(Icons.person_outlined,color: Colors.white),
            Text(' Register',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void initState() {
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
    _confirmpass.dispose();
    _validate= false;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final snackBar =  SnackBar(
      backgroundColor: CustomColors.firebaseNavyLightInput,
      content: Text('Registered Successfully'+ _emailAddress.text,style: TextStyle(
          color: CustomColors.firebaseBackground
      ),),
    );
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            SizedBox(height: screenHeight * .12),
            const Text(
              "Create Account,",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * .01),
            Text(
              "Sign up to get started!",
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
                      SizedBox(height: screenHeight * .025),
                      TextFormField(
                        controller: _confirmpass,
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        validator: (value) => Validator.validateConfirmPassword(cpassword: _pass.text.trim(),fpassword: _confirmpass.text.trim()),
                        decoration:  const InputDecoration(
                          prefixIcon: Icon(Icons.lock,color: Color(0xFFFFCA28),),
                          labelText: 'Confirm Password',
                          border:
                          OutlineInputBorder(
                            borderSide: BorderSide(
                              color:Color(0xFFFFCA28),
                            ),
                            borderRadius: BorderRadius.only(topLeft:Radius.circular(10),topRight:Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * .075,
                      ),
                      registerNewUserButton(snackBar),
                      SizedBox(
                        height: screenHeight * .15,
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        ),
                        child: RichText(
                          text: const TextSpan(
                            text: "Already have a user, ",
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: "Sign In",
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
    );
  }
}
