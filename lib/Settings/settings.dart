import 'package:flutter/widgets.dart';

//Plot maximum length
const int MAX_PLOT_LENGTH = 1000;

//Debug mode, turn this off for release
const bool debugEnabled = true;

void debug(String message) {
  if (debugEnabled) print(message);
}

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
  }
}
