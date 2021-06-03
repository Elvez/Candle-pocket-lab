import 'package:flutter/material.dart';
import 'package:candle_pocketlab/Settings/settings.dart';

class HomeScreenTile extends StatelessWidget {
  final double borderRad = 10;
  final String tileName;
  final _tileColor;
  final _tileImage;

  HomeScreenTile(this.tileName, this._tileColor, this._tileImage);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[800], width: 2),
            gradient: LinearGradient(colors: [
              Color.fromARGB(
                  150, _tileColor.red, _tileColor.green, _tileColor.blue),
              Color.fromARGB(
                  255, _tileColor.red, _tileColor.green, _tileColor.blue)
            ]),
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
