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
    var subscription = FlutterBluePlus.onScanResults.listen((results) {
      if (results.isNotEmpty) {
        var device = results.last.device;
        onDeviceFound(device);
      }
    });

    // Cancelar la suscripción cuando el escaneo esté completo
    FlutterBluePlus.cancelWhenScanComplete(subscription);
    
    // Iniciar el escaneo
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
  }

  // Método para conectar a un dispositivo Bluetooth
  Future<void> connectToDevice(BluetoothDevice device) async {
    // Escuchar el estado de conexión del dispositivo
    var subscription = device.connectionState.listen((state) {
      if (state == BluetoothConnectionState.disconnected) {
        print("Dispositivo desconectado");
      }
    });

    // Cancelar la suscripción cuando el dispositivo se desconecte
    device.cancelWhenDisconnected(subscription, delayed: true, next: true);

    // Conectar al dispositivo
    await device.connect();
  }
}
