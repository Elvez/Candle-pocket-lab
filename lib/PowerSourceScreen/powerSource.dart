import 'package:flutter/material.dart';
import 'package:candle_pocketlab/Widgets/header.dart';
import 'package:candle_pocketlab/Widgets/psEdit.dart';

/*
 * Class name - PowerSourceScreen
 * 
 * Usage - This class is the UI of the power source screen.
 * 
 * @members : Power source tiles
 * @methods : none
 */
class PowerSourceScreen extends StatelessWidget {
  //Appbar height
  final double _barHeight = 50;

  //Appbar shadow colour
  final int _marginColor = 13948116;

  //Power source tiles
  final _psTile1 = new PowerSourceTile("Source 1", 1, 3.3, true);
  final _psTile2 = new PowerSourceTile("Source 2", 2, 5.0, true);
  final _psTile3 = new PowerSourceTile("Source 3", 3, 3.3, false);
  final _psTile4 = new PowerSourceTile("Source 4", 4, 3.3, false);

  //Appbar shadow
  final _shadow = new Container(
    color: Colors.grey,
    height: 1.0,
  );

  //Header
  final _header =
      new HeaderBar("Power source", 54, 219, 112, 52, 54, 255, 199, 0);

  //Main axis alignment
  final _alignment = MainAxisAlignment.spaceEvenly;

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
            child: Column(children: [
              _header,
              SizedBox(height: 15),
              Row(
                children: [_psTile1, _psTile2],
                mainAxisAlignment: _alignment,
              ),
              SizedBox(height: 15),
              Row(
                children: [_psTile3, _psTile4],
                mainAxisAlignment: _alignment,
              ),
            ]),
          ),
        ));
  }

  Future<bool> _onWillPop() {
    return Future.value(true);
  }
}
