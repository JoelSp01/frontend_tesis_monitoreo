import 'package:flutter/material.dart';
import 'package:frontend_tesis_monitoreo/services/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/connection_screen.dart'; // Importa tu pantalla de conexión aquí

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();
  await _requestPermissions();
  runApp(const MyApp());
}

Future<void> _requestPermissions() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: ConnectionScreen(), // Aquí estableces ConnectionScreen como la pantalla de inicio
    );
  }
}
