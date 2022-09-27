import 'package:pet_feeder/api/feeding_api.dart';
import 'package:pet_feeder/api/mqtt_api.dart';
import 'package:pet_feeder/models/feeding.dart';
import 'package:pet_feeder/types/streamable.dart';

import '../models/connection.dart';

class FeedingService {
  final _mqttApi = MqttApi();
  final _feedingApi = FeedingApi();

  late final Streamable<Connection> connection;
  late List<Feeding> feedings;

  static final FeedingService instance = FeedingService();

  void onInvalidate() {}

  Future<void> initialize() async {
    connection = Streamable(await _mqttApi.checkConnectionAlive());
    feedings = await _feedingApi.getFeedings();
    // connection = await _mqttApi.checkConnectionAlive();
  }
}
