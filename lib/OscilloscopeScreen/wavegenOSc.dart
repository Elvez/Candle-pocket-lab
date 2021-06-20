import 'package:flutter/material.dart';
import 'package:candle_pocketlab/Settings/settings.dart';
import 'package:flutter/services.dart';

class WGDialog extends StatefulWidget {
  //Save states
  bool enableSaveP = true;
  bool enableSaveA = true;

  //Generate text
  String actionButton = "Generate";

  //Toggle for wave type
  List<bool> _waveType = [true, false, false];

  //Period text controller
  final period = new TextEditingController(text: "100");

  //Amplitude text controller
  final amplitude = new TextEditingController(text: "5.0");

  //Save state for the settings menu
  bool save = false;

  /*
   * Get save state
   * 
   * Returns true if the settings menu was saved.
   * 
   * @params : none
   * @return : Bool 
   */
  bool getState() {
    return save;
  }

  /*
   * Get Period value
   * 
   * Returns the value of the period of wave.
   * 
   * @params : none
   * @return : double 
   */
  double getPeriod() {
    double per = 0.0;
    per = double.tryParse(period.text);
    return per;
  }

  /*
   * Get Amplitude value
   * 
   * Returns the value of amplitude of the wave.
   * 
   * @params : none
   * @return : double 
   */
  double getAmp() {
    double amp = 0.0;
    amp = double.tryParse(amplitude.text);
    return amp;
  }

  /*
   * Get Wave type
   * 
   * Returns the value of wave type - 
   *    Sine wave - 1
   *    Square wave - 2
   *    Triangle - 3
   * 
   * @params : none
   * @return : int 
   */
  int getWaveType() {
    if (_waveType[0]) {
      return 1;
    }
    if (_waveType[1]) {
      return 2;
    }
    if (_waveType[2]) {
      return 3;
    } else {
      return null;
    }
  }

  /*
   * Set period value
   * 
   * Sets the period value to the passed argument
   * 
   * @params : Period(double)
   * @return : none 
   */
  void setPeriod(double per) {
    period.text = "$per";
  }

  /*
   * Set amplitude value
   * 
   * Sets the amplitude value to the passed argument
   * 
   * @params : Amplitude(double)
   * @return : none 
   */
  void setAmp(double amp) {
    amplitude.text = "$amp";
  }

  /*
   * Set Wave type
   * 
   * Sets the wave type to the passed argument
   * 
   * @params : Wave type(int) [1,2,3]
   * @return : none 
   */
  void setWave(int wave) {
    if (wave == 1) {
      _waveType[0] = true;
      _waveType[1] = false;
      _waveType[2] = false;
    }
    if (wave == 2) {
      _waveType[0] = false;
      _waveType[1] = true;
      _waveType[2] = false;
    }
    if (wave == 3) {
      _waveType[0] = false;
      _waveType[1] = false;
      _waveType[2] = true;
    }
  }

  _WGDialogState createState() => _WGDialogState();
}

class _WGDialogState extends State<WGDialog> {
  //Wave generator text
  final _wgText = new Text("Wave generator",
      style: TextStyle(fontFamily: 'Ropa Sans', fontSize: 25));

  //Amplitude text
  final _ampText = new Text("Amplitude:",
      style: TextStyle(
          fontFamily: 'Ropa Sans',
          fontSize: 20,
          color: Color.fromARGB(255, 74, 74, 74)));

  //Wave text
  final _waveText = new Text("Wave:",
      style: TextStyle(fontFamily: 'Ropa Sans', fontSize: 20));

  //Period text
  final _periodText = new Text("Period:",
      style: TextStyle(
          fontFamily: 'Ropa Sans',
          fontSize: 20,
          color: Color.fromARGB(255, 74, 74, 74)));

  //Sine wave image
  final _sinImg = new Padding(
      padding: const EdgeInsets.all(0),
      child: Image.asset('images/sineWave.png'));

  //Square wave image
  final _sqImg = new Padding(
      padding: const EdgeInsets.all(0),
      child: Image.asset('images/sqWave.png'));

  //Triangle wave image
  final _triangImg = new Padding(
      padding: const EdgeInsets.all(0),
      child: Image.asset('images/triang.png'));

  //Period field decoration
  final _periodDecoration = new BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      border: Border.all(color: Colors.grey, width: 1));

  //Amplitude field decoration
  final _ampDecoration = new BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      border: Border.all(color: Colors.grey, width: 1));

  //Period input decoration
  final _periodInpDecoration = new InputDecoration(
    border: OutlineInputBorder(),
    hintText: "ms",
    contentPadding: EdgeInsets.only(top: 2, right: 5),
  );
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SingleChildScrollView(
        child: AlertDialog(
      title: _wgText,
      content: new Container(
          child: Column(children: [
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _waveText,
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
                children: [_sinImg, _sqImg, _triangImg],
                onPressed: (int newIndex) {
                  setState(() {
                    toggleWave(newIndex);
                  });
                },
                isSelected: widget._waveType,
              ),
            ),
          ],
        ),
        new Container(
            margin: EdgeInsets.only(top: 15),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _periodText,
                  SizedBox(width: 25),
                  Container(
                      child: Container(
                          width: 132,
                          height: 31,
                          decoration: _periodDecoration,
                          margin: EdgeInsets.only(left: 47),
                          child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9.]")),
                                LengthLimitingTextInputFormatter(4)
                              ],
                              autovalidate: true,
                              validator: (value) {
                                validatePeriod(value);
                              },
                              textAlign: TextAlign.right,
                              keyboardType: TextInputType.number,
                              controller: widget.period,
                              decoration: _periodInpDecoration)))
                ])),
        new SizedBox(height: 8),
        new Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ampText,
                SizedBox(width: 25),
                Container(
                  child: Container(
                      width: 132,
                      height: 31,
                      decoration: _ampDecoration,
                      margin: EdgeInsets.only(left: 10),
                      child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                            LengthLimitingTextInputFormatter(4)
                          ],
                          autovalidate: true,
                          validator: (value) {
                            validateAmplitude(value);
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

  /*
   * Toggler for wave type
   */
  void toggleWave(int newIndex) {
    for (int index = 0; index < widget._waveType.length; index++) {
      if (index == newIndex) {
        widget._waveType[index] = true;
      } else {
        widget._waveType[index] = false;
      }
    }
  }

  /*
   * Validator for period input field 
   */
  String validatePeriod(value) {
    if (value == null) {
      widget.enableSaveP = false;
      return 'Invalid';
    } else if (value.isEmpty) {
      widget.enableSaveP = false;
      return 'Invalid';
    } else if (double.tryParse(value) <= 0 || double.tryParse(value) > 3000) {
      widget.enableSaveP = false;
      return 'Invalid';
    } else {
      widget.enableSaveP = true;
      return null;
    }
  }

  /*
   * Validator for period input field 
   */
  String validateAmplitude(value) {
    if (value == null) {
      widget.enableSaveA = false;
      return 'Invalid';
    } else if (value.isEmpty) {
      widget.enableSaveA = false;
      return 'Invalid';
    } else if (double.tryParse(value) <= 0 || double.tryParse(value) > 5.0) {
      widget.enableSaveA = false;
      return 'Invalid';
    } else {
      widget.enableSaveA = true;
      return null;
    }
  }
}
