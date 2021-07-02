import 'dart:async' show Future;
import 'package:usb_serial/usb_serial.dart';
import 'package:candle_pocketlab/OscilloscopeScreen/xyTool.dart';

/*
 * This class of device is similar to device class, it uses USB for communication.
 * 
 * Warning - Use only one device file at once.
 */
class DeviceUSB {
  //USB port, used for sending/receiving data.
  UsbPort _port;

  //Connected Devices list
  List<UsbDevice> _devices = [];

  //Is device connected
  bool isConnected = false;

  /*
   * Get list of connected devices.
   * 
   * Tries to get the list of connected USB devices, return the error string.
   * 
   * @params : none
   * @return : String 
   */
  Future<String> getDevices() async {
    //Get list of connected devices
    _devices = await UsbSerial.listDevices();

    if (_devices.isEmpty) {
      //No device connected.
      return "No device connected!";
    } else {
      print(_devices);
      //Some devices are connected
      return "Devices found!";
    }
  }

  /*
   * Initialize device
   * 
   * Tries to initialize the device, connect it and open the available port.
   * 
   * @params : none
   * @return : none 
   */
  Future<bool> initialize() async {
    //Port open result
    bool _openResult = false;

    if (!isConnected) {
      //Get list of devices
      await getDevices();

      if (_devices.isNotEmpty) {
        //Create port from the first device in the list.
        _port = await _devices[0].create();

        //Try to open port.
        _openResult = await _port.open();
        if (_openResult) {
          //Send "Data Terminal ready" and "Ready to Send" signals
          await _port.setDTR(true);
          await _port.setRTS(true);

          //Set port params, Baud = 115200, Databits = 8, Parity = 0, Stop-bits = 1
          await _port.setPortParameters(115200, UsbPort.DATABITS_8,
              UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

          print("Port opened successfully!");
          isConnected = true;
        } else {
          //Some error opening the port
          print("Could not open port!");
          isConnected = false;
          return Future.value(false);
        }
      } else {
        //Devices list is empty.
        print("There are no devices to connect!");
        isConnected = false;
        return Future.value(false);
      }
    } else {
      //Device is already connected.
      print("Device already connected.");
      return true;
    }
  }

  /*
   * Send string packet to the connected device.
   * 
   * Tries to send string to the connected device.
   * 
   * @params : none
   * @return : none 
   */
  void sendPacket(String _packet) async {
    if (isConnected) {
      //Write string to port.
      await _port.write(_packet.codeUnits);
    } else {
      //Device not connected.
      print("Device not connected!");
    }
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
