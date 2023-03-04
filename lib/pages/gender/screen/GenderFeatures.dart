import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mfunzi/res/custom_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../utils/validator.dart';


class MFGenderFeatures extends StatefulWidget{
  const MFGenderFeatures({Key? key}) : super(key: key);


  @override
  _MFGenderFeaturesState createState() => _MFGenderFeaturesState();

}

class _MFGenderFeaturesState extends State<MFGenderFeatures> {
  GlobalKey _scaffoldGlobalKey = GlobalKey();
  late String dropdownValue;
  late String _email = '';
  late String _id = '';
  late bool _gpass = false;
  late bool _validate = false;
  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _claim = TextEditingController();
  TextEditingController _location = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _category = TextEditingController();
  final _claimStreamDoc = FirebaseFirestore.instance.collection('claim');

  static const List<String>  _gvbCategories = <String>[
    "Kubakwa",
    "Hongo ya ngono",
    "Ndoa ya kulazimishwa",
    "Kukeketwa",
    "Ukatili wa kimwili",
    "Kuvizia"
  ];


  Future<void> addClaim(
      { required String a, required String b, required String c,required String d}) async {
    if (_formKey.currentState!.validate()) {
      a = _claim.text.toString();
      b = _description.text.toString();
      c = _location.text.toString();
      d = _category.text.toString();
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      User? userDetails = await FirebaseAuth.instance.currentUser;

      if (userDetails != null) {
        _claimStreamDoc.add({
          'title':a,
          'location': c,
          'post': b,
          'progress': "inprogress",
          'user_id': userDetails.uid,
          'createdAt': dateConverter(DateTime.now()),
          'category': d
        }).then((value) {
          print("Clain Inserted Successfully");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Information Sent Successfully')),
          );
        }
        ).catchError((error) => print("Failed to update user: $error"));
      } else {
        setState(() {
          _validate = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid Credentials')),
        );
      }
    }
  }
  Container statusClaim(String status) {
    Container container = Container();
    switch (status) {
      case "inprogress":
        container = Container(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Text(status, style: TextStyle(
                color: CustomColors.firebaseBackground,
                fontWeight: FontWeight.bold)),),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: CustomColors.firebaseNavy
          ),
        );
        return container;
      case "done":
        container = Container(
          child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(status, style: TextStyle(
                  color: CustomColors.firebaseBackground,
                  fontWeight: FontWeight.bold),)),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: CustomColors.firebaseOrange
          ),
        );
        return container;

      case "received":
        container = Container(
          child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(status, style: TextStyle(
                  color: CustomColors.firebaseBackground,
                  fontWeight: FontWeight.bold),)),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: CustomColors.complementBackgroundGreen
          ),
        );
        return container;
    }
    return container;
  }

  //Load preferences
  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = (prefs.getString('email') ?? '');
      _id = (prefs.getString('uid') ?? '');
    });
  }
  _displayDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child:
            Expanded(
              flex: 1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:<Widget> [
                  formClaim(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                          style: ButtonStyle(
                            backgroundColor:MaterialStateProperty.all(CustomColors.firebaseNavy),
                            shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                              ),
                            ),
                          ),
                          onPressed: () async {
                            await addClaim(a:_claim.text,b:_description.text,c:_location.text,d:_category.text);
                            Navigator.of(context).pop();
                            Future.delayed(const Duration(milliseconds: 2000),(){
                              const CircularProgressIndicator();

                            });
                          },
                          child:Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:const [
                                  Icon(Icons.arrow_right_alt,color: Colors.white),
                                  Text(' Send a claim',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                        fontFamily: "NotoSans"
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                      ),
                      OutlinedButton(
                          style: ButtonStyle(
                            backgroundColor:MaterialStateProperty.all(CustomColors.firebaseNavy),
                            shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                              ),
                            ),
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                          child:Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:const [
                                  Text(' Cancel',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                        fontFamily: "NotoSans"
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                      )
                    ],
                  )
                ],
              ),
            )
          ),
        );
      },
    );
  }


  Form formClaim() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Material(color: Colors.white,
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: CustomColors.firebaseOrange.withOpacity(.6),
                    ),
                    child :const Padding(
                      padding:EdgeInsets.all(20),
                      child: Text(
                        "SEND A CLAIM!\nFill all necessary information in the form below. Incase of anyhelp please contact us +255755000000",
                        style: TextStyle(fontSize: 15, fontFamily: "NotoSans"),
                      ),
                    )
            )
          ),
          const SizedBox(height: 15),
            Material(color: Colors.white, child: TextFormField(
              style: const TextStyle(
                  fontFamily: "NotoSans",color: Colors.black54
              ),
              controller: _claim,
              validator: (value) =>
                  Validator.validateName(name: _claim.text.trim()),
              decoration: const InputDecoration(
                labelText: 'Problem',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
              ),
            )
          ),
          const SizedBox(height: 10),
          Material(color: Colors.white,
                child: TextFormField(
              style: const TextStyle(
                  fontFamily: "NotoSans",color: Colors.black54
              ),
              controller: _location,
              validator: (value) =>
                  Validator.validateName(name: _location.text.trim()),
              decoration: const InputDecoration(
                labelText: 'Incident Location',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
              ),
            )
          ),
          const SizedBox(height: 10),
          Material(color: Colors.white, child:
            DropdownButtonFormField<String>(
              style: const TextStyle(
                  fontFamily: "NotoSans",
                  color: Colors.black54
              ),
              items:  _gvbCategories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              value: _gvbCategories.first,
              onChanged: (value){
                setState(() {
                  dropdownValue = value!;
                  _category.text = dropdownValue;
                });
              },
            )
          ),
          const SizedBox(height: 10),
          Material(color: Colors.white, child: TextFormField(
            style: TextStyle(
                fontFamily: "NotoSans",
              color: Colors.black54
            ),
            controller: _description,
            validator: (value) =>
                Validator.validateName(name: _description.text.trim()),
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
              ),
            ),
          )
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  @override
  void initState() {
    _validate = false;
    _claim;
    _location;
    _description;
    _gpass = false;
    dropdownValue = _gvbCategories.first;
    _loadData();
    return super.initState();
  }

  @override
  void dispose() {
    _claim.dispose();
    _description.dispose();
    _location.dispose();
    _validate = false;

    return super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomColors.firebaseNavy,
        onPressed: (){
           _displayDialog(context);
        },
        child:Image.asset('assets/icon/icons/ic_Plus.png',width: 20,height: 20,color: CustomColors.firebaseBackground,),
      ),

      body:StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('claim').where("user_id", isEqualTo:_id).orderBy("createdAt", descending:true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(padding:const EdgeInsets.only(top: 5,bottom: 5), child:ListTile(
                        leading: Icon(Icons.message,color: CustomColors.firebaseNavy,),
                        title: Text(data["post"],style: const TextStyle(fontSize:15,fontWeight: FontWeight.w600)),
                        subtitle:  Padding(padding:const EdgeInsets.only(top: 5), child:Row(children: [
                          statusClaim(data["progress"]),
                          const SizedBox(width:10),
                          Text(timeStampConverter(data["createdAt"]))
                        ],
                        )
                        )
                      ),
                    )

                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  String timeStampConverter(Timestamp date) {
    var dateToTimestamp = DateTime.parse(date.toDate().toString());
    return timeago.format(dateToTimestamp);
  }
  Timestamp dateConverter(DateTime date) {
    var dateToTimestamp = Timestamp.fromDate(date);
    return dateToTimestamp;
  }
}

