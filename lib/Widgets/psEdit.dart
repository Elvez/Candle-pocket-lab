import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:holding_gesture/holding_gesture.dart';
import 'package:candle_pocketlab/Settings/settings.dart';
import 'package:candle_pocketlab/Device/connectScreen.dart';
import 'package:auto_size_text/auto_size_text.dart';

//Power source enumeration
enum powerSource { source1, source2, source3, source4 }

/*
 * Class name - PowerSourceTile
 * 
 * Usage - It is the power source tile widget.
 * 
 * @members : Source name, value area, up/down buttons, on/off switch. 
 */
class PowerSourceTile extends StatefulWidget {
  //Source name
  final String sourceNamePS;

  //Rating of the source
  final double ratingPS;

  //Is rating invertible
  final bool plusMinus;

  //Power source on/off state
  bool _isTurnedOn = false;

  //Value formatter (01.200v) -> (1.20v)
  var _valueFormat = NumberFormat("#0.00", "en-US");

  //Field value
  double _value = 0.0;

  //Source
  final int source;

  //Constructor
  PowerSourceTile(
      this.sourceNamePS, this.source, this.ratingPS, this.plusMinus);

  @override
  _PowerSourceTileState createState() => _PowerSourceTileState();

  /*
   * Get source name
   * 
   * Return the source name.
   * 
   * @params : none
   * @return : String 
   */
  String getSourceName() {
    return sourceNamePS;
  }

  /*
   * Get source number
   * 
   * Return the source number.
   * 
   * @params : none
   * @return : int 
   */
  int getSource() {
    return source;
  }

  /*
   * Get source rating
   * 
   * Return the source rating.
   * 
   * @params : none
   * @return : double 
   */
  double getRating() {
    return ratingPS;
  }

  /*
   * Get source Type
   * 
   * Return the source type, i.e. invertible or not.
   * 
   * @params : none
   * @return : bool 
   */
  bool getType() {
    return plusMinus;
  }

  /*
   * Get source state
   * 
   * Return the source state.
   * 
   * @params : none
   * @return : bool 
   */
  bool getState() {
    return _isTurnedOn;
  }

  /*
   * Get source value
   * 
   * Return the source value.
   * 
   * @params : none
   * @return : double 
   */
  double getValue() {
    return _value;
  }

  /*
   * Set source state
   * 
   * Sets the passed argument as source state. 
   * 
   * @params : State(bool)
   * @return : none 
   */
  void setState(bool state) {
    _isTurnedOn = state;
  }

  /*
   * Set source value
   * 
   * Sets the passed argument as the source value.
   * 
   * @params : none
   * @return : String 
   */
  void setValue(double value) {
    _value = value;
  }
}

class _PowerSourceTileState extends State<PowerSourceTile> {
  //Main tile border
  final _decoration = new BoxDecoration(
      border: Border.all(color: Color.fromARGB(255, 70, 70, 70), width: 3),
      borderRadius: BorderRadius.all(Radius.circular(22)));

  //Source name font
  final _sourceFont = new TextStyle(
      color: Color.fromARGB(255, 34, 99, 142),
      fontFamily: 'Ropa Sans',
      fontSize: 25);

  //Field area decoration
  final _valueDecoration = new BoxDecoration(
      border: Border.all(color: Colors.grey, width: 1),
      borderRadius: BorderRadius.all(Radius.circular(15)));

  //Value font
  final _valueFont = new TextStyle(
    color: Colors.black,
    fontFamily: 'Digital-7',
    fontSize: 35,
  );

  //Unit 'v'
  final _voltageUnit = new AutoSizeText(
    "v",
    style:
        TextStyle(color: Colors.black, fontFamily: 'Ropa Sans', fontSize: 35),
    textAlign: TextAlign.right,
  );

  //Up arrow image
  final _upArrow = new Image.asset('images/uparrow.png');

  //Down arrow image
  final _downArrow = new Image.asset('images/downarrow.png');

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new Container(
        width: SizeConfig.blockSizeHorizontal * 44,
        height: SizeConfig.blockSizeVertical * 24.3,
        decoration: _decoration,
        child: new Column(children: [
          new Container(
              margin: EdgeInsets.only(
                  left: SizeConfig.blockSizeVertical * 1.90,
                  right: SizeConfig.blockSizeVertical * 1.26,
                  top: SizeConfig.blockSizeVertical * 1.90),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.sourceNamePS, style: _sourceFont),
                  FlutterSwitch(
                    activeColor: Color.fromARGB(255, 52, 152, 219),
                    width: 43,
                    height: 27,
                    value: widget._isTurnedOn,
                    onToggle: (value) {
                      setState(() {
                        widget._isTurnedOn = value;
                      });
                      setPowerSource(value);
                    },
                  ),
                ],
              )),
          new Container(
              child: new Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.blockSizeVertical * 2.40,
                      left: SizeConfig.blockSizeVertical * 1.20),
                  child: new Row(children: [
                    new Container(
                        width: SizeConfig.blockSizeHorizontal * 28,
                        height: SizeConfig.blockSizeVertical * 9,
                        decoration: _valueDecoration,
                        child: new Container(
                            margin: EdgeInsets.only(left: 3),
                            child: new Row(children: [
                              AutoSizeText(
                                widget._valueFormat.format(widget._value),
                                style: _valueFont,
                                textAlign: TextAlign.right,
                              ),
                              new Container(
                                  margin: EdgeInsets.only(top: 2),
                                  child: _voltageUnit)
                            ]))),
                    SizedBox(width: 10),
                    Column(children: [
                      new Container(
                          width: SizeConfig.blockSizeHorizontal * 7.30,
                          height: SizeConfig.blockSizeVertical * 3.33,
                          child: HoldDetector(
                              onHold: upHoldCounter,
                              holdTimeout: Duration(milliseconds: 100),
                              child: new FloatingActionButton(
                                  heroTag: widget.sourceNamePS + "1",
                                  onPressed: upCounter,
                                  child: _upArrow))),
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
                                  child: _downArrow)))
                    ])
                  ]))),
          LowerSectionPS(widget.plusMinus, widget.ratingPS)
        ]));
  }

  /*
   * Send power source command
   * 
   * Sends the power source command to bluetooth device.
   * 
   * @params : State(bool)
   * @return : none 
   */
  void setPowerSource(value) {
    if (value) {
      candle.sendPSCommand(widget.source, "H",
          widget._valueFormat.format(widget._value).toString());
    } else {
      candle.sendPSCommand(widget.source, "L", widget._value.toString());
    }
  }

  /*
   * Upwards counter for up arrow button
   * 
   * Sets the value to  value + 0.01 on up arrow press.
   * 
   * @params : none
   * @return : none 
   */
  void upCounter() {
    setState(() {
      if (widget._value <= widget.ratingPS) {
        widget._value = widget._value + 0.01;
      }
    });
  }

  /*
   * Downwards counter for down arrow button
   * 
   * Sets the value to  value - 0.01 on down arrow press.
   * 
   * @params : none
   * @return : none 
   */
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

  /*
   * Upwards counter for down arrow button
   * 
   * Sets the value to  value + 0.1 on down arrow hold.
   * 
   * @params : none
   * @return : none 
   */
  void upHoldCounter() {
    setState(() {
      if (widget._value <= (widget.ratingPS - 0.10)) {
        widget._value = widget._value + 0.1;
      }
    });
  }

  /*
   * Downwards counter for down arrow button
   * 
   * Sets the value to  value - 0.1 on down arrow hold.
   * 
   * @params : none
   * @return : none 
   */
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

/*
 * Class name - LowerSectionPs
 * 
 * Usage - It is the lower section of the power source tile. 
 */
class LowerSectionPS extends StatelessWidget {
  //Is source invertible
  final bool isNegativeRated;

  //Rating
  final double rating;

  LowerSectionPS(this.isNegativeRated, this.rating);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10, left: 80),
        child: Row(
          children: [
            isNegativeRated
                ? Container(
                    height: 24, width: 24, child: Image.asset('images/pm.png'))
                : AutoSizeText(
                    "0 - ",
                    style: TextStyle(
                        color: Color.fromARGB(179, 0, 0, 0),
                        fontFamily: 'Ropa Sans',
                        fontSize: 31),
                  ),
            AutoSizeText(
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
