import 'package:flutter/material.dart';

class timesWithDates {
  DateTime StartOfRange;
  DateTime EndOfRange;
  timesWithDates({
    required this.StartOfRange,
    required this.EndOfRange,
  });

  @override
  String toString() {
    // TODO: implement toString
    return "Date :${StartOfRange.year}/ ${StartOfRange.month}/ ${StartOfRange.day} --->> starTtime: ${StartOfRange.hour}:${StartOfRange.minute} - endTime: ${EndOfRange.hour}:${EndOfRange.minute}\n";
  }


}