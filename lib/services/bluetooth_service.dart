import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothServiceConnect {
  static final BluetoothServiceConnect _instance =
      BluetoothServiceConnect._internal();

  factory BluetoothServiceConnect() {
    return _instance;
  }

  BluetoothServiceConnect._internal();

  // Método para iniciar el escaneo de dispositivos Bluetooth
  Future<void> startScanning(
      void Function(BluetoothDevice) onDeviceFound) async {
    var subscription;
    subscription = FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        onDeviceFound(result.device);
      }
    });

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));

    await subscription.cancel();
  }

  // Método para conectar a un dispositivo Bluetooth
  Future<void> connectToDevice(BluetoothDevice device) async {
    var subscription;
    subscription = device.connectionState.listen((state) {
      if (state == BluetoothConnectionState.disconnected) {
        print("Dispositivo desconectado");
        subscription.cancel();
      }
    });

    await device.connect();
  }

  // Método para enviar datos al dispositivo Bluetooth
  Future<void> sendData(
      BluetoothDevice device, String data, String characteristicUUID) async {
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid == Guid(characteristicUUID)) {
          await characteristic.write(data.codeUnits);
          print("Datos enviados: $data");
          return;
        }
      }
    }
    print("Característica no encontrada");
  }

  // Método para suscribirse a notificaciones de una característica Bluetooth
  Future<void> subscribeToNotifications(BluetoothDevice device,
      String characteristicUUID, Function(String) onDataReceived) async {
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid == Guid(characteristicUUID)) {
          await characteristic.setNotifyValue(true);
          characteristic.value.listen((value) {
            String message = String.fromCharCodes(value);
            onDataReceived(message); // Aquí recibes el mensaje del ESP32S3
          });
          return;
        }
      }
    }
    print("Característica no encontrada");
  }
}
