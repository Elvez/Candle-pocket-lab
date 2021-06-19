import 'package:candle_pocketlab/Device/connectScreen.dart';
import 'package:flutter/material.dart';
import 'package:candle_pocketlab/Settings/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:candle_pocketlab/HomeScreen/signupScreen.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

/*
 * Class name - SigninPage
 * 
 * Usage - This class is the login page UI of the app, it is the starting 
 * screen of the app.
 */
class SigninPage extends StatefulWidget {
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  //Form key for email and password fields
  static var _emailController = new TextEditingController();
  static var _passwordController = new TextEditingController();

  //Firebase instance
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  //Loading screen state
  bool _isSigningIn = false;

  //Google instance
  final googleSignIn = new GoogleSignIn();
  //Background gradient
  final Decoration _decoration = new BoxDecoration(
      gradient: LinearGradient(
          colors: [Colors.cyan[50], Colors.blue],
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
  final _emailField = new TextFormField(
    controller: _emailController,
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

  //Or text
  final _or = new Text(
    "Or",
    style: TextStyle(fontFamily: 'Ropa Sans', fontWeight: FontWeight.bold),
  );

  //Sign-in with google text
  final _googleSignInText = new Text(
    'Sign in with Google.',
    style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontFamily: 'Ropa Sans',
        fontSize: 20),
  );

  //Connecting progress indicator
  final _working = new Center(
    child: CircularProgressIndicator(
      strokeWidth: 5,
    ),
  );

  /*
   * Initialize
   *
   * This function is called on the constructor, it check if the user is already logged-in.
   *
   * @param none
   * @return none
   */
  void initState() {
    super.initState();
    this.checkAuthentification();
  }

  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: _isSigningIn
            ? _working
            : SingleChildScrollView(
                child: Container(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.screenHeight,
                  decoration: _decoration,
                  child:
                      Column(crossAxisAlignment: _alignment, children: <Widget>[
                    Container(
                      child: Stack(
                        children: <Widget>[_header],
                      ),
                    ),
                    Container(
                        padding:
                            EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                        child: Column(
                          children: <Widget>[
                            _emailField,
                            SizedBox(height: 10.0),
                            _passwordField,
                            SizedBox(height: 80.0),

                            //Sign-in button
                            new Container(
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
                                        'Log-in',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Ropa Sans',
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                )),

                            SizedBox(height: 15),
                            _or,
                            SizedBox(height: 15),

                            //Sign-in with google button
                            new Container(
                                height: 40.0,
                                width: 250,
                                child: Material(
                                  borderRadius: BorderRadius.circular(20.0),
                                  shadowColor: Colors.grey,
                                  color: Colors.grey[100],
                                  elevation: 7.0,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20.0),
                                    onTap: signInWithGoogle,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Image.asset('images/google.png'),
                                          _googleSignInText,
                                          SizedBox(width: 20)
                                        ],
                                      ),
                                    ),
                                  ),
                                )),

                            SizedBox(height: 10),

                            //Sign-up button
                            new TextButton(
                                onPressed: signUp,
                                child: Text("Don't have an account? Sign-up.",
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

  /*
   * Check authentification
   *
   * This function runs when the app starts, it checks if the user is already signed-in or not.
   * If the user is already signed in, jumps to the connect screen.
   *
   * @param none
   * @return none
   */
  void checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        print(user);
        print(" is Authenticated");

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => StartScreen()));
      }
    });
  }

  /*
   * Log a user in
   *
   * This function tries to log the user in when the "Sign-in" button is pressed.
   *
   * @param none
   * @return none
   */
  void login() async {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      try {
        await _auth.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
      } catch (e) {
        showError(e.message);
        print(e);
      }
    }
  }

  /*
   * Sign in with google
   *
   * This function tries Sign the user in with a google account.
   *
   * @param none
   * @return none
   */
  void signInWithGoogle() async {
    setState(() {
      _isSigningIn = true;
    });
    final user = await googleSignIn.signIn();

    if (user == null) {
      setState(() {
        _isSigningIn = false;
      });
      showError("Cannot sign in with Google.");
      return;
    } else {
      final googleAuth = await user.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      setState(() {
        _isSigningIn = false;
      });
    }
  }

  /*
   * Show error by content
   *
   * This function shows the argument string as an error dialog.
   *
   * @param Error(String)
   * @return none
   */
  void showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error',
                style: TextStyle(fontFamily: 'Ropa Sans', color: Colors.red)),
            content:
                Text(errormessage, style: TextStyle(fontFamily: 'Ropa Sans')),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Future.delayed(Duration.zero, () {
                      Navigator.pop(context);
                    });
                  },
                  child: Text('Ok'))
            ],
          );
        });
  }

  /*
   * Jump to the Sign-up screen.
   *
   * This function makes the app jump to the sign-up screen.
   *
   * @param none
   * @return none
   */
  void signUp() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpScreen()));
  }

  /*
   * Exit app on back pressed
   *
   * This function exits the app when back button is pressed. It is called by the "willPopScope"
   *
   * @param none
   * @return Bool
   */
  Future<bool> _onWillPop() {
    SystemNavigator.pop();
    return Future.value(true);
  }

  set isSigningIn(bool isSigningIn) {
    setState(() {
      _isSigningIn = isSigningIn;
    });
  }
}
