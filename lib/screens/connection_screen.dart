import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:frontend_tesis_monitoreo/screens/credential_screen.dart';
import 'package:frontend_tesis_monitoreo/services/bluetooth_service.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  @override
  ConnectionScreenState createState() => ConnectionScreenState();
}

class ConnectionScreenState extends State<ConnectionScreen> {
  final BluetoothServiceConnect _bluetoothService = BluetoothServiceConnect();
  final List<BluetoothDevice> _devices = [];
  final Set<String> _deviceIds = {};
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _checkBluetoothSupport();
  }

  Future<void> _checkBluetoothSupport() async {
    if (await FlutterBluePlus.isSupported == false) {
      print("Bluetooth no es soportado por este dispositivo");
      return;
    }

    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      if (state == BluetoothAdapterState.on) {
        // Bluetooth está encendido, listo para escanear o conectar
      } else {
        // Muestra un mensaje de error al usuario
        print("Bluetooth está apagado o no autorizado");
      }
    });

    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }
  }

  Future<void> _startScanning() async {
    setState(() {
      _devices.clear();
      _deviceIds.clear();
      _isScanning = true;
    });

    await _bluetoothService.startScanning((device) {
      setState(() {
        if (!_deviceIds.contains(device.remoteId.toString())) {
          _devices.add(device);
          _deviceIds.add(device.remoteId.toString());
        }
      });
    });

    setState(() {
      _isScanning = false;
    });
  }

  Future<void> _onDeviceTapped(BluetoothDevice device) async {
    await _bluetoothService.connectToDevice(device);
    device.connectionState.listen((state) {
      if (state == BluetoothConnectionState.connected) {
        print('Dispositivo conectado');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CredentialScreen(device: device),
          ),
        );
      } else if (state == BluetoothConnectionState.disconnected) {
        print('Dispositivo desconectado');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF07328),
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        title: Center(
          child: Image.asset(
            'img/logoAlphaSinFondo.png',
            width: 70,
            height: 70,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: const Color(0xFFF07328),
            child: _devices.isEmpty
                ? const Center(
                    child: Text(
                      'Ningún dispositivo encontrado\nPresiona el botón para iniciar el escaneo',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: _devices.length,
                          itemBuilder: (context, index) {
                            final device = _devices[index];
                            return Card(
                              color: Colors.white,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                title: Center(
                                  child: Text(
                                    device.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                subtitle: Center(
                                  child: Text(
                                    device.remoteId.toString(),
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                                onTap: () => _onDeviceTapped(device),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ),
          if (_isScanning)
            Positioned.fill(
              child: Container(
                color: const Color(0xFFF07328),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 0),
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: const Text(
                          'Escaneando dispositivos...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startScanning,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFFF07328),
        child: const Icon(Icons.search),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
