import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/services.dart';
import 'package:candle_pocketlab/Settings/settings.dart';
import 'package:candle_pocketlab/OscilloscopeScreen/channelTool.dart';
import 'package:candle_pocketlab/OscilloscopeScreen/graphOpsTool.dart';
import 'package:candle_pocketlab/OscilloscopeScreen/xyTool.dart';
import 'package:candle_pocketlab/OscilloscopeScreen/wavegenOSc.dart';

class OscilloscopeScreen extends StatefulWidget {
  final channelSetup = new ChannelDialog();
  final graphSetup = new XYDialog();
  final operationHandeler = new OpDialog();
  final waveGenerator = new WGDialog();
  bool bugFix = true;

  //chTool data
  double _rangeCh1 = 3.3;
  double _rangeCh2 = 3.3;
  bool ch1Active = false;
  bool ch2Active = false;
  //------------

  //xyTool data
  color ch1 = color.yellow;
  color ch2 = color.red;
  var xAxis = new XGraphData(100.0, timeUnit.milli);
  var yAxis = new YGraphData(5.0, voltUnit.volt);
  //-----------

  //OPtool data
  bool _isFT = false;
  bool _isDiff = false;
  //-----------

  //WGtool data
  double _amplitude = 5.0;
  double _period = 100;
  int _waveType = 1;
  //-----------

  @override
  _OscilloscopeScreenState createState() => _OscilloscopeScreenState();
}

class _OscilloscopeScreenState extends State<OscilloscopeScreen> {
  bool playPauseState = false;

  @override
  void initState() {
    widget.xAxis.range = 100;
    widget.xAxis.unit = timeUnit.milli;
    widget.yAxis.range = 5.0;
    widget.yAxis.unit = voltUnit.volt;
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (widget.bugFix) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      Navigator.pop(context);
    } else {
      widget.bugFix = true;
      widget.graphSetup.setSave(false);
      widget.channelSetup.setSave(false);
      widget.operationHandeler.setSave(false);
      Navigator.pop(context);
      return true;
    }
    return true;
  }

  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
                child: Row(
              children: [
                new Stack(
                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.only(left: 7, top: 7, bottom: 7),
                      width: SizeConfig.blockSizeHorizontal * 85,
                      height: SizeConfig.blockSizeHorizontal * 100,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromARGB(150, 30, 87, 125),
                              width: 1.2),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: new Center(
                        child: Container(
                          child: SfCartesianChart(
                            primaryXAxis: NumericAxis(crossesAt: 0),
                            primaryYAxis: NumericAxis(crossesAt: 0),
                          ),
                        ),
                      ),
                    ),
                    new Container(
                      margin: EdgeInsets.only(top: 10, left: 10),
                      width: 40,
                      height: 40,
                      child: FloatingActionButton(
                        child: Icon(Icons.arrow_back_ios,
                            color: Color.fromARGB(255, 52, 152, 199)),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
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
                new Container(
                  margin: EdgeInsets.only(left: 7, right: 7, top: 7, bottom: 7),
                  width: SizeConfig.blockSizeVertical * 20,
                  height: SizeConfig.blockSizeHorizontal * 100,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromARGB(150, 30, 87, 125), width: 1.2),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      new InkWell(
                        onTap: () {
                          widget.bugFix = false;
                          showDialog<void>(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => widget.channelSetup)
                              .then((value) {
                            widget.bugFix = true;
                            getChData();
                          });
                        },
                        child: new Container(
                          width: SizeConfig.blockSizeVertical * 18,
                          height: SizeConfig.blockSizeHorizontal * 10.0,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              gradient: LinearGradient(colors: [
                                Color.fromARGB(150, 52, 152, 199),
                                Color.fromARGB(255, 52, 152, 199)
                              ])),
                          child: new Center(
                            child: Text("Ch",
                                style: TextStyle(
                                    fontFamily: 'Ropa Sans',
                                    fontSize: 50,
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                      new InkWell(
                        onTap: () {
                          widget.bugFix = false;
                          showDialog<void>(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => widget.graphSetup)
                              .then((value) {
                            widget.bugFix = true;
                            getGraphData();
                          });
                        },
                        child: new Container(
                          width: SizeConfig.blockSizeVertical * 18,
                          height: SizeConfig.blockSizeHorizontal * 10.0,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              gradient: LinearGradient(colors: [
                                Color.fromARGB(110, 82, 152, 199),
                                Color.fromARGB(255, 82, 152, 199)
                              ])),
                          child: new Center(
                            child: Text("XY",
                                style: TextStyle(
                                    fontFamily: 'Ropa Sans',
                                    fontSize: 50,
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                      new InkWell(
                        onTap: () {
                          widget.bugFix = false;
                          showDialog<void>(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) =>
                                  widget.operationHandeler).then((value) {
                            widget.bugFix = true;
                            getOPdata();
                          });
                        },
                        splashColor: Colors.black.withAlpha(50),
                        child: new Container(
                          width: SizeConfig.blockSizeVertical * 18,
                          height: SizeConfig.blockSizeHorizontal * 10.0,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              gradient: LinearGradient(colors: [
                                Color.fromARGB(130, 52, 192, 199),
                                Color.fromARGB(255, 52, 192, 199)
                              ])),
                          child: new Center(
                            child: Text("Op",
                                style: TextStyle(
                                    fontFamily: 'Ropa Sans',
                                    fontSize: 50,
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                      new InkWell(
                        onTap: () {
                          widget.bugFix = false;
                          showDialog<void>(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => widget.waveGenerator)
                              .then((value) {
                            widget.bugFix = true;
                            getWaveData();
                          });
                        },
                        child: new Container(
                          width: SizeConfig.blockSizeVertical * 18,
                          height: SizeConfig.blockSizeHorizontal * 10.0,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              gradient: LinearGradient(
                                  colors: [Colors.red[200], Colors.red[400]])),
                          child: new Center(
                            child: Text("W",
                                style: TextStyle(
                                    fontFamily: 'Ropa Sans',
                                    fontSize: 50,
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                      new InkWell(
                        onTap: () {
                          setState(() {
                            playPauseState = !playPauseState;
                          });
                        },
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        splashColor: Colors.black.withAlpha(50),
                        child: new Container(
                          width: SizeConfig.blockSizeVertical * 18,
                          height: SizeConfig.blockSizeHorizontal * 10.0,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              gradient: LinearGradient(
                                  colors: playPauseState
                                      ? [
                                          Color.fromARGB(150, 175, 46, 255),
                                          Color.fromARGB(255, 175, 46, 255)
                                        ]
                                      : [
                                          Color.fromARGB(150, 0, 232, 62),
                                          Color.fromARGB(255, 0, 232, 62)
                                        ])),
                          child: new Center(
                            child: playPauseState
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

  void getChData() {
    if (widget.channelSetup.isSaved()) {
      widget._rangeCh1 = widget.channelSetup.getRange1();
      widget.ch1Active = widget.channelSetup.getChannelState(1);

      widget._rangeCh2 = widget.channelSetup.getRange2();
      widget.ch2Active = widget.channelSetup.getChannelState(2);
    } else {
      widget.channelSetup.setChState(1, widget.ch1Active);
      widget.channelSetup.setChState(2, widget.ch2Active);
      widget.channelSetup.setRange(widget._rangeCh1, 1);
      widget.channelSetup.setRange(widget._rangeCh2, 2);
    }
  }

  void getWaveData() {
    if (widget.waveGenerator.getState()) {
      widget._amplitude = widget.waveGenerator.getAmp();
      widget._period = widget.waveGenerator.getPeriod();
      widget._waveType = widget.waveGenerator.getWaveType();
    } else {
      widget.waveGenerator.setAmp(widget._amplitude);
      widget.waveGenerator.setPeriod(widget._period);
      widget.waveGenerator.setWave(widget._waveType);
    }
  }

  void getGraphData() {
    if (widget.graphSetup.isSaved()) {
      widget.ch1 = widget.graphSetup.getChannelColor(1);
      widget.ch2 = widget.graphSetup.getChannelColor(2);
      widget.xAxis = widget.graphSetup.getXData();
      widget.yAxis = widget.graphSetup.getYData();
    } else {
      widget.graphSetup.setColor(widget.ch1, widget.ch2);
      widget.graphSetup.setData(widget.xAxis, widget.yAxis);
    }
  }

  void getOPdata() {
    if (widget.operationHandeler.isSaved()) {
      widget._isFT = widget.operationHandeler.getFT();
      widget._isDiff = widget.operationHandeler.getDiff();
    } else {
      widget.operationHandeler.setDiff(widget._isDiff);
      widget.operationHandeler.setFT(widget._isFT);
    }
  }
}

class PlotData {
  List<int> plotX = List<int>.filled(1000, 0);
  List<double> plotY = List<double>.filled(1000, 0);
}
