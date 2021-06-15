import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'HomeScreen/splashScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MaterialApp(
      home: SplashScreen(),
    ));
  });
}
