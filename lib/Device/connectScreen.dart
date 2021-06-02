import 'package:flutter/material.dart';
import 'package:candle_pocketlab/HomeScreen/homescreen.dart';
import 'package:flutter/services.dart';
import 'package:candle_pocketlab/Device/device.dart';

class StartScreen extends StatelessWidget {
  final Device candle = Device();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 80),
          Padding(
            padding: const EdgeInsets.only(
                top: 100, left: 80, right: 80, bottom: 15),
            child: Image.asset('images/logo.png'),
          ),
          Text("Candle pocket lab",
              style: TextStyle(fontFamily: 'Ropa Sans', fontSize: 40)),
          SizedBox(height: 130),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(
                left: 34.0, right: 34.0, bottom: 3.0, top: 3),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Connect device",
                    style: TextStyle(fontFamily: 'Ropa Sans', fontSize: 22)),
                IconButton(
                    icon: Icon(Icons.arrow_forward_ios,
                        color: Color.fromARGB(255, 52, 152, 199)),
                    onPressed: () {})
              ],
            ),
          ),
          Divider()
        ],
      ),
    ));
  }

  //Public methods

}
