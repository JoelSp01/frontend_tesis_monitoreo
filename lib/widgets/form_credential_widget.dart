import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:frontend_tesis_monitoreo/services/bluetooth_service.dart';

class FormCredentialWidget extends StatefulWidget {
  const FormCredentialWidget({
    Key? key,
    required this.device,
    required this.statusMessage,
    required this.ssidController,
    required this.passwordController,
  }) : super(key: key);

  final BluetoothDevice device;
  final String statusMessage;
  final TextEditingController ssidController;
  final TextEditingController passwordController;

  @override
  _FormCredentialWidgetState createState() => _FormCredentialWidgetState();
}

class _FormCredentialWidgetState extends State<FormCredentialWidget> {
  bool _sendingData = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Dispositivo Conectado',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.device.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(49.0),
              child: Image.asset(
                'img/dispositivo.png',
                width: 200,
                height: 200,
              ),
            ),
            if (widget.statusMessage.isNotEmpty)
              Text(
                widget.statusMessage,
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            Expanded(
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      const Text(
                        'Ingrese sus credenciales',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Nombre de la Red:',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      TextField(
                        controller: widget.ssidController,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          hintText: 'Ingrese el nombre de la red',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Contraseña:',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      TextField(
                        controller: widget.passwordController,
                        style: const TextStyle(color: Colors.black),
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Ingrese la contraseña de la red',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _sendingData = true; // Mostrar la progress bar
                          });

                          String ssid = widget.ssidController.text;
                          String password = widget.passwordController.text;

                          if (ssid.isNotEmpty && password.isNotEmpty) {
                            try {
                              await BluetoothServiceConnect().sendData(
                                widget.device,
                                '$ssid;$password',
                                'beb5483e-36e1-4688-b7f5-ea07361b26a8',
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Credenciales enviadas correctamente'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Error al enviar las credenciales'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Por favor ingrese el nombre de la red y la contraseña'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }

                          // Ocultar la progress bar después de 21 segundos
                          _timer = Timer(Duration(seconds: 21), () {
                            if (mounted) {
                              setState(() {
                                _sendingData = false;
                              });
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF07328),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _sendingData
                            ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text('Enviar', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
