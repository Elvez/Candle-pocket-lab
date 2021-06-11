import 'package:flutter/material.dart';
import 'HomeScreen/homescreen.dart';
import 'package:flutter/services.dart';
import 'Device/connectScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MaterialApp(
      home: HomeScreen(),
    ));
  });
}
