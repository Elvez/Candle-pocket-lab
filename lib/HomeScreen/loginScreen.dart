import 'package:flutter/material.dart';
import 'package:candle_pocketlab/Settings/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class SignupPage extends StatefulWidget {
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  //Form key for email and password fields
  static var _usernameController = new TextEditingController();
  static var _passwordController = new TextEditingController();

  //Firebase instance
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  //Email and password
  String _email, _password;

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

  //Sign-up button
  final _signUpButton = new TextButton(
      onPressed: signUp,
      child: Text("Don't have an account? Sign-up.",
          style: TextStyle(
              color: Colors.black, fontFamily: 'Ropa Sans', fontSize: 15)));

  void initState() {
    super.initState();
    this.checkAuthentification();
  }

  Widget build(BuildContext context) {
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
            onTap: login,
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
                      _passwordField,
                      SizedBox(height: 50.0),
                      _signInButton,
                      SizedBox(height: 10),
                      _signUpButton
                    ],
                  )),
            ]),
          ),
        ),
      ),
    );
  }

  void checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        print(user);
        print(" is Authenticated");
      }
    });
  }

  void login() async {
    if (_usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      try {
        await _auth.signInWithEmailAndPassword(
            email: _usernameController.text,
            password: _passwordController.text);
      } catch (e) {
        showError(e.message);
        print(e);
      }
    }
  }

  void showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  /* Callback for Sign-up button pressed.
   * 
   */
  static void signUp() {}
}
