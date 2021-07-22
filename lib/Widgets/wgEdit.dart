import 'package:flutter/material.dart';
import 'package:candle_pocketlab/Device/connectScreen.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:candle_pocketlab/Settings/settings.dart';
import 'package:flutter/services.dart';
import 'package:auto_size_text/auto_size_text.dart';

/*
 * Class name - WaveGeneratorTile
 * 
 * Usage - It is the tile widget on the wave generator screen. 
 */
class WaveGeneratorTile extends StatefulWidget {
  //Source name
  final String sourceName;

  //On/off state
  bool isTurnedOn = false;

  //Source number
  final int source;

  //Text editing controller for period field
  final _periodController = new TextEditingController(text: "200");

  //Text editing controller for amplitude field
  final _amplitudeController = new TextEditingController(text: "3.30");

  //Wave type toggle
  List<bool> _waveType = [true, false, false];

  //Constructor
  WaveGeneratorTile(this.sourceName, this.source);

  @override
  _WaveGeneratorTileState createState() => _WaveGeneratorTileState();

  /*
   * Get source name
   * 
   * Returns the source name.
   * 
   * @params : none
   * @return : String 
   */
  String getSourceName() {
    return sourceName;
  }

  /*
   * Get source number
   * 
   * Returns the source number.
   * 
   * @params : none
   * @return : int 
   */
  int getSource() {
    return source;
  }

  /*
   * Get source state
   * 
   * Returns the source state.
   * 
   * @params : none
   * @return : bool 
   */
  bool getState() {
    return isTurnedOn;
  }

  /*
   * Get period value
   * 
   * Returns the period value.
   * 
   * @params : none
   * @return : double 
   */
  double getPeriod() {
    return double.tryParse(_periodController.text);
  }

  /*
   * Get amplitude value
   * 
   * Returns the amplitude value.
   * 
   * @params : none
   * @return : double 
   */
  double getAmplitude() {
    return double.tryParse(_amplitudeController.text);
  }

  /*
   * Get Wave type
   * 
   * Returns the wave type. 
   *  Sine - 1
   *  Square - 2
   *  Triangle - 3
   * 
   * @params : none
   * @return : int 
   */
  int getWave() {
    if (_waveType[0]) {
      return 1;
    }
    if (_waveType[1]) {
      return 2;
    }
    if (_waveType[2]) {
      return 3;
    }

    return null;
  }

  /*
   * Remotely send command to turn off wave-generator
   * 
   * Sends Turn-off wave-generator command to device
   * 
   * @params : none
   * @return : none 
   */
  void stopWG() {
    candle.sendWGCommand(source, 'L', 1, "0", "0");
  }
}

class _WaveGeneratorTileState extends State<WaveGeneratorTile> {
  //Main tile border
  final _decoration = new BoxDecoration(
      border: Border.all(color: Color.fromARGB(255, 80, 80, 80), width: 3),
      borderRadius: BorderRadius.all(Radius.circular(24)));

  //Text field border
  final _fieldDecoration = new BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      border: Border.all(color: Colors.grey, width: 1));

  //Source name font
  final _sourceFont = new TextStyle(
      color: Color.fromARGB(255, 34, 99, 142),
      fontFamily: 'Ropa Sans',
      fontSize: 25);

  //Wave text
  final _waveText = new AutoSizeText("Wave:",
      style: TextStyle(
          fontFamily: 'Ropa Sans',
          fontSize: 25,
          color: Color.fromARGB(255, 74, 74, 74)));

  //Period text
  final _periodText = new AutoSizeText("Period:",
      style: TextStyle(
          fontFamily: 'Ropa Sans',
          fontSize: 25,
          color: Color.fromARGB(255, 74, 74, 74)));

  //Amplitude text
  final _amplitudeText = new AutoSizeText("Amplitude:",
      style: TextStyle(
          fontFamily: 'Ropa Sans',
          fontSize: 25,
          color: Color.fromARGB(255, 74, 74, 74)));

  //Sine wave imagee
  final _sinImage = new Padding(
      padding: const EdgeInsets.all(0),
      child: Image.asset('images/sineWave.png'));

  //Square wave image
  final _sqImage = new Padding(
      padding: const EdgeInsets.all(1.5),
      child: Image.asset('images/sqWave.png'));

  //Triangle wave image
  final _triangImage = new Padding(
      padding: const EdgeInsets.all(0),
      child: Image.asset('images/triang.png'));

  //Is input data valid
  bool _validPeriod = true;
  bool _validAmp = true;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new Container(
        width: SizeConfig.blockSizeHorizontal * 92.2,
        height: SizeConfig.blockSizeVertical * 30,
        decoration: _decoration,
        margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1.90),
        child: new Column(children: [
          new Container(
              margin: EdgeInsets.only(
                  left: SizeConfig.blockSizeVertical * 1.90,
                  right: SizeConfig.blockSizeVertical * 1.20,
                  top: SizeConfig.blockSizeVertical * 1.90),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new AutoSizeText(widget.sourceName, style: _sourceFont),

                    //On/Off switch
                    new FlutterSwitch(
                        activeColor: Color.fromARGB(150, 52, 152, 199),
                        width: SizeConfig.blockSizeHorizontal * 12.75,
                        height: SizeConfig.blockSizeVertical * 3.79,
                        value: widget.isTurnedOn,
                        onToggle: (value) {
                          setState(() {
                            widget.isTurnedOn = value;
                          });

                          //Send wave generator command
                          if (_validPeriod && _validAmp) {
                            setWaveGenerator(widget.isTurnedOn);
                          } else {
                            setState(() {
                              widget.isTurnedOn = false;
                            });
                          }
                        })
                  ])),

          //Select Wave-type Row
          new Container(
              margin: EdgeInsets.only(left: 10, top: 10),
              child: Row(children: [
                SizedBox(
                  width: 10,
                ),
                _waveText,
                SizedBox(width: SizeConfig.blockSizeVertical * 8.85),
                Container(
                  width: SizeConfig.blockSizeVertical * 25.28,
                  height: SizeConfig.blockSizeVertical * 5.05,
                  child: ToggleButtons(
                      borderColor: Colors.grey,
                      fillColor: Colors.white,
                      borderWidth: 2,
                      selectedBorderColor: Color.fromARGB(250, 52, 152, 199),
                      borderRadius: BorderRadius.circular(4),
                      children: [_sinImage, _sqImage, _triangImage],
                      onPressed: (int newIndex) {
                        setState(() {
                          toggleWaveType(newIndex);
                        });

                        //Send wave-generator command
                        if (_validAmp && _validPeriod)
                          setWaveGenerator(widget.isTurnedOn);
                      },
                      isSelected: widget._waveType),
                )
              ])),

          //Enter period row
          new Container(
              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1.90),
              child: Row(children: [
                SizedBox(width: SizeConfig.blockSizeVertical * 2.40),
                _periodText,
                SizedBox(width: SizeConfig.blockSizeVertical * 3.16),
                Container(
                    child: Container(
                        width: SizeConfig.blockSizeVertical * 16.7,
                        height: SizeConfig.blockSizeVertical * 3.92,
                        decoration: _fieldDecoration,
                        margin: EdgeInsets.only(
                            left: SizeConfig.blockSizeVertical * 5.94),
                        child: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d*')),
                              LengthLimitingTextInputFormatter(4)
                            ],

                            //Input validation
                            autovalidate: true,
                            validator: validatePeriod,
                            onEditingComplete: () {
                              //Send wave-generator command
                              if (_validAmp && _validPeriod)
                                setWaveGenerator(widget.isTurnedOn);
                            },
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.number,
                            controller: widget._periodController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding:
                                    EdgeInsets.only(top: 2, right: 5))))),
                SizedBox(width: 5),
                AutoSizeText("ms",
                    style: TextStyle(
                        fontFamily: 'Ropa Sans',
                        fontSize: 20,
                        color: Colors.grey[700]))
              ])),

          new SizedBox(height: SizeConfig.blockSizeVertical * 1.0),

          //Enter amplitude row
          new Container(
              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1.20),
              child: Row(children: [
                SizedBox(width: SizeConfig.blockSizeVertical * 2.40),
                _amplitudeText,
                SizedBox(width: SizeConfig.blockSizeVertical * 2.60),
                Container(
                    child: Container(
                        width: SizeConfig.blockSizeVertical * 16.7,
                        height: SizeConfig.blockSizeVertical * 3.92,
                        decoration: _fieldDecoration,
                        margin: EdgeInsets.only(
                            left: SizeConfig.blockSizeVertical * 1.90),
                        child: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d*')),
                              LengthLimitingTextInputFormatter(4)
                            ],
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.number,
                            controller: widget._amplitudeController,

                            //Input validation
                            autovalidate: true,
                            onEditingComplete: () {
                              //Send wave-generator command
                              if (_validAmp && _validPeriod)
                                setWaveGenerator(widget.isTurnedOn);
                            },
                            validator: validateAmp,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding:
                                    EdgeInsets.only(top: 2, right: 5))))),
                SizedBox(width: 5),
                AutoSizeText("V",
                    style: TextStyle(
                        fontFamily: 'Ropa Sans',
                        fontSize: 20,
                        color: Colors.grey[700]))
              ]))
        ]));
  }

  /*
   * Toggle wave type
   * 
   * Toggles between wave types on press.
   * 
   * @params : index(int)
   * @return : none 
   */
  void toggleWaveType(int newIndex) {
    for (int index = 0; index < widget._waveType.length; index++) {
      if (index == newIndex) {
        widget._waveType[index] = true;
      } else {
        widget._waveType[index] = false;
      }
    }
  }

  /*
   * Period input validator
   * 
   * Validates the period input.
   * 
   * 
   * @params : Input(String)
   * @return : String(Error) 
   */
  String validatePeriod(String value) {
    if (value.isEmpty || value == null) {
      //Value should not be empty
      _validPeriod = false;

      return "Enter period.";
    } else if (double.tryParse(value) > 3000) {
      //Out of range
      _validPeriod = false;

      return "Out of range!";
    } else if (double.tryParse(value) <= 0) {
      //Cannot be negative
      _validPeriod = false;

      return "Out of range!";
    } else if (value.endsWith('.')) {
      //Invalid number
      _validPeriod = false;

      return "Invalid";
    } else {
      //Valid input
      _validPeriod = true;

      return null;
    }
  }

  /*
   * Amplitude input validator
   * 
   * Validates the amplitude input.
   * 
   * 
   * @params : Input(String)
   * @return : String(Error) 
   */
  String validateAmp(String value) {
    if (value.isEmpty || value == null) {
      //Cannot be empty
      _validAmp = false;

      return "Enter amplitude.";
    } else if (double.tryParse(value) > 3.3) {
      //Out of range
      _validAmp = false;

      return "Out of range!";
    } else if (double.tryParse(value) <= 0) {
      //Out of range
      _validAmp = false;

      return "Out of range!";
    } else if (value.endsWith('.')) {
      //Invalid input
      _validAmp = false;

      return "Invalid";
    } else {
      //Valid input
      _validAmp = true;

      return null;
    }
  }

  /*
   * Send wave generator command
   * 
   * Sends the wave generator command to the bluetooth device.
   * 
   * @params : State(bool)
   * @return : none 
   */
  void setWaveGenerator(bool state) {
    //Proceed if device is connected
    if (state && candle.isDeviceConnected()) {
      if (widget.source == 1) {
        //Send command with source 1 and state High
        candle.sendWGCommand(1, "H", widget.getWave(),
            widget._periodController.text, widget._amplitudeController.text);
      } else if (widget.source == 2) {
        //Send command with source 2 and state High
        candle.sendWGCommand(2, "H", widget.getWave(),
            widget._periodController.text, widget._amplitudeController.text);
      }
    } else {
      if (widget.source == 1) {
        //Send command with source 1 and state Low
        candle.sendWGCommand(1, "L", widget.getWave(),
            widget._periodController.text, widget._amplitudeController.text);
      } else if (widget.source == 2) {
        //Send command with source 2 and state Low
        candle.sendWGCommand(2, "L", widget.getWave(),
            widget._periodController.text, widget._amplitudeController.text);
      }
    }
  }
}
