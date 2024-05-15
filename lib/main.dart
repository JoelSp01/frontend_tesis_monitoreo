import 'package:flutter/material.dart';
import './widgets/gauge_glp.dart';
import './widgets/gauge_temperature.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
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
        backgroundColor: const Color(0xFFF07328),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20), // Agrega relleno solo en la parte superior
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(20), // Redondea los bordes
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withOpacity(0.2), // Color de la sombra
                        spreadRadius: 2, // Extensión de la sombra
                        blurRadius: 5, // Difuminado de la sombra
                        offset:
                            const Offset(0, 3), // Desplazamiento de la sombra
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  width: 300,
                  height: 300,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Medición GLP', // Título que deseas mostrar
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                          height: 10), // Espacio entre el título y el Gauge
                      GaugeGlp(value: 80),
                      SizedBox(height: 30), // Espacio entre el Gauge y el texto
                      Text(
                        'Disponibilidad del GLP: 80%', // Texto debajo del Gauge
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            /* Gauge TEMPERATURA */
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20), // Agrega relleno solo en la parte superior
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(20), // Redondea los bordes
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withOpacity(0.2), // Color de la sombra
                        spreadRadius: 2, // Extensión de la sombra
                        blurRadius: 5, // Difuminado de la sombra
                        offset:
                            const Offset(0, 3), // Desplazamiento de la sombra
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  width: 300,
                  height: 300,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Medición de Temperatura', // Título que deseas mostrar
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                          height: 10), // Espacio entre el título y el Gauge
                      GaugeTemperature(value: 30),
                      SizedBox(height: 30), // Espacio entre el Gauge y el texto
                      Text(
                        'Temperatura ambiente: 30°C', // Texto debajo del Gauge
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
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
