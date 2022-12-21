import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/AppointmentConfirmationScreen.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class FacultyViewScreen extends StatefulWidget {
  const FacultyViewScreen({required this.facultyId});

  final String facultyId;

  @override
  _FacultyViewScreenState createState() => _FacultyViewScreenState();
}

class _FacultyViewScreenState extends State<FacultyViewScreen> {
  late ThemeData themeData;
  late final ValueNotifier<List<Map<String, dynamic>>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  List<Map<String, dynamic>> appointmentModels = [];

  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  late DateTime kToday;
  late DateTime kFirstDay;
  late DateTime kLastDay;
  var formattedDate = new DateFormat('dd-MM-yyyy hh:mm a');
  var formattedDateTime = new DateFormat('hh:mm a');
  Map<String, dynamic>? faculty;

  var loading = false;

  @override
  void initState() {
    super.initState();

    loading = true;

    initFaculty();
    initAppointments();
  }

  void initFaculty() async {
    CollectionReference facultyCollection =
        FirebaseFirestore.instance.collection('faculty');

    DocumentSnapshot data = await facultyCollection.doc(widget.facultyId).get();

    faculty = data.data() as Map<String, dynamic>;

    faculty?['id'] = data.reference.id;
  }

  void initAppointments() async {
    CollectionReference? appointment = FirebaseFirestore.instance
        .collection('faculty')
        .doc(widget.facultyId)
        .collection('appointment');

    var q = await appointment.where('Booked', isEqualTo: false).get();

    for (var doc in q.docs) {
      var app = doc.data() as Map<String, dynamic>;
      app['id'] = doc.reference.id;

      appointmentModels.add(app);
    }

    appointmentModels.sort((a, b) {
      return a['starttime'].compareTo(b['starttime']);
    });

    debugPrint(appointmentModels.length.toString());

    if (appointmentModels.length.compareTo(1) == 1) {
      kFirstDay = appointmentModels.first['starttime'].toDate();

      kLastDay = appointmentModels.last['starttime'].toDate();
    } else {
      kFirstDay =
          appointmentModels.first['starttime']?.toDate() ?? DateTime.now();
      kLastDay =
          appointmentModels.first['starttime']?.toDate() ?? DateTime.now();
    }

    // DateTime.now().subtract(Duration(days: 60));

    // DateTime.now().add(Duration(days: 60));

    kToday = DateTime.now();

    _focusedDay = kFirstDay;
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));

    setState(() {
      loading = false;
      appointmentModels = appointmentModels;
    });
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  /// Returns a list of [DateTime] objects from [first] to [last], inclusive.
  List<DateTime> _daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
      (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    if (day.weekday == DateTime.friday || day.weekday == DateTime.saturday) {
      return [];
    }
    final kEvents = LinkedHashMap<DateTime, List<Map<String, dynamic>>>(
      equals: isSameDay,
      hashCode: (DateTime key) =>
          key.day * 1000000 + key.month * 10000 + key.year,
    )..addAll({
        day: appointmentModels
                .where((Map<String, dynamic> element) =>
                    element['starttime']?.toDate().difference(day).inDays == 0)
                .toList() ??
            []
      });

    return kEvents[day] ?? [];
  }

  List<Map<String, dynamic>> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = _daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(""
                  // widget.faculty.firstname + ' ' + widget.faculty.lastname
                  ),
            ),
            body: loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : calendarBox()));
  }

  Widget calendarBox() {
    return Column(children: [
      TableCalendar<Map<String, dynamic>>(
        headerStyle: const HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
        ),
        weekendDays: [DateTime.friday, DateTime.saturday],
        firstDay: kFirstDay,
        lastDay: kLastDay,
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        rangeStartDay: _rangeStart,
        rangeEndDay: _rangeEnd,
        calendarFormat: _calendarFormat,
        rangeSelectionMode: _rangeSelectionMode,
        eventLoader: _getEventsForDay,
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarStyle: CalendarStyle(outsideDaysVisible: false),
        onDaySelected: _onDaySelected,
        onRangeSelected: _onRangeSelected,
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
      ),
      const SizedBox(height: 8.0),
      Expanded(
        child: ValueListenableBuilder<List<Map<String, dynamic>>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      tileColor: Colors.lightBlueAccent,
                      onTap: () => appointmentClick(value[index]),
                      title: Text("Time : " +
                          formattedDateTime.format(
                              value[index]['starttime']?.toDate() ??
                                  DateTime.now()) +
                          "-" +
                          formattedDateTime
                              .format(value[index]['endtime']?.toDate() ??
                                  DateTime.now())
                              .toString()),
                    ),
                  );
                },
              );
            }),
      )
    ]);
  }

  void appointmentClick(Map<String, dynamic> appointment) {
    showAlertDialog(BuildContext context) {
      Widget cancelButton = TextButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
      );
      Widget continueButton = TextButton(
        child: Text("Yes, Confirm"),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AppointmentConfirmationScreen(
                      appointment: appointment, faculty: faculty!)));
        },
      );

      // set up the AlertDialog
      var alert = AlertDialog(
        title: Text("Booking appointment for your group:"),
        content: Text(""
            "It will be with (${faculty?['firstname']} ${faculty?['lastname']}), on ${formattedDate.format(appointment['starttime']?.toDate() ?? DateTime.now())} until ${formattedDateTime.format(appointment['endtime']?.toDate() ?? DateTime.now())}."),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    showAlertDialog(context);
  }
}
