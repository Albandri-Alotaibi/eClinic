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
    // var dateFormat = DateFormat("h:mm a");
    // DateTime tempDateS = DateFormat("hh:mm")
    //     .parse(start.hour.toString() + ":" + start.minute.toString());
    // DateTime tempDateE = DateFormat("hh:mm")
    //     .parse(end.hour.toString() + ":" + end.minute.toString());

    String indicator = start.hour >= 12 ? 'PM' : 'AM';
    int hour = start.hour % 12 == 0 ? 12 : start.hour % 12;

    String hourString = hour.toString().padLeft(2, '0');
    String minuteString = start.minute.toString().padLeft(2, '0');

    String indicator2 = end.hour >= 12 ? 'PM' : 'AM';
    int hour2 = end.hour % 12 == 0 ? 12 : end.hour % 12;

    String hourString2 = hour2.toString().padLeft(2, '0');
    String minuteString2 = end.minute.toString().padLeft(2, '0');

    return "\n" +
        "Start:${hourString}:${minuteString} ${indicator} - End:${hourString2}:${minuteString2} ${indicator2}";
  }
}
