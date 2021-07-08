import 'package:flutter/material.dart';
import 'package:candle_pocketlab/Widgets/header.dart';
import 'package:candle_pocketlab/Widgets/gpio.dart';
import 'package:candle_pocketlab/Settings/settings.dart';

/*
 * Class name - PWMScreen
 * 
 * Usage - This class is the UI of the PWM and output screen.
 * 
 * @members : pwm tiles
 * @methods : none
 */
class PWMScreen extends StatelessWidget {
  //Appbar height
  final double _barHeight = 50;

  //Appbar shadow colour
  final int _marginColor = 13948116;

  //Appbar shadow
  final _shadow = new Container(
    color: Colors.grey,
    height: 1.0,
  );

  //Header
  final _header =
      new HeaderBar("PWM Output", 54, 219, 112, 52, 54, 255, 199, 0);

  //PWM tiles
  var _tileG1 = PWMTile(SizeConfig.blockSizeVertical * 10,
      SizeConfig.blockSizeHorizontal * 90, 1);
  var _tileG2 = PWMTile(SizeConfig.blockSizeVertical * 10,
      SizeConfig.blockSizeHorizontal * 90, 2);
  var _tileG3 = PWMTile(SizeConfig.blockSizeVertical * 10,
      SizeConfig.blockSizeHorizontal * 90, 3);
  var _tileG4 = PWMTile(SizeConfig.blockSizeVertical * 10,
      SizeConfig.blockSizeHorizontal * 90, 4);
  var _tileG5 = PWMTile(SizeConfig.blockSizeVertical * 10,
      SizeConfig.blockSizeHorizontal * 90, 5);
  var _tileG6 = PWMTile(SizeConfig.blockSizeVertical * 10,
      SizeConfig.blockSizeHorizontal * 90, 6);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        //Back button interception
        onWillPop: _onWillPop,

        //Home
        child: Scaffold(
          //Appbar
          appBar: AppBar(
              automaticallyImplyLeading: true,

              //Back button
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios,
                    color: Color.fromARGB(255, 52, 152, 199)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),

              //Appbar height and shadow
              toolbarHeight: _barHeight,
              bottom: PreferredSize(
                  child: _shadow, preferredSize: Size.fromHeight(4.0)),
              backgroundColor: Color(_marginColor),
              elevation: 0),

          //Body
          body: SingleChildScrollView(
            child: Column(
              children: [
                _header,
                SizedBox(height: SizeConfig.blockSizeVertical * 1.90),
                _tileG1,
                SizedBox(height: SizeConfig.blockSizeVertical * 1.20),
                _tileG2,
                SizedBox(height: SizeConfig.blockSizeVertical * 1.20),
                _tileG3,
                SizedBox(height: SizeConfig.blockSizeVertical * 1.20),
                _tileG4,
                SizedBox(height: SizeConfig.blockSizeVertical * 1.20),
                _tileG5,
                SizedBox(height: SizeConfig.blockSizeVertical * 1.20),
                _tileG6
              ],
            ),
          ),
        ));
  }

  Future<bool> _onWillPop() {
    return Future.value(true);
  }
}
