import 'package:pet_feeder/api/feeding_api.dart';
import 'package:pet_feeder/api/mqtt_api.dart';
import 'package:pet_feeder/api/schedule_api.dart';
import 'package:pet_feeder/models/feeding.dart';
import 'package:pet_feeder/models/schedule.dart';
import 'package:pet_feeder/types/streamable.dart';
import 'package:rxdart/rxdart.dart';

import '../models/connection.dart';

class AppService {
  static final AppService instance = AppService();

  final _mqttApi = MqttApi();
  final _feedingApi = FeedingApi();
  final _scheduleApi = ScheduleApi();

  final _connection = Streamable<Connection?>();
  final _feedings = Streamable<List<Feeding>?>();
  final _schedules = Streamable<List<Schedule>?>();

  Future<void> onInvalidate() async {
    try {
      _connection.add(null);
      _connection.add(await _mqttApi.checkConnectionAlive());
    } catch (e) {
      _connection.addError(e, StackTrace.empty);
    }

    try {
      _feedings.add(null);
      _feedings.add(await _feedingApi.getFeedings());
    } catch (e) {
      _feedings.addError(e, StackTrace.empty);
    }

    try {
      _schedules.add(null);
      _schedules.add(await _scheduleApi.getAll());
    } catch (e) {
      _schedules.addError(e, StackTrace.empty);
    }
  }

  Future<void> initialize() async {
    try {
      _connection.add(await _mqttApi.checkConnectionAlive());
    } catch (e) {
      _connection.addError(e, StackTrace.empty);
    }

    try {
      _feedings.add(await _feedingApi.getFeedings());
    } catch (e) {
      _feedings.addError(e, StackTrace.empty);
    }

    try {
      _schedules.add(await _scheduleApi.getAll());
    } catch (e) {
      _schedules.addError(e, StackTrace.empty);
    }
  }

  ValueStream<Connection?> get connection => _connection.stream;
  ValueStream<List<Feeding>?> get feedings => _feedings.stream;
  ValueStream<List<Schedule>?> get schedules => _schedules.stream;
}
