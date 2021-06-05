import 'package:flutter/material.dart';
import 'package:candle_pocketlab/HomeScreen/homescreen.dart';
import 'package:flutter/services.dart';
import 'package:candle_pocketlab/Device/device.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final Device candle = Device();
  bool isConnecting = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Colors.white,
      body: isConnecting
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 5,
              ),
            )
          : Column(
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
                          style:
                              TextStyle(fontFamily: 'Ropa Sans', fontSize: 22)),
                      IconButton(
                          icon: Icon(Icons.arrow_forward_ios,
                              color: Color.fromARGB(255, 52, 152, 199)),
                          onPressed: () async {
                            if (await candle.isBTon()) {
                              setState(() {
                                isConnecting = true;
                              });
                              bool result = await candle.tryConnect();
                              setState(() {
                                isConnecting = false;
                              });
                              if (result) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text("Error",
                                              style: TextStyle(
                                                  fontFamily: 'Ropa Sans')),
                                          content: Text(
                                              "Device cannot connect, try pairing with the device.",
                                              style: TextStyle(
                                                  fontFamily: 'Ropa Sans')),
                                          actions: [
                                            TextButton(
                                              child: Text("Ok",
                                                  style: TextStyle(
                                                      fontFamily: 'Ropa Sans')),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            )
                                          ],
                                        ));
                              }
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text("Error",
                                            style: TextStyle(
                                                fontFamily: 'Ropa Sans')),
                                        content: Text(
                                            "Would you like to turn on bluetooth?",
                                            style: TextStyle(
                                                fontFamily: 'Ropa Sans')),
                                        actions: [
                                          TextButton(
                                            child: Text("Ok",
                                                style: TextStyle(
                                                    fontFamily: 'Ropa Sans')),
                                            onPressed: () {
                                              candle.enableBluetooth();
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      ));
                            }
                          })
                    ],
                  ),
                ),
                Divider()
              ],
            ),
    ));
  }
}
