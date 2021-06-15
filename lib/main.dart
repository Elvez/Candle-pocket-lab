import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'HomeScreen/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    await Firebase.initializeApp();
    runApp(MaterialApp(
      home: SplashScreen(),
    ));
  });
}
