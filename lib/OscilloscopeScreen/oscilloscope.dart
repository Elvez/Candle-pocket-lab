import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/services.dart';
import 'package:candle_pocketlab/Settings/settings.dart';

class OscilloscopeScreen extends StatefulWidget {
  @override
  _OscilloscopeScreenState createState() => _OscilloscopeScreenState();
}

class _OscilloscopeScreenState extends State<OscilloscopeScreen> {
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    Navigator.pop(context);
    return true;
  }

  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
        home: Scaffold(
            body: Container(
                child: Row(
      children: [
        new Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 7, top: 7, bottom: 7),
              width: SizeConfig.blockSizeHorizontal * 85,
              height: SizeConfig.blockSizeHorizontal * 100,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromARGB(150, 30, 87, 125), width: 1.2),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, left: 10),
              width: 40,
              height: 40,
              child: FloatingActionButton(
                child: Icon(Icons.arrow_back_ios,
                    color: Color.fromARGB(255, 52, 152, 199)),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                elevation: 1,
                onPressed: () {
                  SystemChrome.setPreferredOrientations(
                      [DeviceOrientation.portraitUp]);
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 7, right: 7, top: 7, bottom: 7),
          width: 100,
          height: SizeConfig.blockSizeHorizontal * 100,
          decoration: BoxDecoration(
              border: Border.all(
                  color: Color.fromARGB(150, 30, 87, 125), width: 1.2),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 8),
                width: 90,
                height: 86,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(150, 52, 152, 199),
                      Color.fromARGB(255, 52, 152, 199)
                    ])),
              ),
              Container(
                margin: EdgeInsets.only(top: 6),
                width: 90,
                height: 86,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(150, 52, 152, 199),
                      Color.fromARGB(255, 52, 152, 199)
                    ])),
              ),
              Container(
                margin: EdgeInsets.only(top: 6),
                width: 90,
                height: 86,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(150, 52, 152, 199),
                      Color.fromARGB(255, 52, 152, 199)
                    ])),
              ),
              Container(
                margin: EdgeInsets.only(top: 6),
                width: 90,
                height: 86,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(150, 52, 152, 199),
                      Color.fromARGB(255, 52, 152, 199)
                    ])),
              ),
            ],
          ),
        )
      ],
    ))));
  }
}
