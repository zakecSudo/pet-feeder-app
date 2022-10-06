import 'package:flutter/material.dart';
import 'package:pet_feeder/dialogues/feeding_dialogue.dart';

import '../models/feeding.dart';
import '../service/app_service.dart';

class FeedingControlPage extends StatefulWidget {
  const FeedingControlPage({Key? key}) : super(key: key);

  @override
  State<FeedingControlPage> createState() => _FeedingControlPageState();
}

class _FeedingControlPageState extends State<FeedingControlPage> {
  AppService appService = AppService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const FeedingDialogue()));
        },
        backgroundColor: Colors.lightGreen[400],
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
          child: StreamBuilder<List<Feeding>?>(
            stream: appService.feedings,
            initialData: appService.feedings.valueOrNull,
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

  Widget buildScheduleList(List<Feeding> feedings) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 60),
      itemCount: feedings.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: InkWell(
            child: Container(
              margin: const EdgeInsets.only(top: 5, bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(feedings[index].name,
                            style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
                      ),
                      Text("${feedings[index].durationSeconds.round()}s", style: const TextStyle(fontSize: 14.0)),
                    ],
                  ),
                  Text(feedings[index].description, style: const TextStyle(fontSize: 18.0)),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FeedingDialogue(
                            feeding: feedings[index],
                          )));
            },
          ),
        );
      },
    );
  }
}
