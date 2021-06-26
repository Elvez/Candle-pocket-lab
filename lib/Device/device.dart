import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:candle_pocketlab/OscilloscopeScreen/xyTool.dart';

/* Class name - Device
 * This class is used to connect, disconnect, send data and recieve data from 
 * the bluetooth device named CandlePl. This class uses flutter_bluetooth_serial
 * library downloaded from pub.dev. 
 * flutter_bluetooth_serial : https://pub.dev/packages/flutter_bluetooth_serial
 *
 */
class Device {
  //Necessary bluetooth instances
  BluetoothConnection connection;
  BluetoothState bluetoothState = BluetoothState.UNKNOWN;
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  List<BluetoothDevice> devicesList = [];

  //isDisconnecting is true when the app is trying to disconnect the device
  bool isDisconnecting = false;

  //Address of CandlePL bluetooth device
  String address;

  //Is connected
  bool isDeviceConnected = false;

  /*
   * Initialize device
   *
   * This function is used to initialize the app's bluetooth and get a list
   * of paired devices. This function tries to enable bluetooth of the phone.
   *
   * @param none
   * @return none
   */
  void initDevice() {
    FlutterBluetoothSerial.instance.state.then((state) {
      bluetoothState = state;
    });

    //Try to enable bluetooth
    enableBluetooth();

    //Get bluetooth instance from phone
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      bluetoothState = state;

      //Fetch a list of paired devices
      getPairedDevices();
    });
  }

  /*
   * Send data
   *
   * This function is used to send String data to the bluetooth device, it is an 
   * asynchronous function and it runs in the background.
   *
   * @param Message to be sent (String)
   * example : sendPacket("Hello World!");
   * @return none
   */
  void sendPacket(String packet) async {
    connection.output.add(utf8.encode(packet));
    await connection.output.allSent;
  }

  /*
   * Send Multimeter command
   *
   * This function sends the Multimeter command to the bluetooth device.
   *
   * @param Source(int), State(String)
   * example : sendMulCommand(1, "H");
   * @return none
   */
  void sendMulCommand(int source, String state) async {
    String commandPacket;
    commandPacket = "M" + source.toString() + state;
    commandPacket = fillDummy(commandPacket);

    //Send command
    sendPacket(commandPacket);
  }

  /*
   * Send Wave generator command
   *
   * This function sends the wave generator command to the bluetooth device.
   *
   * @param Source(int), State(String), Wave type(int), Period(String), Amplitude(String)
   * example : sendWGCommand(1, "H", 1, "200.0", "3.30");
   * @return none
   */
  void sendWGCommand(
      int source, String state, int waveType, String period, String amplitude) {
    String commandPacket;
    commandPacket = "W" + source.toString();
    commandPacket += state;
    if (state == "L") {
      commandPacket = fillDummy(commandPacket);

      //Send command
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

      //Send Command
      sendPacket(commandPacket);
    }
  }

  /*
   * Send Power source command
   *
   * This function sends the power source command to the bluetooth device.
   *
   * @param Source(int), State(String), Amplitude(String)
   * example : sendPSCommand(1, "H", "2.50");
   * @return none
   */
  void sendPSCommand(int source, String state, String amplitude) {
    String commandPacket;
    commandPacket = "P" + source.toString();
    commandPacket += state;

    if (state == "L") {
      commandPacket = fillDummy(commandPacket);

      //Send Command
      sendPacket(commandPacket);
      return;
    } else if (state == "H") {
      commandPacket += amplitude;
      commandPacket = fillDummy(commandPacket);

      //Send Command
      sendPacket(commandPacket);
    }
  }

  /*
   * Send Oscilloscope command
   *
   * This function sends the Oscilloscope command to the bluetooth device.
   *
   * @param Source(int), State(String), Range(String), Time unit(timeUnit)
   * example : sendOSCCommand(1, "H", "300.0", timeUnit.seconds);
   * @return none
   */
  void sendOSCCommmand(
      int channel, String state, String rangeX, timeUnit unit) {
    String commandPacket;
    commandPacket = "O" + channel.toString();
    commandPacket += state;

    if (state == "L") {
      commandPacket = fillDummy(commandPacket);

      //Send Command
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

      //Send Command
      sendPacket(commandPacket);
    }
  }

  /*
   * Try to connect to CandlePL
   *
   * This function tries to connect to the CandlePL bluetooth device, it is asynchronous.
   *
   * @param None
   * example : tryConnect();
   * @return true if connected and false if not
   */
  Future<bool> tryConnect() async {
    Future<bool> result;

    //Find the CandlePl device in Paired device list by name.
    if (devicesList.isNotEmpty && devicesList != null) {
      for (int iter = 0; iter < devicesList.length; iter++) {
        print(devicesList[iter].name);
        if (devicesList[iter].name == "CandlePL") {
          address = devicesList[iter].address;
        }
      }
    }

    //If the device is not already connected, try to connect.
    if (!isDeviceConnected) {
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
            isDeviceConnected = true;
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

  /*
   * Get bluetooth state
   *
   * This function returns the state of bluetooth of the phone.
   *
   * @param None
   * example : isBTon();
   * @return true if bluetooth is turned on, false if not.
   */
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

  /*
   * Disconnect from device
   *
   * This function tries to disconnect from CandlePL.
   *
   * @param None
   * example : tryDisconnect();
   * @return none
   */
  void tryDisconnect() async {
    await connection.close();
    print('Device disconnected');
  }

  /*
   * Get connected state
   *
   * This function returns the state of the connection with CandlePL
   *
   * @param None
   * example : isConnected();
   * @return true if CandlePL is connected, false if not
   */
  bool isConnected() {
    return connection != null && connection.isConnected;
  }

  /*
   * Enable phone bluetooth
   *
   * This function tries to enable the phone bluetooth. It is asynchronous and runs in background.
   *
   * @param none
   * example : enableBluetooth();
   * @return none
   */
  Future<void> enableBluetooth() async {
    bluetoothState = await FlutterBluetoothSerial.instance.state;

    //Try to turn on bluetooth if it is off.
    if (bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();

      //Get the list of paired devices.
      await getPairedDevices();

      return true;
    } else {
      //Get the list of paired devices.
      await getPairedDevices();
    }

    return false;
  }

  /*
   * Get the list of paired devices
   *
   * This function stores the list of paired devices in the Class member devicesList.
   *
   * @paramNone
   * example : getPairedDevices();
   * @return none
   */
  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    devicesList = devices;
  }

  /*
   * Fill rest of the packet with '-' 
   *
   * This function fills the packet's remaining length with '-' so that it's size is 20.
   *
   * @param Command(String)
   * example : fillDummy("Hello");
   * returns : Hello---------------
   * @return String
   */
  String fillDummy(String command) {
    int length = 20 - command.length;

    for (int iter = 0; iter < length; iter++) {
      command += "-";
    }
    return command;
  }
}
