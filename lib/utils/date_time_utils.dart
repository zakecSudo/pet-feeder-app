import 'package:time_machine/time_machine.dart';

class DateTimeUtils {
  static LocalTime getLocalTimeFromString(String timeString) {
    List<String> values = timeString.split(":");
    if (values[2].split(".").length == 2) {
      values[3] = values[2].split(".")[1];
      values[2] = values[2].split(".")[0];

      return LocalTime(int.parse(values[0]), int.parse(values[1]), int.parse(values[2]), ms: int.parse(values[3]));
    }

    return LocalTime(int.parse(values[0]), int.parse(values[1]), int.parse(values[2]));
  }
}
