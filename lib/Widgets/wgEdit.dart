import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:candle_pocketlab/Settings/settings.dart';

class WaveGeneratorTile extends StatefulWidget {
  final String sourceName;
  bool isTurnedOn = false;
  int _value = 0;
  WaveGeneratorTile(this.sourceName);

  @override
  _WaveGeneratorTileState createState() => _WaveGeneratorTileState();
}

class _WaveGeneratorTileState extends State<WaveGeneratorTile> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new Container(
        width: SizeConfig.blockSizeHorizontal * 92.2,
        height: SizeConfig.blockSizeVertical * 27.1,
        decoration: BoxDecoration(
            border: Border.all(
                color: Color.fromARGB(255, 52, 152, 219), width: 1.2),
            borderRadius: BorderRadius.all(Radius.circular(24))),
        margin: EdgeInsets.only(top: 15),
        child: new Column(
          children: [
            new Container(
                margin: EdgeInsets.only(left: 15, right: 10, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.sourceName,
                      style: TextStyle(
                          color: Color.fromARGB(255, 34, 99, 142),
                          fontFamily: 'Ropa Sans',
                          fontSize: 25),
                    ),
                    new FlutterSwitch(
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
            new Container(
                margin: EdgeInsets.only(left: 10, top: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text("Wave:",
                        style: TextStyle(
                            fontFamily: 'Ropa Sans',
                            fontSize: 25,
                            color: Color.fromARGB(255, 74, 74, 74))),
                    SizedBox(width: 60),
                    Container(
                        child: Row(
                      children: <Widget>[
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                widget._value = 0;
                              });
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              color: widget._value == 0
                                  ? Color.fromARGB(100, 52, 152, 219)
                                  : Colors.white,
                              child: Image.asset('images/sineWave.png'),
                            )),
                        SizedBox(width: 10),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                widget._value = 1;
                              });
                            },
                            child: Container(
                                height: 50,
                                width: 50,
                                color: widget._value == 1
                                    ? Color.fromARGB(100, 52, 152, 219)
                                    : Colors.white,
                                child: Image.asset('images/sqWave.png'))),
                        SizedBox(width: 10),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                widget._value = 2;
                              });
                            },
                            child: Container(
                                height: 50,
                                width: 50,
                                color: widget._value == 2
                                    ? Color.fromARGB(100, 52, 152, 219)
                                    : Colors.white,
                                child: Image.asset('images/triang.png')))
                      ],
                    ))
                  ],
                )),
            new Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    SizedBox(width: 20),
                    Text("Period:",
                        style: TextStyle(
                            fontFamily: 'Ropa Sans',
                            fontSize: 25,
                            color: Color.fromARGB(255, 74, 74, 74))),
                    SizedBox(width: 25),
                    Container(
                      child: Container(
                          width: 132,
                          height: 31,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              border: Border.all(color: Colors.grey, width: 1)),
                          margin: EdgeInsets.only(left: 47),
                          child: TextFormField(
                              decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "0.000 ms.",
                            contentPadding: EdgeInsets.only(top: 2, left: 2),
                          ))),
                    )
                  ],
                )),
            new SizedBox(height: 8),
            new Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    SizedBox(width: 20),
                    Text("Amplitude:",
                        style: TextStyle(
                            fontFamily: 'Ropa Sans',
                            fontSize: 25,
                            color: Color.fromARGB(255, 74, 74, 74))),
                    SizedBox(width: 25),
                    Container(
                      child: Container(
                          width: 132,
                          height: 31,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              border: Border.all(color: Colors.grey, width: 1)),
                          margin: EdgeInsets.only(left: 10),
                          child: TextFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "0.000 v.",
                                  contentPadding:
                                      EdgeInsets.only(top: 2, left: 2)))),
                    )
                  ],
                ))
          ],
        ));
  }
}
