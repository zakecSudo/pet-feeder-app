import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_feeder/api/schedule_api.dart';
import 'package:pet_feeder/widgets/feeding_widget.dart';
import 'package:pet_feeder/widgets/multi_select_days.dart';
import 'package:time_machine/time_machine.dart';

import '../models/schedule.dart';

class ScheduleEditDialogue extends StatefulWidget {
  final Schedule schedule;

  const ScheduleEditDialogue(this.schedule, {Key? key}) : super(key: key);

  @override
  State<ScheduleEditDialogue> createState() => _ScheduleEditDialogueState();
}

class _ScheduleEditDialogueState extends State<ScheduleEditDialogue> {
  final _scheduleApi = ScheduleApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Edit schedule', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
          children: [
            SizedBox(
                height: 130,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: true,
                  initialDateTime: DateTime(
                    1,
                    1,
                    1,
                    widget.schedule.time.hourOfDay,
                    widget.schedule.time.minuteOfHour,
                  ),
                  onDateTimeChanged: (DateTime value) {
                    widget.schedule.time = LocalTime(value.hour, value.minute, 0);
                  },
                )),
            MultiSelectDays(selectedDays: widget.schedule.repeatDays),
            FeedingWidget(
              selectedFeeding: widget.schedule.feeding,
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {});
                  _scheduleApi.updateSchedule(widget.schedule);
                  Navigator.pop(context);
                },
                child: const Text("SAVE"))
          ],
        ),
      ),
    );
  }
}
