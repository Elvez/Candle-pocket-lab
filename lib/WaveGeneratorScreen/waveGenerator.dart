import 'package:flutter/material.dart';
import 'package:candle_pocketlab/Widgets/header.dart';
import 'package:candle_pocketlab/Widgets/wgEdit.dart';

class WaveGeneratorScreen extends StatelessWidget {
  //Private variables
  final double _barHeight = 50;
  final int _marginColor = 13948116;
  final _sourceTile1 = new WaveGeneratorTile("Source 1");
  final _sourceTile2 = new WaveGeneratorTile("Source 2");
  //-----------------
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: new IconButton(
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
      body: new Container(
        child: new SingleChildScrollView(
          child: new Column(children: [
            HeaderBar("Wave generator", 54, 219, 52, 122, 54, 255, 0, 0),
            _sourceTile1,
            _sourceTile2
          ]),
        ),
      ),
    ));
  }
}
