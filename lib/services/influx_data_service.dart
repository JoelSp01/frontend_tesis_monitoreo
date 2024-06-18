import 'dart:async';
import 'package:influxdb_client/api.dart';
import 'package:frontend_tesis_monitoreo/services/notification_service.dart';

class InfluxDBService {
  final InfluxDBClient _client;
  bool _notificationSent = false;

  InfluxDBService()
      : _client = InfluxDBClient(
          url: 'http://www.pucei.edu.ec:8086',
          token:
              'JuKSh-3m_z_-k4R3U4x6Jp9Ee3Omb0k8Dg0kw1t2rsJOmmbOqmG1IpV2UASuV6vbDQ8-qKj-Vf5xiu-MxeLSGg==',
          org: 'titulacion',
          bucket: 'titulacion',
          debug: true,
        );

  Stream<Map<String, dynamic>> getDataStream() async* {
    var queryService = _client.getQueryService();
    var fluxQuery = '''
      from(bucket: "titulacion")
        |> range(start: -20d)
        |> filter(fn: (r) => r["_measurement"] == "lecturas")
        |> filter(fn: (r) => r["_field"] == "peso" or r["_field"] == "temperatura")
        |> last()
    ''';

    while (true) {
      try {
        var recordStream = await queryService.query(fluxQuery);
        var records = await recordStream.toList();

        if (records.isNotEmpty) {
          var pesoRecord = records.firstWhere((r) => r['_field'] == 'peso');
          var temperaturaRecord =
              records.firstWhere((r) => r['_field'] == 'temperatura');

          var peso = pesoRecord['_value'] ?? 0;
          var temperatura = temperaturaRecord['_value'] ?? 0;

          // Lógica de notificación
          if (peso <= 5 && !_notificationSent) {
            LocalNotifications.showNotification(
              title: "Advetrtencia",
              body: "Los niveles de GLP son bajos",
              payload: "Advertencia",
            );
            _notificationSent = true;
            // Programar la notificación de recordatorio después de un tiempo
            Future.delayed(const Duration(minutes: 30), () {
              if (peso <= 5 && _notificationSent) {
                LocalNotifications.showNotification(
                  title: "Recordatorio",
                  body: "El peso sigue siendo <= 5",
                  payload: "Recordatorio",
                );
              }
            });
          } else if (peso > 5) {
            // Reiniciar la bandera si el peso vuelve a ser > 5
            _notificationSent = false;
          }

          yield {
            'peso': peso,
            'temperatura': temperatura,
          };
        } else {
          yield {
            'peso': 0,
            'temperatura': 0,
          };
        }
      } catch (e) {
        yield {
          'peso': 0,
          'temperatura': 0,
        };
      }

      await Future.delayed(const Duration(seconds: 5));
    }
  }
}
