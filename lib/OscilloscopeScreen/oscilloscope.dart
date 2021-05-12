import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/services.dart';

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
    return MaterialApp(home: Scaffold(body: Container(child: Row())));
  }
}
