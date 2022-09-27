import 'package:pet_feeder/enums.dart';
import 'package:time_machine/time_machine.dart';

class ScheduleStorable {
  final bool active;
  final LocalTime time;
  final List<Day> repeatDays;
  final int feedingId;

  ScheduleStorable(this.active, this.time, this.repeatDays, this.feedingId);

  Map<String, dynamic> toJson() => {
        'active': active,
        'time': time.toString("HH:mm:ss"),
        'repeatDays': List<String>.from(repeatDays.map((day) => day.toJson())),
        'feedingId': feedingId,
      };
}
