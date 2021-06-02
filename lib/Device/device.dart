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
    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      bluetoothState = state;
    });

    deviceState = 0; // neutral

    // If the Bluetooth of the device is not enabled,
    // then request permission to turn on Bluetooth
    // as the app starts up
    enableBluetooth();

    // Listen for further state changes
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
    for (int iter = 0; iter < devicesList.length; iter++) {
      print(devicesList[iter].name);
      if (devicesList[iter].name == "CandlePL") {
        address = devicesList[iter].address;
      }
    }
    if (!isConnected()) {
      await BluetoothConnection.toAddress(address);
      print("Connected");
    } else {
      print("Device either already connected or process timed out!");
    }
  }

  bool isConnected() {
    return connection != null && connection.isConnected;
  }

  Future<void> enableBluetooth() async {
    // Retrieving the current Bluetooth state
    bluetoothState = await FlutterBluetoothSerial.instance.state;

    // If the Bluetooth is off, then turn it on first
    // and then retrieve the devices that are paired.
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

    // To get the list of paired devices
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    // Store the [devices] list in the [_devicesList] for accessing
    // the list outside this class
    devicesList = devices;
  }
}
