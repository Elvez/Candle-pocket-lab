import 'dart:typed_data';

import 'package:usb_serial/usb_serial.dart';

class Device {
  UsbPort _port;
  List<UsbPort> _ports;
  final int _baud = 115200;
  final int _dataBits = UsbPort.DATABITS_8;
  final int _stopButs = UsbPort.STOPBITS_1;
  final int _parity = UsbPort.PARITY_NONE;

  Future<bool> connectTo(device) async {
    if (_port != null) {
      _port.close();
      _port = null;
    }

    _port = await device.create();
    if (!await _port.open()) {
      return false;
    }
    await _port.setDTR(true);
    await _port.setRTS(true);
    await _port.setPortParameters(_baud, _dataBits, _stopButs, _parity);
    print(_baud);
    print(_dataBits);
    print(_stopButs);
    print(_parity);
    return true;
  }

  void sendPacket(Uint8List message) {
    _port.write(message);
  }

  void receivePacket(int size) {}

  void tryConnect() async {
    _ports = [];
    List<UsbDevice> devices = await UsbSerial.listDevices();
    print(devices);
    await connectTo(devices.isEmpty ? null : devices[0]);

    sendPacket("y".codeUnits);
  }
}
