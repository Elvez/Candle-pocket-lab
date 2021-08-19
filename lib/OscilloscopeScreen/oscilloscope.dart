import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/services.dart';
import 'package:candle_pocketlab/Settings/settings.dart';
import 'package:candle_pocketlab/Device/deviceUSB.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:candle_pocketlab/Plot/plot.dart';
import 'package:auto_size_text/auto_size_text.dart';

class OscilloscopeScreen extends StatefulWidget {
  //Fix bug for scren orientation
  bool bugFix = true;

  bool chActive = false;

  var xAxis = new XGraphData(MAX_X_RANGE);
  var yAxis = new YGraphData(MAX_Y_RANGE);

  _OscilloscopeScreenState createState() => _OscilloscopeScreenState();
}

class _OscilloscopeScreenState extends State<OscilloscopeScreen> {
  //Graph on/off state
  bool _graphState = false;

  //Free device
  bool turnOff = false;

  //Graph area margin
  final _graphMargin = new EdgeInsets.only(left: 7, top: 7, bottom: 7);

  //Back button margin
  final _backButtonMargin = new EdgeInsets.only(top: 10, left: 10);

  //Graph border
  final _graphDecoration = new BoxDecoration(
      border: Border.all(color: Color.fromARGB(150, 30, 87, 125), width: 1.2),
      borderRadius: BorderRadius.all(Radius.circular(10)));

  //Back button icon
  final _backIcon =
      new Icon(Icons.arrow_back_ios, color: Color.fromARGB(255, 52, 152, 199));

  //Back button shape
  final _backShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)));

  //Play button shape
  final _playShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)));

  //Custom Axis line
  final _axisLine = new AxisLine(color: Colors.grey[400], width: 2);

  //Graph plot data
  var _channelData = new GraphData(Colors.black);
  String yTitle = "V";
  String xTitle = "ms";

  Widget build(BuildContext context) {
    //Debug
    debug("Entered Oscilloscope screen!");

    //Get screen sizes
    SizeConfig().init(context);
    return MaterialApp(
        home: Scaffold(
            //Avoid resize on keyboard pulled.
            resizeToAvoidBottomInset: false,

            //Body
            body: Container(
                child: Row(children: [
              new Stack(children: <Widget>[
                new Container(
                    margin: _graphMargin,
                    width: SizeConfig.blockSizeHorizontal * 98,
                    height: SizeConfig.blockSizeVertical * 100,
                    decoration: _graphDecoration,
                    child: new Center(
                        child: Container(
                            margin: EdgeInsets.only(
                                right: SizeConfig.blockSizeVertical * 1.90),
                            child: SfCartesianChart(
                              borderColor: Colors.white,
                              series: <ChartSeries>[
                                //Channel 1 plot
                                LineSeries<PlotValue, double>(
                                    dataSource: _channelData.plot,
                                    color: _channelData.color,
                                    xValueMapper: (PlotValue _plot, _) =>
                                        _plot.xVal,
                                    yValueMapper: (PlotValue _plot, _) =>
                                        _plot.yVal),
                              ],

                              //X axis customization
                              primaryXAxis: NumericAxis(
                                  labelFormat: '{value} $xTitle',
                                  visibleMinimum: 0,
                                  visibleMaximum: widget.xAxis.range,
                                  interval: widget.xAxis.range / 10,
                                  placeLabelsNearAxisLine: false,
                                  crossesAt: 0,
                                  axisLine: _axisLine),

                              //Y axis customization
                              primaryYAxis: NumericAxis(
                                  interval: widget.yAxis.range / 5,
                                  visibleMaximum: widget.yAxis.range,
                                  visibleMinimum: (0 - widget.yAxis.range),
                                  labelFormat: '{value} $yTitle',
                                  axisLine: _axisLine),
                            )))),

                //Back button
                new Container(
                    margin: _backButtonMargin,
                    width: SizeConfig.blockSizeVertical * 8.0,
                    height: SizeConfig.blockSizeVertical * 8.0,
                    child: FloatingActionButton(
                        child: _backIcon,
                        backgroundColor: Colors.white,
                        shape: _backShape,
                        elevation: 1,
                        onPressed: () {
                          //Free device
                          setOscilloscope(false);

                          SystemChrome.setPreferredOrientations(
                              [DeviceOrientation.portraitUp]);
                          Navigator.pop(context);
                        })),

                //Graph pla/pause button
                new Container(
                    margin: new EdgeInsets.only(
                        top: SizeConfig.blockSizeHorizontal * 44,
                        left: SizeConfig.blockSizeHorizontal * 88),
                    width: SizeConfig.blockSizeVertical * 15.0,
                    height: SizeConfig.blockSizeVertical * 15.0,
                    child: FloatingActionButton(
                        child: new Icon(
                          _graphState
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          size: SizeConfig.blockSizeHorizontal * 8.5,
                          color: _graphState
                              ? Color.fromARGB(255, 52, 152, 199)
                              : Color.fromARGB(255, 152, 52, 100),
                        ),
                        backgroundColor: Colors.white,
                        heroTag: "PlayButton",
                        shape: _playShape,
                        elevation: 2,
                        onPressed: () {
                          setState(() {
                            _graphState = !_graphState;
                          });

                          //Turn On/off oscilloscope
                          setOscilloscope(_graphState);

                          //Start channel
                          if (_graphState) startChannel();
                        }))
              ])
            ]))));
  }

  /*
   * Start Channel Plotting
   * 
   * Starts looping values inside the graph.
   * 
   * @params : none
   * @return : none 
   */
  void startChannel() async {
    //Packet receive buffer
    String _packet = "";

    //Parse value for voltmeter
    double _value = 0;

    //Iterator
    int iter = 0;

    if (candle.isDeviceConnected() && _graphState) {
      candle.port.inputStream.listen((Uint8List data) {
        //Decode bytes to string
        _packet = ascii.decode(data);

        //Remove tail : Packet received = 1000!, After tail remove = 1000
        if (_packet != null && _packet.isNotEmpty) {
          _packet = _packet.substring(0, _packet.length - 1);
        }

        //Parse and convert to voltage, MinValue = 0, MaxValue = 4096 | ResultMin = -20.0, ResultMax = 20.0
        _value = double.tryParse(_packet);
        if (_value != null) _value = (_value / 102.4) - 20.0;
        print(_value);

        setState(() {
          _channelData.plot[iter] = PlotValue(iter.toDouble(), _value);
        });

        if (iter == 99) {
          iter = 0;
        } else {
          iter++;
        }
      });
    }
  }

  /*
   * Initialize
   * 
   * This function is called at the constructor, sets default values. 
   */
  void initState() {
    //Set default x axis range to 100ms
    widget.xAxis.range = MAX_X_RANGE;

    //Set default y axis range to 5.0V
    widget.yAxis.range = MAX_Y_RANGE;

    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  /*
   * Destructor
   * 
   * This function is called when the class is destructed. 
   */
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  /*
   * Back button interceptor
   * TODO : Replace interceptor with WillPopScope 
   */
  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    //Free device
    setOscilloscope(turnOff);

    //If bug fix bool is true, then set orientation to portrait. If bugFix is true then the navigator is used from Osc screen.
    if (widget.bugFix) {
      //Set orientation
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

      Navigator.pop(context);
    } else {
      //Navigator used from Dialog screens.
      widget.bugFix = true;
      Navigator.pop(context);
      return true;
    }
    return true;
  }

  /*
   * Send oscilloscope command
   *
   * This function sends oscilloscope command to the bluetooth device by the Device class instance 'candle'.
   *
   * @param State(bool)
   * @return none
   */
  void setOscilloscope(bool state) {
    //Send start command to device
    if (state) {
      candle.sendOSCCommand(1, "H");
    } else {
      candle.sendOSCCommand(1, "L");
    }
  }
}
