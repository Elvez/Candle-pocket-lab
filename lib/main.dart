import 'package:flutter/material.dart';
import 'HomeScreen/homescreen.dart';
import 'MultimeterScreen/multimeter.dart';
import 'OscilloscopeScreen/oscilloscope.dart';
import 'PowerSourceScreen/powerSource.dart';
import 'WaveGeneratorScreen/waveGenerator.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(HomeScreen());
  });
}
