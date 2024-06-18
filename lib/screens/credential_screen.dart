import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:frontend_tesis_monitoreo/screens/home_screen.dart';
import 'package:frontend_tesis_monitoreo/services/bluetooth_service.dart';
import 'package:frontend_tesis_monitoreo/widgets/form_credential_widget.dart';

class CredentialScreen extends StatefulWidget {
  final BluetoothDevice device;

  const CredentialScreen({super.key, required this.device});

  @override
  _CredentialScreenState createState() => _CredentialScreenState();
}

class _CredentialScreenState extends State<CredentialScreen> {
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _statusMessage = "";

  @override
  void initState() {
    super.initState();
    _subscribeToStatusNotifications();
  }

  void _subscribeToStatusNotifications() {
    BluetoothServiceConnect().subscribeToNotifications(
      widget.device,
      'c7b4c99d-00d0-4b8b-a2a1-7a840f3b6d45', // UUID de la característica de estado
      (message) {
        if (!mounted) return; // Verificar si el widget está montado
        setState(() {
          if (message == "Failed to connect to Wifi") {
            _statusMessage = "Ups! Hubo un error al conectar a la red WiFi";
            print(_statusMessage);
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Error de conexión"),
                content: Text(_statusMessage),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Cierra el diálogo
                    },
                    child: const Text("Cerrar"),
                  ),
                ],
              ),
            );
          } else if (message == "Connected to Wifi") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF07328),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 90.0),
          child: Image.asset(
            'img/logoAlphaSinFondo.png',
            width: 70,
            height: 70,
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFFF07328),
        child: FormCredentialWidget(
          device: widget.device,
          statusMessage: _statusMessage,
          ssidController: _ssidController,
          passwordController: _passwordController,
        ),
      ),
    );
  }
}
