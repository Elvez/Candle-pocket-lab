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
   * Add value to the plot
   * 
   * Adds the value of type PlotValue to the plot list.
   * 
   * @params : XVal(double), YVal(double)
   * @return : none 
   */
  void addValue(double x, double y) {
    plot.add(PlotValue(x, y));
  }

  /*
   * Removes value from the plot
   * 
   * Removes a value from the beginning of the plot.
   * 
   * @params : XVal(double), YVal(double)
   * @return : none 
   */
  void popFirst() {
    plot.removeAt(0);
  }

  /*
   * Clears the plot
   * 
   * Removes all values from the plot.
   * 
   * @params : none
   * @return : none 
   */
  void clearPlot() {
    plot.clear();
  }

  /*
   * Fill X axis values
   * 
   * Fills x axis values seperated by space, hundred values are filles irrespective of the range.
   * 
   * Status - UNUSED
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
   * Returns plot's current length
   * 
   * @params : none
   * @return : int
   */
  int plotLength() {
    return plot.length;
  }

  /*
   * Reset plot
   * 
   * Resets the plot
   * 
   * @params : none
   * @return : none 
   */
  void resetPlot(double range) {
    double x = 0;
    if (plot.isNotEmpty) {
      for (int iter = 0; iter < plot.length; iter++) {
        plot[iter] = PlotValue(x, 0);
        x += range / 1000;
      }
    }
  }

  /*
   * Returns values at given index.
   * 
   * Returns x and y values at argument index. Index should be between (0-999)
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

  /*
   * Set value at index
   * 
   * Sets given value at the given index in plot
   * 
   * @params : Value(double), index(int)
   * @return : none 
   */
  void setValue(double value, int index) {
    //In case bad value is passed
    if (index < 0) {
      index = 0;
    } else if (index >= plot.length) {
      index = (plot.length - 1);
    }

    plot[index].yVal = value;
  }
}

class PlotValue {
  //XY values
  double xVal;
  double yVal;

  //Constructor
  PlotValue(this.xVal, this.yVal);
}
