import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:holding_gesture/holding_gesture.dart';
import 'package:candle_pocketlab/Settings/settings.dart';

enum powerSource { source1, source2, source3, source4 }

class PowerSourceTile extends StatefulWidget {
  final String sourceNamePS;
  final double ratingPS;
  final bool plusMinus;
  bool _isTurnedOn = false;
  var _valueFormat = NumberFormat("#0.00#", "en-US");
  double _value = 0.0;

  PowerSourceTile(this.sourceNamePS, this.ratingPS, this.plusMinus);

  @override
  _PowerSourceTileState createState() => _PowerSourceTileState();
}

class _PowerSourceTileState extends State<PowerSourceTile> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new Container(
        width: SizeConfig.blockSizeHorizontal * 44,
        height: SizeConfig.blockSizeVertical * 24.3,
        decoration: BoxDecoration(
            border: Border.all(
                color: Color.fromARGB(255, 52, 152, 199), width: 1.2),
            borderRadius: BorderRadius.all(Radius.circular(22))),
        child: new Column(
          children: [
            new Container(
                margin: EdgeInsets.only(left: 15, right: 10, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.sourceNamePS,
                      style: TextStyle(
                          color: Color.fromARGB(255, 34, 99, 142),
                          fontFamily: 'Ropa Sans',
                          fontSize: 25),
                    ),
                    FlutterSwitch(
                      activeColor: Color.fromARGB(255, 52, 152, 219),
                      width: 43,
                      height: 27,
                      value: widget._isTurnedOn,
                      onToggle: (value) {
                        setState(() {
                          widget._isTurnedOn = value;
                        });
                      },
                    ),
                  ],
                )),
            new Container(
              child: new Container(
                margin: EdgeInsets.only(top: 20, left: 10),
                child: new Row(
                  children: [
                    new Container(
                        width: SizeConfig.blockSizeHorizontal * 28,
                        height: SizeConfig.blockSizeVertical * 9,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(3))),
                        child: new Container(
                          margin: EdgeInsets.only(left: 3),
                          child: new Row(
                            children: [
                              Text(
                                widget._valueFormat.format(widget._value),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Digital-7',
                                  fontSize: 35,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              new Container(
                                margin: EdgeInsets.only(top: 2),
                                child: Text(
                                  "v",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Ropa Sans',
                                      fontSize: 35),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        )),
                    SizedBox(width: 10),
                    Column(
                      children: [
                        new Container(
                            width: SizeConfig.blockSizeHorizontal * 7.30,
                            height: SizeConfig.blockSizeVertical * 3.33,
                            child: HoldDetector(
                              onHold: upHoldCounter,
                              holdTimeout: Duration(milliseconds: 100),
                              child: new FloatingActionButton(
                                  heroTag: widget.sourceNamePS + "1",
                                  onPressed: upCounter,
                                  child: Image.asset('images/uparrow.png')),
                            )),
                        SizedBox(height: 5),
                        new Container(
                            width: SizeConfig.blockSizeHorizontal * 7.30,
                            height: SizeConfig.blockSizeVertical * 3.33,
                            child: HoldDetector(
                              onHold: downHoldCounter,
                              holdTimeout: Duration(milliseconds: 100),
                              child: new FloatingActionButton(
                                  heroTag: widget.sourceNamePS + "2",
                                  onPressed: downCounter,
                                  child: Image.asset('images/downarrow.png')),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
            LowerSectionPS(widget.plusMinus, widget.ratingPS)
          ],
        ));
  }

  void upCounter() {
    setState(() {
      if (widget._value <= widget.ratingPS) {
        widget._value = widget._value + 0.01;
      }
    });
  }

  void downCounter() {
    setState(() {
      if (widget.plusMinus) {
        if (widget._value > (0.10 - widget.ratingPS)) {
          widget._value = widget._value - 0.01;
        }
      } else if (widget._value > 0) {
        widget._value = widget._value - 0.01;
      } else if (widget._value < 0) {
        widget._value = 0;
      }
    });
  }

  void upHoldCounter() {
    setState(() {
      if (widget._value <= (widget.ratingPS - 0.10)) {
        widget._value = widget._value + 0.1;
      }
    });
  }

  void downHoldCounter() {
    setState(() {
      if (widget.plusMinus) {
        if (widget._value > (0.10 - widget.ratingPS)) {
          widget._value = widget._value - 0.1;
        }
      } else if (widget._value > 0) {
        widget._value = widget._value - 0.1;
      } else if (widget._value < 0) {
        widget._value = 0;
      }
    });
  }
}

class LowerSectionPS extends StatelessWidget {
  final bool isNegativeRated;
  final double rating;

  LowerSectionPS(this.isNegativeRated, this.rating);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 20, left: 80),
        child: Row(
          children: [
            isNegativeRated
                ? Container(
                    height: 24, width: 24, child: Image.asset('images/pm.png'))
                : Text(
                    "0 - ",
                    style: TextStyle(
                        color: Color.fromARGB(179, 0, 0, 0),
                        fontFamily: 'Ropa Sans',
                        fontSize: 31),
                  ),
            Text(
              "$rating" + "v",
              style: TextStyle(
                  color: Color.fromARGB(179, 0, 0, 0),
                  fontFamily: 'Ropa Sans',
                  fontSize: 31),
            )
          ],
        ));
  }
}
