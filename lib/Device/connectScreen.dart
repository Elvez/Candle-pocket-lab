import 'package:flutter/material.dart';
import 'package:candle_pocketlab/HomeScreen/homescreen.dart';
import 'package:candle_pocketlab/Device/device.dart';

//Global bluetooth device instance
Device candle = Device();

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
    child: Image.asset('images/deviceIcon.png'),
  );

  //Text "Connect device!"
  final _connectText = new Text("Connect device!",
      style: TextStyle(fontFamily: 'Ropa Sans', fontSize: 30));

  //Connect button icon
  final _connectIcon = new Icon(Icons.arrow_forward_ios,
      color: Color.fromARGB(255, 52, 152, 199));

  Widget build(BuildContext context) {
    candle.initDevice();
    return MaterialApp(
        home: Scaffold(
      backgroundColor: _bgColor,
      body: isConnecting
          ? _working
          : Column(
              children: [
                SizedBox(height: 80),
                _deviceIcon,
                SizedBox(height: 150),
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
                                    builder: (context) => ErrorDialog());
                              }
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) => BluetoothError());
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

/* Error dialog for if bluetooth is not turned on.
 * No methods
 */
class BluetoothError extends StatelessWidget {
  //Title Text
  final _title = new Text("Error", style: TextStyle(fontFamily: 'Ropa Sans'));

  //Body text
  final _bodyText = new Text("Would you like to turn on bluetooth?",
      style: TextStyle(fontFamily: 'Ropa Sans'));

  //Ok button text
  final _okButton = new Text("Ok", style: TextStyle(fontFamily: 'Ropa Sans'));
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _title,
      content: _bodyText,
      actions: [
        TextButton(
          child: _okButton,
          onPressed: () {
            candle.enableBluetooth();
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}

/* Error dialog for if device cannot connect.
 * No methods
 */
class ErrorDialog extends StatelessWidget {
  //Title text
  final _title = new Text("Error", style: TextStyle(fontFamily: 'Ropa Sans'));

  //Body text
  final _bodyText = new Text(
      "Device cannot connect, try pairing with the device.",
      style: TextStyle(fontFamily: 'Ropa Sans'));

  //Ok button text
  final _okButton = new Text("Ok", style: TextStyle(fontFamily: 'Ropa Sans'));

  Widget build(BuildContext context) {
    return AlertDialog(
      title: _title,
      content: _bodyText,
      actions: [
        TextButton(
          child: _okButton,
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
