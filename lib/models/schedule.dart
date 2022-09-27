import 'package:pet_feeder/enums.dart';
import 'package:pet_feeder/models/feeding.dart';
import 'package:pet_feeder/utils/date_time_utils.dart';
import 'package:time_machine/time_machine.dart';

class Schedule {
  final int? id;
  bool active;
  LocalTime time;
  final List<Day> repeatDays;
  Feeding feeding;

  Schedule(this.active, this.time, this.repeatDays, this.feeding, [this.id]);

  Schedule.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        active = json['active'],
        time = DateTimeUtils.getLocalTimeFromString(json['time']),
        repeatDays = List<Day>.from(json['repeatDays'].map((day) => Day.fromJson(day))),
        feeding = Feeding.fromJson(json['feeding']);
}
