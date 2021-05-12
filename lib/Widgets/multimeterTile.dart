import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';

class MultimeterTile extends StatefulWidget {
  String channelName;
  bool isTurnedOn = false;
  double fieldValue = 0;
  final String unit;
  var valueM = NumberFormat("00.000", "en-US");
  MultimeterTile(this.channelName, this.unit);

  @override
  _MultimeterTileState createState() => _MultimeterTileState();
}

class _MultimeterTileState extends State<MultimeterTile> {
  double borderWidth = 1.2;
  double value = 0.0;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 373,
        height: 205,
        decoration: BoxDecoration(
            border: Border.all(
                color: Color.fromARGB(255, 52, 152, 219), width: borderWidth),
            borderRadius: BorderRadius.all(Radius.circular(24))),
        margin: EdgeInsets.only(top: 15),
        child: Column(children: [
          Container(
              margin: EdgeInsets.only(left: 15, right: 10, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.channelName,
                    style: TextStyle(
                        color: Color.fromARGB(255, 34, 99, 142),
                        fontFamily: 'Ropa Sans',
                        fontSize: 25),
                  ),
                  FlutterSwitch(
                    duration: Duration(milliseconds: 200),
                    activeColor: Color.fromARGB(255, 52, 152, 219),
                    width: 50,
                    height: 30,
                    value: widget.isTurnedOn,
                    onToggle: (value) {
                      setState(() {
                        widget.isTurnedOn = value;
                      });
                    },
                  ),
                ],
              )),
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                    width: 1, color: Color.fromARGB(255, 151, 151, 151)),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            width: 274,
            height: 100,
            margin: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 50),
                  child: Text(widget.valueM.format(widget.fieldValue),
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Digital-7',
                          fontSize: 50)),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, top: 12, right: 20),
                  child: Text(
                    widget.unit,
                    style: TextStyle(
                        color: Colors.grey[850],
                        fontFamily: 'Ropa Sans',
                        fontSize: 40),
                  ),
                )
              ],
            ),
          )
        ]));
  }
}
