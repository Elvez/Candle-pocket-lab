import 'package:flutter/material.dart';
import 'package:candle_pocketlab/HomeScreen/homescreen.dart';
import 'package:candle_pocketlab/Device/deviceUSB.dart';
import 'package:candle_pocketlab/Settings/settings.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
    child: new CircularProgressIndicator(
      strokeWidth: 5,
    ),
  );

  //Device image
  final Widget _deviceIcon = new Center(
    child: new Container(child: Image.asset('images/deviceIcon.png')),
  );

  //Text "Connect device!"
  final _connectText = new AutoSizeText("Connect device!",
      style: new TextStyle(fontFamily: 'Ropa Sans', fontSize: 30));

  //Connect button icon
  final _connectIcon = new Icon(Icons.arrow_forward_ios,
      color: Color.fromARGB(255, 52, 152, 199));

  Widget build(BuildContext context) {
    //Debug
    debug("Entered Connect device screen!");

    //Init screen size
    SizeConfig().init(context);
    return MaterialApp(
        home: Scaffold(
            backgroundColor: _bgColor,
            body: isConnecting
                ? _working
                : Column(children: [
                    SizedBox(height: SizeConfig.blockSizeVertical * 10),

                    //USB image
                    _deviceIcon,

                    SizedBox(height: SizeConfig.blockSizeVertical * 12),

                    Divider(),

                    //Connect text and button
                    Padding(
                        padding: EdgeInsets.only(
                            left: SizeConfig.blockSizeVertical * 3,
                            right: SizeConfig.blockSizeVertical * 3,
                            bottom: 3.0,
                            top: 3),
                        child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _connectText,

                              //Connect button
                              new IconButton(
                                  icon: _connectIcon,
                                  onPressed: () async {
                                    //Debug
                                    debug("Trying connection...");

                                    //Try Connect USB
                                    String _result = await candle.tryConnect();

                                    //Device is connected
                                    if (candle.isDeviceConnected()) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeScreen()));
                                    } else {
                                      //Debug
                                      debug(_result);

                                      //Show connection result
                                      showMessage("Info", _result);
                                    }
                                  })
                            ])),

                    Divider()
                  ])));
  }

  /*
   * Show error by content
   *
   * This function shows the argument string as an error dialog.
   *
   * @param Error(String)
   * @return none
   */
  void showMessage(String errorTitle, String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: Text(errorTitle,
                  style:
                      TextStyle(fontFamily: 'Ropa Sans', color: Colors.black)),
              content:
                  Text(errormessage, style: TextStyle(fontFamily: 'Ropa Sans')),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Ok'))
              ]);
        });
  }
}
