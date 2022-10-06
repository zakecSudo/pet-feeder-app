import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pet_feeder/models/connection.dart';
import 'package:pet_feeder/values.dart';

class MqttApi {
  Future<Connection> checkConnectionAlive() async {
    Uri connectionStatusUrl = Uri.parse(GlobalValues.baseUrl + "/mqtt/connection-status");
    final response = await http.get(connectionStatusUrl);

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return Connection.fromJson(body);
    } else {
      throw Exception("Failed to load connection status. Status code: ${response.statusCode}");
    }
  }

  Future<void> turnMotor(double? seconds) async {
    if (seconds != null && seconds > 0.007) {
      http.post(Uri.parse(GlobalValues.baseUrl + "/mqtt/turn-motor/$seconds"));
    }
  }
}
