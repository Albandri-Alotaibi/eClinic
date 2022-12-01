import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_time_range_picker/simple_time_range_picker.dart';
import 'model/checkbox_state.dart';
import 'model/startEnd.dart';
import 'package:jiffy/jiffy.dart';
import 'package:intl/intl.dart';
import 'model/timesWithDates.dart';

class addHoursFaculty extends StatefulWidget {
  // const deem({super.key});

  @override
  State<addHoursFaculty> createState() => _AddHourState();
}

class _AddHourState extends State<addHoursFaculty> {
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  TimeOfDay initime = TimeOfDay.now();

  final daysOfHelp = [
    CheckBoxState(title: 'Sunday', hours: ['un']),
    CheckBoxState(title: 'Monday', hours: ['un']),
    CheckBoxState(title: 'Tuesday', hours: ['un']),
    CheckBoxState(title: 'Wednesday', hours: ['un']),
    CheckBoxState(title: 'Thursday', hours: ['un']),
  ];

  List<startEnd> ArrayOfTimesOfDays = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add hours'),
        ),
        body: ListView(
          children: [
            // ...daysOfHelp.map(buildSingleCheckbox).toList(),

            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(daysOfHelp[0].title),
              value: daysOfHelp[0].value,
              onChanged: (newvalue) {
                setState(() {
                  daysOfHelp[0].value = newvalue!;
                });
                selectTime1(0);
                // if (newvalue == false) {
                //   deleteHours(0);

                // }
              },
              subtitle: subtitleForEachDay(0),
            ),

            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(daysOfHelp[1].title),
              value: daysOfHelp[1].value,
              onChanged: (newvalue) {
                setState(() {
                  daysOfHelp[1].value = newvalue!;
                });
                selectTime1(1);
                // if (newvalue == false) {
                //   daysOfHelp[1].hours[0] = "un";
                // }
              },
              subtitle: subtitleForEachDay(1),
            ),

            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(daysOfHelp[2].title),
              value: daysOfHelp[2].value,
              onChanged: (newvalue) {
                setState(() {
                  daysOfHelp[2].value = newvalue!;
                });
                selectTime1(2);
                // if (newvalue == false) {
                //   daysOfHelp[1].hours[0] = "un";
                // }
              },
              subtitle: subtitleForEachDay(2),
            ),

            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(daysOfHelp[3].title),
              value: daysOfHelp[3].value,
              onChanged: (newvalue) {
                setState(() {
                  daysOfHelp[3].value = newvalue!;
                });
                selectTime1(3);
                // if (newvalue == false) {
                //   daysOfHelp[1].hours[0] = "un";
                // }
              },
              subtitle: subtitleForEachDay(3),
            ),

            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(daysOfHelp[4].title),
              value: daysOfHelp[4].value,
              onChanged: (newvalue) {
                setState(() {
                  daysOfHelp[4].value = newvalue!;
                });
                selectTime1(4);
                // if (newvalue == false) {
                //   daysOfHelp[1].hours[0] = "un";
                // }
              },
              subtitle: subtitleForEachDay(4),
            ),

            ListTile(
              title: ElevatedButton(
                  child: Text("Confirm"), onPressed: () => {Confirm()}),
            ),
          ],
        ));
  }

  _timeFormated(TimeOfDay Stime, TimeOfDay Etime, int x) {
    if (Stime == null || Etime == null) {}

    daysOfHelp[x].hours.add(startEnd(start: Stime, end: Etime));
    //ArrayOfTimesOfDays.add(startEnd(start: _startTime, end: _endTime));
  }

  selectTime1(int x) {
    if (daysOfHelp[x].value == false)
      return;
    else {
      if (daysOfHelp[x].hours.length == 1) {
        return TimeRangePicker.show(
            context: context,
            unSelectedEmpty: true,
            startTime:
                TimeOfDay(hour: _startTime.hour, minute: _startTime.minute),
            endTime: TimeOfDay(hour: _endTime.hour, minute: _endTime.minute),
            onSubmitted: (TimeRangeValue value) {
              setState(() {
                _startTime = value.startTime!;
                _endTime = value.endTime!;
              });

              if (_startTime.hour == _endTime.hour &&
                  _startTime.minute == _endTime.minute) {
                //can she have a period of time ends and start at the same hour???????????
                showerror(context,
                    "the start time connot be equal to the end time", x);
              } else if (_startTime.hour < 7 ||
                  _startTime.hour > 16 ||
                  _endTime.hour < 7 ||
                  _endTime.hour > 16) {
                // print(_startTime.hour);
                // print(_endTime.hour);
                showerror(context,
                    "the time you choosed is out of the working hours", x);
              } else
                _timeFormated(_startTime, _endTime, x);
            },
            onCancel: (() {
              setState(() {
                daysOfHelp[x].value = false;
                //daysOfHelp[x].hours[0] = "un";
              });
            }));
      }
    }
  }

  subtitleForEachDay(int x) {
    if (daysOfHelp[x].value == false)
      return Text("Unavailable");
    else {
      return Column(
        children: <Widget>[
          for (int i = 1; i < daysOfHelp[x].hours.length; i++)
            ListTile(
              title: Text(daysOfHelp[x].hours[i].toString()),
              subtitle: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => {deleteHour(x, i)},
              ),
            ),
          ElevatedButton(
            child: Text("add"),
            onPressed: () => TimeRangePicker.show(
              context: context,
              unSelectedEmpty: true,
              startTime:
                  TimeOfDay(hour: _startTime.hour, minute: _startTime.minute),
              endTime: TimeOfDay(hour: _endTime.hour, minute: _endTime.minute),
              onSubmitted: (TimeRangeValue value) {
                setState(() {
                  _startTime = value.startTime!;
                  _endTime = value.endTime!;
                });
                bool flag = true;
                for (var i = 1; i < daysOfHelp[x].hours.length; i++) {
                  startEnd startend = daysOfHelp[x].hours[i];
                  //--------------the new time = to the old times----------------------
                  if (startend.start.hour == _startTime.hour &&
                      startend.start.minute == _startTime.minute &&
                      startend.end.hour == _endTime.hour &&
                      startend.end.minute == _endTime.minute) {
                    showerror(
                        context,
                        "the new time you choosed is the same for the previos one",
                        x);
                    flag = false;
                  }
                  //----------------------------the start time = to the end time-------------------------------------
                  else if (_startTime.hour == _endTime.hour &&
                      _startTime.minute == _endTime.minute) {
                    //can she have a period of time ends and start at the same hour???????????
                    showerror(context,
                        "the start time connot be equal to the end time", x);
                    flag = false;
                  }

                  //-----------------------------the new start time > old start time------------------------------
                  else if (_startTime.hour < startend.start.hour) {
                    showerror(
                        context,
                        "the new start time must start after the the prevrios period of times",
                        x);
                    flag = false;
                  }
                  //------------------------new time connot be inside the old time-----------------------
                  else if (_startTime.hour >= startend.start.hour &&
                      _startTime.hour < startend.end.hour &&
                      (_endTime.hour >= startend.end.hour ||
                          _endTime.hour < startend.end.hour)) {
                    showerror(context,
                        "the new time must be out of the prevrios period ", x);
                    flag = false;
                  }
                  //------------------------time must be in working hours(7-4)-------------------------
                  else if (_startTime.hour < 7 ||
                      _startTime.hour > 16 ||
                      _endTime.hour < 7 ||
                      _endTime.hour > 16) {
                    // print(_startTime.hour);
                    // print(_endTime.hour);
                    showerror(context,
                        "the time you choosed is out of the working hours", x);
                    flag = false;
                  }
                }
                if (flag) _timeFormated(_startTime, _endTime, x);
              },
              // onCancel: (() {
              //   setState(() {
              //     daysOfHelp[x].value = false;
              //    // daysOfHelp[x].hours[0] = "un";
              //   });
              // })
            ),
          ),
        ],
      );
    } //end else
  } //end subtitle function

  deleteHour(int x, int i) {
    setState(() {
      dynamic res = daysOfHelp[x].hours.removeAt(i);
      if (daysOfHelp[x].hours.length == 1) {
        daysOfHelp[x].value = false;
      }
    });
  } //end delete function

  Confirm() {
    for (var k = 0; k < daysOfHelp.length; k++) {
      if (daysOfHelp[k].value == true) {
        var ArrayOfAllTheDayRanges = [];
        for (var i = 1; i < daysOfHelp[k].hours.length; i++) {
          TimeOfDay starttime = daysOfHelp[k].hours[i].start;
          TimeOfDay endtime = daysOfHelp[k].hours[i].end;

          List<timesWithDates> Ranges = hourDivision(starttime, endtime);
//var ArrayOfAllTheDayRanges = [];
//print(ArrayOfAllTheDayRanges.length);
          ArrayOfAllTheDayRanges.add(Ranges);
          //print(ArrayOfAllTheDayRanges.length);

        } //end of generating all ranges for one day
//print(ArrayOfAllTheDayRanges.length);
        OneDayGenerating(daysOfHelp[k].title, ArrayOfAllTheDayRanges);
      } //value true
    } //loop on each day
  } //end confirm

  hourDivision(TimeOfDay starttime, TimeOfDay endtime) {
//loop on days or deal with each day alone?

    //if checked
    //loop on its hour list length
    //convert each 2 times in the hour index  list to datetine

//convert user input start and end time to DateTime
    DateTime now = DateTime.now();
    DateTime start = DateTime(now.year, now.month, now.day, starttime.hour,
        starttime.minute); //user input converted
    DateTime end = DateTime(now.year, now.month, now.day, endtime.hour,
        endtime.minute); //user input converted

//  DateTime start = DateTime(2021, 07, 20, 10);//user input1
//  DateTime end = DateTime(2021, 07, 20, 12);//user input1

    var Ranges = <timesWithDates>[];

    var current1 = start;
    var current2 = current1.add(Duration(minutes: 25));

    while (current1.isBefore(end) && current2.isBefore(end)) {
      Ranges.add(
          new timesWithDates(StartOfRange: current1, EndOfRange: current2));

      current1 = current2.add(Duration(minutes: 5));
      current2 = current1.add(Duration(minutes: 25));
    }
    //print(Ranges); //each day will have its own array with all the available ranges in it.
    return Ranges;
  }

//Sunday
  OneDayGenerating(String day, List<dynamic> ArrayOfAllTheDayRanges) {
    var AllActualDatesWithRanges = <timesWithDates>[];
    Timestamp? startdate;
    Timestamp? enddate;
    DateTime startdateINDate = DateTime(1990, 1, 1);
    DateTime enddateINDate = DateTime(1990, 1, 20);
    final semesterRef = FirebaseFirestore.instance
        .collection('semester')
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        //print(doc['semestername']);
        if (doc['semestername'] == '1st 2022/2023') {
          startdate = doc['startdate'];
          enddate = doc['enddate'];
          print(startdate);
          print(enddate);
          startdateINDate = startdate!.toDate();
          enddateINDate = enddate!.toDate();
          print("new start date${startdateINDate}");
        }
      });
    });

    DateTime startingDate = startdateINDate; //admin start date or today
    //print("old start date${startingDate}");
    DateTime endDate = enddateINDate; //admin end date

    int diff = endDate.difference(startingDate).inDays;

    for (var i = 1; i <= diff; i++) {
      DateTime newDate =
          DateTime(startingDate.year, startingDate.month, startingDate.day + i);

      String dayname = DateFormat("EEE").format(
          newDate); //عشان يطلع اليوم الي فيه هذا التاريخ الجديد- الاحد او الاثنين... كسترنق

      if ((dayname == 'Sun' && day == 'Sunday') ||
          (dayname == 'Mon' && day == 'Monday') ||
          (dayname == 'Tue' && day == 'Tuesday') ||
          (dayname == 'Wed' && day == 'Wednesday') ||
          (dayname == 'Thu' && day == 'Thursday')) {
        for (var i = 0; i < ArrayOfAllTheDayRanges.length; i++) {
          for (var j = 0; j < ArrayOfAllTheDayRanges[i].length; j++) {
            DateTime start = DateTime(
                newDate.year,
                newDate.month,
                newDate.day,
                ArrayOfAllTheDayRanges[i][j].StartOfRange.hour,
                ArrayOfAllTheDayRanges[i][j].StartOfRange.minute);
            DateTime end = DateTime(
                newDate.year,
                newDate.month,
                newDate.day,
                ArrayOfAllTheDayRanges[i][j].EndOfRange.hour,
                ArrayOfAllTheDayRanges[i][j].EndOfRange.minute);

            AllActualDatesWithRanges.add(
                new timesWithDates(StartOfRange: start, EndOfRange: end));
          } //loop on one index in ArrayOfAllTheDayRanges
        } //loop on ArrayOfAllTheDayRanges

        //AllActualDatesWithRanges
        //HERE STORING IN DATABASE *****************************************

        //day
        //date
        //time

      } //end if sunday

    }
    print(day);
    print(AllActualDatesWithRanges.toString());
  }

  showerror(BuildContext context, String msg, int x) {
    if (daysOfHelp[x].hours.length == 1)
      setState(() {
        daysOfHelp[x].value = false;
      });
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            height: 90,
            decoration: BoxDecoration(
                color: Color(0xFFC72C41),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Row(
              children: [
                SizedBox(
                  width: 48,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Oh snap!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        msg,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ));
  }
} //en
