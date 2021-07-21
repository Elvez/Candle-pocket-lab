import 'package:flutter/material.dart';
import 'package:candle_pocketlab/Settings/settings.dart';
import 'package:flutter/services.dart';
import 'package:candle_pocketlab/Settings/settings.dart';

enum timeUnit { micro, milli, second }
enum voltUnit { milli, volt }
enum color { black, red, blue, green }

class XYDialog extends StatefulWidget {
  //Text editing controller for X axis range
  final rangeXController = new TextEditingController(text: "100");

  //Text editing controller for Y axis range
  final rangeYController = new TextEditingController(text: "5");

  //Graph data
  var xData = new XGraphData(100.0, timeUnit.milli);
  var yData = new YGraphData(5.0, voltUnit.volt);

  //Save state for settings menu
  bool _save = false;

  //X toggle time unit
  List<bool> isXSelected = [true, false];

  //Y toggle range unit
  List<bool> isYSelected = [false, true];

  //Channel 1 color toggle
  List<bool> is1Color = [true, false, false, false];

  //Channel 2 color toggle
  List<bool> is2Color = [false, true, false, false];

  //Save validator for settings menu
  bool yRangeValid = true;
  bool xRangeValid = true;

  /*
   * Set XY graph data
   * 
   * Sets the graph range and unit to the passed arguments.
   * 
   * @params : XData(XGraphData), YData(YGraphData)
   * @return : none 
   */
  void setData(XGraphData x, YGraphData y) {
    double rangex = x.range;
    double rangey = y.range;
    rangeXController.text = "$rangex";
    rangeYController.text = "$rangey";

    if (x.unit == timeUnit.micro) {
      //No such unit
    }
    if (x.unit == timeUnit.milli) {
      isXSelected[0] = true;
      isXSelected[1] = false;
    }
    if (x.unit == timeUnit.second) {
      isXSelected[0] = false;
      isXSelected[1] = true;
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

  /*
   * Set channel colors
   * 
   * Sets Channel colors to the passed arguments.
   * 
   * @params : Channel 1 color(enum color), Channel 2 color(enum colors)
   * @return : none 
   */
  void setColor(color channel1, color channel2) {
    if (channel1 == color.black) {
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

    if (channel2 == color.black) {
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

  /*
   * Is setting saved?
   * 
   * Returns true if settings were saved.
   * 
   * @params : none
   * @return : bool 
   */
  bool isSaved() {
    return _save;
  }

  /*
   * Set save state
   * 
   * Sets the settings save state to the argument passed.
   * 
   * @params : none
   * @return : bool 
   */
  void setSave(bool save) {
    _save = save;
  }

  /*
   * Get graph data
   * 
   * Returns Graph data, range and unit
   * 
   * @params : none
   * @return : XGraphData 
   */
  XGraphData getXData() {
    xData.range = double.tryParse(rangeXController.text);
    if (isXSelected[0]) xData.unit = timeUnit.milli;
    if (isXSelected[1]) xData.unit = timeUnit.second;
    return xData;
  }

  /*
   * Get graph data
   * 
   * Returns Graph data, range and unit
   * 
   * @params : none
   * @return : YGraphData 
   */
  YGraphData getYData() {
    yData.range = double.tryParse(rangeYController.text);
    if (isYSelected[0]) yData.unit = voltUnit.milli;
    if (isYSelected[1]) yData.unit = voltUnit.volt;
    return yData;
  }

  /*
   * Get channel color
   * 
   * Returns enum color.
   * 
   * @params : Channel(int)
   * @return : enum color 
   */
  color getChannelColor(int ch) {
    if (ch == 1) {
      if (is1Color[0]) return color.black;
      if (is1Color[1]) return color.red;
      if (is1Color[2]) return color.blue;
      if (is1Color[3]) return color.green;
    }

    if (ch == 2) {
      if (is2Color[0]) return color.black;
      if (is2Color[1]) return color.red;
      if (is2Color[2]) return color.blue;
      if (is2Color[3]) return color.green;
    }
    return null;
  }

  _XYDialogState createState() => _XYDialogState();
}

class _XYDialogState extends State<XYDialog> {
  _XYDialogState();
  //Title
  final _title = new Text("Graph setup",
      style: TextStyle(fontFamily: 'Ropa Sans', fontSize: 25));

  //RangeX text
  final _rangeXText = new Text("RangeX",
      style: TextStyle(fontFamily: 'Ropa Sans', fontSize: 20));

  //RangeY text
  final _rangeYText = new Text("RangeY",
      style: TextStyle(fontFamily: 'Ropa Sans', fontSize: 20));

  //Field decoration
  final _xfieldDecoration = new BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      border: Border.all(color: Colors.grey, width: 1));

  //Y field decoration
  final _yfieldDecoration = new BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      border: Border.all(color: Colors.grey, width: 1));

  //Milli seconds text
  final _msText = new Padding(
    padding: const EdgeInsets.all(2.0),
    child: Text(
      'ms',
      style: TextStyle(fontSize: 20, fontFamily: 'Ropa Sans'),
    ),
  );

  //Seconds text
  final _secText = new Padding(
    padding: const EdgeInsets.all(2.0),
    child: Text(
      's',
      style: TextStyle(fontSize: 20, fontFamily: 'Ropa Sans'),
    ),
  );

  //Milli volt text
  final _mvText = new Padding(
    padding: const EdgeInsets.all(2.0),
    child: Text(
      'mV',
      style: TextStyle(fontSize: 20, fontFamily: 'Ropa Sans'),
    ),
  );

  //V text
  final _vText = new Padding(
    padding: const EdgeInsets.all(2.0),
    child: Text(
      'V',
      style: TextStyle(fontSize: 20, fontFamily: 'Ropa Sans'),
    ),
  );

  //Channel 1 text
  final _ch1Text = new Text("Channel 1",
      style: TextStyle(fontFamily: 'Ropa Sans', fontSize: 20));

  //Channel colors
  final List<Icon> _channelColors = [
    new Icon(Icons.circle, color: Colors.black),
    new Icon(Icons.circle, color: Colors.red),
    new Icon(Icons.circle, color: Colors.blue),
    new Icon(Icons.circle, color: Colors.green)
  ];

  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SingleChildScrollView(
      child: AlertDialog(
        title: _title,
        content: new Container(
          child: Column(
            children: [
              new Row(
                children: [
                  _rangeXText,

                  //Range textbox
                  new Container(
                      width: SizeConfig.blockSizeVertical * 20,
                      height: SizeConfig.blockSizeHorizontal * 3.5,
                      decoration: _xfieldDecoration,
                      margin: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 5.94),
                      child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d*')),
                            LengthLimitingTextInputFormatter(4)
                          ],
                          validator: _validator,
                          autovalidate: true,
                          controller: widget.rangeXController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.only(top: 2, left: 2),
                          ))),

                  //X-range toggle button
                  new Container(
                      width: SizeConfig.blockSizeHorizontal * 22.50,
                      height: SizeConfig.blockSizeHorizontal * 3.5,
                      margin: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 3.60),
                      child: ToggleButtons(
                        borderColor: Colors.grey[700],
                        fillColor: Colors.grey[350],
                        borderWidth: 1.2,
                        selectedBorderColor: Colors.black,
                        selectedColor: Colors.black,
                        borderRadius: BorderRadius.circular(4),
                        children: [_msText, _secText],
                        onPressed: (int newIndex) {
                          setState(() {
                            toggleXRange(newIndex);
                          });
                        },
                        isSelected: widget.isXSelected,
                      )),
                ],
              ),
              SizedBox(height: SizeConfig.blockSizeHorizontal * 1.51),
              new Row(
                children: [
                  _rangeYText,
                  new Container(
                      width: SizeConfig.blockSizeVertical * 20,
                      height: SizeConfig.blockSizeHorizontal * 3.5,
                      decoration: _yfieldDecoration,
                      margin: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 6.06),
                      child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d*')),
                            widget.isYSelected[0]
                                ? LengthLimitingTextInputFormatter(4)
                                : LengthLimitingTextInputFormatter(2)
                          ],
                          autovalidate: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              widget.yRangeValid = false;
                              return 'Error';
                            } else {
                              widget.yRangeValid = true;
                              return null;
                            }
                          },
                          controller: widget.rangeYController,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "0",
                            contentPadding: EdgeInsets.only(top: 2, left: 2),
                          ))),
                  new Container(
                      width: 150,
                      height: SizeConfig.blockSizeHorizontal * 3.5,
                      margin: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 3.60),
                      child: ToggleButtons(
                        borderColor: Colors.grey[700],
                        fillColor: Colors.grey[350],
                        borderWidth: 1.2,
                        selectedBorderColor: Colors.black,
                        selectedColor: Colors.black,
                        borderRadius: BorderRadius.circular(4),
                        children: [_mvText, _vText],
                        onPressed: (int newIndex) {
                          setState(() {
                            toggleYRange(newIndex);
                            widget.rangeYController.text = "10";
                          });
                        },
                        isSelected: widget.isYSelected,
                      )),
                ],
              ),
              SizedBox(height: SizeConfig.blockSizeHorizontal * 1.50),
              new Row(
                children: [
                  _ch1Text,
                  new Container(
                    width: SizeConfig.blockSizeHorizontal * 28.28,
                    height: SizeConfig.blockSizeHorizontal * 3.5,
                    margin: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 4.29),
                    child: ToggleButtons(
                      borderColor: Colors.grey[200],
                      fillColor: Colors.white,
                      borderWidth: 1.2,
                      selectedBorderColor: Colors.grey[600],
                      borderRadius: BorderRadius.circular(15),
                      children: _channelColors,
                      onPressed: (int newIndex) {
                        setState(() {
                          toggle1Color(newIndex);
                        });
                      },
                      isSelected: widget.is1Color,
                    ),
                  )
                ],
              ),
              SizedBox(height: SizeConfig.blockSizeHorizontal * 1.50),
              new Row(
                children: [
                  Text("Channel 2",
                      style: TextStyle(fontFamily: 'Ropa Sans', fontSize: 20)),
                  new Container(
                    width: SizeConfig.blockSizeHorizontal * 28.28,
                    height: SizeConfig.blockSizeHorizontal * 3.5,
                    margin: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 4.04),
                    child: ToggleButtons(
                      borderColor: Colors.grey[200],
                      fillColor: Colors.white,
                      borderWidth: 1.2,
                      selectedBorderColor: Colors.grey[600],
                      borderRadius: BorderRadius.circular(15),
                      children: _channelColors,
                      onPressed: (int newIndex) {
                        setState(() {
                          toggle2Color(newIndex);
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
              if (widget.xRangeValid && widget.yRangeValid) {
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

  /*
   * Validate x range
   * 
   * Validates x range in (100 - 10,000)ms and (1 - 10)s. Sets a boolean for range valiator so that save button 
   * can be disabled if the range is not valid.
   * 
   * @params : none
   * @return : error(String) 
   */
  String _validator(String input) {
    if (input == null || input.isEmpty) {
      //Input should not be empty
      widget.xRangeValid = false;

      return "Can't be empty!";
    } else {
      if (widget.isXSelected[0] == true) {
        //For milli-seconds range
        if (double.tryParse(input) < 100 || double.tryParse(input) > 10000) {
          widget.xRangeValid = false;

          return "Out of range!";
        } else {
          widget.xRangeValid = true;

          return null;
        }
      } else if (widget.isXSelected[1] == true) {
        //For seconds range
        if (double.tryParse(input) < 0.1 || double.tryParse(input) > 10) {
          widget.xRangeValid = false;

          return "Out of range!";
        } else {
          widget.xRangeValid = true;

          return null;
        }
      } else {
        widget.xRangeValid = true;

        return null;
      }
    }
  }

  /*
   * X axis range unit toggler
   * 
   * Toggles the x axis range on tap 
   * 
   * @params : index(int)
   * @return : none
   */
  void toggleXRange(int newIndex) {
    for (int index = 0; index < widget.isXSelected.length; index++) {
      if (index == newIndex) {
        widget.isXSelected[index] = true;
      } else {
        widget.isXSelected[index] = false;
      }
    }
  }

  /*
   * Y axis range unit toggler
   * 
   * Toggles the y axis range on tap 
   * 
   * @params : index(int)
   * @return : none
   */
  void toggleYRange(int newIndex) {
    for (int index = 0; index < widget.isYSelected.length; index++) {
      if (index == newIndex) {
        widget.isYSelected[index] = true;
      } else {
        widget.isYSelected[index] = false;
      }
    }
  }

  /*
   * Channel 1 color toggler 
   * 
   * Toggles the channel 1 color on tap 
   * 
   * @params : index(int)
   * @return : none
   */
  void toggle1Color(int newIndex) {
    for (int index = 0; index < widget.is1Color.length; index++) {
      if (index == newIndex) {
        widget.is1Color[index] = true;
      } else {
        widget.is1Color[index] = false;
      }
    }
  }

  /*
   * Channel 2 color toggler 
   * 
   * Toggles the channel 2 color on tap 
   * 
   * @params : index(int)
   * @return : none
   */
  void toggle2Color(int newIndex) {
    for (int index = 0; index < widget.is2Color.length; index++) {
      if (index == newIndex) {
        widget.is2Color[index] = true;
      } else {
        widget.is2Color[index] = false;
      }
    }
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
