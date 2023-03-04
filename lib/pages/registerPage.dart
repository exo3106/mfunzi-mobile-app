import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../models/userModel.dart';
import '../res/custom_colors.dart';
import '../services/auth.dart';
import '../services/databaseAPI.dart';
import 'package:sizer/sizer.dart';
import '../services/storageAPI.dart';
import '../utils/profileImagePicker.dart';
import '../utils/validator.dart';
import 'loginPage.dart';


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
  late bool isRegister = false;
  Uint8List? _imageFile;

  //Update Language
  updateLanguage(Locale locale){
    Get.back();
    Get.updateLocale(locale);
  }

  StatefulWidget registerNewUserButton(SnackBar snackBar){
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
        const CircularProgressIndicator();
        setState(() {
          isRegister = true;
        });

        if (_formKey.currentState!.validate()) {
          // If the form is valid, display a snackbar. In the real world,
          // you'd often call a server or save the information in a database.
          //Check if Image is null
          if(_imageFile == null){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('null-image'.tr)),
            );
          }else{
            if(_confirmpass.text.trim() == _pass.text.trim()){
              User? userInfo = await AuthMethods
                  .createUserUsingEmailPassword(
                  email: _emailAddress.text.trim(),
                  password: _pass.text.trim(),
                  context: context);

              //Upload to storage
              String photoUrl = await StorageMethods()
                  .uploadImageToStorage("profilePictures", _imageFile!, false);
              if (userInfo != null) {
                UserModel newUser = UserModel(
                    email: userInfo.email.toString(),
                    uid: userInfo.uid.toString(),
                    profileUrl: photoUrl,
                    username: userInfo.email.toString().replaceAll("@gmail.com",""),
                    bio: "", file: _imageFile!
                );

                await DatabaseMethods.addUserInfoToDB(userInfo.uid,  newUser.toJson());

                // await DatabaseRefDoc(uid:userInfo.uid).updateUserInfo(email:userInfo.email, name:getRandomString(5).toString());
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                //Send Email Verification
                _emailAddress.clear();
                _pass.clear();
                _confirmpass.clear();

                Future.delayed(const Duration(milliseconds: 300),(){
                  Navigator.of(context)
                      .pushReplacement(
                    MaterialPageRoute(builder: (context) =>const LoginScreen()),
                  );
                });
              }else{
                if (kDebugMode) {
                  print("Pass don't match");
                }
              }

            }else{
              setState(() {
                _validate = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('null-image'.tr)),
              );
            }
          }

        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(90, 10, 90, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_outlined,color: Colors.white),
            Text('register'.tr,
              style: const TextStyle(
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
  //selecting n image
  selectImage() async {

      Uint8List im = await pickImage(ImageSource.gallery);
      setState(() {
        _imageFile = im;
      });

  }
  @override
  void initState() {
    _validate = false;
    isRegister = false;
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
    double screenWidth = MediaQuery.of(context).size.width;
    final snackBar =  SnackBar(
      backgroundColor: CustomColors.firebaseNavyLightInput,
      content: Text('register-successful'.tr+ _emailAddress.text,style: TextStyle(
          color: CustomColors.firebaseBackground
      ),),
    );
    return Sizer(
        builder: (context, orientation, deviceType){
          return Scaffold(
              resizeToAvoidBottomInset:false,
              body: SingleChildScrollView(
                  child: SizedBox(
                    width: screenWidth,
                    height: screenHeight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView(
                        children: [
                          SizedBox(height:10),
                          Text(
                            "create-account".tr,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height:5),
                          Text(
                            "sign-up-account".tr,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black.withOpacity(.6),
                            ),
                          ),
                          SizedBox(height:20),
                          Form(
                              key: _formKey,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                        _imageFile!=null?CircleAvatar(
                                          radius: 40,
                                          backgroundImage: MemoryImage(_imageFile!),
                                      ):const CircleAvatar(
                                      radius: 40,
                                      backgroundImage:AssetImage('assets/icon/icons/blank_profile.png'),
                                    ),
                                    const SizedBox(height:5),
                                    TextButton(
                                      child:Text("upload-image".tr,
                                          style:TextStyle(color: CustomColors.firebaseOrange,)),
                                      onPressed: selectImage
                                    ),
                                    const SizedBox(height: 5),
                                    TextFormField(
                                      controller: _emailAddress,
                                      validator: (value) =>
                                          Validator.validateEmail(
                                              email: _emailAddress.text.trim()),
                                      decoration:  InputDecoration(
                                        prefixIcon: const Icon(Icons.email_outlined,
                                            color: Color(0xFFFFCA28)),
                                        labelText: 'email'.tr,
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10)),
                                        ),
                                      ),

                                    ),
                                    SizedBox(height:10),
                                    TextFormField(
                                      controller: _pass,
                                      textInputAction: TextInputAction.done,
                                      obscureText: true,
                                      validator: (value) =>
                                          Validator.validatePassword(password: _pass
                                              .text.trim()),
                                      decoration:  InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.lock, color: Color(0xFFFFCA28),),
                                        labelText: 'password'.tr,
                                        border:
                                        const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFFFFCA28),
                                          ),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    TextFormField(
                                      controller: _confirmpass,
                                      textInputAction: TextInputAction.done,
                                      obscureText: true,
                                      validator: (value) =>
                                          Validator.validateConfirmPassword(
                                              cpassword: _pass.text.trim(),
                                              fpassword: _confirmpass.text.trim()),
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.lock, color: Color(0xFFFFCA28),),
                                        labelText: 'confirm'.tr,
                                        border:
                                        const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFFFFCA28),
                                          ),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    registerNewUserButton(snackBar),
                                    SizedBox(
                                      height:10,
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => const LoginScreen(),
                                            ),
                                          ),
                                      child: RichText(
                                        text: TextSpan(
                                          text: "already-user".tr,
                                          style: TextStyle(color: Colors.black),
                                          children: [
                                            TextSpan(
                                              text: "login".tr,
                                              style: const TextStyle(
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
              )
          );
        }
    );
  }
}
