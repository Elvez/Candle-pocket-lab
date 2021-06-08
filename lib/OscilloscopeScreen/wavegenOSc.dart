import 'package:flutter/material.dart';
import 'package:candle_pocketlab/Settings/settings.dart';
import 'package:flutter/services.dart';
import 'package:candle_pocketlab/Device/connectScreen.dart';

class WGDialog extends StatefulWidget {
  double _period = 100;
  double _amplitude = 5.0;
  bool enableSaveP = true;
  bool enableSaveA = true;
  String actionButton = "Generate";
  List<bool> _isSelected = [true, false, false];
  final period = new TextEditingController(text: "100");
  final amplitude = new TextEditingController(text: "5.0");
  bool save = false;

  bool getState() {
    return save;
  }

  double getPeriod() {
    double per = 0.0;
    per = double.tryParse(period.text);
    return per;
  }

  double getAmp() {
    double amp = 0.0;
    amp = double.tryParse(amplitude.text);
    return amp;
  }

  int getWaveType() {
    if (_isSelected[0]) {
      return 1;
    }
    if (_isSelected[1]) {
      return 2;
    }
    if (_isSelected[2]) {
      return 3;
    }
  }

  void setPeriod(double per) {
    period.text = "$per";
  }

  void setAmp(double amp) {
    amplitude.text = "$amp";
  }

  void setWave(int wave) {
    if (wave == 1) {
      _isSelected[0] = true;
      _isSelected[1] = false;
      _isSelected[2] = false;
    }
    if (wave == 2) {
      _isSelected[0] = false;
      _isSelected[1] = true;
      _isSelected[2] = false;
    }
    if (wave == 3) {
      _isSelected[0] = false;
      _isSelected[1] = false;
      _isSelected[2] = true;
    }
  }

  @override
  _WGDialogState createState() => _WGDialogState();
}

class _WGDialogState extends State<WGDialog> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SingleChildScrollView(
        child: AlertDialog(
      title: Text("Wave generator",
          style: TextStyle(fontFamily: 'Ropa Sans', fontSize: 25)),
      content: new Container(
          child: Column(children: [
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Wave:",
                style: TextStyle(fontFamily: 'Ropa Sans', fontSize: 20)),
            Container(
              margin: EdgeInsets.only(left: 50),
              width: 180,
              height: SizeConfig.blockSizeHorizontal * 3.5,
              child: ToggleButtons(
                borderColor: Colors.grey,
                fillColor: Colors.white,
                borderWidth: 2,
                selectedBorderColor: Color.fromARGB(255, 52, 152, 199),
                borderRadius: BorderRadius.circular(4),
                children: [
                  Padding(
                      padding: const EdgeInsets.all(0),
                      child: Image.asset('images/sineWave.png')),
                  Padding(
                      padding: const EdgeInsets.all(0),
                      child: Image.asset('images/sqWave.png')),
                  Padding(
                      padding: const EdgeInsets.all(0),
                      child: Image.asset('images/triang.png')),
                ],
                onPressed: (int newIndex) {
                  setState(() {
                    for (int index = 0;
                        index < widget._isSelected.length;
                        index++) {
                      if (index == newIndex) {
                        widget._isSelected[index] = true;
                      } else {
                        widget._isSelected[index] = false;
                      }
                    }
                  });
                },
                isSelected: widget._isSelected,
              ),
            ),
          ],
        ),
        new Container(
            margin: EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Period:",
                    style: TextStyle(
                        fontFamily: 'Ropa Sans',
                        fontSize: 20,
                        color: Color.fromARGB(255, 74, 74, 74))),
                SizedBox(width: 25),
                Container(
                  child: Container(
                      width: 132,
                      height: 31,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          border: Border.all(color: Colors.grey, width: 1)),
                      margin: EdgeInsets.only(left: 47),
                      child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                            LengthLimitingTextInputFormatter(4)
                          ],
                          autovalidate: true,
                          validator: (value) {
                            if (value == null) {
                              widget.enableSaveP = false;
                              return 'Invalid';
                            } else if (value.isEmpty) {
                              widget.enableSaveP = false;
                              return 'Invalid';
                            } else if (double.tryParse(value) <= 0 ||
                                double.tryParse(value) > 3000) {
                              widget.enableSaveP = false;
                              return 'Invalid';
                            } else {
                              widget.enableSaveP = true;
                              return null;
                            }
                          },
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          controller: widget.period,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "ms",
                            contentPadding: EdgeInsets.only(top: 2, right: 5),
                          ))),
                )
              ],
            )),
        new SizedBox(height: 8),
        new Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Amplitude:",
                    style: TextStyle(
                        fontFamily: 'Ropa Sans',
                        fontSize: 20,
                        color: Color.fromARGB(255, 74, 74, 74))),
                SizedBox(width: 25),
                Container(
                  child: Container(
                      width: 132,
                      height: 31,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          border: Border.all(color: Colors.grey, width: 1)),
                      margin: EdgeInsets.only(left: 10),
                      child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                            LengthLimitingTextInputFormatter(4)
                          ],
                          autovalidate: true,
                          validator: (value) {
                            if (value == null) {
                              widget.enableSaveA = false;
                              return 'Invalid';
                            } else if (value.isEmpty) {
                              widget.enableSaveA = false;
                              return 'Invalid';
                            } else if (double.tryParse(value) <= 0 ||
                                double.tryParse(value) > 5.0) {
                              widget.enableSaveA = false;
                              return 'Invalid';
                            } else {
                              widget.enableSaveA = true;
                              return null;
                            }
                          },
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          controller: widget.amplitude,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "V",
                              contentPadding:
                                  EdgeInsets.only(top: 2, right: 5)))),
                )
              ],
            )),
      ])),
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
            if (widget.enableSaveP && widget.enableSaveA) {
              widget.save = true;
              Navigator.pop(context);
            } else {}
          },
          child: Text(widget.actionButton,
              style: TextStyle(fontFamily: 'Ropa Sans')),
        ),
      ],
    ));
  }
}
