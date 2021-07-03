import 'package:candle_pocketlab/Device/connectScreen.dart';
import 'package:candle_pocketlab/HomeScreen/homescreen.dart';
import 'package:candle_pocketlab/HomeScreen/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

///  Entry point.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //Set default orientation
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    //Initialize Firebase Auth
    await Firebase.initializeApp();
    runApp(MaterialApp(
      home: SigninPage(),
    ));
  });
}
