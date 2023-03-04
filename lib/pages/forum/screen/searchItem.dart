import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MFSearchitem extends StatefulWidget{
  final snap;
  const MFSearchitem({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  _MFSearchitemState createState() => _MFSearchitemState();

}
class _MFSearchitemState extends State<MFSearchitem>{


  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
              leading: Text(widget.snap["title"].toString()),
              title:Text(widget.snap["created_at"].toString()),
          ),
        ],
      ),
    );
  }

}
