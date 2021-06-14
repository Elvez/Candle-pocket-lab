import 'dart:ffi';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:dart_native/dart_native.dart';
import 'package:candle_pocketlab/OscilloscopeScreen/xyTool.dart';

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

  void sendPacket(String packet) async {
    connection.output.add(utf8.encode(packet));
    await connection.output.allSent;
  }

  void sendMulCommand(int source, String state) async {
    String commandPacket;
    commandPacket = "M" + source.toString() + state;
    commandPacket = fillDummy(commandPacket);
    sendPacket(commandPacket);
  }

  void sendWGCommand(
      int source, String state, int waveType, String period, String amplitude) {
    String commandPacket;
    commandPacket = "W" + source.toString();
    commandPacket += state;
    if (state == "L") {
      commandPacket = fillDummy(commandPacket);
      sendPacket(commandPacket);
      return;
    } else if (state == "H") {
      switch (waveType) {
        case 1:
          commandPacket += "1";
          break;
        case 2:
          commandPacket += "2";
          break;
        case 3:
          commandPacket += "3";
          break;
        default:
          return;
          break;
      }

      commandPacket += period;
      commandPacket += amplitude;
      commandPacket = fillDummy(commandPacket);
      sendPacket(commandPacket);
    }
  }

  void sendPSCommand(int source, String state, String amplitude) {
    String commandPacket;
    commandPacket = "P" + source.toString();
    commandPacket += state;

    if (state == "L") {
      commandPacket = fillDummy(commandPacket);
      sendPacket(commandPacket);
      return;
    } else if (state == "H") {
      commandPacket += amplitude;
      commandPacket = fillDummy(commandPacket);
      sendPacket(commandPacket);
    }
  }

  void sendOSCCommmand(
      int channel, String state, String rangeX, timeUnit unit) {
    String commandPacket;
    commandPacket = "O" + channel.toString();
    commandPacket += state;

    if (state == "L") {
      commandPacket = fillDummy(commandPacket);
      sendPacket(commandPacket);
      return;
    } else if (state == "H") {
      commandPacket += rangeX;
      switch (unit) {
        case timeUnit.micro:
          commandPacket += "1";
          break;
        case timeUnit.milli:
          commandPacket += "2";
          break;
        case timeUnit.second:
          commandPacket += "3";
          break;
        default:
          return;
          break;
      }
      commandPacket = fillDummy(commandPacket);
      sendPacket(commandPacket);
    }
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

  String fillDummy(String command) {
    int length = 20 - command.length;
    for (int iter = 0; iter < length; iter++) {
      command += "-";
    }
    return command;
  }
}
