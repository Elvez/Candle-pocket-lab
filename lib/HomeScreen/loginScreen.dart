import 'package:flutter/material.dart';
import 'package:candle_pocketlab/Settings/settings.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  //Background gradient
  final Decoration _decoration = new BoxDecoration(
      gradient: LinearGradient(
          colors: [Colors.cyan, Colors.blue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter));

  //Alignment
  final _alignment = CrossAxisAlignment.start;

  //Heading text "Hello there"
  final _header = new Container(
    padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
    child: Text(
      'Hello\nthere!',
      style: TextStyle(
          fontSize: 80.0, fontWeight: FontWeight.bold, fontFamily: 'Ropa Sans'),
    ),
  );

  //Username text field
  final _usernameField = new TextField(
    decoration: InputDecoration(
        labelText: 'Username',
        labelStyle: TextStyle(fontFamily: 'Ropa Sans', color: Colors.black),
        focusedBorder: OutlineInputBorder()),
  );

  //Password text field
  final _passwordField = new TextField(
    decoration: InputDecoration(
        labelText: 'Password ',
        labelStyle: TextStyle(fontFamily: 'Ropa Sans', color: Colors.black),
        focusedBorder: OutlineInputBorder()),
    obscureText: true,
  );

  //Sign-in button
  final _signInButton = new Container(
      height: 50.0,
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        shadowColor: Colors.grey,
        color: Colors.grey[100],
        elevation: 7.0,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.0),
          onTap: signIn,
          child: Center(
            child: Text(
              'Sign-in',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Ropa Sans',
                  fontSize: 20),
            ),
          ),
        ),
      ));

  //Sign-up button
  final _signUpButton = new TextButton(
      onPressed: signUp,
      child: Text("Don't have an account? Sign-up.",
          style: TextStyle(
              color: Colors.black, fontFamily: 'Ropa Sans', fontSize: 15)));

  Widget build(BuildContext context) {
    return new Scaffold(
        body: SingleChildScrollView(
      child: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        decoration: _decoration,
        child: Column(crossAxisAlignment: _alignment, children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[_header],
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  _usernameField,
                  SizedBox(height: 10.0),
                  _passwordField,
                  SizedBox(height: 50.0),
                  _signInButton,
                  SizedBox(height: 10),
                  _signUpButton
                ],
              )),
        ]),
      ),
    ));
  }

  /* Callback for Sign-in button pressed.
   * 
   */
  static void signIn() {}

  /* Callback for Sign-up button pressed.
   * 
   */
  static void signUp() {}
}
