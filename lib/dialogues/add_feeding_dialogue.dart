import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_feeder/api/feeding_api.dart';
import 'package:pet_feeder/api/mqtt_api.dart';
import 'package:pet_feeder/models/feeding.dart';

class AddFeedingDialogue extends StatefulWidget {

  const AddFeedingDialogue({Key? key}) : super(key: key);

  @override
  State<AddFeedingDialogue> createState() => _AddFeedingDialogueState();
}

class _AddFeedingDialogueState extends State<AddFeedingDialogue> {

  final MqttApi _mqttApi = MqttApi();
  final FeedingApi _feedingApi = FeedingApi();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Add feeding',
              style: TextStyle(
                  color: Colors.black54, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.grey,
        ),
        body: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.fromLTRB(20, 20, 30, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Name"),
                controller: _nameController,
              ),
               TextField(
                decoration: const InputDecoration(labelText: "Description"),
                controller: _descriptionController,
              ),
              TextField(
                decoration: const InputDecoration(
                    labelText: "Duration in seconds"),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ], // Only numbers can be entered
                controller: _durationController,
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // TODO: add control cant be less than 0.008
                        _mqttApi.turnMotor(_durationController.text.isNotEmpty ? double.parse(_durationController.text) : null);
                      },
                      child: const Text(
                        'Test',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.grey),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _feedingApi.saveFeeding(Feeding(
                            _nameController.text, _descriptionController.text,
                            _durationController.text.isNotEmpty ? double.parse(_durationController.text) : 0));
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Add feeding',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.lightGreen[400]),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
