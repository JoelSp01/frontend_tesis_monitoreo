import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:frontend_tesis_monitoreo/services/bluetooth_service.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  final BluetoothServiceConnect _bluetoothService = BluetoothServiceConnect();
  final List<BluetoothDevice> _devices = [];
  final Set<String> _deviceIds = {};
  bool _isScanning = false;

  Future<void> _startScanning() async {
    setState(() {
      _devices.clear();
      _deviceIds.clear();
      _isScanning = true; // Inicia la animación de búsqueda
    });

    await _bluetoothService.startScanning((device) {
      setState(() {
        // ignore: deprecated_member_use
        if (!_deviceIds.contains(device.id.toString())) {
          _devices.add(device);
          // ignore: deprecated_member_use
          _deviceIds.add(device.id.toString());
        }
      });
    });

    // Detiene la animación de búsqueda después de 5 segundos
    await Future.delayed(const Duration(seconds: 5));

    setState(() {
      _isScanning = false;
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
            child: _devices
                    .isEmpty // Verifica si la lista de dispositivos está vacía
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
                                    // ignore: deprecated_member_use
                                    device.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                subtitle: Center(
                                  child: Text(
                                    // ignore: deprecated_member_use
                                    device.id.toString(),
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  //agregar logica para dirigir a la pantalla donde tendremos los inputs para ingresar las credenciales de red

                                },
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
                      const SizedBox(
                          height: 0), // Ajuste para mover el texto hacia arriba
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
