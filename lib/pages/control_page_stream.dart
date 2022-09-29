import 'package:flutter/material.dart';
import 'package:pet_feeder/api/schedule_api.dart';
import 'package:pet_feeder/models/schedule.dart';
import 'package:pet_feeder/service/app_service.dart';
import 'package:time_machine/time_machine.dart';

import '../dialogues/schedule_dialogue.dart';

class ControlPageStream extends StatefulWidget {
  const ControlPageStream({Key? key}) : super(key: key);

  @override
  State<ControlPageStream> createState() => _ControlPageStreamState();
}

class _ControlPageStreamState extends State<ControlPageStream> {
  AppService appService = AppService.instance;
  final ScheduleApi _scheduleApi = ScheduleApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ScheduleDialogue(
                        Schedule(true, LocalTime.minValue, [], null),
                        create: true,
                      )));
        },
        backgroundColor: Colors.lightGreen[400],
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
          child: StreamBuilder<List<Schedule>?>(
            stream: appService.schedules,
            initialData: appService.schedules.valueOrNull,
            builder: (context, snapshot) {
              final schedules = snapshot.data;
              if (schedules != null) {
                return buildScheduleList(schedules);
              } else {
                return Container();
              }
            },
          ),
          onRefresh: () async {
            await appService.onInvalidate();
          }),
    );
  }

  Widget buildScheduleList(List<Schedule> schedules) {
    return ListView.builder(
      itemCount: schedules.length,
      itemBuilder: (context, index) {
        return SwitchListTile(
          title: InkWell(
            child: Container(
              margin: const EdgeInsets.only(top: 5, bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "${schedules[index].time.hourOfDay.toString().padLeft(2, '0')}:${schedules[index].time.minuteOfHour.toString().padLeft(2, '0')}",
                      style: const TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold)),
                  Visibility(
                    child: Text(
                      schedules[index].repeatDays.map((day) => day.displayText).toList().join(" "),
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    visible: schedules[index].repeatDays.isNotEmpty,
                  )
                ],
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleDialogue(schedules[index])));
            },
          ),
          value: schedules[index].active,
          onChanged: (bool value) {
            setState(() {
              schedules[index].active = value;
              _scheduleApi.update(schedules[index]);
            });
          },
          activeColor: Colors.lightGreen[400],
        );
      },
    );
  }
}
