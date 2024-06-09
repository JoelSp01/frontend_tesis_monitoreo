import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothServiceConnect {
  static final BluetoothServiceConnect _instance = BluetoothServiceConnect._internal();

  factory BluetoothServiceConnect() {
    return _instance;
  }

  BluetoothServiceConnect._internal();

  // Método para iniciar el escaneo de dispositivos Bluetooth
  Future<void> startScanning(void Function(BluetoothDevice) onDeviceFound) async {
    // Iniciar el escaneo de dispositivos Bluetooth
    var subscription;
    subscription = FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        onDeviceFound(result.device);
      }
    });

    // Iniciar el escaneo
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));

    // Cancelar la suscripción cuando el escaneo esté completo
    await subscription.cancel();
  }

  // Método para conectar a un dispositivo Bluetooth
  Future<void> connectToDevice(BluetoothDevice device) async {
    // Escuchar el estado de conexión del dispositivo
    var subscription;
    subscription = device.connectionState.listen((state) {
      if (state == BluetoothConnectionState.disconnected) {
        print("Dispositivo desconectado");
        subscription.cancel();
      }
    });

    // Conectar al dispositivo
    await device.connect();
  }

  // Método para enviar datos al dispositivo Bluetooth
  Future<void> sendData(BluetoothDevice device, String data, String characteristicUUID) async {
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
}
