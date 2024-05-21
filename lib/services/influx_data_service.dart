import 'dart:async';
import 'package:influxdb_client/api.dart';

class InfluxDBService {
  final InfluxDBClient _client;

  InfluxDBService()
      : _client = InfluxDBClient(
          url: 'http://172.16.132.53:8086',  // Cambia esto según tu configuración
          token: 'ymHvcMekmKA9-vJRSbwT4gSGDwAijui2twmdO_CPImyO7TZUFJac3wG-019JXO5Edh0Objbb95S840j-2mbOxw==',
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
          var temperaturaRecord = records.firstWhere((r) => r['_field'] == 'temperatura');

          var peso = pesoRecord['_value'] ?? 0;
          var temperatura = temperaturaRecord['_value'] ?? 0;

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

      await Future.delayed(const Duration(seconds: 5)); // Ajusta el intervalo según tus necesidades
    }
  }
}
