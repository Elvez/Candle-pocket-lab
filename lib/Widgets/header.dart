import 'package:flutter/material.dart';

class HeaderBar extends StatelessWidget {
  final String title;
  final int aL, rL, gL, bL, aR, rR, gR, bR;
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
