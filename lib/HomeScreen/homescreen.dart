import 'package:flutter/material.dart';
import 'package:candle_pocketlab/Widgets/header.dart';
import 'package:candle_pocketlab/Widgets/homeScreenTile.dart';
import 'package:candle_pocketlab/MultimeterScreen/multimeter.dart';
import 'package:candle_pocketlab/OscilloscopeScreen/oscilloscope.dart';
import 'package:candle_pocketlab/PowerSourceScreen/powerSource.dart';
import 'package:candle_pocketlab/WaveGeneratorScreen/waveGenerator.dart';
import 'package:flutter/services.dart';

var scaffoldKey = GlobalKey<ScaffoldState>();

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
        home: HomePage(
            barHeight: _barHeight,
            marginColor: _marginColor,
            oscTile: _oscTile,
            mulTile: _mulTile,
            wgTile: _wgTile,
            psTile: _psTile));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key key,
    @required double barHeight,
    @required int marginColor,
    @required HomeScreenTile oscTile,
    @required HomeScreenTile mulTile,
    @required HomeScreenTile wgTile,
    @required HomeScreenTile psTile,
  })  : _barHeight = barHeight,
        _marginColor = marginColor,
        _oscTile = oscTile,
        _mulTile = mulTile,
        _wgTile = wgTile,
        _psTile = psTile,
        super(key: key);

  final double _barHeight;
  final int _marginColor;
  final HomeScreenTile _oscTile;
  final HomeScreenTile _mulTile;
  final HomeScreenTile _wgTile;
  final HomeScreenTile _psTile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: SideDrawer(),
      appBar: AppBar(
          leading: IconButton(
            icon: Image.asset('images/sideMenu.png'),
            padding: new EdgeInsets.all(10),
            onPressed: () {
              scaffoldKey.currentState.openDrawer();
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
    );
  }
}

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: 340,
            height: 120,
            child: DrawerHeader(
              child: Center(
                child: Row(
                  children: [
                    Image.asset('images/logo.png'),
                    Text(
                      'Candle',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontFamily: "Ropa Sans"),
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color.fromARGB(150, 52, 152, 199),
                Color.fromARGB(255, 52, 152, 199)
              ])),
            ),
          ),
          SizedBox(height: 8),
          ListTile(
            leading: Container(
                margin: EdgeInsets.only(left: 10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('images/connection.png'),
                )),
            title: Container(
              margin: EdgeInsets.only(left: 10),
              child: Text("Connect",
                  style: TextStyle(fontFamily: 'Ropa Sans', fontSize: 20)),
            ),
            onTap: () => {},
          ),
          SizedBox(height: 8),
          ListTile(
            leading: Container(
                margin: EdgeInsets.only(left: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('images/experiments.png'),
                )),
            title: Container(
              margin: EdgeInsets.only(left: 12),
              child: Text('Experiments',
                  style: TextStyle(fontFamily: 'Ropa Sans', fontSize: 20)),
            ),
            onTap: () => {},
          ),
          SizedBox(height: 8),
          ListTile(
            leading: Container(
                margin: EdgeInsets.only(left: 10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('images/aboutUs.png'),
                )),
            title: Container(
              margin: EdgeInsets.only(left: 10),
              child: Text('About us',
                  style: TextStyle(fontFamily: 'Ropa Sans', fontSize: 20)),
            ),
            onTap: () => {},
          ),
        ],
      ),
    );
  }
}

class MyRoute extends MaterialPageRoute {
  MyRoute({WidgetBuilder builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => Duration(milliseconds: 200);
}
