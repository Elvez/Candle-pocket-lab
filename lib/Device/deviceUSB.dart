import 'dart:async' show Future;
import 'dart:typed_data';
import 'package:usb_serial/usb_serial.dart';

/*
 * This class of device is similar to device class, it uses USB for communication.
 * 
 * Warning - Use only one device file at once.
 */
class DeviceUSB {
  //USB port, used for sending/receiving data.
  UsbPort port;

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
  Future<String> tryConnect() async {
    //Port open result
    bool _openResult = false;
    String result = "";

    if (!isConnected) {
      //Get list of devices
      await getDevices();

      if (_devices.isNotEmpty) {
        //Create port from the first device in the list.
        port = await _devices[0].create();

        //Try to open port.
        _openResult = await port.open();
        if (_openResult) {
          //Send "Data Terminal ready" and "Ready to Send" signals
          await port.setDTR(true);
          await port.setRTS(true);

          //Set port params, Baud = 115200, Databits = 8, Parity = 0, Stop-bits = 1
          await port.setPortParameters(115200, UsbPort.DATABITS_8,
              UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

          result = "Connected successfully!";
          isConnected = true;
          return result;
        } else {
          //Some error opening the port
          result = "Could not connect!";
          isConnected = false;
          return result;
        }
      } else {
        //Devices list is empty.
        result = "No connected device found!";
        isConnected = false;
        return result;
      }
    } else {
      //Device is already connected.
      result = "Device already connected!";
      return result;
    }
  }

  /*
   * Is device connected
   * 
   * Returns device bool isConnected
   * 
   * @params : none
   * @return : bool 
   */
  bool isDeviceConnected() {
    return isConnected;
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
      await port.write(Uint8List.fromList(_packet.codeUnits));
    } else {
      //Device not connected.
      print("Device not connected!");
    }
  }

  /*
   * Send Multimeter command
   *
   * This function sends the Multimeter command to the USB device.
   * Command packet - M(Source)(State)-----------------
   * Example - M1H-----------------
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
   * This function sends the wave generator command to the USB device.
   * Command packet - W(Source)(State)(WaveType)(Period)(Amplitude)
   * Example - W1H120.03.30-------
   *
   * @param Source(int), State(String), Wave type(int), Period(String), Amplitude(String)
   * example : sendWGCommand(1, "H", 1, "20.0", "3.30");
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
      commandPacket += 'A';
      commandPacket += amplitude;
      commandPacket = fillDummy(commandPacket);

      //Send Command
      sendPacket(commandPacket);
    }
  }

  /*
   * Send Power source command
   *
   * This function sends the power source command to the USB device.
   * Command packet - P(Source)(State)(Value)-------------
   * Example - P1H2.50-------------
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
   * This function sends the Oscilloscope command to the USB device.
   * Command packet - O(Source)(State)-----------------
   * Example - O1H-------------------
   *
   * @param : Source(int), State(String)
   * example : sendOSCCommand(1, "H");
   * @return none
   */
  void sendOSCCommand(int source, String state) async {
    String commandPacket;
    commandPacket = "O" + source.toString() + state;
    commandPacket = fillDummy(commandPacket);

    //Send command
    sendPacket(commandPacket);
  }

  /*
   * Send PWM command
   * 
   * This function sends the PWM command to the USB device 
   * Command Packet - G(Source)(State)(Duty Cycle)------
   * Example - G2H50---------------
   * 
   * @params : Source(int), State(String), Duty cycle(String)
   * @return : none
   */
  void sendPWMCommand(int source, String state, String dutyCycle) {
    //Command packet
    String commandPacket;

    //Set header and source
    commandPacket = 'G' + source.toString();
    commandPacket += state;

    if (state == 'H') {
      //Set duty cycle
      commandPacket += dutyCycle;
    } else if (state == 'L') {
      //Fill packet
      commandPacket = fillDummy(commandPacket);

      //Send command
      sendPacket(commandPacket);

      return;
    } else {
      print("Bad command");

      return;
    }

    //Fill packet
    commandPacket = fillDummy(commandPacket);

    //Send packet
    sendPacket(commandPacket);
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
