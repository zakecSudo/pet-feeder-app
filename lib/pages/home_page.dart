import 'package:flutter/material.dart';
import 'package:pet_feeder/extensions/string_extension.dart';
import 'package:pet_feeder/service/app_service.dart';
import 'package:pet_feeder/widgets/connection_widget_stream.dart';
import 'package:pet_feeder/widgets/feeding_widget_stream.dart';

import '../models/schedule.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppService appService = AppService.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 25, 15, 15),
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            CustomStreamConnectionWidget(),
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(10),
              color: Colors.grey[300],
              child: FeedingWidgetStream(showStartButton: true),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: StreamBuilder<List<Schedule>?>(
                stream: appService.upcomingSchedules,
                initialData: appService.upcomingSchedules.valueOrNull,
                builder: (context, snapshot) {
                  final schedules = snapshot.data;
                  if (schedules != null) {
                    return buildUpcomingList(schedules);
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUpcomingList(List<Schedule> schedules) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Upcoming events",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        ListView.builder(
          itemCount: schedules.length,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: const EdgeInsets.only(left: 0.0),
              title: Container(
                margin: const EdgeInsets.only(top: 5, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${schedules[index].time.hourOfDay.toString().padLeft(2, '0')}:${schedules[index].time.minuteOfHour.toString().padLeft(2, '0')}",
                      style: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${schedules[index].feeding?.name}, ${schedules[index].repeatDays.map((day) => day.name.capitalize()).toList().join(" ")}",
                      style: const TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
