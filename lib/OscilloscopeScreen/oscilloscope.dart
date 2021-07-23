import 'dart:convert';
import 'dart:typed_data';

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
import 'package:candle_pocketlab/Plot/plot.dart';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';

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
  color ch1 = color.black;
  color ch2 = color.red;
  var xAxis = new XGraphData(1000.0, timeUnit.milli);
  var yAxis = new YGraphData(5.0, voltUnit.volt);

  //OPtool data
  bool _isFT = false;
  bool _isDiff = false;

  //WGtool data
  double _phase = 3.3;
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
      borderRadius: BorderRadius.all(Radius.circular(15)));

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
  final _chToolText = new AutoSizeText("Ch",
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
  final _xyToolText = new AutoSizeText("XY",
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
  final _opToolText = AutoSizeText("Op",
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
  final _wgToolText = new AutoSizeText("W",
      style: TextStyle(
          fontFamily: 'Ropa Sans', fontSize: 50, color: Colors.white));

  //Back button icon
  final _backIcon =
      new Icon(Icons.arrow_back_ios, color: Color.fromARGB(255, 52, 152, 199));

  //Back button shape
  final _backShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)));

  //Custom Axis line
  final _axisLine = new AxisLine(color: Colors.grey[400], width: 2);

  //Graph plot data
  var _ch1Data = new GraphData(100, Colors.black);
  var _ch2Data = new GraphData(100, Colors.red);
  String yTitle = "V";
  String xTitle = "ms";

  Widget build(BuildContext context) {
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
                                        animationDuration: 10,
                                        dataSource: _ch1Data.plot,
                                        color: _ch1Data.color,
                                        xValueMapper: (PlotValue _plot, _) =>
                                            _plot.xVal,
                                        yValueMapper: (PlotValue _plot, _) =>
                                            _plot.yVal),

                                    //Channel 2 plot
                                    LineSeries<PlotValue, double>(
                                        animationDuration: 10,
                                        dataSource: _ch2Data.plot,
                                        color: _ch2Data.color,
                                        xValueMapper: (PlotValue _plot, _) =>
                                            _plot.xVal,
                                        yValueMapper: (PlotValue _plot, _) =>
                                            _plot.yVal)
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
                        },
                      ),
                    )
                  ],
                ),

                //Tool box
                new Container(
                  margin: _toolMargin,
                  width: SizeConfig.blockSizeHorizontal * 10,
                  height: SizeConfig.blockSizeVertical * 100,
                  decoration: _toolDecoration,
                  child: new Column(
                    mainAxisAlignment: _toolAlignment,
                    children: [
                      //Channel setup tool
                      new InkWell(
                          onTap: () {
                            //Turn oscilloscope off
                            setOscilloscope(false);

                            widget.bugFix = false;
                            showDialog<void>(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) => widget.channelSetup)
                                .then((value) {
                              widget.bugFix = true;

                              //Get channel settings.
                              getChData();

                              //Turn Oscilloscope on
                              setOscilloscope(_graphState);
                            });
                          },
                          child: new Container(
                              margin: EdgeInsets.only(right: 1, left: 1),
                              width: SizeConfig.blockSizeVertical * 20,
                              height: SizeConfig.blockSizeHorizontal * 8.0,
                              decoration: _chToolDecoration,
                              child: new Center(child: _chToolText))),

                      //Graph setup tool
                      new InkWell(
                          onTap: () {
                            //Turn oscilloscope off
                            setOscilloscope(false);

                            widget.bugFix = false;
                            showDialog<void>(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) => widget.graphSetup)
                                .then((value) {
                              widget.bugFix = true;

                              //Get graph settings
                              getGraphData();

                              //Reset graph plot
                              initGraph();

                              //Turn Oscilloscope on
                              setOscilloscope(_graphState);
                            });
                          },
                          child: new Container(
                              margin: EdgeInsets.only(right: 1, left: 1),
                              width: SizeConfig.blockSizeVertical * 20,
                              height: SizeConfig.blockSizeHorizontal * 8.0,
                              decoration: _xyToolDecoration,
                              child: new Center(child: _xyToolText))),

                      //Operations tool
                      new InkWell(
                          onTap: () {
                            //Turn oscilloscope off
                            setOscilloscope(false);

                            widget.bugFix = false;
                            showDialog<void>(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) =>
                                    widget.operationHandeler).then((value) {
                              widget.bugFix = true;

                              //Get operation tool settings
                              getOPdata();

                              //Turn Oscilloscope on
                              setOscilloscope(_graphState);
                            });
                          },
                          child: new Container(
                              margin: EdgeInsets.only(right: 1, left: 1),
                              width: SizeConfig.blockSizeVertical * 20,
                              height: SizeConfig.blockSizeHorizontal * 8.0,
                              decoration: _opToolDecoration,
                              child: new Center(child: _opToolText))),

                      //Wave generator tool
                      new InkWell(
                          onTap: () {
                            //Turn oscilloscope off
                            setOscilloscope(false);
                            widget.bugFix = false;
                            showDialog<void>(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) => widget.waveGenerator)
                                .then((value) {
                              widget.bugFix = true;

                              //Get wave generator settings
                              getWaveData();

                              //Turn Oscilloscope on
                              setOscilloscope(_graphState);
                            });
                          },
                          child: new Container(
                              margin: EdgeInsets.only(right: 1, left: 1),
                              width: SizeConfig.blockSizeVertical * 20,
                              height: SizeConfig.blockSizeHorizontal * 8.0,
                              decoration: _wgToolDecoration,
                              child: new Center(child: _wgToolText))),

                      //Graph start/stop button
                      new InkWell(
                        onTap: () async {
                          setState(() {
                            _graphState = !_graphState;
                          });

                          //Send oscilloscope command
                          if (candle.isDeviceConnected()) {
                            setOscilloscope(_graphState);
                          }
                        },
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        splashColor: Colors.black.withAlpha(50),
                        child: new Container(
                          width: SizeConfig.blockSizeVertical * 20,
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
   * Channel 1 loop
   * 
   * Loops values in the Channel 1 plot
   * 
   * @params : none
   * @return : none
   */
  void startChannel1() async {
    //Packet receive buffer
    String _packet = "";

    //Parse value for plot
    double _value = 0;

    //Plot iterator
    int iter = 0;

    //Start channel
    if (_graphState) {
      candle.port.inputStream.listen((Uint8List data) {
        //Decode bytes to string
        _packet = ascii.decode(data);

        //print(_packet);
        //Remove tail : Packet received = 1000!, After tail remove = 1000
        _packet = _packet.substring(0, _packet.length - 1);

        //Parse and convert to voltage, MinValue = 0, MaxValue = 4096 | ResultMin = -20.0, ResultMax = 20.0
        _value = double.tryParse(_packet);
        if (_value != null) _value = (_value / 102.4) - 20.0;

        // print(_value);

        // //Update graph
        setState(() {
          _ch1Data.plot[iter] = PlotValue((iter.toDouble() / 10), _value);
        });
        if (iter == 999)
          iter = 0;
        else
          iter++;
      });
    } else {}
  }

  /*
   * Channel 1 loop
   * 
   * Loops values in the Channel 1 plot
   * 
   * @params : none
   * @return : none
   */
  void startChannel2() async {
    //Start channel
    if (_graphState) {
      //TODO: start loop
    } else {}
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

      setState(() {
        //Save data
        widget._rangeCh1 = widget.channelSetup.getRange1();
        widget.ch1Active = widget.channelSetup.getChannelState(1);
        widget._rangeCh2 = widget.channelSetup.getRange2();
        widget.ch2Active = widget.channelSetup.getChannelState(2);

        //if (!widget.ch1Active) _ch1Data.resetPlot();
        //if (!widget.ch2Active) _ch2Data.resetPlot();
      });
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
      widget._phase = widget.waveGenerator.getPhase();
      widget._period = widget.waveGenerator.getPeriod();
      widget._waveType = widget.waveGenerator.getWaveType();

      //Set wave state
      widget.waveGenerator.isWaveOn = !widget.waveGenerator.isWaveOn;

      //Send wave generator command
      widget.waveGenerator.isWaveOn
          ? candle.sendWGCommand(1, "H", widget._waveType,
              widget._period.toString(), widget._phase.toString())
          : candle.sendWGCommand(1, "L", widget._waveType,
              widget._period.toString(), widget._phase.toString());
    } else {
      //Dialog closed with cancel button

      //Replace data with previous
      widget.waveGenerator.setPhase(widget._phase);
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

        //Update graph Xaxis unit
        switch (widget.xAxis.unit) {
          case timeUnit.micro:
            xTitle = "μs";
            break;
          case timeUnit.milli:
            xTitle = "ms";
            break;
          case timeUnit.second:
            xTitle = "s";
            break;
        }

        //Update graph Yaxis unit
        switch (widget.yAxis.unit) {
          case voltUnit.milli:
            yTitle = "mV";
            break;
          case voltUnit.volt:
            yTitle = "V";
            break;
        }

        //Update channel 1 color
        switch (widget.ch1) {
          case color.black:
            _ch1Data.setColor(Colors.black);
            break;
          case color.red:
            _ch1Data.setColor(Colors.red);
            break;
          case color.blue:
            _ch1Data.setColor(Colors.blue);
            break;
          case color.green:
            _ch1Data.setColor(Colors.green);
            break;
        }

        //Update channel 2 color
        switch (widget.ch2) {
          case color.black:
            _ch2Data.setColor(Colors.black);
            break;
          case color.red:
            _ch2Data.setColor(Colors.red);
            break;
          case color.blue:
            _ch2Data.setColor(Colors.blue);
            break;
          case color.green:
            _ch2Data.setColor(Colors.green);
            break;
        }
      } else {
        //Dialog closed with cancel button

        //Replace data with previous
        widget.graphSetup.setColor(widget.ch1, widget.ch2);
        widget.graphSetup.setData(widget.xAxis, widget.yAxis);
      }
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
    //Send start command to device
    if (widget.ch1Active) {
      candle.sendOSCCommand(1, state ? "H" : "L");
    } else {
      candle.sendOSCCommand(1, "L");
    }

    if (widget.ch2Active) {
      candle.sendOSCCommand(2, state ? "H" : "L");
    } else {
      candle.sendOSCCommand(2, "L");
    }
  }

  /*
   * Initialise graph
   * 
   * Initializes graph with current x range, sets plot x values accordingly. 
   * For example if current x range is 10s, plot length will be set to 10,000 values as 
   * for every milli-second there is a sampled ADC value. 
   * 
   * @params : none
   * @return : none 
   */
  void initGraph() {
    if (widget.xAxis.unit == timeUnit.milli) {
      _ch1Data.setPlotLength(widget.xAxis.range.round());
      _ch2Data.setPlotLength(widget.xAxis.range.round());
    } else if (widget.xAxis.unit == timeUnit.second) {
      _ch1Data.setPlotLength((widget.xAxis.range * 1000).toInt());
      _ch2Data.setPlotLength((widget.xAxis.range * 1000).toInt());
    }
  }
}
