import 'package:flutter/material.dart';
import 'package:frontend_tesis_monitoreo/services/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/connection_screen.dart';
import 'screens/home_screen.dart'; // Asegúrate de importar tu HomeScreen aquí

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();
  await _requestPermissions();

  // Verifica si es la primera vez que se abre la app
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  if (isFirstTime) {
    // Marca que la app ya fue abierta por primera vez
    await prefs.setBool('isFirstTime', false);
  }

  runApp(MyApp(isFirstTime: isFirstTime));
}

Future<void> _requestPermissions() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;

  const MyApp({Key? key, required this.isFirstTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: isFirstTime ? const ConnectionScreen() : const HomeScreen(), // Establece la pantalla inicial según el estado
    );
  }
}
