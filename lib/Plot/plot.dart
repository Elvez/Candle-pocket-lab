import 'dart:math';
import 'package:flutter/material.dart';

/*
 * Class name - GraphData
 * 
 * Usage - Graph plotting. 
 */
class GraphData {
  //Graph range
  double _range;

  //Color
  Color color;

  //Plot vector
  List<PlotValue> plot = [];

  //Constructor
  GraphData(this._range, this.color) {
    setRange(_range);
    setColor(color);
  }

  /*
   * Get color
   * 
   * Returns the color of line chart
   * 
   * @params : none
   * @return : Color 
   */
  Color getColor() {
    return color;
  }

  /*
   * Set color
   * 
   * Sets argument as the graph color
   * 
   * @params : Color(Color)
   * @return : none 
   */
  void setColor(Color _color) {
    color = _color;
  }

  /*
   * Fill X axis values
   * 
   * Fills x axis values seperated by space, hundred values are filles irrespective of the range.
   * 
   * @params : Range(int)
   * @return : none 
   */
  void setRange(double range) {
    //Space between plot points
    double _space = _range / 1000;

    //Reset the graph
    _range = range;
    plot = [];

    //Set rest of the values
    for (int iter = 0; iter < 1000; iter++) {
      plot.add(PlotValue(iter * _space, 0));
    }
  }

  /*
   * Returns plot's current x-axis range 
   * 
   * @params : none
   * @return double
   */
  double getRange() {
    return _range;
  }

  /*
   * Returns values at given index.
   * 
   * Returns x and y values at argument index. Index should be between (0-99)
   * 
   * @params : Index(int) 
   * @return : PlotValue
   */
  PlotValue getValuesAt(int index) {
    if (index < 0) {
      index = 0;
    } else if (index >= plot.length) {
      index = (plot.length - 1);
    }
    return plot[index];
  }
}

class PlotValue {
  //XY values
  double xVal;
  double yVal;

  //Constructor
  PlotValue(this.xVal, this.yVal);
}
