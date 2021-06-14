import 'package:candle_pocketlab/Device/connectScreen.dart';
import 'package:flutter/material.dart';
import 'package:candle_pocketlab/HomeScreen/loginScreen.dart';
import 'package:candle_pocketlab/Settings/settings.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:async';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Timer(
        Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft, child: SignupPage())));
    return MaterialApp(
      home: Scaffold(
        body: new Center(
          child: new Container(
              width: SizeConfig.blockSizeHorizontal * 100,
              height: SizeConfig.blockSizeVertical * 100,
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  SizedBox(height: 100),
                  Container(
                    padding: const EdgeInsets.all(30.0),
                    child: Image.asset('images/logo.png'),
                  ),
                  Text('Candle',
                      style: TextStyle(
                          fontFamily: 'Ropa Sans',
                          fontSize: 40,
                          color: Colors.grey[800]))
                ],
              )),
        ),
      ),
    );
  }
}
