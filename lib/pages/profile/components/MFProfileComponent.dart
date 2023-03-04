import 'package:flutter/material.dart';
import 'package:mfunzi/res/custom_colors.dart';

class InfoCard extends StatefulWidget{

  // the values we need
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const InfoCard({Key?key, required this.text, required this.icon,required this.onTap,required this.color}) : super(key: key);

  @override
  InfoCardState createState() => InfoCardState();
}
class InfoCardState extends State<InfoCard>{
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: widget.color,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          child: ListTile(
            leading: Icon(
              widget.icon,
              color: CustomColors.firebaseBackground,
            ),
            title: Text(
              widget.text,
              style: TextStyle(
                  color: CustomColors.firebaseBackground,
                  fontSize: 15),
            ),
          ),
        )
      ],
    );
  }
}