import 'package:candle_pocketlab/OscilloscopeScreen/oscilloscope.dart';
import 'package:flutter/material.dart';
import 'package:candle_pocketlab/Settings/settings.dart';
import 'package:flutter/services.dart';

enum timeUnit { micro, milli, second }
enum voltUnit { milli, volt }
enum color { yellow, red, blue, green }

class XYDialog extends StatefulWidget {
  final rangeXController = new TextEditingController(text: "100");
  final rangeYController = new TextEditingController(text: "5");
  var xData = new XGraphData(100.0, timeUnit.milli);
  var yData = new YGraphData(5.0, voltUnit.volt);
  bool _save = false;
  List<bool> isXSelected = [false, true, false];
  List<bool> isYSelected = [false, true];
  List<bool> is1Color = [true, false, false, false];
  List<bool> is2Color = [false, true, false, false];
  bool saveButton = true;

  void setData(XGraphData x, YGraphData y) {
    double rangex = x.range;
    double rangey = y.range;
    rangeXController.text = "$rangex";
    rangeYController.text = "$rangey";

    if (x.unit == timeUnit.micro) {
      isXSelected[0] = true;
      isXSelected[1] = false;
      isXSelected[2] = false;
    }
    if (x.unit == timeUnit.milli) {
      isXSelected[0] = false;
      isXSelected[1] = true;
      isXSelected[2] = false;
    }
    if (x.unit == timeUnit.second) {
      isXSelected[0] = false;
      isXSelected[1] = false;
      isXSelected[2] = true;
    }

    if (y.unit == voltUnit.milli) {
      isYSelected[0] = true;
      isYSelected[1] = false;
    }
    if (y.unit == voltUnit.volt) {
      isYSelected[0] = false;
      isYSelected[1] = true;
    }
  }

  void setColor(color channel1, color channel2) {
    if (channel1 == color.yellow) {
      is1Color[0] = true;
      is1Color[1] = false;
      is1Color[2] = false;
      is1Color[3] = false;
    }
    if (channel1 == color.red) {
      is1Color[0] = false;
      is1Color[1] = true;
      is1Color[2] = false;
      is1Color[3] = false;
    }
    if (channel1 == color.blue) {
      is1Color[0] = false;
      is1Color[1] = false;
      is1Color[2] = true;
      is1Color[3] = false;
    }
    if (channel1 == color.green) {
      is1Color[0] = false;
      is1Color[1] = false;
      is1Color[2] = false;
      is1Color[3] = true;
    }

    if (channel2 == color.yellow) {
      is2Color[0] = true;
      is2Color[1] = false;
      is2Color[2] = false;
      is2Color[3] = false;
    }
    if (channel2 == color.red) {
      is2Color[0] = false;
      is2Color[1] = true;
      is2Color[2] = false;
      is2Color[3] = false;
    }
    if (channel2 == color.blue) {
      is2Color[0] = false;
      is2Color[1] = false;
      is2Color[2] = true;
      is2Color[3] = false;
    }
    if (channel2 == color.green) {
      is2Color[0] = false;
      is2Color[1] = false;
      is2Color[2] = false;
      is2Color[3] = true;
    }
  }

  bool isSaved() {
    return _save;
  }

  void setSave(bool save) {
    _save = save;
  }

  XGraphData getXData() {
    xData.range = double.tryParse(rangeXController.text);
    if (isXSelected[0]) xData.unit = timeUnit.micro;
    if (isXSelected[1]) xData.unit = timeUnit.milli;
    if (isXSelected[2]) xData.unit = timeUnit.second;
    return xData;
  }

  YGraphData getYData() {
    yData.range = double.tryParse(rangeYController.text);
    if (isYSelected[0]) yData.unit = voltUnit.milli;
    if (isYSelected[1]) yData.unit = voltUnit.volt;
    return yData;
  }

  color getChannelColor(int ch) {
    if (ch == 1) {
      if (is1Color[0]) return color.yellow;
      if (is1Color[1]) return color.red;
      if (is1Color[2]) return color.blue;
      if (is1Color[3]) return color.green;
    }

    if (ch == 2) {
      if (is2Color[0]) return color.yellow;
      if (is2Color[1]) return color.red;
      if (is2Color[2]) return color.blue;
      if (is2Color[3]) return color.green;
    }
    return null;
  }

  @override
  _XYDialogState createState() => _XYDialogState();
}

class _XYDialogState extends State<XYDialog> {
  _XYDialogState();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: Text("Graph setup",
            style: TextStyle(fontFamily: 'Ropa Sans', fontSize: 25)),
        content: new Container(
          child: Column(
            children: [
              new Row(
                children: [
                  Text("RangeX",
                      style: TextStyle(fontFamily: 'Ropa Sans', fontSize: 20)),
                  new Container(
                      width: SizeConfig.blockSizeVertical * 20,
                      height: SizeConfig.blockSizeHorizontal * 3.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          border: Border.all(color: Colors.grey, width: 1)),
                      margin: EdgeInsets.only(left: 47),
                      child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                            LengthLimitingTextInputFormatter(4)
                          ],
                          controller: widget.rangeXController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.only(top: 2, left: 2),
                          ))),
                  new Container(
                      width: 150,
                      height: SizeConfig.blockSizeHorizontal * 3.5,
                      margin: EdgeInsets.only(left: 30),
                      child: ToggleButtons(
                        borderColor: Colors.grey[700],
                        fillColor: Colors.grey[350],
                        borderWidth: 1.2,
                        selectedBorderColor: Colors.black,
                        selectedColor: Colors.black,
                        borderRadius: BorderRadius.circular(4),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              'µs',
                              style: TextStyle(
                                  fontSize: 20, fontFamily: 'Ropa Sans'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              'ms',
                              style: TextStyle(
                                  fontSize: 20, fontFamily: 'Ropa Sans'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              's',
                              style: TextStyle(
                                  fontSize: 20, fontFamily: 'Ropa Sans'),
                            ),
                          )
                        ],
                        onPressed: (int newIndex) {
                          setState(() {
                            for (int index = 0;
                                index < widget.isXSelected.length;
                                index++) {
                              if (index == newIndex) {
                                widget.isXSelected[index] = true;
                              } else {
                                widget.isXSelected[index] = false;
                              }
                            }
                          });
                        },
                        isSelected: widget.isXSelected,
                      )),
                ],
              ),
              SizedBox(height: 12),
              new Row(
                children: [
                  Text("RangeY",
                      style: TextStyle(fontFamily: 'Ropa Sans', fontSize: 20)),
                  new Container(
                      width: SizeConfig.blockSizeVertical * 20,
                      height: SizeConfig.blockSizeHorizontal * 3.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          border: Border.all(color: Colors.grey, width: 1)),
                      margin: EdgeInsets.only(left: 48),
                      child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                            widget.isYSelected[0]
                                ? LengthLimitingTextInputFormatter(4)
                                : LengthLimitingTextInputFormatter(2)
                          ],
                          autovalidate: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              widget.saveButton = false;
                              return 'Error';
                            } else {
                              widget.saveButton = true;
                              return null;
                            }
                          },
                          controller: widget.rangeYController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "0",
                            contentPadding: EdgeInsets.only(top: 2, left: 2),
                          ))),
                  new Container(
                      width: 150,
                      height: SizeConfig.blockSizeHorizontal * 3.5,
                      margin: EdgeInsets.only(left: 30),
                      child: ToggleButtons(
                        borderColor: Colors.grey[700],
                        fillColor: Colors.grey[350],
                        borderWidth: 1.2,
                        selectedBorderColor: Colors.black,
                        selectedColor: Colors.black,
                        borderRadius: BorderRadius.circular(4),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              'mV',
                              style: TextStyle(
                                  fontSize: 20, fontFamily: 'Ropa Sans'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              'V',
                              style: TextStyle(
                                  fontSize: 20, fontFamily: 'Ropa Sans'),
                            ),
                          )
                        ],
                        onPressed: (int newIndex) {
                          setState(() {
                            for (int index = 0;
                                index < widget.isYSelected.length;
                                index++) {
                              if (index == newIndex) {
                                widget.isYSelected[index] = true;
                              } else {
                                widget.isYSelected[index] = false;
                              }
                            }
                            widget.rangeYController.text = "10";
                          });
                        },
                        isSelected: widget.isYSelected,
                      )),
                ],
              ),
              SizedBox(height: 12),
              new Row(
                children: [
                  Text("Channel 1",
                      style: TextStyle(fontFamily: 'Ropa Sans', fontSize: 20)),
                  new Container(
                    width: 200,
                    height: SizeConfig.blockSizeHorizontal * 3.5,
                    margin: EdgeInsets.only(left: 34),
                    child: ToggleButtons(
                      borderColor: Colors.grey[200],
                      fillColor: Colors.white,
                      borderWidth: 1.2,
                      selectedBorderColor: Colors.black,
                      borderRadius: BorderRadius.circular(15),
                      children: [
                        new Icon(Icons.circle, color: Colors.yellow),
                        new Icon(Icons.circle, color: Colors.red),
                        new Icon(Icons.circle, color: Colors.blue),
                        new Icon(Icons.circle, color: Colors.green)
                      ],
                      onPressed: (int newIndex) {
                        setState(() {
                          for (int index = 0;
                              index < widget.is1Color.length;
                              index++) {
                            if (index == newIndex) {
                              widget.is1Color[index] = true;
                            } else {
                              widget.is1Color[index] = false;
                            }
                          }
                        });
                      },
                      isSelected: widget.is1Color,
                    ),
                  )
                ],
              ),
              SizedBox(height: 12),
              new Row(
                children: [
                  Text("Channel 2",
                      style: TextStyle(fontFamily: 'Ropa Sans', fontSize: 20)),
                  new Container(
                    width: 200,
                    height: SizeConfig.blockSizeHorizontal * 3.5,
                    margin: EdgeInsets.only(left: 32),
                    child: ToggleButtons(
                      borderColor: Colors.grey[200],
                      fillColor: Colors.white,
                      borderWidth: 1.2,
                      selectedBorderColor: Colors.black,
                      borderRadius: BorderRadius.circular(15),
                      children: [
                        new Icon(Icons.circle, color: Colors.yellow),
                        new Icon(Icons.circle, color: Colors.red),
                        new Icon(Icons.circle, color: Colors.blue),
                        new Icon(Icons.circle, color: Colors.green)
                      ],
                      onPressed: (int newIndex) {
                        setState(() {
                          for (int index = 0;
                              index < widget.is2Color.length;
                              index++) {
                            if (index == newIndex) {
                              widget.is2Color[index] = true;
                            } else {
                              widget.is2Color[index] = false;
                            }
                          }
                        });
                      },
                      isSelected: widget.is2Color,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              widget._save = false;
              Navigator.pop(context);
            },
            child: Text('Cancel', style: TextStyle(fontFamily: 'Ropa Sans')),
          ),
          TextButton(
            onPressed: () {
              if (widget.saveButton) {
                widget._save = true;
                Navigator.pop(context);
              } else {}
            },
            child: Text('Save', style: TextStyle(fontFamily: 'Ropa Sans')),
          ),
        ],
      ),
    );
  }
}

class XGraphData {
  double range;
  timeUnit unit;
  XGraphData(this.range, this.unit);
}

class YGraphData {
  double range;
  voltUnit unit;
  YGraphData(this.range, this.unit);
}
