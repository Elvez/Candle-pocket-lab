import 'dart:math';
import 'package:candle_pocketlab/Settings/settings.dart';
import 'package:flutter/material.dart';

/*
 * Class name - GraphData
 * 
 * Usage - Graph plotting. 
 */
class GraphData {
  //Color
  Color color;

  //Plot vector
  List<PlotValue> plot = List.filled(100, PlotValue(null, null));

  //Constructor
  GraphData(this.color) {
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
   * Returns plot's current length
   * 
   * @params : none
   * @return : int
   */
  int plotLength() {
    return plot.length;
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
    //Plot in range
    if (index < 0) index = 0;
    if (index >= plot.length) index = (plot.length - 1);

    return plot[index];
  }

  /*
   * Reset plot
   * 
   * Resets the plot
   * 
   * @params : none
   * @return : none 
   */
  void reset() {
    //Reset
    for (int iter = 0; iter < plot.length; iter++) {
      plot.add(PlotValue(iter.toDouble(), null));
    }
  }
}

class PlotValue {
  //XY values
  double xVal;
  double yVal;

  //Constructor
  PlotValue(this.xVal, this.yVal);
}

class XGraphData {
  double range;
  XGraphData(this.range);
}

class YGraphData {
  double range;
  YGraphData(this.range);
}
