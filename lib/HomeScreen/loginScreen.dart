import 'package:candle_pocketlab/Device/connectScreen.dart';
import 'package:flutter/material.dart';
import 'package:candle_pocketlab/Settings/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  //Firebase instance
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  //Loading screen state
  bool _isSigningIn = false;

  //Google instance
  final googleSignIn = new GoogleSignIn();

  //Background gradient
  final Decoration _decoration = new BoxDecoration(color: Colors.white);

  //Alignment
  final _alignment = CrossAxisAlignment.start;

  //Heading text "Hello there"
  final _header = new Container(
    padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
    child: Text(
      'Just\nOne\nsmall\nstep!',
      style: TextStyle(
          color: Colors.grey[800],
          fontSize: 80.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Ropa Sans'),
    ),
  );

  //Sign-in with google text
  final _googleSignInText = new Text(
    'Sign in with Google.',
    style:
        TextStyle(color: Colors.black, fontFamily: 'Ropa Sans', fontSize: 20),
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
                        padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 5,
                            left: SizeConfig.blockSizeHorizontal * 10,
                            right: SizeConfig.blockSizeHorizontal * 10),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: SizeConfig.blockSizeVertical * 12),

                            //Sign-in with google button
                            new Container(
                                height: SizeConfig.blockSizeVertical * 6,
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
                                          SizedBox(
                                              width: SizeConfig
                                                      .blockSizeHorizontal *
                                                  5)
                                        ],
                                      ),
                                    ),
                                  ),
                                )),

                            SizedBox(height: 10),
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
