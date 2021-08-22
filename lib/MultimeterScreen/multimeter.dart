import 'package:candle_pocketlab/Settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:candle_pocketlab/Widgets/header.dart';
import 'package:candle_pocketlab/Widgets/multimeterTile.dart';

/*
 * Class name - MultimeterScreen
 * 
 * Usage - This class is the UI of multimeter screen.
 * @members : Channel tiles 
 */
class MultimeterScreen extends StatefulWidget {
  @override
  _MultimeterScreenState createState() => _MultimeterScreenState();
}

class _MultimeterScreenState extends State<MultimeterScreen> {
  //Appbar height
  final double _barHeight = 50;

  //Appbar shadow colour
  final int _marginColor = 13948116;

  //Back button icon
  final _backButton =
      new Icon(Icons.arrow_back_ios, color: Color.fromARGB(255, 52, 152, 199));

  //Appbar shadow
  final _shadow = new Container(
    color: Colors.grey,
    height: 1.0,
  );

  //Header
  final _header = HeaderBar("Multimeter", 54, 105, 52, 219, 54, 173, 0, 255);

  @override
  Widget build(BuildContext context) {
    //Debug
    debug("Entered Multimeter screen!");

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: true,

              //Back button
              leading: IconButton(
                icon: _backButton,
                onPressed: () {
                  //Set both channels as 'off' on back press.
                  channelTile1.turnOff();
                  channelTile2.turnOff();

                  //Reset switches
                  isAmmeterOn = false;
                  isVoltmeterOn = false;

                  Navigator.pop(context);
                },
              ),

              //Appbar height
              toolbarHeight: _barHeight,
              bottom: PreferredSize(
                  child: _shadow, preferredSize: Size.fromHeight(4.0)),
              backgroundColor: Color(_marginColor),
              elevation: 0),

          //Body
          body: SingleChildScrollView(
            child: Column(children: [_header, channelTile1, channelTile2]),
          ),
        ));
  }

  /*
   * Set both the channels to state off on navigator back press.
   * 
   * @params : none
   * @return : Bool 
   */
  Future<bool> _onWillPop() {
    //Set both channels as 'off' on navigator back press.
    channelTile1.turnOff();
    channelTile2.turnOff();

    //Reset switches
    isAmmeterOn = false;
    isVoltmeterOn = false;

    Navigator.of(context).pop(true);

    return Future.value(true);
  }
}
