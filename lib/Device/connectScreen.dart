import 'package:flutter/material.dart';
import 'package:candle_pocketlab/HomeScreen/homescreen.dart';
import 'package:candle_pocketlab/Device/deviceUSB.dart';
import 'package:candle_pocketlab/Settings/settings.dart';
import 'package:auto_size_text/auto_size_text.dart';

//Global bluetooth device instance
DeviceUSB candle = DeviceUSB();

/* Class name - StartScreen
 * This class is the UI screen class for connect screen.
 *
 */
class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  //isConnecting is true when the app is trying to connect to the device
  bool isConnecting = false;

  //Background color
  final Color _bgColor = Colors.white;

  //Connecting progress indicator
  final _working = new Center(
    child: CircularProgressIndicator(
      strokeWidth: 5,
    ),
  );

  //Device image
  final Widget _deviceIcon = new Center(
    child: Container(child: Image.asset('images/deviceIcon.png')),
  );

  //Text "Connect device!"
  final _connectText = new AutoSizeText("Connect device!",
      style: TextStyle(fontFamily: 'Ropa Sans', fontSize: 30));

  //Connect button icon
  final _connectIcon = new Icon(Icons.arrow_forward_ios,
      color: Color.fromARGB(255, 52, 152, 199));

  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
        home: Scaffold(
      backgroundColor: _bgColor,
      body: isConnecting
          ? _working
          : Column(
              children: [
                SizedBox(height: SizeConfig.blockSizeVertical * 10),
                _deviceIcon,
                SizedBox(height: SizeConfig.blockSizeVertical * 12),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 34.0, right: 34.0, bottom: 3.0, top: 3),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _connectText,
                      IconButton(
                          icon: _connectIcon,
                          onPressed: () async {
                            //TODO: Add USB connect API
                            print(await candle.getDevices());
                          })
                    ],
                  ),
                ),
                Divider()
              ],
            ),
    ));
  }

  /*
   * Show error by content
   *
   * This function shows the argument string as an error dialog.
   *
   * @param Error(String)
   * @return none
   */
  void showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error',
                style: TextStyle(fontFamily: 'Ropa Sans', color: Colors.red)),
            content:
                Text(errormessage, style: TextStyle(fontFamily: 'Ropa Sans')),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Future.delayed(Duration.zero, () {
                      Navigator.pop(context);
                    });
                  },
                  child: Text('Ok'))
            ],
          );
        });
  }
}
