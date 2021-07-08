import 'package:candle_pocketlab/Settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class PWMTile extends StatefulWidget {
  //Tile height
  final double _height;

  //Tile width
  final double _width;

  //GPIO number
  final int gpio;

  //GPIO state
  bool isTurnedOn = false;

  //PWM value
  double _pwm = 0;

  //Mode, false for pwm and true for switch
  bool _mode = false;

  PWMTile(this._height, this._width, this.gpio);
  @override
  _PWMTileState createState() => _PWMTileState();
}

class _PWMTileState extends State<PWMTile> {
  //Tile decoration and border
  final _decoration = new BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.grey[100], Colors.grey[300]],
      ));

  //GPIO icon
  final _icon = new Icon(Icons.circle, color: Colors.grey[800], size: 10);

  //Mode texts
  final String pwmMode = "PWM";
  final String switchMode = "Switch";

  //Mode color
  final _pwmColor = new Color.fromARGB(255, 229, 255, 217);
  final _switchColor = Colors.grey[200];

  //Font
  final _modeFont = new TextStyle(
      color: Colors.grey[850], fontFamily: 'Ropa Sans', fontSize: 22);

  //PWM message
  final String _pwmMessage = "Set duty cycle";
  final String _switchMessage = "Set state";

  @override
  Widget build(BuildContext context) {
    return Container(
        //Width
        width: widget._width,

        //Height
        height: widget._height,

        //Border and fill
        decoration: _decoration,

        //Body
        child: new Row(children: [
          SizedBox(width: SizeConfig.blockSizeHorizontal * 5),

          //GPIO name
          new Text("G" + widget.gpio.toString(),
              style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Ropa Sans',
                  color: Colors.grey[850])),

          SizedBox(width: SizeConfig.blockSizeHorizontal * 8),

          //Three dots
          _icon,
          _icon,
          _icon,

          SizedBox(width: SizeConfig.blockSizeHorizontal * 10),

          //Mode toggler
          Container(
              width: widget._width / 3.5,
              height: widget._height / 2,
              decoration: new BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      widget._mode ? _pwmColor : _switchColor
                    ]),
                border: Border.all(color: Colors.grey, width: 0),
                borderRadius: BorderRadius.circular(15),
              ),
              child: new TextButton(
                  child: Text(widget._mode ? pwmMode : switchMode,
                      style: _modeFont),
                  onPressed: () {
                    setState(() {
                      widget._mode = !widget._mode;
                    });
                  })),

          SizedBox(width: SizeConfig.blockSizeHorizontal * 10),

          //Toggle on/off button
          new FlutterSwitch(
              activeColor: Color.fromARGB(180, 52, 152, 219),
              width: SizeConfig.blockSizeVertical * 5.43,
              height: SizeConfig.blockSizeVertical * 3.41,
              value: widget.isTurnedOn,
              onToggle: (value) {
                if (value)
                  getValue(widget._mode ? _pwmMessage : _switchMessage);
                setState(() {
                  widget.isTurnedOn = value;
                });
              })
        ]));
  }

  /*
   * Value dialog
   * 
   * Shows a dialog and asks for a value
   * 
   * @params : Message (String)
   * @return : none 
   */
  void getValue(String message) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text(message,
                style: TextStyle(fontFamily: 'Ropa Sans', color: Colors.black)),
            content: new Slider(
                label: "${widget._pwm}",
                min: 0,
                max: 100,
                value: widget._pwm,
                onChanged: (value) {
                  setState(() {
                    widget._pwm = value;
                  });
                }),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Future.delayed(Duration.zero, () {
                      Navigator.pop(context);
                    });
                  },
                  child: Text('Ok'))
            ],
          );
        });
  }
}
