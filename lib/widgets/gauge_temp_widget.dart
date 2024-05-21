import 'package:flutter/material.dart';
import '../services/influx_data_service.dart';
import 'package:frontend_tesis_monitoreo/widgets/gauge_temperature.dart';

class GaugeTempWidget extends StatelessWidget {
  const GaugeTempWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final InfluxDBService influxDBService = InfluxDBService();

    return StreamBuilder<Map<String, dynamic>>(
      stream: influxDBService.getDataStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No data available'));
        } else {
          double tempValue = snapshot.data!['temperatura'] ?? 0.0;

          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                width: 300,
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Medición de Temperatura',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GaugeTemperature(value: tempValue),
                    const SizedBox(height: 30),
                    Text(
                      'Temperatura ambiente: ${tempValue.toStringAsFixed(2)}°C',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
