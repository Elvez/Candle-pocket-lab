import 'package:flutter/material.dart';
import 'package:candle_pocketlab/Widgets/header.dart';
import 'package:candle_pocketlab/Widgets/psEdit.dart';

class PowerSourceScreen extends StatelessWidget {
  //Private variables
  final double _barHeight = 50;
  final int _marginColor = 13948116;
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
            children: [
              new PowerSourceTile("Source 1", 3.3, true),
              new PowerSourceTile("Source 2", 5.0, true)
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          SizedBox(height: 15),
          Row(
            children: [
              new PowerSourceTile("Source 3", 3.3, false),
              new PowerSourceTile("Source 4", 3.3, false)
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ]),
      ),
    ));
  }
}
