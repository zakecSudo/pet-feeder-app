import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_feeder/api/schedule_api.dart';
import 'package:pet_feeder/service/app_service.dart';
import 'package:pet_feeder/widgets/feeding_widget_stream.dart';
import 'package:pet_feeder/widgets/multi_select_days.dart';
import 'package:time_machine/time_machine.dart';

import '../models/schedule.dart';

class ScheduleEditDialogue extends StatefulWidget {
  final Schedule schedule;
  final bool create;

  const ScheduleEditDialogue(this.schedule, {this.create = false, Key? key}) : super(key: key);

  @override
  State<ScheduleEditDialogue> createState() => _ScheduleEditDialogueState();
}

class _ScheduleEditDialogueState extends State<ScheduleEditDialogue> {
  final scheduleApi = ScheduleApi();

  @override
  Widget build(BuildContext context) {
    AppService appService = AppService.instance;
    FeedingWidgetStream feedingWidget = FeedingWidgetStream(selectedFeeding: widget.schedule.feeding);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: widget.create
            ? const Text('Create schedule', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold))
            : const Text('Edit schedule', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: SizedBox(
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
            ),
            MultiSelectDays(selectedDays: widget.schedule.repeatDays),
            feedingWidget,
            Visibility(
              visible: !widget.create,
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(right: 5),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (feedingWidget.selectedFeeding != null) {
                              widget.schedule.feeding = feedingWidget.selectedFeeding!;
                            }
                            await scheduleApi.update(widget.schedule);
                            appService.onInvalidate();
                            Navigator.pop(context);
                          },
                          child: const Text("SAVE"),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.lightGreen[400]),
                            padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 5),
                        child: ElevatedButton(
                          onPressed: () async {
                            await scheduleApi.delete(widget.schedule.id);
                            appService.onInvalidate();
                            Navigator.pop(context);
                          },
                          child: const Text("DELETE"),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.red[600]),
                            padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: widget.create,
              child: ElevatedButton(
                onPressed: () async {
                  if (feedingWidget.selectedFeeding != null) {
                    widget.schedule.feeding = feedingWidget.selectedFeeding!;
                  }
                  await scheduleApi.create(widget.schedule);
                  appService.onInvalidate();
                  Navigator.pop(context);
                },
                child: const Text("CREATE"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.lightGreen[400]),
                  padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
