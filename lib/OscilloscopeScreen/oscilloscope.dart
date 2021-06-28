import 'package:flutter/material.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/services.dart';
import 'package:candle_pocketlab/Settings/settings.dart';
import 'package:candle_pocketlab/OscilloscopeScreen/channelTool.dart';
import 'package:candle_pocketlab/OscilloscopeScreen/graphOpsTool.dart';
import 'package:candle_pocketlab/OscilloscopeScreen/xyTool.dart';
import 'package:candle_pocketlab/OscilloscopeScreen/wavegenOSc.dart';
import 'package:candle_pocketlab/Device/connectScreen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'dart:math';

class OscilloscopeScreen extends StatefulWidget {
  //Channel setup dialog instance
  final channelSetup = new ChannelDialog();

  //Graph setup dialog instance
  final graphSetup = new XYDialog();

  //Operation dialog instance
  final operationHandeler = new OpDialog();

  //Wave generator dialog instance
  final waveGenerator = new WGDialog();

  //Fix bug for scren orientation
  bool bugFix = true;

  //chTool data
  double _rangeCh1 = 3.3;
  double _rangeCh2 = 3.3;
  bool ch1Active = false;
  bool ch2Active = false;

  //xyTool data
  color ch1 = color.yellow;
  color ch2 = color.red;
  var xAxis = new XGraphData(100.0, timeUnit.milli);
  var yAxis = new YGraphData(5.0, voltUnit.volt);

  //OPtool data
  bool _isFT = false;
  bool _isDiff = false;

  //WGtool data
  double _amplitude = 3.3;
  double _period = 100;
  int _waveType = 1;

  //Plot values

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

  //Tool area margin
  final _toolMargin = new EdgeInsets.only(left: 7, right: 7, top: 7, bottom: 7);

  //Graph border
  final _graphDecoration = new BoxDecoration(
      border: Border.all(color: Color.fromARGB(150, 30, 87, 125), width: 1.2),
      borderRadius: BorderRadius.all(Radius.circular(10)));

  //Tool area border
  final _toolDecoration = new BoxDecoration(
      border: Border.all(color: Color.fromARGB(150, 30, 87, 125), width: 1.2),
      borderRadius: BorderRadius.all(Radius.circular(10)));

  //Tools alignment
  final _toolAlignment = MainAxisAlignment.spaceEvenly;

  //Channel tool decoration
  final _chToolDecoration = new BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      gradient: LinearGradient(colors: [
        Color.fromARGB(150, 52, 152, 199),
        Color.fromARGB(255, 52, 152, 199)
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter));

  //Channel tool text
  final _chToolText = new Text("Ch",
      style: TextStyle(
          fontFamily: 'Ropa Sans', fontSize: 50, color: Colors.white));

  //Graph tool decoration
  final _xyToolDecoration = new BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      gradient: LinearGradient(colors: [
        Color.fromARGB(110, 82, 152, 199),
        Color.fromARGB(255, 82, 152, 199)
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter));

  //Graph tool text
  final _xyToolText = new Text("XY",
      style: TextStyle(
          fontFamily: 'Ropa Sans', fontSize: 50, color: Colors.white));

  //Operations tool decoration
  final _opToolDecoration = new BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      gradient: LinearGradient(colors: [
        Color.fromARGB(130, 52, 192, 199),
        Color.fromARGB(255, 52, 192, 199)
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter));

  //Operations tool text
  final _opToolText = Text("Op",
      style: TextStyle(
          fontFamily: 'Ropa Sans', fontSize: 50, color: Colors.white));

  //Wave generator tool decoration
  final _wgToolDecoration = new BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      gradient: LinearGradient(
          colors: [Colors.red[200], Colors.red[400]],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter));

  //Wave generator tool text
  final _wgToolText = new Text("W",
      style: TextStyle(
          fontFamily: 'Ropa Sans', fontSize: 50, color: Colors.white));

  //Back button icon
  final _backIcon =
      new Icon(Icons.arrow_back_ios, color: Color.fromARGB(255, 52, 152, 199));

  //Back button shape
  final _backShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)));

  //Graph plot data
  var _ch1Data = new GraphData();
  var _ch2Data = new GraphData();

  Widget build(BuildContext context) {
    //Set default range for both channels
    _ch1Data.setRange(widget.xAxis.range);
    _ch2Data.setRange(widget.xAxis.range);

    //Get screen sizes
    SizeConfig().init(context);
    return MaterialApp(
        home: Scaffold(
            //Avoid resize on keyboard pulled.
            resizeToAvoidBottomInset: false,

            //Body
            body: Container(
                child: Row(
              children: [
                new Stack(
                  children: <Widget>[
                    new Container(
                        margin: _graphMargin,
                        width: SizeConfig.blockSizeHorizontal * 85,
                        height: SizeConfig.blockSizeHorizontal * 100,
                        decoration: _graphDecoration,
                        child: new Center(
                            child: Container(
                                child: SfCartesianChart(
                          borderColor: Colors.grey,
                          primaryXAxis: NumericAxis(
                              visibleMinimum: 0,
                              visibleMaximum: widget.xAxis.range,
                              interval: widget.xAxis.range / 10,
                              placeLabelsNearAxisLine: false,
                              crossesAt: 0,
                              axisLine:
                                  AxisLine(color: Colors.grey[600], width: 2)),
                          primaryYAxis: NumericAxis(
                              visibleMaximum: widget.yAxis.range,
                              visibleMinimum: (0 - widget.yAxis.range),
                              axisLine:
                                  AxisLine(color: Colors.grey[600], width: 2)),
                        )))),

                    //Back button
                    new Container(
                      margin: _backButtonMargin,
                      width: 40,
                      height: 40,
                      child: FloatingActionButton(
                        child: _backIcon,
                        backgroundColor: Colors.white,
                        shape: _backShape,
                        elevation: 1,
                        onPressed: () {
                          SystemChrome.setPreferredOrientations(
                              [DeviceOrientation.portraitUp]);
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),

                //Tool box
                new Container(
                  margin: _toolMargin,
                  width: SizeConfig.blockSizeVertical * 20,
                  height: SizeConfig.blockSizeHorizontal * 100,
                  decoration: _toolDecoration,
                  child: new Column(
                    mainAxisAlignment: _toolAlignment,
                    children: [
                      //Channel setup tool
                      new InkWell(
                          onTap: () {
                            widget.bugFix = false;
                            showDialog<void>(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) => widget.channelSetup)
                                .then((value) {
                              widget.bugFix = true;

                              //Get channel settings.
                              getChData();
                            });
                          },
                          child: new Container(
                              width: SizeConfig.blockSizeVertical * 18,
                              height: SizeConfig.blockSizeHorizontal * 8.0,
                              decoration: _chToolDecoration,
                              child: new Center(child: _chToolText))),

                      //Graph setup tool
                      new InkWell(
                          onTap: () {
                            widget.bugFix = false;
                            showDialog<void>(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) => widget.graphSetup)
                                .then((value) {
                              widget.bugFix = true;

                              //Get graph settings
                              getGraphData();
                            });
                          },
                          child: new Container(
                              width: SizeConfig.blockSizeVertical * 18,
                              height: SizeConfig.blockSizeHorizontal * 8.0,
                              decoration: _xyToolDecoration,
                              child: new Center(child: _xyToolText))),

                      //Operations tool
                      new InkWell(
                          onTap: () {
                            widget.bugFix = false;
                            showDialog<void>(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) =>
                                    widget.operationHandeler).then((value) {
                              widget.bugFix = true;

                              //Get operation tool settings
                              getOPdata();
                            });
                          },
                          child: new Container(
                              width: SizeConfig.blockSizeVertical * 18,
                              height: SizeConfig.blockSizeHorizontal * 8.0,
                              decoration: _opToolDecoration,
                              child: new Center(child: _opToolText))),

                      //Wave generator tool
                      new InkWell(
                          onTap: () {
                            widget.bugFix = false;
                            showDialog<void>(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) => widget.waveGenerator)
                                .then((value) {
                              widget.bugFix = true;

                              //Get wave generator settings
                              getWaveData();
                            });
                          },
                          child: new Container(
                              width: SizeConfig.blockSizeVertical * 18,
                              height: SizeConfig.blockSizeHorizontal * 8.0,
                              decoration: _wgToolDecoration,
                              child: new Center(child: _wgToolText))),

                      //Graph start/stop button
                      new InkWell(
                        onTap: () {
                          setState(() {
                            _graphState = !_graphState;
                          });
                          setOscilloscope(_graphState);
                        },
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        splashColor: Colors.black.withAlpha(50),
                        child: new Container(
                          width: SizeConfig.blockSizeVertical * 18,
                          height: SizeConfig.blockSizeHorizontal * 8.0,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),

                              //Set gradient according to graph state
                              gradient: LinearGradient(
                                  colors: _graphState
                                      ? [
                                          Color.fromARGB(150, 175, 46, 255),
                                          Color.fromARGB(255, 175, 46, 255)
                                        ]
                                      : [
                                          Color.fromARGB(150, 0, 232, 62),
                                          Color.fromARGB(255, 0, 232, 62)
                                        ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter)),
                          child: new Center(
                            //Set icon according to graph state
                            child: _graphState
                                ? new Icon(Icons.stop_rounded,
                                    color: Colors.white, size: 50)
                                : new Icon(Icons.play_arrow_rounded,
                                    color: Colors.white, size: 50),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ))));
  }

  /*
   * Initialize
   * 
   * This function is called at the constructor, sets default values. 
   */
  void initState() {
    //Set default x axis range to 100ms
    widget.xAxis.range = 100;
    widget.xAxis.unit = timeUnit.milli;

    //Set default y axis range to 5.0V
    widget.yAxis.range = 5.0;
    widget.yAxis.unit = voltUnit.volt;

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
      widget.graphSetup.setSave(false);
      widget.channelSetup.setSave(false);
      widget.operationHandeler.setSave(false);
      Navigator.pop(context);
      return true;
    }
    return true;
  }

  /*
   * Get channel settings
   *
   * This function saves channel settings data if the dialog was closed with the 'save' button.
   *
   * @param none
   * @return none
   */
  void getChData() {
    if (widget.channelSetup.isSaved()) {
      //Dialog closed with save button

      //Save data
      widget._rangeCh1 = widget.channelSetup.getRange1();
      widget.ch1Active = widget.channelSetup.getChannelState(1);
      widget._rangeCh2 = widget.channelSetup.getRange2();
      widget.ch2Active = widget.channelSetup.getChannelState(2);
    } else {
      //Dialog closed with cancel button

      //Replace data with previous
      widget.channelSetup.setChState(1, widget.ch1Active);
      widget.channelSetup.setChState(2, widget.ch2Active);
      widget.channelSetup.setRange(widget._rangeCh1, 1);
      widget.channelSetup.setRange(widget._rangeCh2, 2);
    }
  }

  /*
   * Get Wave generator settings
   *
   * This function saves wave generator settings if the dialog was closed with the save button.
   *
   * @param none
   * @return none
   */
  void getWaveData() {
    if (widget.waveGenerator.getState()) {
      //Dialog closed with save button

      //Save data
      widget._amplitude = widget.waveGenerator.getAmp();
      widget._period = widget.waveGenerator.getPeriod();
      widget._waveType = widget.waveGenerator.getWaveType();

      //Send wave generator command
      candle.sendWGCommand(1, "H", widget._waveType, widget._period.toString(),
          widget._amplitude.toString());

      //Set wave state
      widget.waveGenerator.isWaveOn = !widget.waveGenerator.isWaveOn;
    } else {
      //Dialog closed with cancel button

      //Replace data with previous
      widget.waveGenerator.setAmp(widget._amplitude);
      widget.waveGenerator.setPeriod(widget._period);
      widget.waveGenerator.setWave(widget._waveType);
    }
  }

  /*
   * Get graph settings
   *
   * This function saves graph settings if the dialog was closed with the save button.
   *
   * @param none
   * @return none
   */
  void getGraphData() {
    setState(() {
      if (widget.graphSetup.isSaved()) {
        //Dialog closed with save button

        //Save data
        widget.ch1 = widget.graphSetup.getChannelColor(1);
        widget.ch2 = widget.graphSetup.getChannelColor(2);
        widget.xAxis = widget.graphSetup.getXData();
        widget.yAxis = widget.graphSetup.getYData();
      } else {
        //Dialog closed with cancel button

        //Replace data with previous
        widget.graphSetup.setColor(widget.ch1, widget.ch2);
        widget.graphSetup.setData(widget.xAxis, widget.yAxis);
      }
      _ch1Data.setRange(widget.xAxis.range);
      _ch2Data.setRange(widget.xAxis.range);
    });
  }

  /*
   * Get operation settings
   *
   * This function saves operation settings if the dialog was cloed with the save button.
   *
   * @param none
   * @return none
   */
  void getOPdata() {
    if (widget.operationHandeler.isSaved()) {
      //Dialog closed with save button

      //Save data
      widget._isFT = widget.operationHandeler.getFT();
      widget._isDiff = widget.operationHandeler.getDiff();
    } else {
      //Dialog closed with cancel button

      //Replace data with previous
      widget.operationHandeler.setDiff(widget._isDiff);
      widget.operationHandeler.setFT(widget._isFT);
    }
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
    if (state) {
      //Send start command to device
      if (widget.ch1Active) {
        //Send channel-one state HIGH
        candle.sendOSCCommmand(
            1, "H", widget.xAxis.range.toString(), widget.xAxis.unit);
      }
      if (widget.ch2Active) {
        //Send channel-two state HIGH
        candle.sendOSCCommmand(
            2, "H", widget.xAxis.range.toString(), widget.xAxis.unit);
      }
    } else {
      //Send both channels state LOW
      candle.sendOSCCommmand(
          1, "L", widget.xAxis.range.toString(), widget.xAxis.unit);
      candle.sendOSCCommmand(
          2, "L", widget.xAxis.range.toString(), widget.xAxis.unit);
    }
  }
}

class GraphData {
  var xData = List<double>.filled(100, 0);
  var yData = List<double>.filled(100, 0);

  /*
   * Fill X axis values
   * 
   * Fills x axis values seperated by space, hundred values are filles irrespective of the range.
   * 
   * @params : Range(int)
   * @return : none 
   */
  void setRange(double _range) {
    xData[0] = 0;
    double _space = _range / 100;

    for (int iter = 1; iter < 100; iter++) {
      xData[iter] = xData[iter - 1] + _space;
    }
  }
}
