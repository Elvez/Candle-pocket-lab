import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:candle_pocketlab/Settings/settings.dart';
import 'package:candle_pocketlab/Device/connectScreen.dart';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';

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
    //Set state to default
    isTurnedOn = state;

    if (isTurnedOn) {
      //Send 'Multimeter state = on' command for current channel.
      channelName == "Channel 1"
          ? candle.sendMulCommand(1, "H")
          : candle.sendMulCommand(2, "H");
    } else {
      //Send 'Multimeter state = off' command for current channel.
      channelName == "Channel 1"
          ? candle.sendMulCommand(1, "L")
          : candle.sendMulCommand(2, "L");
    }
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
      border: Border.all(width: 3, color: Color.fromARGB(255, 151, 151, 151)),
      borderRadius: BorderRadius.all(Radius.circular(24)));

  //Channel name font
  final _channelNameStyle = new TextStyle(
      color: Color.fromARGB(255, 34, 99, 142),
      fontFamily: 'Ropa Sans',
      fontSize: 25);

  //Value area font
  final _valueFont = new TextStyle(
      color: Colors.grey[800], fontFamily: 'Digital-7', fontSize: 60);

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
        margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1.90),
        child: Column(children: [
          Container(
              margin: EdgeInsets.only(
                  left: SizeConfig.blockSizeVertical * 1.90,
                  right: SizeConfig.blockSizeVertical * 1.20,
                  top: SizeConfig.blockSizeVertical * 1.90),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new AutoSizeText(widget.channelName,
                      style: _channelNameStyle),
                  FlutterSwitch(
                    duration: Duration(milliseconds: 200),
                    activeColor: Color.fromARGB(255, 52, 152, 199),
                    width: SizeConfig.blockSizeVertical * 6.32,
                    height: SizeConfig.blockSizeVertical * 3.8,
                    value: widget.isTurnedOn,
                    onToggle: (value) {
                      //Set the switch state of tile
                      setState(() {
                        widget.isTurnedOn = value;
                      });

                      //Set multimeter state on device.
                      setMultimeter(value);

                      //Process state
                      if (!widget.isTurnedOn) {
                        //Dislplay zero on multimeter turned off.
                        setState(() {
                          widget.fieldValue = 0;
                        });
                      } else {
                        //Receive values and update.
                        loopValues();
                      }
                    },
                  ),
                ],
              )),
          Container(
              decoration: _valueDecoration,
              width: SizeConfig.blockSizeHorizontal * 66.7,
              height: SizeConfig.blockSizeVertical * 12.2,
              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2.40),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 18),
                        child: new AutoSizeText(
                            widget.valueM.format(widget.fieldValue),
                            style: _valueFont)),
                    Container(
                      margin: EdgeInsets.only(
                          left: SizeConfig.blockSizeVertical * 1.20,
                          top: SizeConfig.blockSizeVertical * 1.50,
                          right: SizeConfig.blockSizeVertical * 3.60),
                      child: new AutoSizeText(widget.unit, style: _unitFont),
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
    //Packet receive buffer
    String _packet = "";

    //Parse value for voltmeter
    double _value = 0;

    // try {
    //   //Start listening
    //   candle.connection.input.listen((event) {
    //     //Decode bytes to string data
    //     _packet = ascii.decode(event);

    //     //Remove packet tail and parse to double
    //     _packet = _packet.substring(0, _packet.length - 1);
    //     _value = double.tryParse(_packet);

    //     //Calculation MinVal = 0, MaxVal = 4096, Min result val = -20, Max result val = +20.
    //     _value = (_value / 102.4) - 20.0;
    //     setState(() {
    //       //Display value.
    //       widget.fieldValue = _value;
    //       if (!widget.isTurnedOn) widget.fieldValue = 0;
    //     });
    //   });
    // } catch (e) {
    //   print(e);
    // }
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
        //Send multimeter 'channel 1 = on'.
        candle.sendMulCommand(1, "H");
      } else if (widget.channelName == "Channel 2") {
        //Send multimeter 'channel 2 = on'.
        candle.sendMulCommand(2, "H");
      }
    } else {
      if (widget.channelName == "Channel 1") {
        //Send multimeter 'channel 1 = off'.
        candle.sendMulCommand(1, "L");
      } else if (widget.channelName == "Channel 2") {
        //Send multimeter 'channel 2 = off'.
        candle.sendMulCommand(2, "L");
      }
    }
  }
}
