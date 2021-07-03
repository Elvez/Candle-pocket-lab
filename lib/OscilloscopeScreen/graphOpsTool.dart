import 'package:flutter/material.dart';
import 'package:candle_pocketlab/Settings/settings.dart';
import 'package:flutter_switch/flutter_switch.dart';

/*
 * Class name - OpDialog
 * 
 * Usage - This class is the settings menu for the operations tool 'Op' button on Oscilloscope screen 
 */
class OpDialog extends StatefulWidget {
  //Fourier transform checked state
  bool isFT = false;

  //Differentiate checked state
  bool isDiff = false;

  //Graph save
  bool _save = false;

  _OpDialogState createState() => _OpDialogState();

  /*
   * Is setting saved?
   * 
   * Returns true if the settings are closed with the save button.
   * 
   * @params : none
   * @return : bool 
   */
  bool isSaved() {
    return _save;
  }

  /*
   * Set the save state of settings menu
   * 
   * Set the argument bool to the save state of the Settings.
   * 
   * @params : State(Bool)
   * @return : none
   */
  void setSave(bool save) {
    _save = save;
  }

  /*
   * Is fourier transform selected
   * 
   * Returns true if the FT option is selected.
   * 
   * @params : none
   * @return : bool 
   */
  bool getFT() {
    return isFT;
  }

  /*
   * Is Differentiate selected
   * 
   * Returns true if the differentiate option is selected.
   * 
   * @params : none
   * @return : bool 
   */
  bool getDiff() {
    return isDiff;
  }

  /*
   * Set Fourier transform state
   * 
   * Sets the argument bool as the FT checkbox state.
   * 
   * @params : FT State(bool)
   * @return : none 
   */
  void setFT(bool ft) {
    isFT = ft;
  }

  /*
   * Set Differentiate option state
   * 
   * Sets the argument bool as the Differentiate checkbox state.
   * 
   * @params : Diff State(bool)
   * @return : none 
   */
  void setDiff(bool diff) {
    isDiff = diff;
  }
}

class _OpDialogState extends State<OpDialog> {
  //Title
  final _title =
      new Text("Graph operations", style: TextStyle(fontFamily: 'Ropa Sans'));

  //Fourier transform text
  final _ftText = new Text("Fourier transform",
      style: TextStyle(
          fontFamily: 'Ropa Sans',
          fontSize: 20,
          color: Color.fromARGB(255, 90, 90, 90)));

  //Differentiate text
  final _diffText = new Text("Differentiate",
      style: TextStyle(
          fontFamily: 'Ropa Sans',
          fontSize: 20,
          color: Color.fromARGB(255, 90, 90, 90)));

  //Save button text
  final _saveText = new Text('Save', style: TextStyle(fontFamily: 'Ropa Sans'));

  //Cancle button text
  final _cancelText =
      new Text('Cancel', style: TextStyle(fontFamily: 'Ropa Sans'));

  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AlertDialog(
      title: _title,
      content: new Container(
        child: new Column(
          children: [
            new Row(
              children: [
                _ftText,
                SizedBox(width: SizeConfig.blockSizeHorizontal * 24.02),
                FlutterSwitch(
                  duration: Duration(milliseconds: 200),
                  activeColor: Color.fromARGB(255, 52, 152, 219),
                  width: SizeConfig.blockSizeHorizontal * 5.43,
                  height: SizeConfig.blockSizeHorizontal * 3.413,
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
                _diffText,
                SizedBox(width: SizeConfig.blockSizeHorizontal * 28.44),
                FlutterSwitch(
                  duration: Duration(milliseconds: 200),
                  activeColor: Color.fromARGB(255, 52, 152, 219),
                  width: SizeConfig.blockSizeHorizontal * 5.43,
                  height: SizeConfig.blockSizeHorizontal * 3.413,
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
          child: _cancelText,
        ),
        TextButton(
          onPressed: () {
            widget._save = true;
            Navigator.pop(context);
          },
          child: _saveText,
        ),
      ],
    );
  }
}
