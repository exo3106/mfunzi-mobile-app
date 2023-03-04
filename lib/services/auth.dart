import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/userModel.dart';
import '../pages/loginPage.dart';
import 'FirebaseHandle Exception.dart';
import 'databaseAPI.dart';

enum AuthStatus {
  successful,
  wrongPassword,
  emailAlreadyExists,
  invalidEmail,
  weakPassword,
  unknown,
}

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  static late AuthStatus _status;
  SnackBar customSnackBar({ required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  getCurrentUser() async {
    User? user = await auth.currentUser;
    return user;
  }

  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseOptions firebaseOptions = const FirebaseOptions(
        appId: '1:331461582634:android:588cadd7663ef306dbc853',
        apiKey: 'AIzaSyAaib8CNfpUa7q7ko9uTd4DKBAVvAzAeeI',
        projectId: 'multimedia.mfunzi-home',
        messagingSenderId: '331461582634',
        storageBucket:'multimedia.mfunzi-home.appspot.com'
    );
    FirebaseApp firebaseApp = await Firebase.initializeApp(
        options: firebaseOptions
    );
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => HomeScreen(
      //       user: user,
      //     ),
      //   ),
      // );
    }

    return firebaseApp;
  }
  // get user details
  Future<UserModel> getUserDetails() async {
    User currentUser = FirebaseAuth.instance.currentUser!;

    DocumentSnapshot documentSnapshot =
    await FirebaseFirestore.instance.collection('mfunzi_users').doc(currentUser.uid).get();

    return UserModel.fromSnap(documentSnapshot);
  }
  Future<void> _prefManager(String _prefName) async {
    late Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

    final SharedPreferences prefs = await _prefs;
    String returnedPref;
    switch (_prefName) {
      case "email":
        returnedPref = prefs.getString(_prefName).toString();
        break;
      case "username":
        returnedPref = prefs.getString(_prefName).toString();
        break;
      case "uid":
        returnedPref = prefs.getString(_prefName).toString();
        break;
    }

  }
  static Future signInWithGoogle(BuildContext context) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
    await _googleSignIn.signIn();

    final GoogleSignInAuthentication? googleSignInAuthentication =
    await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication?.idToken,
        accessToken: googleSignInAuthentication?.accessToken);

    UserCredential result =
    await _firebaseAuth.signInWithCredential(credential);

    User? userDetails = result.user;

    if (userDetails!=null) {
      late Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

      final SharedPreferences prefs = await _prefs;

      prefs.setString("email", userDetails.email.toString());
      prefs.setString("iud", userDetails.email.toString());
      prefs.setString("username", userDetails.email.toString().replaceAll("@gmail.com", ""));

      Map<String, dynamic> userInfoMap = {
        "email": userDetails.email,
        "username": userDetails.email.toString().replaceAll("@gmail.com", ""),
        "name": userDetails.displayName,
        "imgUrl": userDetails.photoURL
      };

      DatabaseMethods
          .addUserInfoToDB(userDetails.uid, userInfoMap)
          .then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      });
    }
  }
  static Future<User?> createUserUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return user;
  }
  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
    }

    return user;
  }
  static Future<AuthStatus> resetPassword({required String email}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth
        .sendPasswordResetEmail(email: email)
        .then((value) => _status = AuthStatus.successful)
        .catchError((e) => _status = AuthExceptionHandler.handleAuthException(e));
    return _status;

  }
  static Future signOut() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await auth.signOut();

  }

}
