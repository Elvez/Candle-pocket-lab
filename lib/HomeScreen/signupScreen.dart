import 'package:flutter/material.dart';
import 'package:candle_pocketlab/Settings/settings.dart';
import 'package:candle_pocketlab/HomeScreen/loginScreen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  //Form key for email and password fields
  static var _usernameController = new TextEditingController();
  static var _passwordController = new TextEditingController();
  static var _emailController = new TextEditingController();

  //Background gradient
  final Decoration _decoration = new BoxDecoration(
      gradient: LinearGradient(
          colors: [Colors.green[50], Colors.green],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter));

  //Alignment
  final _alignment = CrossAxisAlignment.start;

  //Heading text "Sign up!"
  final _header = new Container(
    padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
    child: Text(
      'Sign\nUp!',
      style: TextStyle(
          fontSize: 80.0, fontWeight: FontWeight.bold, fontFamily: 'Ropa Sans'),
    ),
  );

  //Username text field
  final _usernameField = new TextFormField(
    controller: _usernameController,
    validator: (input) {
      if (input.isEmpty) {
        return "Enter E-mail";
      }

      return null;
    },
    decoration: InputDecoration(
        labelText: 'Username',
        labelStyle: TextStyle(fontFamily: 'Ropa Sans', color: Colors.black),
        focusedBorder: OutlineInputBorder()),
  );

  //Username text field
  final _emailField = new TextFormField(
    controller: _usernameController,
    validator: (input) {
      if (input.isEmpty) {
        return "Enter E-mail";
      }

      return null;
    },
    decoration: InputDecoration(
        labelText: 'E-mail',
        labelStyle: TextStyle(fontFamily: 'Ropa Sans', color: Colors.black),
        focusedBorder: OutlineInputBorder()),
  );

  //Password text field
  final _passwordField = new TextFormField(
    controller: _passwordController,
    validator: (input) {
      if (input.length < 6) {
        return 'Password should be at least 6 characters.';
      }

      return null;
    },
    decoration: InputDecoration(
        labelText: 'Password ',
        labelStyle: TextStyle(fontFamily: 'Ropa Sans', color: Colors.black),
        focusedBorder: OutlineInputBorder()),
    obscureText: true,
  );

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
      home: Scaffold(
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
                      _emailField,
                      SizedBox(height: 10.0),
                      _passwordField,
                      SizedBox(height: 50.0),

                      //Sign-up button
                      new Container(
                          height: 50.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.grey,
                            color: Colors.grey[100],
                            elevation: 7.0,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20.0),
                              onTap: () {},
                              child: Center(
                                child: Text(
                                  'Sign-up',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Ropa Sans',
                                      fontSize: 20),
                                ),
                              ),
                            ),
                          )),
                      SizedBox(height: 10),

                      //Sign-in button
                      new TextButton(
                          onPressed: login,
                          child: Text("Already have an account? Sign-in.",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Ropa Sans',
                                  fontSize: 15)))
                    ],
                  )),
            ]),
          ),
        ),
      ),
    );
  }

  void login() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SigninPage()));
  }
}