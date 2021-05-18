import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class Device {
  //Private members
  bool _connected = false;
  String _address;
  //---------------

  //Public methods
  bool isConnected() {
    return _connected;
  }

  String getAdress() {
    return _address;
  }

  bool tryConnect(String add) {
    return true;
  }

  void disconnect() {}
}
