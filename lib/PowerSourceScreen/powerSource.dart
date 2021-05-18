import 'package:flutter/material.dart';
import 'package:candle_pocketlab/Widgets/header.dart';
import 'package:candle_pocketlab/Widgets/psEdit.dart';

class PowerSourceScreen extends StatelessWidget {
  //Private variables
  final double _barHeight = 50;
  final int _marginColor = 13948116;
  final _psTile1 = new PowerSourceTile("Source 1", 1, 3.3, true);
  final _psTile2 = new PowerSourceTile("Source 2", 2, 5.0, true);
  final _psTile3 = new PowerSourceTile("Source 3", 3, 3.3, false);
  final _psTile4 = new PowerSourceTile("Source 4", 4, 3.3, false);
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
          HeaderBar("Power source", 54, 219, 112, 52, 54, 255, 199, 0),
          SizedBox(height: 15),
          Row(
            children: [_psTile1, _psTile2],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          SizedBox(height: 15),
          Row(
            children: [_psTile3, _psTile4],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ]),
      ),
    ));
  }
}
