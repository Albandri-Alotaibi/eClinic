import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/AppointmentConfirmationScreen.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class FacultyViewScreen extends StatefulWidget {
  const FacultyViewScreen(
      {super.key, required this.faculty, required this.speciality});
  final Map<String, dynamic> faculty;
  final Map<String, dynamic> speciality;

  @override
  FacultyViewScreenState createState() => FacultyViewScreenState();
}

class FacultyViewScreenState extends State<FacultyViewScreen> {
  late ThemeData themeData;
  late final ValueNotifier<List<Map<String, dynamic>>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  List<Map<String, dynamic>> appointmentModels = [];

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late DateTime kToday;
  late DateTime kFirstDay;
  late DateTime kLastDay;
  var formattedDate = DateFormat('dd-MM-yyyy hh:mm a');
  var formattedDateTime = DateFormat('hh:mm a');

  var loading = false;

  @override
  void initState() {
    super.initState();

    loading = true;

    initAppointments();
  }

  void initAppointments() async {
    CollectionReference? appointment = FirebaseFirestore.instance
        .collection('faculty')
        .doc(widget.faculty['id'])
        .collection('appointment');

    var q = await appointment
        .where('Booked', isEqualTo: false)
        .get(const GetOptions(source: Source.server));

    for (var doc in q.docs) {
      var app = doc.data() as Map<String, dynamic>;
      app['id'] = doc.reference.id;
      app['ref'] = doc.reference;

      if (DateTime.now().isBefore(app['starttime'].toDate())) {
        appointmentModels.add(app);
      }
    }

    appointmentModels.sort((a, b) {
      return a['starttime'].compareTo(b['starttime']);
    });

    if (appointmentModels.length > 1) {
      kFirstDay = appointmentModels.first['starttime'].toDate();
      // .subtract(const Duration(hours: 1));
      kLastDay = appointmentModels.last['endtime'].toDate();
      // .add(const Duration(hours: 1));
    } else {
      kFirstDay = appointmentModels.isNotEmpty
          ? appointmentModels.first['starttime']
              ?.toDate()
              .subtract(const Duration(hours: 1))
          : DateTime.now().subtract(const Duration(hours: 1));
      kLastDay = appointmentModels.isNotEmpty
          ? appointmentModels.last['endtime']
              ?.toDate()
              .add(const Duration(hours: 1))
          : DateTime.now().add(const Duration(hours: 1));
    }

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
                    isSameDay(element['starttime'].toDate(), day))
                .toList() ??
            []
      });

    return kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                  "${widget.faculty['firstname']} ${widget.faculty['lastname']} — ${widget.speciality['specialityname']}"),
            ),
            body: loading
                ? const Center(
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
        weekendDays: const [DateTime.friday, DateTime.saturday],
        firstDay: kFirstDay,
        pageAnimationEnabled: true,
        pageJumpingEnabled: true,
        lastDay: kLastDay,
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        calendarFormat: _calendarFormat,
        rangeSelectionMode: RangeSelectionMode.toggledOff,
        eventLoader: _getEventsForDay,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        calendarStyle: const CalendarStyle(
          outsideDaysVisible: false,
          markerSizeScale: 0.1,
          markersAlignment: Alignment.bottomRight,
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) => events.isNotEmpty
              ? Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                  ),
                  child: Text(
                    '${events.length}',
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              : null,
        ),
        onDaySelected: _onDaySelected,
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
                physics: const NeverScrollableScrollPhysics(),
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.indigo),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: ListTile(
                      tileColor: Colors.blueAccent,
                      onTap: () => appointmentClick(value[index]),
                      title: Text(
                          "${formattedDateTime.format(value[index]['starttime']?.toDate() ?? DateTime.now())}-${formattedDateTime.format(value[index]['endtime']?.toDate() ?? DateTime.now())}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.white)),
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
        child: const Text("Cancel"),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
      );
      Widget continueButton = TextButton(
        child: const Text("Yes, Confirm"),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AppointmentConfirmationScreen(
                      appointment: appointment,
                      faculty: widget.faculty,
                      speciality: widget.speciality)));
        },
      );

      // set up the AlertDialog
      var alert = AlertDialog(
        title: const Text("Booking appointment for your group:"),
        content: Text(
            "Faculty: (${widget.faculty['firstname']} ${widget.faculty['lastname']}). \nTime: ${formattedDate.format(appointment['starttime']?.toDate() ?? DateTime.now())} until ${formattedDateTime.format(appointment['endtime']?.toDate() ?? DateTime.now())}.\nSpeciality: ${widget.speciality['specialityname']} \nMeeting: ${widget.faculty['meetingmethod']}, ${widget.faculty['mettingmethodinfo']}.   \n\nAre you sure?"),
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
