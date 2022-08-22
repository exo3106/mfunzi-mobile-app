import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mfunzi/res/custom_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../comonents/MFHomeDrawerComponent.dart';
import '../comonents/MFHomeFeaturesComponent.dart';



class HomeScreen extends StatefulWidget {
  /// Callback for when this form is submitted successfully. Parameters are (email, password)
  final User? user;

  const HomeScreen({this.user, Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin{
  late String email, password, confirmPassword;
  /// Whether dark mode is enabled.
  bool isDarkModeEnabled = false;
  Widget appBarTitle = Text("Search Sample", style: new TextStyle(color: Colors.white),);
  var scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  final TextEditingController _searchQuery = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final List<String> _list = [];
  late bool _isSearching = false;
  late final String _searchText = "";
  late List<String> _searchList;
  late  String _email="";
  late  String _id ="";

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = (prefs.getString('email')??'');
      _id = (prefs.getString('uid')??'');
    });
  }
  Icon actionIcon =  Icon(Icons.search, color: CustomColors.firebaseNavy);
  void _handleTabSelection() {
    setState(() {

    });
  }
  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      _isSearching = false;
      _searchQuery.clear();
    });
  }
  /// Called when the state (day / night) has changed.
  void onStateChanged(bool isDarkModeEnabled) {
    setState(() {
      this.isDarkModeEnabled = isDarkModeEnabled;
    });
  }

  List<ChildItem> _buildList() {
    return _list.map((contact) => ChildItem(contact)).toList();
  }

  List<ChildItem> _buildSearchList() {
    if (_searchText.isEmpty) {
      return _list.map((contact) =>  ChildItem(contact))
          .toList();
    }
    else {

      for (int i = 0; i < _list.length; i++) {
        String  name = _list.elementAt(i);
        if (name.toLowerCase().contains(_searchText.toLowerCase())) {
          _searchList.add(name);
        }
      }
      return _searchList.map((contact) => ChildItem(contact))
          .toList();
    }
  }
  Widget searchTextField()  {
    setState(() {
      if (actionIcon.icon == Icons.search) {
        appBarTitle = TextField(
          controller: _searchQuery,
          style: TextStyle(
            color: CustomColors.firebaseBackground,
          ),
          decoration:  InputDecoration(
              prefixIcon: Icon(Icons.search, color:CustomColors.firebaseBackground,),
              hintText: "Search...",
              hintStyle: TextStyle(color: CustomColors.firebaseBackground)
          ),
        );
      }
      else {
        _handleSearchEnd();
      }
    });
    return appBarTitle;
  }
  Widget homeTextHeader()  {
    actionIcon = Icon(Icons.search, color: CustomColors.firebaseBackground,);
    appBarTitle = Text("Mfunzi Home",style: TextStyle(
      color: CustomColors.firebaseBackground));
    return appBarTitle;
  }

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(_handleTabSelection);
    _handleSearchStart();
    _handleSearchEnd();
    _loadData();
    init();
    super.initState();
  }
  void init() async {
    _list.add("Google");
    _list.add("IOS");
    _list.add("Andorid");
    _list.add("Dart");
    _list.add("Flutter");
    _list.add("Python");
    _list.add("React");
    _list.add("Xamarin");
    _list.add("Kotlin");
    _list.add("Java");
    _list.add("RxAndroid");
  }
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(color: Color(0xFF253341)),
        scaffoldBackgroundColor: const Color(0xFF15202B),
      ),
      themeMode: isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light,
      home: DefaultTabController(
          length: 3,
          child: Scaffold(
          drawer: Drawer(
            child: MFHomeDrawerComponent(),
          ),
          appBar: AppBar(
            backgroundColor: CustomColors.firebaseNavy,
            title: _isSearching ? searchTextField(): homeTextHeader(),
            actions: <Widget>[
              !_isSearching?
              IconButton(
                  icon:Image.asset('assets/icon/icons/ic_Search.png',width: 20,height: 20,color: CustomColors.firebaseBackground,),
                  onPressed: () => _handleSearchStart()):IconButton(
                  icon:Image.asset('assets/icon/icons/ic_CloseSquare.png',width: 20,height: 20,color: CustomColors.firebaseBackground,),
                  onPressed: () => _handleSearchEnd()),
            ],
            bottom:TabBar(
              indicatorColor: CustomColors.firebaseOrange,
              tabs: [
                Tab(icon: Image.asset('assets/icon/icons/ic_Home.png',width: 22,height: 22,
                color: CustomColors.firebaseBackground,)),
                Tab(icon: Image.asset('assets/icon/icons/ic_Forum.png',width: 22,height: 22,
                  color: CustomColors.firebaseBackground,)),
                Tab(icon: Image.asset('assets/icon/icons/ic_Gender.png',width: 22,height: 22,
                  color: CustomColors.firebaseBackground,)),
                ],
              ),
           ),
          body:TabBarView(
            children: [
              MFCardFeatures(email: _email,id: _id,),
              Text("Hello"),
              Text("Hello"),
              // FirstScreen(),
              // SecondScreen(),
              ],
            )
          )
        )
     );
  }
}
class ChildItem extends StatelessWidget {
  final String name;
  ChildItem(this.name);
  @override
  Widget build(BuildContext context) {
    return new ListTile(title: new Text(this.name));
  }

}