import 'package:flutter/material.dart';
import 'package:candle_pocketlab/Widgets/header.dart';
import 'package:candle_pocketlab/Widgets/homeScreenTile.dart';
import 'package:candle_pocketlab/MultimeterScreen/multimeter.dart';
import 'package:candle_pocketlab/OscilloscopeScreen/oscilloscope.dart';
import 'package:candle_pocketlab/PowerSourceScreen/powerSource.dart';
import 'package:candle_pocketlab/WaveGeneratorScreen/waveGenerator.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatelessWidget {
  //Private variables
  final double _barHeight = 50;
  final int _marginColor = 13948116;
  final _oscTile = new HomeScreenTile(
      "Oscilloscope",
      TileColor(52, 152, 199),
      new Image.asset('images/osc.png',
          alignment: Alignment.bottomLeft, width: 100, height: 88));
  final _mulTile = new HomeScreenTile(
      "Multimeter",
      TileColor(52, 152, 199),
      new Image.asset('images/multimeter.png',
          alignment: Alignment.bottomLeft, width: 90, height: 77));
  final _wgTile = new HomeScreenTile(
      "Wave generator",
      TileColor(52, 152, 199),
      new Image.asset('images/waveIcon.png',
          alignment: Alignment.bottomLeft, width: 85, height: 82));
  final _psTile = new HomeScreenTile(
      "Power source",
      TileColor(52, 152, 199),
      new Image.asset('images/powerSource.png',
          alignment: Alignment.bottomLeft, width: 62, height: 69));
  //-----------------
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: Color.fromARGB(255, 52, 152, 199)),
            onPressed: () {
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
          new HeaderBar("Pocket lab", 75, 52, 152, 199, 125, 52, 152, 199),
          Container(
              margin: EdgeInsets.only(top: 15),
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: InkWell(
                      splashColor: Colors.black.withAlpha(50),
                      child: _oscTile,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MyRoute(
                                builder: (context) => OscilloscopeScreen()));
                        SystemChrome.setPreferredOrientations(
                            [DeviceOrientation.landscapeLeft]);
                      }))),
          Container(
              margin: EdgeInsets.only(top: 15),
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: InkWell(
                      splashColor: Colors.black.withAlpha(50),
                      child: _mulTile,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      onTap: () {
                        Navigator.push(context,
                            MyRoute(builder: (context) => MultimeterScreen()));
                      }))),
          Container(
              margin: EdgeInsets.only(top: 15),
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: InkWell(
                      splashColor: Colors.black.withAlpha(50),
                      child: _wgTile,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MyRoute(
                                builder: (context) => WaveGeneratorScreen()));
                      }))),
          Container(
              margin: EdgeInsets.only(top: 15),
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: InkWell(
                      splashColor: Colors.black.withAlpha(50),
                      child: _psTile,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      onTap: () {
                        Navigator.push(context,
                            MyRoute(builder: (context) => PowerSourceScreen()));
                      })))
        ]),
      ),
    ));
  }
}

class MyRoute extends MaterialPageRoute {
  MyRoute({WidgetBuilder builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => Duration(milliseconds: 200);
}
