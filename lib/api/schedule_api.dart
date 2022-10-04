import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pet_feeder/models/schedule_storable.dart';

import '../models/schedule.dart';
import '../values.dart';

class ScheduleApi {
  final Uri _scheduleUrl = Uri.parse(GlobalValues.baseUrl + "/schedules");

  Future<List<Schedule>> getAll() async {
    final response = await http.get(_scheduleUrl);
    final body = json.decode(response.body);

    return List<Schedule>.from(body.map((model) => Schedule.fromJson(model)));
  }

  Future<List<Schedule>> getUpcoming() async {
    final response = await http.get(Uri.parse(GlobalValues.baseUrl + "/schedules/upcoming"));
    final body = json.decode(response.body);

    return List<Schedule>.from(body.map((model) => Schedule.fromJson(model)));
  }

  Future<Schedule> create(Schedule schedule) async {
    ScheduleStorable scheduleStorable =
        ScheduleStorable(schedule.active, schedule.time, schedule.repeatDays, schedule.feeding!.id!);
    final response = await http.post(
      _scheduleUrl,
      body: json.encode(scheduleStorable.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return Schedule.fromJson(body);
    }
    throw Exception("Failed to create schedule. Status code: ${response.statusCode}");
  }

  Future<Schedule> update(Schedule schedule) async {
    ScheduleStorable scheduleStorable =
        ScheduleStorable(schedule.active, schedule.time, schedule.repeatDays, schedule.feeding!.id!);
    final response = await http.put(
      Uri.parse(GlobalValues.baseUrl + "/schedules/${schedule.id}"),
      body: json.encode(scheduleStorable.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return Schedule.fromJson(body);
    }
    throw Exception("Failed to update schedule. Status code: ${response.statusCode}");
  }

  Future<void> delete(int? scheduleId) async {
    if (scheduleId != null) {
      final response = await http.delete(Uri.parse(GlobalValues.baseUrl + "/schedules/$scheduleId"));

      if (response.statusCode != 200) {
        throw Exception("Failed to delete schedule. Status code: ${response.statusCode}");
      }
    }
  }
}
