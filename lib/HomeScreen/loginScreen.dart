import 'package:flutter/material.dart';
import 'package:candle_pocketlab/Settings/settings.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: SingleChildScrollView(
      child: Container(
        width: SizeConfig.blockSizeHorizontal * 100,
        height: SizeConfig.blockSizeVertical * 100,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.cyan, Colors.blue],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                      child: Text(
                        'Hello\nthere!',
                        style: TextStyle(
                            fontSize: 80.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Ropa Sans'),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(
                                fontFamily: 'Ropa Sans', color: Colors.black),
                            focusedBorder: OutlineInputBorder()),
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'Password ',
                            labelStyle: TextStyle(
                                fontFamily: 'Ropa Sans', color: Colors.black),
                            focusedBorder: OutlineInputBorder()),
                        obscureText: true,
                      ),
                      SizedBox(height: 50.0),
                      Container(
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
                                  'Sign-in',
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
                      TextButton(
                          onPressed: () {},
                          child: Text("Don't have an account? Sign-up.",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Ropa Sans',
                                  fontSize: 15)))
                    ],
                  )),
            ]),
      ),
    ));
  }
}
