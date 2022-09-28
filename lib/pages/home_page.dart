import 'package:flutter/material.dart';
import 'package:pet_feeder/dialogues/add_feeding_dialogue.dart';
import 'package:pet_feeder/service/app_service.dart';
import 'package:pet_feeder/widgets/connection_widget_stream.dart';
import 'package:pet_feeder/widgets/feeding_widget_stream.dart';

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
    appService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 25, 15, 15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        CustomStreamConnectionWidget(),
        Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.all(10),
          color: Colors.grey[300],
          child: FeedingWidgetStream(showStartButton: true),
        ),
        Container(
          margin: const EdgeInsets.only(top: 5),
          child: ElevatedButton(
            child: const Text(
              "+ ADD FEEDING",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.lightGreen[400]),
              padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
            ),
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddFeedingDialogue()),
              )
            },
          ),
        ),
      ]),
    );
  }
}
