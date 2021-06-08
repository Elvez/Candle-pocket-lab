import 'package:candle_pocketlab/OscilloscopeScreen/oscilloscope.dart';
import 'package:flutter/material.dart';
import 'package:candle_pocketlab/Settings/settings.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:candle_pocketlab/Device/connectScreen.dart';

class OpDialog extends StatefulWidget {
  bool isFT = false;

  bool isDiff = false;
  bool _save = false;
  @override
  _OpDialogState createState() => _OpDialogState();

  bool isSaved() {
    return _save;
  }

  void setSave(bool save) {
    _save = save;
  }

  bool getFT() {
    return isFT;
  }

  bool getDiff() {
    return isDiff;
  }

  bool setFT(bool ft) {
    isFT = ft;
  }

  bool setDiff(bool diff) {
    isDiff = diff;
  }
}

class _OpDialogState extends State<OpDialog> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AlertDialog(
      title:
          Text("Graph operations", style: TextStyle(fontFamily: 'Ropa Sans')),
      content: new Container(
        child: new Column(
          children: [
            new Row(
              children: [
                Text("Fourier transform",
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
                  value: widget.isFT,
                  onToggle: (value) {
                    setState(() {
                      widget.isFT = value;
                    });
                  },
                )
              ],
            ),
            SizedBox(height: 40),
            new Row(
              children: [
                Text("Differentiate",
                    style: TextStyle(
                        fontFamily: 'Ropa Sans',
                        fontSize: 20,
                        color: Color.fromARGB(255, 90, 90, 90))),
                SizedBox(width: 225),
                FlutterSwitch(
                  duration: Duration(milliseconds: 200),
                  activeColor: Color.fromARGB(255, 52, 152, 219),
                  width: 43,
                  height: 27,
                  value: widget.isDiff,
                  onToggle: (value) {
                    setState(() {
                      widget.isDiff = value;
                    });
                  },
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
            widget._save = true;
            Navigator.pop(context);
          },
          child: Text('Save', style: TextStyle(fontFamily: 'Ropa Sans')),
        ),
      ],
    );
  }
}
