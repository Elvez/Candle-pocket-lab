import 'package:flutter/material.dart';
import 'package:candle_pocketlab/Widgets/header.dart';
import 'package:candle_pocketlab/Widgets/wgEdit.dart';

/*
 * Class name - WaveGeneratorScreen
 * 
 * Usage - This class is the UI of Wave generator screen 
 * 
 * @members : Source tiles
 * @methods : none
 */
class WaveGeneratorScreen extends StatefulWidget {
  @override
  _WaveGeneratorScreenState createState() => _WaveGeneratorScreenState();
}

class _WaveGeneratorScreenState extends State<WaveGeneratorScreen> {
  //Appbar height
  final double _barHeight = 50;

  //Appbar shadow colour
  final int _marginColor = 13948116;

  //Source tiles
  final _sourceTile1 = new WaveGeneratorTile("Source 1", 1);
  final _sourceTile2 = new WaveGeneratorTile("Source 2", 2);

  //Header
  final _header =
      new HeaderBar("Wave generator", 54, 219, 52, 122, 54, 255, 0, 0);

  //Appbar shadow
  final _shadow = new Container(
    color: Colors.grey,
    height: 1.0,
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        //Back button interception
        onWillPop: _onWillPop,

        //UI
        child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: true,

              //Back button
              leading: new IconButton(
                icon: Icon(Icons.arrow_back_ios,
                    color: Color.fromARGB(255, 52, 152, 199)),
                onPressed: () {
                  //Stop any running wave-generators
                  _sourceTile1.stopWG();
                  _sourceTile2.stopWG();

                  //Go back to homescreen
                  Navigator.pop(context);
                },
              ),
              toolbarHeight: _barHeight,
              bottom: PreferredSize(
                  child: _shadow, preferredSize: Size.fromHeight(4.0)),
              backgroundColor: Color(_marginColor),
              elevation: 0),

          //Body
          body: new Container(
            child: new SingleChildScrollView(
              child:
                  new Column(children: [_header, _sourceTile1, _sourceTile2]),
            ),
          ),
        ));
  }

  /*
   * Intercept back button
   * 
   * Sets state of all wave generator sources to 'off' on back press.
   * 
   * @params : none
   * @return : Bool 
   */
  Future<bool> _onWillPop() {
    //Stop any running wave-generators
    _sourceTile1.stopWG();
    _sourceTile2.stopWG();

    Navigator.of(context).pop(true);

    return Future.value(true);
  }
}
