import 'dart:async';
import 'package:influxdb_client/api.dart';

Future<Map<String, dynamic>> fetchDataFromDatabase() async {
  // Crear InfluxDBClient
  var client = InfluxDBClient(
    url: 'http://localhost:8086',
    token: 'ymHvcMekmKA9-vJRSbwT4gSGDwAijui2twmdO_CPImyO7TZUFJac3wG-019JXO5Edh0Objbb95S840j-2mbOxw==',
    org: 'titulacion',
    bucket: 'titulacion',
    debug: true,
  );

  // Crear servicio de consulta y consultar datos
  var queryService = client.getQueryService();
  var fluxQuery = '''
    from(bucket: "titulacion")
      |> range(start: -20d)
      |> filter(fn: (r) => r["_measurement"] == "lecturas")
      |> last()
  ''';

  // Consultar datos
  var recordStream = await queryService.query(fluxQuery);

  // Obtener el primer registro
  var record = await recordStream.first;

  // Retornar los datos
  return {
    'peso': record['peso'],
    'temperatura': record['temperatura'],
  };
}

void main() async {
  // Obtener los datos de la base de datos
  var data = await fetchDataFromDatabase();

  // Imprimir los datos
  print('Peso: ${data['peso']}, Temperatura: ${data['temperatura']}');
}
