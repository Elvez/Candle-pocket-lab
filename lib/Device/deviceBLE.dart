import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart'
    as BluetoothClassic;

/*
 * This class of device is similar to device class, it uses BLE for communication.
 * 
 * Warning - Use only one device file at once.
 */
class DeviceBLE {
  //BLE instance
  FlutterBlue _ble = FlutterBlue.instance;

  /*
   * Check bluetooth state
   * 
   * Returns true if bluetooth is on.
   * 
   * @params : none
   * @return : Bool 
   */
  bool isBTon() {
    //Bluetooth state
    bool _bluetoothState = false;

    //Check if bluetooth is on
    _ble.state.listen((state) {
      if (state == BluetoothState.on) {
        _bluetoothState = true;
      } else {
        _bluetoothState = false;
      }
    });

    return _bluetoothState;
  }

  /* 
   * Try to enable bluetooth
   * 
   * Tries to enable bluetooth on the phone.
   * 
   * @params : none
   * @return : none
   */
  void enableBluetooth() async {
    if (isBTon()) {
      //Bluetooth already on
      return;
    } else {
      //Try to enable bluetooth
      BluetoothClassic.FlutterBluetoothSerial.instance.requestEnable();
    }
  }

  /*
   * Get paired devices
   * 
   * Stores the list of paired devices in the class member _devices.
   * 
   * @params : noen
   * @return : none 
   */
  void getPairedDevices() async {
    _ble.scan().listen((scanResult) {
      print(scanResult.device.name);
    });
  }
}
