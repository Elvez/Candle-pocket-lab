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

  //Channel 1 Tile
  var _channelTile1 = MultimeterTile("Channel 1", "v");

  //Channel 2 Tile
  var _channelTile2 = MultimeterTile("Channel 2", "mA");

  //Appbar shadow
  final _shadow = new Container(
    color: Colors.grey,
    height: 1.0,
  );

  //Header
  final _header = HeaderBar("Multimeter", 54, 105, 52, 219, 54, 173, 0, 255);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: true,

              //Back button
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios,
                    color: Color.fromARGB(255, 52, 152, 199)),
                onPressed: () {
                  _channelTile1.setState(false);
                  _channelTile2.setState(false);
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
            child: Column(children: [_header, _channelTile1, _channelTile2]),
          ),
        ));
  }

  /*
   * Set both the channels to state off on back press.
   * 
   * @params : none
   * @return : Bool 
   */
  Future<bool> _onWillPop() {
    _channelTile2.setState(false);
    _channelTile1.setState(false);
    Navigator.of(context).pop(true);
  }
}
