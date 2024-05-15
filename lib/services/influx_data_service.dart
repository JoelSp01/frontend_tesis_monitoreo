import 'dart:async';
import 'package:influxdb_client/api.dart';

void main() async {
  // Crear InfluxDBClient
  var client = InfluxDBClient(
    url: 'http://localhost:8086',
    token: 'B6FuBSJ2PHbKlt_NUcpG3ocWgnVt7-VNR9tMjMaW_jsZwkuxW4azGATxSIpjMZMXkk7igjP6XgW06KP2ZViTcg==',
    org: 'titulacion',
    bucket: 'titulacion',
    debug: true,
  );

  // Crear servicio de consulta y consultar datos
  var queryService = client.getQueryService();
  var fluxQuery = '''
    from(bucket: "mi-bucket")
      |> range(start: -20d)
      |> filter(fn: (r) => r["_measurement"] == "GLP_measurement")
  ''';

  // Consultar datos
  print('\n\n----------------------- Consulta de datos -----------------------\n');
  var recordStream = await queryService.query(fluxQuery);

  // Imprimir resultados de la consulta
  print('\n\n--------------------- Resultados de la consulta ---------------------\n');
  await recordStream.forEach((record) {
    print('Valor de GLP en ${record['_time']} es ${record['_value']}');
  });

  // Cerrar cliente después de la consulta
  await Future.delayed(Duration(seconds: 5));
  client.close();
}
