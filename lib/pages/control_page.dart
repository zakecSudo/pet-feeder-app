import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_feeder/api/schedule_api.dart';
import 'package:pet_feeder/dialogues/schedule_edit_dialogue.dart';

import '../models/schedule.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({Key? key}) : super(key: key);

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final ScheduleApi _scheduleApi = ScheduleApi();
  late List<Schedule> _schedules = [];

  @override
  void initState() {
    super.initState();
    _refreshSchedules();
  }

  Future<void> _refreshSchedules() async {
    _refreshIndicatorKey.currentState?.show();
    _schedules = await _scheduleApi.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: ListView.builder(
        itemCount: _schedules.length,
        itemBuilder: (context, index) {
          return SwitchListTile(
            title: InkWell(
              child: Container(
                margin: const EdgeInsets.only(top: 5, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "${_schedules[index].time.hourOfDay.toString().padLeft(2, '0')}:${_schedules[index].time.minuteOfHour.toString().padLeft(2, '0')}",
                        style: const TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold)),
                    Visibility(
                      child: Text(
                        _schedules[index].repeatDays.map((day) => day.displayText).toList().join(" "),
                        style: const TextStyle(fontSize: 18.0),
                      ),
                      visible: _schedules[index].repeatDays.isNotEmpty,
                    )
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => ScheduleEditDialogue(_schedules[index])));
              },
            ),
            value: _schedules[index].active,
            onChanged: (bool value) {
              setState(() {
                _schedules[index].active = value;
                _scheduleApi.update(_schedules[index]);
              });
            },
            activeColor: Colors.lightGreen[400],
          );
        },
      ),
      onRefresh: () async {
        await _refreshSchedules();
        setState(() {});
      },
    );
  }
}
