import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:convert';

class Device {
  BluetoothConnection connection;
  BluetoothState bluetoothState = BluetoothState.UNKNOWN;
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  List<BluetoothDevice> devicesList = [];
  bool isDisconnecting = false;
  String address;

  void initDevice() {
    FlutterBluetoothSerial.instance.state.then((state) {
      bluetoothState = state;
    });

    enableBluetooth();
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      bluetoothState = state;
      getPairedDevices();
    });
  }

  void sendPacket() async {
    connection.output.add(utf8.encode("y"));
    await connection.output.allSent;
  }

  Future<bool> tryConnect() async {
    Future<bool> result;
    if (devicesList.isNotEmpty && devicesList != null) {
      for (int iter = 0; iter < devicesList.length; iter++) {
        print(devicesList[iter].name);
        if (devicesList[iter].name == "CandlePL") {
          address = devicesList[iter].address;
        }
      }
    }
    if (!isConnected()) {
      try {
        await BluetoothConnection.toAddress(address)
            .timeout(Duration(seconds: 5), onTimeout: () {
          print("Timeout occured!");
          result = Future.value(false);
        }).then((_connection) {
          connection = _connection;
          if (result == null) {
            print("Connected!");
            result = Future.value(true);
          }
        }).catchError((error) {
          print("Error");
        });
      } on PlatformException {
        print("Error");
      }
    }
    return result;
  }

  Future<bool> isBTon() async {
    bluetoothState = await FlutterBluetoothSerial.instance.state;

    if (bluetoothState == BluetoothState.STATE_OFF) {
      return Future.value(false);
    }
    if (bluetoothState == BluetoothState.STATE_ON) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  void tryDisconnect() async {
    await connection.close();
    print('Device disconnected');
  }

  bool isConnected() {
    return connection != null && connection.isConnected;
  }

  Future<void> enableBluetooth() async {
    bluetoothState = await FlutterBluetoothSerial.instance.state;

    if (bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    devicesList = devices;
  }
}
