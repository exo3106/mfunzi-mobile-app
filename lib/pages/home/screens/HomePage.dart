import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mfunzi/pages/gender/screen/GenderFeatures.dart';
import 'package:mfunzi/res/custom_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../forum/screen/forumFeature.dart';
import '../comonents/fFHomeDrawerComponent.dart';
import '../comonents/fFHomeFeaturesComponent.dart';



class HomeScreen extends StatefulWidget {
  /// Callback for when this form is submitted successfully. Parameters are (email, password)
  final User? user;

  const HomeScreen({required this.user, Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin{
  late String email, password, confirmPassword;
  /// Whether dark mode is enabled.
  bool isDarkModeEnabled = false;

  late TabController _tabController;
  final TextEditingController _searchQuery = TextEditingController();
  late final List<String> _list = [];
  late  String _email="";
  late  String _id ="";
  late  String _username ="";

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = (prefs.getString('email')??'');
      _id = (prefs.getString('uid')??'');
      _username = (prefs.getString('username')??'');
    });
  }
  Icon actionIcon =  Icon(Icons.search, color: CustomColors.firebaseNavy);
  void _handleTabSelection() {
    setState(() {

    });
  }
  /// Called when the state (day / night) has changed.
  void onStateChanged(bool isDarkModeEnabled) {
    setState(() {
      this.isDarkModeEnabled = isDarkModeEnabled;
    });
  }

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(_handleTabSelection);
    _loadData();
    super.initState();
  }

  int _selectedIndex = 0;
  static  late final List<Widget> _widgetOptions = <Widget>[
    MFCardFeatures(),
    MFForumFeatures(),
    MFGenderFeatures(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: const Drawer(
        child: MFHomeDrawerComponent(),
      ),
      appBar: AppBar(
        backgroundColor: CustomColors.firebaseNavy,
        title:Text("Mfunzi",style: TextStyle(
            color: CustomColors.firebaseBackground)),
      ),
      body: SizedBox(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items:  <BottomNavigationBarItem>[
             BottomNavigationBarItem(
                label: "home".tr,
                icon:Icon(Icons.home),
                backgroundColor: CustomColors.firebaseNavy
            ),
            BottomNavigationBarItem(
                label: "forum".tr,
                icon:Icon(Icons.people_alt_outlined),
                backgroundColor: CustomColors.firebaseNavy
            ),
            BottomNavigationBarItem(
              label: "grp".tr,
              icon:Icon(Icons.help),
                backgroundColor:CustomColors.firebaseNavy
            ),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          selectedItemColor:CustomColors.firebaseOrange,
          iconSize: 20,
          onTap: _onItemTapped,
          elevation: 5
      ),
    );

  }
}

