import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:candle_pocketlab/Settings/settings.dart';
import 'package:candle_pocketlab/Device/deviceUSB.dart';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';

//Global Tiles
MultimeterTile channelTile1 = new MultimeterTile(1);
MultimeterTile channelTile2 = new MultimeterTile(2);

//Global switch states
bool isVoltmeterOn = false;
bool isAmmeterOn = false;

/*
 * Class name - MultimeterTile
 * 
 * Usage - Multimeter widget in the multimeter screen.
 * 
 * @members : Channel name, unit area, value area,  on/off switch. 
 */
class MultimeterTile extends StatefulWidget {
  //Tile on/off state
  bool isTurnedOn = false;

  //Value of the multimeter
  double fieldValue = 0;

  //Channel name
  final int channelNumber;

  //Value formater - (004.400v) -> (04.40V)
  var valueM = NumberFormat("##00.00", "en-US");

  //Constructor
  MultimeterTile(this.channelNumber);

  _MultimeterTileState createState() => _MultimeterTileState();

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
   * Turn Off tile
   * 
   * Turns tile switch off and sends stop command 
   * 
   * @params : none
   * @return : none
   */
  void turnOff() {
    isTurnedOn = false;
    if (channelNumber == 1) {
      candle.sendMulCommand(1, "L");
    } else {
      candle.sendMulCommand(2, "L");
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
                    new AutoSizeText("Channel ${widget.channelNumber}",
                        style: _channelNameStyle),

                    //On-off switch
                    new FlutterSwitch(
                        duration: Duration(milliseconds: 200),
                        activeColor: Color.fromARGB(255, 52, 152, 199),
                        width: SizeConfig.blockSizeVertical * 6.32,
                        height: SizeConfig.blockSizeVertical * 3.8,
                        value: widget.isTurnedOn,
                        onToggle: (value) {
                          //Set the switch state of tile
                          onSwitch(value);

                          //Process state
                          if (widget.isTurnedOn) {
                            //Receive values and update.
                            loopValues();
                          }

                          //Process state
                          if (!widget.isTurnedOn) {
                            //Dislplay zero on multimeter turned off.
                            setState(() {
                              widget.fieldValue = 0;
                            });
                          }
                        })
                  ])),

          //Multimeter value area
          new Container(
              decoration: _valueDecoration,
              width: SizeConfig.blockSizeHorizontal * 66.7,
              height: SizeConfig.blockSizeVertical * 12.2,
              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2.40),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Value
                    new Container(
                        margin: EdgeInsets.only(left: 30),
                        child: new AutoSizeText(
                            widget.valueM.format(widget.fieldValue),
                            style: _valueFont)),

                    //Unit
                    new Container(
                      margin: EdgeInsets.only(
                          left: SizeConfig.blockSizeVertical * 1.20,
                          top: SizeConfig.blockSizeVertical * 1.50,
                          right: SizeConfig.blockSizeVertical * 3.60),
                      child: new AutoSizeText(
                          widget.channelNumber == 1 ? "V" : "mA",
                          style: _unitFont),
                    )
                  ]))
        ]));
  }

  /*
   * Set multimeter state
   * 
   * Call on button pressed
   * 
   * @params : none
   * @return : none 
   */
  void onSwitch(bool value) {
    //Set initial states
    setState(() {
      widget.isTurnedOn = value;

      if (widget.channelNumber == 1) {
        isVoltmeterOn = value;
      } else {
        isAmmeterOn = value;
      }
    });

    //Change state only if all tiles are IDLE
    if (widget.channelNumber == 1) {
      if (isAmmeterOn) {
        setState(() {
          widget.isTurnedOn = false;
          isVoltmeterOn = false;
        });
      } else {
        switchVoltmeter(widget.isTurnedOn);
      }
    } else if (widget.channelNumber == 2) {
      if (isVoltmeterOn) {
        setState(() {
          widget.isTurnedOn = false;
          isAmmeterOn = false;
        });
      } else {
        switchAmmeter(widget.isTurnedOn);
      }
    }
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

    if (candle.isDeviceConnected() && widget.isTurnedOn) {
      candle.port.inputStream.listen((Uint8List data) {
        //Decode bytes to string
        _packet = ascii.decode(data);

        //Remove tail : Packet received = 1000!, After tail remove = 1000
        _packet = _packet.substring(0, _packet.length - 1);

        //Parse and convert to voltage, MinValue = 0, MaxValue = 4096 | ResultMin = -20.0, ResultMax = 20.0
        _value = double.tryParse(_packet);
        if (_value != null) {
          _value = (_value / 102.4) - 20.0;
        }

        //Loop values
        if (mounted && widget.isTurnedOn) {
          setState(() {
            widget.fieldValue = _value;
          });
        }
      });
    }
  }

  /*
   * Switch on/off voltmeter
   * 
   * Sends on/off command for channel 1.
   * 
   * @params : State(Bool)
   * @return : none 
   */
  void switchVoltmeter(bool state) {
    state ? candle.sendMulCommand(1, "H") : candle.sendMulCommand(1, "L");
  }

  /*
   * Switch on/off ammeter
   * 
   * Sends on/off command for channel 2.
   * 
   * @params : State(Bool)
   * @return : none 
   */
  void switchAmmeter(bool state) {
    state ? candle.sendMulCommand(2, "H") : candle.sendMulCommand(2, "L");
  }
}
