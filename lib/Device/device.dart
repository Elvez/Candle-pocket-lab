import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:convert';

class Device {
  BluetoothConnection connection;
  BluetoothState bluetoothState = BluetoothState.UNKNOWN;
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  int deviceState;
  List<BluetoothDevice> devicesList = [];
  bool isDisconnecting = false;
  String address;

  Device() {
    FlutterBluetoothSerial.instance.state.then((state) {
      bluetoothState = state;
    });

    deviceState = 0; // neutral

    enableBluetooth();
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      bluetoothState = state;

      // For retrieving the paired devices list
      getPairedDevices();
    });
  }

  void dispose() {
    if (isConnected()) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }
  }

  void tryConnect() async {
    if (devicesList.isNotEmpty) {
      for (int iter = 0; iter < devicesList.length; iter++) {
        print(devicesList[iter].name);
        if (devicesList[iter].name == "CandlePL") {
          address = devicesList[iter].address;
        }
      }
    }
    if (!isConnected()) {
      await BluetoothConnection.toAddress(address).then((_connection) {
        connection = _connection;
        print("Connected!");
      });
    } else {
      tryDisconnect();
      print(
          "Device either already connected or process timed out! Disconnecting device...");
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
