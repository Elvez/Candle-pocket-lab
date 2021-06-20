import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:candle_pocketlab/Settings/settings.dart';
import 'package:candle_pocketlab/Device/connectScreen.dart';

/*
 * Class name - MultimeterTile
 * 
 * Usage - Multimeter widget in the multimeter screen.
 * 
 * @members : Channel name, unit area, value area,  on/off switch. 
 */
class MultimeterTile extends StatefulWidget {
  //Channel name
  String channelName;

  //Tile on/off state
  bool isTurnedOn = false;

  //Value of the multimeter
  double fieldValue = 0;

  //Unit
  final String unit;

  //Value formater - (004.400v) -> (04.40V)
  var valueM = NumberFormat("##00.00", "en-US");

  //Constructor
  MultimeterTile(this.channelName, this.unit);

  _MultimeterTileState createState() => _MultimeterTileState();

  /*
   * Get channel name
   * 
   * Returns the channel name.
   * 
   * @params : none
   * @return : String 
   */
  String getChannelName() {
    return channelName;
  }

  /*
   * Get channel state
   * 
   * Returns the channel state.
   * 
   * @params : none
   * @return : Bool 
   */
  bool getState() {
    return isTurnedOn;
  }

  /*
   * Get channel field value
   * 
   * Returns the channel field value.
   * 
   * @params : none
   * @return : double
   */
  double getFieldVal() {
    return fieldValue;
  }

  /*
   * Get tile unit
   * 
   * Returns the Unit of the tile
   * 
   * @params : none
   * @return : String 
   */
  String getUnit() {
    return unit;
  }

  /*
   * Set channel name
   * 
   * Sets passed argument as the channel name.
   * 
   * @params : Name(String)
   * @return : none 
   */
  void setChannelName(String name) {
    channelName = name;
  }

  /*
   * Set channel state
   * 
   * Sets passed argument as the channel state.
   * 
   * @params : State(bool)
   * @return : none 
   */
  void setState(bool state) {
    isTurnedOn = state;
  }
}

class _MultimeterTileState extends State<MultimeterTile> {
  //Border width, increase it if you want it to look uglier.
  static double borderWidth = 3;

  //Field value.
  double value = 0.0;

  //Tile border decoration
  final _decoration = new BoxDecoration(
      border: Border.all(
          color: Color.fromARGB(255, 80, 80, 80), width: borderWidth),
      borderRadius: BorderRadius.all(Radius.circular(24)));

  //Value field decoration
  final _valueDecoration = new BoxDecoration(
      border: Border.all(width: 1, color: Color.fromARGB(255, 151, 151, 151)),
      borderRadius: BorderRadius.all(Radius.circular(5)));

  //Channel name font
  final _channelNameStyle = new TextStyle(
      color: Color.fromARGB(255, 34, 99, 142),
      fontFamily: 'Ropa Sans',
      fontSize: 25);

  //Value area font
  final _valueFont =
      new TextStyle(color: Colors.black, fontFamily: 'Digital-7', fontSize: 50);

  //Unit font
  final _unitFont = new TextStyle(
      color: Colors.grey[850], fontFamily: 'Ropa Sans', fontSize: 40);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
        width: SizeConfig.blockSizeHorizontal * 92.2,
        height: SizeConfig.blockSizeVertical * 27.1,
        decoration: _decoration,
        margin: EdgeInsets.only(top: 15),
        child: Column(children: [
          Container(
              margin: EdgeInsets.only(left: 15, right: 10, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.channelName, style: _channelNameStyle),
                  FlutterSwitch(
                    duration: Duration(milliseconds: 200),
                    activeColor: Color.fromARGB(255, 52, 152, 199),
                    width: 50,
                    height: 30,
                    value: widget.isTurnedOn,
                    onToggle: (value) {
                      setState(() {
                        widget.isTurnedOn = value;
                      });
                      setMultimeter(value);
                    },
                  ),
                ],
              )),
          Container(
              decoration: _valueDecoration,
              width: SizeConfig.blockSizeHorizontal * 66.7,
              height: SizeConfig.blockSizeVertical * 12.2,
              margin: EdgeInsets.only(top: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 50),
                        child: Text(widget.valueM.format(widget.fieldValue),
                            style: _valueFont)),
                    Container(
                      margin: EdgeInsets.only(left: 10, top: 12, right: 20),
                      child: Text(widget.unit, style: _unitFont),
                    )
                  ]))
        ]));
  }

  /*
   * Loop values in the value area
   * 
   * Loops the values received from candle device onto the Value area.
   * 
   * @params : none
   * @return : none 
   */
  Future<void> loopValues() async {
    while (widget.isTurnedOn) {
      setState(() {
        //getVal and assign value.
      });
      await Future.delayed(Duration(milliseconds: 17));
    }
  }

  /*
   * Send multimeter command
   * 
   * Sends the multimeter command to bluetooth device.
   * 
   * @params : State(bool)
   * @return : none 
   */
  void setMultimeter(bool state) {
    if (state) {
      if (widget.channelName == "Channel 1") {
        candle.sendMulCommand(1, "H");
      } else if (widget.channelName == "Channel 2") {
        candle.sendMulCommand(2, "H");
      }
    } else {
      if (widget.channelName == "Channel 1") {
        candle.sendMulCommand(1, "L");
      } else if (widget.channelName == "Channel 2") {
        candle.sendMulCommand(2, "L");
      }
    }
  }
}
