import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_feeder/api/feeding_api.dart';
import 'package:pet_feeder/api/mqtt_api.dart';
import 'package:pet_feeder/models/feeding.dart';

import '../service/app_service.dart';

class FeedingDialogue extends StatefulWidget {
  final Feeding? feeding;

  const FeedingDialogue({this.feeding, Key? key}) : super(key: key);

  @override
  State<FeedingDialogue> createState() => _FeedingDialogueState();
}

class _FeedingDialogueState extends State<FeedingDialogue> {
  final MqttApi mqttApi = MqttApi();
  final FeedingApi feedingApi = FeedingApi();
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
    AppService appService = AppService.instance;
    _nameController.text = widget.feeding?.name ?? '';
    _descriptionController.text = widget.feeding?.description ?? '';
    _durationController.text = widget.feeding?.durationSeconds.toString() ?? '';

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: widget.feeding == null
              ? const Text('Create feeding', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold))
              : const Text('Edit feeding', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.grey,
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.lightGreen[400],
          onPressed: () async {
            if (widget.feeding == null) {
              await feedingApi.create(Feeding(_nameController.text, _descriptionController.text,
                  _durationController.text.isNotEmpty ? double.parse(_durationController.text) : 0));
            } else if (widget.feeding != null) {
              widget.feeding?.name = _nameController.text;
              widget.feeding?.description = _descriptionController.text;
              widget.feeding?.durationSeconds =
                  _durationController.text.isNotEmpty ? double.parse(_durationController.text) : 0;

              await feedingApi.update(widget.feeding);
            }

            appService.onInvalidate();
            Navigator.pop(context);
          },
          label: Row(
            children: const [
              Padding(
                padding: EdgeInsets.only(right: 4.0),
                child: Icon(Icons.save),
              ),
              Text("Save")
            ],
          ),
        ),
        body: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.fromLTRB(20, 20, 30, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                decoration: const InputDecoration(labelText: "Duration in seconds"),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ], // Only numbers can be entered
                controller: _durationController,
              ),
              Visibility(
                visible: widget.feeding == null,
                child: Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: Container(
                    margin: const EdgeInsets.only(right: 5),
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: add control cant be less than 0.008
                        mqttApi.turnMotor(
                            _durationController.text.isNotEmpty ? double.parse(_durationController.text) : null);
                      },
                      child: const Text(
                        'Test',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: widget.feeding != null,
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: () async {
                      await feedingApi.delete(widget.feeding?.id);
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
        ));
  }
}
