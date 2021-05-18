import 'package:candle_pocketlab/OscilloscopeScreen/oscilloscope.dart';
import 'package:flutter/material.dart';
import 'package:candle_pocketlab/Settings/settings.dart';
import 'package:flutter_switch/flutter_switch.dart';

class ChannelDialog extends StatefulWidget {
  List<bool> is1Selected = [true, false, false];
  List<bool> is2Selected = [true, false, false];
  bool is1TurnedOn = false;
  bool is2TurnedOn = false;
  bool save = false;
  @override
  _ChannelDialogState createState() => _ChannelDialogState();

  void setChState(int ch, bool state) {
    if (ch == 1) {
      is1TurnedOn = state;
    }
    if (ch == 2) {
      is2TurnedOn = state;
    }
  }

  void setRange(double range, int ch) {
    if (ch == 1) {
      if (range == 3.3) {
        is1Selected[0] = true;
        is1Selected[1] = false;
        is1Selected[2] = false;
      }
      if (range == 10.0) {
        is1Selected[0] = false;
        is1Selected[1] = true;
        is1Selected[2] = false;
      }
      if (range == 20.0) {
        is1Selected[0] = false;
        is1Selected[1] = false;
        is1Selected[2] = true;
      }
    }
    if (ch == 2) {
      if (range == 3.3) {
        is2Selected[0] = true;
        is2Selected[1] = false;
        is2Selected[2] = false;
      }
      if (range == 10.0) {
        is2Selected[0] = false;
        is2Selected[1] = true;
        is2Selected[2] = false;
      }
      if (range == 20.0) {
        is2Selected[0] = false;
        is2Selected[1] = false;
        is2Selected[2] = true;
      }
    }
  }

  bool isSaved() {
    return save;
  }

  void setSave(bool saver) {
    save = saver;
  }

  bool getChannelState(int val) {
    if (val == 1) {
      return is1TurnedOn;
    }
    if (val == 2) {
      return is2TurnedOn;
    }
    return null;
  }

  double getRange1() {
    if (is1Selected[0]) {
      return 3.3;
    }
    if (is1Selected[1]) {
      return 10.0;
    }
    if (is1Selected[2]) {
      return 20.0;
    }
    return null;
  }

  double getRange2() {
    if (is2Selected[0]) {
      return 3.3;
    }
    if (is2Selected[1]) {
      return 10.0;
    }
    if (is2Selected[2]) {
      return 20.0;
    }
    return null;
  }
}

class _ChannelDialogState extends State<ChannelDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Channel setup",
          style: TextStyle(fontFamily: 'Ropa Sans', fontSize: 25)),
      content: new Container(
        child: Column(
          children: [
            new Container(
                child: Column(
              children: [
                new Row(
                  children: [
                    Text("Channel 1",
                        style: TextStyle(
                            fontFamily: 'Ropa Sans',
                            fontSize: 20,
                            color: Color.fromARGB(255, 90, 90, 90))),
                    SizedBox(width: 190),
                    FlutterSwitch(
                      duration: Duration(milliseconds: 200),
                      activeColor: Color.fromARGB(255, 52, 152, 219),
                      width: 43,
                      height: 27,
                      value: widget.is1TurnedOn,
                      onToggle: (value) {
                        setState(() {
                          widget.is1TurnedOn = value;
                        });
                      },
                    )
                  ],
                ),
                SizedBox(height: 7),
                new Row(
                  children: [
                    Text("Range",
                        style: TextStyle(
                            fontFamily: 'Ropa Sans',
                            fontSize: 20,
                            color: Color.fromARGB(255, 90, 90, 90))),
                    SizedBox(width: 110),
                    Container(
                      width: 150,
                      height: 30,
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
                              '3.3v',
                              style: TextStyle(
                                  fontSize: 20, fontFamily: 'Ropa Sans'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              '10v',
                              style: TextStyle(
                                  fontSize: 20, fontFamily: 'Ropa Sans'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              '20v',
                              style: TextStyle(
                                  fontSize: 20, fontFamily: 'Ropa Sans'),
                            ),
                          )
                        ],
                        onPressed: (int newIndex) {
                          setState(() {
                            for (int index = 0;
                                index < widget.is1Selected.length;
                                index++) {
                              if (index == newIndex) {
                                widget.is1Selected[index] = true;
                              } else {
                                widget.is1Selected[index] = false;
                              }
                            }
                          });
                        },
                        isSelected: widget.is1Selected,
                      ),
                    )
                  ],
                )
              ],
            )),
            Divider(),
            new Container(
                child: Column(
              children: [
                new Row(
                  children: [
                    Text("Channel 2",
                        style: TextStyle(
                            fontFamily: 'Ropa Sans',
                            fontSize: 20,
                            color: Color.fromARGB(255, 90, 90, 90))),
                    SizedBox(width: 190),
                    FlutterSwitch(
                      duration: Duration(milliseconds: 200),
                      activeColor: Color.fromARGB(255, 52, 152, 219),
                      width: 43,
                      height: 27,
                      value: widget.is2TurnedOn,
                      onToggle: (value) {
                        setState(() {
                          widget.is2TurnedOn = value;
                        });
                      },
                    )
                  ],
                ),
                SizedBox(height: 7),
                new Row(
                  children: [
                    Text("Range",
                        style: TextStyle(
                            fontFamily: 'Ropa Sans',
                            fontSize: 20,
                            color: Color.fromARGB(255, 90, 90, 90))),
                    SizedBox(width: 110),
                    Container(
                      width: 150,
                      height: 30,
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
                              '3.3v',
                              style: TextStyle(
                                  fontSize: 20, fontFamily: 'Ropa Sans'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              '10v',
                              style: TextStyle(
                                  fontSize: 20, fontFamily: 'Ropa Sans'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              '20v',
                              style: TextStyle(
                                  fontSize: 20, fontFamily: 'Ropa Sans'),
                            ),
                          )
                        ],
                        onPressed: (int newIndex) {
                          setState(() {
                            for (int index = 0;
                                index < widget.is2Selected.length;
                                index++) {
                              if (index == newIndex) {
                                widget.is2Selected[index] = true;
                              } else {
                                widget.is2Selected[index] = false;
                              }
                            }
                          });
                        },
                        isSelected: widget.is2Selected,
                      ),
                    )
                  ],
                )
              ],
            )),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.save = false;
            Navigator.pop(context);
          },
          child: Text('Cancel', style: TextStyle(fontFamily: 'Ropa Sans')),
        ),
        TextButton(
          onPressed: () {
            widget.save = true;
            Navigator.pop(context);
          },
          child: Text('Save', style: TextStyle(fontFamily: 'Ropa Sans')),
        ),
      ],
    );
  }
}
