import 'package:flutter/material.dart';
import 'package:candle_pocketlab/Widgets/header.dart';
import 'package:candle_pocketlab/Widgets/multimeterTile.dart';

class MultimeterScreen extends StatefulWidget {
  //Private variables
  @override
  _MultimeterScreenState createState() => _MultimeterScreenState();
}

class _MultimeterScreenState extends State<MultimeterScreen> {
  final double _barHeight = 50;

  final int _marginColor = 13948116;

  var _channelTile1 = MultimeterTile("Channel 1", "v");

  var _channelTile2 = MultimeterTile("Channel 2", "mA");

  // ignore: missing_return
  Future<bool> _onWillPop() {
    _channelTile2.setState(false);
    _channelTile1.setState(false);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios,
                    color: Color.fromARGB(255, 52, 152, 199)),
                onPressed: () {
                  _channelTile1.setState(false);
                  _channelTile2.setState(false);
                  Navigator.pop(context);
                },
              ),
              toolbarHeight: _barHeight,
              bottom: PreferredSize(
                  child: Container(
                    color: Colors.grey,
                    height: 1.0,
                  ),
                  preferredSize: Size.fromHeight(4.0)),
              backgroundColor: Color(_marginColor),
              elevation: 0),
          body: SingleChildScrollView(
            child: Column(children: [
              HeaderBar("Multimeter", 54, 105, 52, 219, 54, 173, 0, 255),
              _channelTile1,
              _channelTile2
            ]),
          ),
        ));
  }
}
