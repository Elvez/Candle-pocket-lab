import 'package:flutter/material.dart';
import 'package:candle_pocketlab/HomeScreen/loginScreen.dart';
import 'package:candle_pocketlab/Settings/settings.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:async';

class SplashScreen extends StatelessWidget {
  //Logo Image
  final Widget _logoImage = new Container(
    padding: const EdgeInsets.all(30.0),
    child: Image.asset('images/logo.png'),
  );

  //Title text
  final Widget _title = new Text('Candle',
      style: TextStyle(
          fontFamily: 'Ropa Sans', fontSize: 40, color: Colors.grey[800]));

  //Background white screen
  final Decoration _decoration = new BoxDecoration(color: Colors.white);

  //Margin from top
  final Widget _margin = new SizedBox(height: 100);

  //Splash screen duration
  final _duration = new Duration(seconds: 2);

  //Transition to Sign-up page
  final _transition = new PageTransition(
      type: PageTransitionType.rightToLeft, child: SignupPage());

  Widget build(BuildContext context) {
    SizeConfig().init(context);

    //Stay on the screen till Timer runs for 2 seconds, then navigate to Sign-up page.
    Timer(_duration, () => Navigator.push(context, _transition));

    return MaterialApp(
      home: Scaffold(
        body: new Center(
          child: new Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight,
              decoration: _decoration,
              child: Column(
                children: [_margin, _logoImage, _title],
              )),
        ),
      ),
    );
  }
}
