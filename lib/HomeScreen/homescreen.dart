import 'package:flutter/material.dart';
import 'package:candle_pocketlab/Widgets/header.dart';
import 'package:candle_pocketlab/Widgets/homeScreenTile.dart';
import 'package:candle_pocketlab/MultimeterScreen/multimeter.dart';
import 'package:candle_pocketlab/OscilloscopeScreen/oscilloscope.dart';
import 'package:candle_pocketlab/PWM & Output/pwmScreen.dart';
import 'package:candle_pocketlab/WaveGeneratorScreen/waveGenerator.dart';
import 'package:flutter/services.dart';

/*
 * Class name - HomeScreen
 * 
 * Usage - This class is the Home page of the app, it has the tile buttons for,
 *  - Multimeter
 *  - Oscilloscope
 *  - Wave generator
 *  - Power source
 * 
 */
class HomeScreen extends StatelessWidget {
  //App bar height
  final double _barHeight = 50;

  //App bar shadow color
  final int _marginColor = 13948116;

  //Oscilloscope tile
  final _oscTile = new HomeScreenTile(
      "Oscilloscope",
      TileColor(52, 152, 199),
      new Image.asset('images/osc.png',
          alignment: Alignment.bottomLeft, width: 100, height: 88));

  //Multimeter tile
  final _mulTile = new HomeScreenTile(
      "Multimeter",
      TileColor(100, 150, 200),
      new Image.asset('images/multimeter.png',
          alignment: Alignment.bottomLeft, width: 90, height: 77));

  //Wave generator tile
  final _wgTile = new HomeScreenTile(
      "Wave generator",
      TileColor(100, 150, 255),
      new Image.asset('images/waveIcon.png',
          alignment: Alignment.bottomLeft, width: 85, height: 82));

  //Power source tile
  final _psTile = new HomeScreenTile(
      "PWM Output",
      TileColor(100, 100, 255),
      new Image.asset('images/ic.png',
          alignment: Alignment.bottomLeft, width: 62, height: 69));

  //Back button
  final _backButton = new IconButton(
    icon: Icon(Icons.arrow_back_ios, color: Color.fromARGB(255, 52, 152, 199)),
    onPressed: () {
      SystemNavigator.pop();
    },
  );

  //Appbar shadow
  final _shadow = new Container(
    color: Colors.grey,
    height: 1.0,
  );

  //Header bar "Pocket-lab"
  final _header =
      new HeaderBar("Pocket lab", 75, 52, 152, 199, 125, 52, 152, 199);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        //Back button interception
        onWillPop: _onWillPop,

        //UI
        child: Scaffold(
          //App bar
          appBar: AppBar(
              automaticallyImplyLeading: true,
              leading: _backButton,
              toolbarHeight: _barHeight,
              bottom: PreferredSize(
                  child: _shadow, preferredSize: Size.fromHeight(4.0)),
              backgroundColor: Color(_marginColor),
              elevation: 0),

          //Body
          body: SingleChildScrollView(
            child: Column(children: [
              _header,

              //Oscilloscope button
              Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: InkWell(
                          splashColor: Colors.black.withAlpha(50),
                          child: _oscTile,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          onTap: () {
                            Navigator.push(
                                context,
                                MyRoute(
                                    builder: (context) =>
                                        OscilloscopeScreen()));

                            //Change to landscape orientation
                            SystemChrome.setPreferredOrientations(
                                [DeviceOrientation.landscapeLeft]);
                          }))),

              //Multimeter button
              Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: InkWell(
                          splashColor: Colors.black.withAlpha(50),
                          child: _mulTile,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          onTap: () {
                            Navigator.push(
                                context,
                                MyRoute(
                                    builder: (context) => MultimeterScreen()));
                          }))),

              //Wave generator button
              Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: InkWell(
                          splashColor: Colors.black.withAlpha(50),
                          child: _wgTile,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          onTap: () {
                            Navigator.push(
                                context,
                                MyRoute(
                                    builder: (context) =>
                                        WaveGeneratorScreen()));
                          }))),

              //Power source button
              Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: InkWell(
                          splashColor: Colors.black.withAlpha(50),
                          child: _psTile,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          onTap: () {
                            Navigator.push(context,
                                MyRoute(builder: (context) => PWMScreen()));
                          })))
            ]),
          ),
        ));
  }

  /*
   * Exit app on back press
   *
   * This function exits the app on back press.
   *
   * @param none
   * @return Bool
   */
  Future<bool> _onWillPop() {
    SystemNavigator.pop();
    return Future.value(true);
  }
}

class MyRoute extends MaterialPageRoute {
  MyRoute({WidgetBuilder builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => Duration(milliseconds: 200);
}
