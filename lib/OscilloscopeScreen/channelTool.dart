import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

/*
  * Class nane - ChannelDialog
  * 
  * Usage - This class is the settings menu for Ch button on Oscilloscope screen.
  * 
  */
class ChannelDialog extends StatefulWidget {
  //Channel ranges, toggles in (3.3, 5.0, 10.0)
  List<bool> _ch1Range = [true, false, false];
  List<bool> _ch2Range = [true, false, false];

  //Channel on/off states
  bool is1TurnedOn = false;
  bool is2TurnedOn = false;

  //Save the settings
  bool save = false;

  _ChannelDialogState createState() => _ChannelDialogState();

  /*
   * Set channel state
   * 
   * Sets the channel state to on or off.
   * 
   * @params : Channel(int), State(bool)
   * @return : none 
   */
  void setChState(int ch, bool state) {
    if (ch == 1) {
      is1TurnedOn = state;
    }
    if (ch == 2) {
      is2TurnedOn = state;
    }
  }

  /*
   * Set channel range
   * 
   * Sets the channel range.
   * 
   * @params : Range(double), Channel(int)
   * @return : none 
   */
  void setRange(double range, int ch) {
    if (ch == 1) {
      if (range == 3.3) {
        _ch1Range[0] = true;
        _ch1Range[1] = false;
        _ch1Range[2] = false;
      }
      if (range == 10.0) {
        _ch1Range[0] = false;
        _ch1Range[1] = true;
        _ch1Range[2] = false;
      }
      if (range == 20.0) {
        _ch1Range[0] = false;
        _ch1Range[1] = false;
        _ch1Range[2] = true;
      }
    }
    if (ch == 2) {
      if (range == 3.3) {
        _ch2Range[0] = true;
        _ch2Range[1] = false;
        _ch2Range[2] = false;
      }
      if (range == 10.0) {
        _ch2Range[0] = false;
        _ch2Range[1] = true;
        _ch2Range[2] = false;
      }
      if (range == 20.0) {
        _ch2Range[0] = false;
        _ch2Range[1] = false;
        _ch2Range[2] = true;
      }
    }
  }

  /*
   * Is setting saved?
   * 
   * Returns true if save button is pressed.
   * 
   * @params : none
   * @return : Bool 
   */
  bool isSaved() {
    return save;
  }

  /*
   * Set setting save
   * 
   * Sets the channel settings save to on or off.
   * 
   * @params : State(bool)
   * @return : none 
   */
  void setSave(bool saver) {
    save = saver;
  }

  /*
   * Get channel state
   * 
   * Returns the channel state.
   * 
   * @params : Channel(int)
   * @return : Bool 
   */
  bool getChannelState(int val) {
    if (val == 1) {
      return is1TurnedOn;
    }
    if (val == 2) {
      return is2TurnedOn;
    }
    return null;
  }

  /*
   * Get channel range
   * 
   * Returns the channel range.
   * 
   * @params : none
   * @return : Double 
   */
  double getRange1() {
    if (_ch1Range[0]) {
      return 3.3;
    }
    if (_ch1Range[1]) {
      return 10.0;
    }
    if (_ch1Range[2]) {
      return 20.0;
    }
    return null;
  }

  /*
   * Get channel range
   * 
   * Returns the channel range.
   * 
   * @params : none
   * @return : Double 
   */
  double getRange2() {
    if (_ch2Range[0]) {
      return 3.3;
    }
    if (_ch2Range[1]) {
      return 10.0;
    }
    if (_ch2Range[2]) {
      return 20.0;
    }
    return null;
  }
}

class _ChannelDialogState extends State<ChannelDialog> {
  //Dialog title
  final _title = new Text("Channel setup",
      style: TextStyle(fontFamily: 'Ropa Sans', fontSize: 25));

  //Channel 1 text
  final _ch1Text = new Text("Channel 1",
      style: TextStyle(
          fontFamily: 'Ropa Sans',
          fontSize: 20,
          color: Color.fromARGB(255, 90, 90, 90)));

  //Channel 2 text
  final _ch2Text = new Text("Channel 2",
      style: TextStyle(
          fontFamily: 'Ropa Sans',
          fontSize: 20,
          color: Color.fromARGB(255, 90, 90, 90)));

  //Range text
  final _rangeText = new Text("Range",
      style: TextStyle(
          fontFamily: 'Ropa Sans',
          fontSize: 20,
          color: Color.fromARGB(255, 90, 90, 90)));

  //Text 3.3v
  final _textVoltage3 = new Text(
    '3.3v',
    style: TextStyle(fontSize: 20, fontFamily: 'Ropa Sans'),
  );

  //Text 10v
  final _textVoltage10 = new Text(
    '10v',
    style: TextStyle(fontSize: 20, fontFamily: 'Ropa Sans'),
  );

  //Text 20v
  final _textVoltage20 = new Text(
    '20v',
    style: TextStyle(fontSize: 20, fontFamily: 'Ropa Sans'),
  );

  //Cancel text
  final _cancelText =
      new Text('Cancel', style: TextStyle(fontFamily: 'Ropa Sans'));

  //Save text
  final _saveText = new Text('Save', style: TextStyle(fontFamily: 'Ropa Sans'));

  Widget build(BuildContext context) {
    return AlertDialog(
        title: _title,
        content: new Container(
          child: Column(
            children: [
              new Container(
                  child: Column(
                children: [
                  new Row(
                    children: [
                      _ch1Text,
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
                      _rangeText,
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
                              child: _textVoltage3,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: _textVoltage10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: _textVoltage20,
                            )
                          ],
                          onPressed: (int newIndex) {
                            setState(() {
                              toggleRangeCh1(newIndex);
                            });
                          },
                          isSelected: widget._ch1Range,
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
                      _ch2Text,
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
                      _rangeText,
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
                              child: _textVoltage3,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: _textVoltage10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: _textVoltage20,
                            )
                          ],
                          onPressed: (int newIndex) {
                            setState(() {
                              toggleRangeCh2(newIndex);
                            });
                          },
                          isSelected: widget._ch2Range,
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
              child: _cancelText),
          TextButton(
              onPressed: () {
                widget.save = true;
                Navigator.pop(context);
              },
              child: _saveText),
        ]);
  }

  /*
  * Toggle channel 1 range
  * 
  * Toggles for channel 1 range.
  *
  * @params : none
  * @return : none
  */
  void toggleRangeCh1(int newIndex) {
    for (int index = 0; index < widget._ch1Range.length; index++) {
      if (index == newIndex) {
        widget._ch1Range[index] = true;
      } else {
        widget._ch1Range[index] = false;
      }
    }
  }

  /*
  * Toggle channel 2 range
  * 
  * Toggles for channel 2 range.
  *
  * @params : none
  * @return : none
  */
  void toggleRangeCh2(int newIndex) {
    for (int index = 0; index < widget._ch2Range.length; index++) {
      if (index == newIndex) {
        widget._ch2Range[index] = true;
      } else {
        widget._ch2Range[index] = false;
      }
    }
  }
}
