import 'package:flutter/material.dart';

class HomeScreenTile extends StatelessWidget {
  final double borderRad = 10;
  final String tileName;
  final _tileColor;
  final _tileImage;

  HomeScreenTile(this.tileName, this._tileColor, this._tileImage);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromARGB(
                  150, _tileColor.red, _tileColor.green, _tileColor.blue),
              Color.fromARGB(
                  255, _tileColor.red, _tileColor.green, _tileColor.blue)
            ]),
            borderRadius: BorderRadius.all(Radius.circular(borderRad))),
        width: 360,
        height: 114,
        child: new Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
              _tileImage,
              Text(tileName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 35,
                      fontFamily: 'Ropa Sans',
                      fontWeight: FontWeight.normal)),
            ])));
  }
}

class TileColor {
  int red;
  int green;
  int blue;
  TileColor(this.red, this.green, this.blue);
}
