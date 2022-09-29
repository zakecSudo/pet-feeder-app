import 'package:flutter/material.dart';
import 'package:pet_feeder/api/feeding_api.dart';
import 'package:pet_feeder/service/app_service.dart';

import '../models/feeding.dart';

class FeedingWidgetStream extends StatefulWidget {
  final bool showStartButton;
  Feeding? selectedFeeding;

  FeedingWidgetStream({this.showStartButton = false, this.selectedFeeding, Key? key}) : super(key: key);

  @override
  State<FeedingWidgetStream> createState() => _FeedingWidgetStreamState();
}

class _FeedingWidgetStreamState extends State<FeedingWidgetStream> {
  final appService = AppService.instance;
  final feedingApi = FeedingApi();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Feeding>?>(
      stream: appService.feedings,
      initialData: appService.feedings.valueOrNull,
      builder: (context, snapshot) {
        final feedings = snapshot.data;
        if (widget.selectedFeeding != null) {
          widget.selectedFeeding = feedings?.where((feeding) => feeding.id == widget.selectedFeeding?.id).first;
        }
        return buildFeedingBanner(feedings);
      },
    );
  }

  Widget buildFeedingBanner(List<Feeding>? feedings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonHideUnderline(
          child: DropdownButton(
            hint: const Text("Choose feeding"),
            items: feedings?.map((feeding) {
              return DropdownMenuItem(
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 5,
                    right: 5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              feeding.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text("${feeding.durationSeconds.round()}s")
                        ],
                      ),
                      Text(feeding.description),
                    ],
                  ),
                ),
                value: feeding,
              );
            }).toList(),
            onChanged: (newVal) {
              setState(() {
                widget.selectedFeeding = newVal as Feeding;
              });
            },
            value: widget.selectedFeeding,
            isExpanded: true,
          ),
        ),
        Visibility(
          visible: widget.showStartButton,
          child: ElevatedButton(
            onPressed: () => {feedingApi.startFeeding(widget.selectedFeeding?.id)},
            child: const Text(
              "START",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
              Colors.grey,
            )),
          ),
        ),
      ],
    );
  }
}
