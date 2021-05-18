import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:candle_pocketlab/Settings/settings.dart';
import 'package:flutter/services.dart';

class WaveGeneratorTile extends StatefulWidget {
  final String sourceName;
  bool isTurnedOn = false;
  int _value = 0;
  final int source;
  final _periodController = new TextEditingController();
  final _amplitudeController = new TextEditingController();
  List<bool> isSelected = [true, false, false];
  WaveGeneratorTile(this.sourceName, this.source);

  @override
  _WaveGeneratorTileState createState() => _WaveGeneratorTileState();

  String getSourceName() {
    return sourceName;
  }

  int getSource() {
    return source;
  }

  bool getState() {
    return isTurnedOn;
  }

  double getPeriod() {
    return double.tryParse(_periodController.text);
  }

  double getAmplitude() {
    return double.tryParse(_amplitudeController.text);
  }

  int getWave() {
    if (isSelected[0]) {
      return 1;
    }
    if (isSelected[1]) {
      return 2;
    }
    if (isSelected[2]) {
      return 3;
    }

    return null;
  }
}

class _WaveGeneratorTileState extends State<WaveGeneratorTile> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new Container(
        width: SizeConfig.blockSizeHorizontal * 92.2,
        height: SizeConfig.blockSizeVertical * 27.1,
        decoration: BoxDecoration(
            border:
                Border.all(color: Color.fromARGB(255, 80, 80, 80), width: 3),
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
                      activeColor: Color.fromARGB(150, 52, 152, 199),
                      width: 50,
                      height: 30,
                      value: widget.isTurnedOn,
                      onToggle: (value) {
                        setState(() {
                          widget.isTurnedOn = value;
                          validateInput();
                          //sendCommandPacket
                          //ACK
                          //showDialog
                          //NACK
                          //showDialog
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
                    SizedBox(width: 70),
                    Container(
                      width: 200,
                      height: 40,
                      child: ToggleButtons(
                          borderColor: Colors.grey,
                          fillColor: Colors.white,
                          borderWidth: 2,
                          selectedBorderColor:
                              Color.fromARGB(250, 52, 152, 199),
                          borderRadius: BorderRadius.circular(4),
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(0),
                                child: Image.asset('images/sineWave.png')),
                            Padding(
                                padding: const EdgeInsets.all(1.5),
                                child: Image.asset('images/sqWave.png')),
                            Padding(
                                padding: const EdgeInsets.all(0),
                                child: Image.asset('images/triang.png'))
                          ],
                          onPressed: (int newIndex) {
                            setState(() {
                              for (int index = 0;
                                  index < widget.isSelected.length;
                                  index++) {
                                if (index == newIndex) {
                                  widget.isSelected[index] = true;
                                } else {
                                  widget.isSelected[index] = false;
                                }
                              }
                            });
                          },
                          isSelected: widget.isSelected),
                    )
                  ],
                )),
            new Container(
                margin: EdgeInsets.only(top: 15),
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
                                    EdgeInsets.only(top: 2, right: 5),
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
                                      EdgeInsets.only(top: 2, right: 5)))),
                    )
                  ],
                ))
          ],
        ));
  }

  void validateInput() {
    String error =
        "Invalid data, period must be less than 3000ms and amplitude less than 3.3V";

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
}
