import 'package:flutter/material.dart';
import 'package:candle_pocketlab/Settings/settings.dart';

/*
 * Class name - HomeScreenTile
 * 
 * Usage - This class is used for the 4 tiles (Oscilloscope, Multimeter, Wave generator, Power source)
 * on the homescreen. 
 */
class HomeScreenTile extends StatelessWidget {
  //Border radius
  final double borderRad = 20;

  //Name of the tile
  final String tileName;

  //Color
  final _tileColor;

  //Image on the tile
  final _tileImage;

  //Constructor
  HomeScreenTile(this.tileName, this._tileColor, this._tileImage);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
        //Gradient
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 0),
            gradient: LinearGradient(colors: [
              Color.fromARGB(
                  100, _tileColor.red, _tileColor.green, _tileColor.blue),
              Color.fromARGB(
                  200, _tileColor.red, _tileColor.green, _tileColor.blue)
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            borderRadius: BorderRadius.all(Radius.circular(borderRad))),
        width: SizeConfig.blockSizeHorizontal * 94,
        height: SizeConfig.blockSizeVertical * 14,
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
