import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/AppointmentConfirmationScreen.dart';
import 'package:flutter/material.dart';
import 'package:myapp/style/Mycolors.dart';
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
  late ValueNotifier<List<Map<String, dynamic>>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  List<Map<String, dynamic>> appointmentModels = [];

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late DateTime kToday;
  late DateTime kFirstDay;
  late DateTime kLastDay;
  var formattedDate = DateFormat('dd-MM-yyyy');
  var formattedDateTime = DateFormat('hh:mm a');

  var loading = false;

  @override
  void initState() {
    super.initState();

    loading = true;

    initAppointments();
  }

  void initAppointments() async {
    loading = true;

    CollectionReference? appointment = FirebaseFirestore.instance
        .collection('faculty')
        .doc(widget.faculty['id'])
        .collection('appointment');

    var q = await appointment
        .where('Booked', isEqualTo: false)
        .get(const GetOptions(source: Source.server));

    appointmentModels = [];
    for (var doc in q.docs) {
      var app = doc.data() as Map<String, dynamic>;
      app['id'] = doc.reference.id;
      app['ref'] = doc.reference;

      if (app['starttime'] != null &&
          DateTime.now().isBefore(app['starttime']?.toDate())) {
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
            backgroundColor: Colors.white,
            appBar: AppBar(
              // primary: true,
              centerTitle: true,
              backgroundColor: Mycolors.mainColorWhite,
              shadowColor: Colors.transparent,
              iconTheme: const IconThemeData(
                color: Color.fromARGB(255, 12, 12, 12),
              ),
              titleTextStyle: TextStyle(
                fontFamily: 'main',
                fontSize: 18,
                color: Mycolors.mainColorBlack,
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black54),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                  "${widget.faculty['firstname']} — ${widget.speciality['specialityname']}"),
            ),
            body: loading
                ? const Center(
                    child: CircularProgressIndicator(color: Color.fromRGBO(
                                                    21, 70, 160, 1)),
                  )
                : calendarBox()));
  }

  Widget calendarBox() {
    return Column(children: [
      if (appointmentModels.isEmpty)
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "No appointments available for this faculty. Go back and choose another faculty with available appointments.",
            style: TextStyle(fontSize: 18, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ),
      if (appointmentModels.isEmpty)
        ElevatedButton(
            style:  ElevatedButton.styleFrom(
                                    textStyle: const TextStyle(
                                        fontFamily: 'main', fontSize: 16),
                                    // shadowColor: Colors.blue[900],
                                    elevation: 20,
                                    backgroundColor: Mycolors.mainShadedColorBlue,
                                    shadowColor: Colors.transparent,
                                    minimumSize: const Size(200, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          17), // <-- Radius
                                    ),
                                  ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Go Back",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5))),
      if (appointmentModels.isNotEmpty)
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
                // physics: const NeverScrollableScrollPhysics(),
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromRGBO(21, 70, 160, 1),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      tileColor: Colors.transparent,
                      onTap: () => appointmentClick(value[index]),
                      title: Text(
                          "${formattedDateTime.format(value[index]['starttime']?.toDate() ?? DateTime.now())}-${formattedDateTime.format(value[index]['endtime']?.toDate() ?? DateTime.now())}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            // backgroundColor: Color.fromRGBO(21, 70, 160, 1),
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Color.fromRGBO(21, 70, 160, 1),
                          )),
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
                          speciality: widget.speciality)))
              .then((value) => setState(() {
                    initAppointments();
                  }));
        },
      );

      // set up the AlertDialog
      var alert = AlertDialog(
        title: const Text("Booking appointment for your group:"),
        content: Text(
            "Faculty: (${widget.faculty['firstname']} ${widget.faculty['lastname']}). "
                "\nDate: ${formattedDate.format(appointment['starttime']?.toDate() ?? DateTime.now())}"
                "\nTime: ${formattedDateTime.format(appointment['starttime']?.toDate() ?? DateTime.now())} until ${formattedDateTime.format(appointment['endtime']?.toDate() ?? DateTime.now())}."
                "\nSpeciality: ${widget.speciality['specialityname']} \nMeeting: ${meetingValues(widget.faculty['meetingmethod'])} (${widget.faculty['mettingmethodinfo']}).   \n\nAre you sure?"),
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

  String meetingValues(String value) {
    var items = {
      "inperson": "In Person",
    };

    if (items.containsKey(value)) {
      return items[value]!;
    }

    return value;
  }
}
