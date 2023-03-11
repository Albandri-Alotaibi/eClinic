import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    var dateFormat = DateFormat("h:mm a");
    DateTime tempDateS = DateFormat("hh:mm")
        .parse(start.hour.toString() + ":" + start.minute.toString());
    DateTime tempDateE = DateFormat("hh:mm")
        .parse(end.hour.toString() + ":" + end.minute.toString());
    return "\n" +
        "Start:${dateFormat.format(tempDateS)} - End:${dateFormat.format(tempDateE)}";
  }
}
