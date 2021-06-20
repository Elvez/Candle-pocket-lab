import 'package:flutter/material.dart';

/*
 * Class name - HeaderBar
 * 
 * Usage - It is just a simple colorful bar with title text. 
 */
class HeaderBar extends StatelessWidget {
  //Title
  final String title;

  //Colors in ARGB
  final int aL, rL, gL, bL, aR, rR, gR, bR;

  //Constructor
  HeaderBar(this.title, this.aL, this.rL, this.gL, this.bL, this.aR, this.rR,
      this.gR, this.bR);
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Center(
        child: Text(
          title,
          textDirection: TextDirection.ltr,
          style: TextStyle(
              fontSize: 30.0,
              color: Color.fromARGB(255, 58, 58, 58),
              fontWeight: FontWeight.normal,
              fontFamily: 'Ropa Sans'),
        ),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(aL, rL, gL, bL),
            Color.fromARGB(aR, rR, gR, bR)
          ],
        ),
      ),
      margin: const EdgeInsets.only(top: 15),
      alignment: Alignment.topCenter,
    );
  }
}
