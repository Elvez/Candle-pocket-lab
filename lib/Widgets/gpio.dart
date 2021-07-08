import 'package:candle_pocketlab/Settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:candle_pocketlab/Device/connectScreen.dart';

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
  int _pwm = 0;

  PWMTile(this._height, this._width, this.gpio);
  @override
  _PWMTileState createState() => _PWMTileState();
}

class _PWMTileState extends State<PWMTile> {
  //Tile border
  final _decoration = new BoxDecoration(
      border: Border.all(color: Colors.grey[850], width: 2),
      borderRadius: BorderRadius.circular(10));

  //Title font
  final _font = new TextStyle(
      fontFamily: 'Ropa Sans', fontSize: 25, color: Colors.grey[700]);
  @override
  Widget build(BuildContext context) {
    return Container(
      //Size
      width: widget._width,
      height: widget._height,

      //Border
      decoration: _decoration,

      //Body
      child: new Column(
        children: [
          SizedBox(height: SizeConfig.blockSizeVertical * 1),
          new Row(children: [
            SizedBox(width: SizeConfig.blockSizeHorizontal * 3),

            //Source name
            new Text("Source " + widget.gpio.toString(), style: _font),

            SizedBox(width: SizeConfig.blockSizeHorizontal * 52),

            //Toggle switch
            FlutterSwitch(
              activeColor: Color.fromARGB(150, 52, 152, 219),
              width: SizeConfig.blockSizeVertical * 5.43,
              height: SizeConfig.blockSizeVertical * 3.41,
              value: widget.isTurnedOn,
              onToggle: (value) {
                setState(() {
                  widget.isTurnedOn = !widget.isTurnedOn;

                  //Send PWM command
                  setPWM(value);

                  if (!value) {
                    setState(() {
                      widget._pwm = 0;
                    });
                  }
                });
              },
            )
          ]),

          //PWM duty cycle slider
          new Slider(
            value: widget._pwm.toDouble(),
            activeColor: Color.fromARGB(255, 52, 152, 219),
            inactiveColor: Colors.grey,
            min: 0,
            max: 100,
            divisions: 100,
            label: "Duty cycle ${widget._pwm}%",
            onChanged: (value) {
              setState(() {
                widget._pwm = value.round();
              });
            },
          )
        ],
      ),
    );
  }

  /*
   * Send PWM command
   * 
   * Sends PWM command with source, state and duty cycle
   * 
   * @params : State(bool)
   * @return : none 
   */
  void setPWM(bool state) {
    if (state) {
      //Send PWM on command
      candle.sendPWMCommand(widget.gpio, 'H', widget._pwm.toString());
    } else {
      //Send PWM off command
      candle.sendPWMCommand(widget.gpio, 'L', '0');
    }
  }
}
