import 'package:flutter/material.dart';
import 'package:pet_feeder/api/feeding_api.dart';
import 'package:pet_feeder/models/feeding.dart';

class FeedingWidget extends StatefulWidget {
  final bool showStartButton;
  Feeding? selectedFeeding;

  FeedingWidget({this.showStartButton = false, this.selectedFeeding, Key? key}) : super(key: key);

  @override
  State<FeedingWidget> createState() => _FeedingWidgetState();
}

class _FeedingWidgetState extends State<FeedingWidget> {
  final FeedingApi _feedingApi = FeedingApi();
  late Future<List<Feeding>> _feedings;

  @override
  void initState() {
    super.initState();
    _feedings = _feedingApi.getFeedings();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Feeding>>(
        future: _feedings,
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonHideUnderline(
                child: DropdownButton(
                  hint: const Text("Choose feeding"),
                  items: snapshot.data?.map((feeding) {
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
                                Text("${feeding.durationSeconds}s")
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
                  value: snapshot.data != null &&
                          snapshot.data!.where((feeding) => feeding.id == widget.selectedFeeding?.id).isNotEmpty
                      ? snapshot.data?.where((feeding) => feeding.id == widget.selectedFeeding?.id).first
                      : null,
                  isExpanded: true,
                ),
              ),
              Visibility(
                visible: widget.showStartButton,
                child: ElevatedButton(
                  onPressed: () => {_feedingApi.startFeeding(widget.selectedFeeding?.id)},
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
        });
  }
}
