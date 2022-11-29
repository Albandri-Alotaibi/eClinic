import 'package:flutter/material.dart';

class startEnd {
  TimeOfDay start;
  TimeOfDay end;
  startEnd({
    required this.start,
    required this.end,
  });

  @override
  String toString() {
    // TODO: implement toString
    return "\n" +
        "start: ${start.hour}:${start.minute} - end: ${end.hour}:${end.minute}";
  }
}
