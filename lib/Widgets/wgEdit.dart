import 'package:flutter/material.dart';
import 'package:candle_pocketlab/Device/connectScreen.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:candle_pocketlab/Settings/settings.dart';
import 'package:flutter/services.dart';

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
  final _periodController = new TextEditingController();

  //Text editing controller for amplitude field
  final _amplitudeController = new TextEditingController();

  //Wave type toggle
  List<bool> _waveTyoe = [true, false, false];

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
    if (_waveTyoe[0]) {
      return 1;
    }
    if (_waveTyoe[1]) {
      return 2;
    }
    if (_waveTyoe[2]) {
      return 3;
    }

    return null;
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
  final _waveText = new Text("Wave:",
      style: TextStyle(
          fontFamily: 'Ropa Sans',
          fontSize: 25,
          color: Color.fromARGB(255, 74, 74, 74)));

  //Period text
  final _periodText = new Text("Period:",
      style: TextStyle(
          fontFamily: 'Ropa Sans',
          fontSize: 25,
          color: Color.fromARGB(255, 74, 74, 74)));

  //Amplitude text
  final _amplitudeText = new Text("Amplitude:",
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
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new Container(
        width: SizeConfig.blockSizeHorizontal * 92.2,
        height: SizeConfig.blockSizeVertical * 27.1,
        decoration: _decoration,
        margin: EdgeInsets.only(top: 15),
        child: new Column(children: [
          new Container(
              margin: EdgeInsets.only(left: 15, right: 10, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.sourceName, style: _sourceFont),
                  new FlutterSwitch(
                    activeColor: Color.fromARGB(150, 52, 152, 199),
                    width: 50,
                    height: 30,
                    value: widget.isTurnedOn,
                    onToggle: (value) {
                      setState(() {
                        widget.isTurnedOn = value;
                        validateInput();
                      });

                      //Send wave generator command
                      setWaveGenerator(widget.isTurnedOn);
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
                  _waveText,
                  SizedBox(width: 70),
                  Container(
                    width: 200,
                    height: 40,
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
                        },
                        isSelected: widget._waveTyoe),
                  )
                ],
              )),
          new Container(
              margin: EdgeInsets.only(top: 15),
              child: Row(children: [
                SizedBox(width: 20),
                _periodText,
                SizedBox(width: 25),
                Container(
                    child: Container(
                        width: 132,
                        height: 31,
                        decoration: _fieldDecoration,
                        margin: EdgeInsets.only(left: 47),
                        child: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9.]")),
                              LengthLimitingTextInputFormatter(4)
                            ],
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.number,
                            controller: widget._periodController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "ms",
                                contentPadding:
                                    EdgeInsets.only(top: 2, right: 5)))))
              ])),
          new SizedBox(height: 8),
          new Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(children: [
                SizedBox(width: 20),
                _amplitudeText,
                SizedBox(width: 25),
                Container(
                    child: Container(
                        width: 132,
                        height: 31,
                        decoration: _fieldDecoration,
                        margin: EdgeInsets.only(left: 10),
                        child: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9.]")),
                              LengthLimitingTextInputFormatter(4)
                            ],
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.number,
                            controller: widget._amplitudeController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "V",
                                contentPadding:
                                    EdgeInsets.only(top: 2, right: 5)))))
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
    for (int index = 0; index < widget._waveTyoe.length; index++) {
      if (index == newIndex) {
        widget._waveTyoe[index] = true;
      } else {
        widget._waveTyoe[index] = false;
      }
    }
  }

  /*
   * Period input validator
   * 
   * Validates the period input.
   * 
   * @params : none
   * @return : none 
   */
  void validateInput() {
    String error =
        "Invalid data, period must be in (0-3000)ms and amplitude less than 3.3V";

    if (widget._amplitudeController.text.isEmpty ||
        widget._periodController.text.isEmpty) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Error", style: TextStyle(fontFamily: 'Ropa Sans')),
                content: Text(error, style: TextStyle(fontFamily: 'Ropa Sans')),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child:
                          Text("Ok", style: TextStyle(fontFamily: 'Ropa Sans')))
                ],
              ));
      setState(() {
        widget.isTurnedOn = false;
      });
    } else if (double.tryParse(widget._periodController.text) <= 0 ||
        double.tryParse(widget._periodController.text) >= 3000.0 ||
        double.tryParse(widget._amplitudeController.text) <= 0 ||
        double.tryParse(widget._amplitudeController.text) >= 3.30) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Error", style: TextStyle(fontFamily: 'Ropa Sans')),
                content: Text(error, style: TextStyle(fontFamily: 'Ropa Sans')),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child:
                          Text("Ok", style: TextStyle(fontFamily: 'Ropa Sans')))
                ],
              ));
      setState(() {
        widget.isTurnedOn = false;
      });
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
    if (state) {
      if (widget.source == 1) {
        candle.sendWGCommand(1, "H", widget.getWave(),
            widget._periodController.text, widget._amplitudeController.text);
      } else if (widget.source == 2) {
        candle.sendWGCommand(2, "H", widget.getWave(),
            widget._periodController.text, widget._amplitudeController.text);
      }
    } else {
      if (widget.source == 1) {
        candle.sendWGCommand(1, "L", widget.getWave(),
            widget._periodController.text, widget._amplitudeController.text);
      } else if (widget.source == 2) {
        candle.sendWGCommand(2, "L", widget.getWave(),
            widget._periodController.text, widget._amplitudeController.text);
      }
    }
  }
}
