import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_feeder/enums.dart';
import 'package:pet_feeder/extensions/string_extension.dart';

class MultiSelectDays extends StatefulWidget {
  List<Day>? selectedDays;

  MultiSelectDays({Key? key, this.selectedDays}) : super(key: key);

  @override
  State<MultiSelectDays> createState() => _MultiSelectDaysState();
}

class _MultiSelectDaysState extends State<MultiSelectDays> {
  final List<Day> days = Day.values;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 20),
        shrinkWrap: true,
        itemCount: days.length,
        itemBuilder: (context, index) {
          return InkWell(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Text(days[index].name.capitalize()),
              color: widget.selectedDays != null && widget.selectedDays!.contains(days[index])
                  ? Colors.grey[200]
                  : Colors.white,
            ),
            onTap: () {
              setState(() {
                if (widget.selectedDays!.contains(days[index])) {
                  widget.selectedDays!.remove(days[index]);
                } else {
                  widget.selectedDays!.add(days[index]);
                }
              });
            },
          );
        });
  }
}
