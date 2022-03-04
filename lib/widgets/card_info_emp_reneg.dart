import 'package:flutter/material.dart';

class CardInfo extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;

  const CardInfo({
    Key key,
    @required this.title,
    @required this.icon,
    @required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40.0, left: 20.0),
      child: Row(
        children: [
          Container(
            height: 45.0,
            width: 45.0,
            decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: BorderRadius.all(Radius.circular(60.0))),
            child: Icon(
              icon,
              size: 25.0,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Text(
              "$title",
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            ),
          ),
          SizedBox(
            width: 25.0,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(right: 20),
              child: Text(
                "$value",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
