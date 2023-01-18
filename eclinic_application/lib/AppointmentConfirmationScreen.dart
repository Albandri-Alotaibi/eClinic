import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:myapp/style/Mycolors.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AppointmentConfirmationScreen extends StatefulWidget {
  const AppointmentConfirmationScreen(
      {super.key,
      required this.appointment,
      required this.faculty,
      required this.speciality});

  final Map<String, dynamic> appointment;
  final Map<String, dynamic> faculty;
  final Map<String, dynamic> speciality;

  @override
  AppointmentConfirmationScreenState createState() =>
      AppointmentConfirmationScreenState();
}

class AppointmentConfirmationScreenState
    extends State<AppointmentConfirmationScreen> {
  late List students;

  late ThemeData themeData;
  var formattedDate = DateFormat('dd-MM-yyyy hh:mm a');
  var formattedDateTime = DateFormat('hh:mm a');
  var currentProgressStatus = "";

  var loading = false;
  var bookingDone = false;
  Map<String, dynamic>? student;
  Map<String, dynamic>? semester;
  String? userid;
  String? email;

  @override
  void initState() {
    super.initState();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    userid = user!.uid;
    email = user.email!;

    loading = true;
    initStudent().then((value) => bookAnAppointment());
    pushNotification();
  }

  Future initStudent() async {
    currentProgressStatus = "getting student info";

    if (student != null) {
      return;
    }

    CollectionReference studentCollection =
        FirebaseFirestore.instance.collection('student');
    DocumentSnapshot studentData = await studentCollection.doc(userid).get();

    if (studentData.exists) {
      student = studentData.data() as Map<String, dynamic>;

      if (student?.containsKey("semester") ?? false) {
        DocumentReference? semesterData = studentData['semester'];
        setState(() {
          currentProgressStatus = "getting student semester";
        });

        if (semesterData != null) {
          var sData = await semesterData.get();

          if (sData.exists) {
            semester = sData.data() as Map<String, dynamic>;
            semester?['id'] = sData.reference.id;
            semester?['ref'] = sData.reference;
          }
        }
      }
    } else {
      student = null;
    }

    loading = false;
  }

  void bookAnAppointment() async {
    if (bookingDone) {
      return;
    }

    loading = true;

    try {
      setState(() {
        currentProgressStatus = "getting all students of project";
      });

      //get all students with same project name
      var studentsDoc = await FirebaseFirestore.instance
          .collection('student')
          .where("semester", isEqualTo: semester?['ref'])
          .get();

      //get their references
      students = studentsDoc.docs
          .map((doc) {
            setState(() {
              currentProgressStatus =
                  "getting student: ${doc.data()['firstname']}";
            });
            var projectname = doc.data()['projectname'] as String?;
            projectname = projectname
                    ?.replaceAll(RegExp('[^A-Za-z0-9]'), '')
                    .toLowerCase() ??
                "";
            if (projectname ==
                student?['projectname']
                    ?.replaceAll(RegExp('[^A-Za-z0-9]'), '')
                    ?.toLowerCase()) {
              return doc.reference;
            }
            return null;
          })
          .where((element) => element != null)
          .toList();

      //add the appointment to each students array of appointments
      var i = 0;
      for (var element in students) {
        i++;
        setState(() {
          currentProgressStatus = "adding appointment to a student $i";
        });

        await element?.update({
          'appointments': FieldValue.arrayUnion([widget.appointment['ref']])
        });
      }

      //update the appointment to add students/booked/specialty

      setState(() {
        currentProgressStatus = "updating appointment status";
      });
      await widget.appointment['ref']?.update({
        'Booked': true,
        'specialty': widget.speciality['ref'],
        'student': FieldValue.arrayUnion(students)
      });
      setState(() {
        loading = false;
      });
    } catch (e) {
      loading = false;
      setState(() {
        currentProgressStatus = "$e";
      });
    }

    loading = false;
    bookingDone = true;
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    if (loading) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('./assets/images/eClinicLogo-blue.png'),
              height: 50,
            ),
            const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 40),
            Text(
              "Booking an appointment with ${widget.faculty['firstname']} ${widget.faculty['lastname']}\n\nPlease wait.....\n\n ", //(${currentProgressStatus})
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
          ],
        ),
      );
    } else {
      return bookingIsDone();
    }
  }

  Widget bookingIsDone() {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        ClipPath(
            clipper: _MyCustomClipper(context),
            child: Container(
              alignment: Alignment.center,
              color: const Color.fromRGBO(21, 70, 160, 1),
            )),
        Positioned(
          left: 30,
          right: 30,
          top: MediaQuery.of(context).size.height * 0.15,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Card(
                child: Container(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: Column(
                    children: <Widget>[
                      const Image(
                          image: AssetImage('./assets/images/check-mark.png'),
                          height: 100),
                      Container(
                        margin: const EdgeInsets.only(bottom: 24, top: 0),
                        child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 10.0),
                            child: Text(
                              "The selected appointment is now booked for your group.",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            )),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                "Faculty: ${widget.faculty['firstname']} ${widget.faculty['lastname']}",
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Color.fromRGBO(21, 70, 160, 1),
                                    fontWeight: FontWeight.w600),
                              ),
                              // title: const Text("Faculty",
                              //     style: TextStyle(
                              //         fontSize: 12,
                              //         color: Colors.lightBlueAccent)),
                              leading: const Icon(
                                Icons.face_outlined,
                                color: Colors.black45,
                              ),
                            ),
                            const Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                            ListTile(
                              title: Text(
                                "Time: ${formattedDate.format(widget.appointment['starttime']!.toDate())}-${formattedDateTime.format(widget.appointment['endtime']!.toDate())}",
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Color.fromRGBO(21, 70, 160, 1),
                                    fontWeight: FontWeight.w600),
                              ),
                              // title: const Text("Time",
                              //     style: TextStyle(
                              //         fontSize: 12,
                              //         color: Colors.lightBlueAccent)),
                              leading: const Icon(
                                Icons.timer,
                                color: Colors.black45,
                              ),
                            ),
                            const Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                            ListTile(
                              title: Text(
                                "Speciality: ${widget.speciality['specialityname']}",
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Color.fromRGBO(21, 70, 160, 1),
                                    fontWeight: FontWeight.w600),
                              ),
                              // title: const Text("Speciality",
                              //     style: TextStyle(
                              //         fontSize: 12,
                              //         color: Colors.lightBlueAccent)),
                              leading: const Icon(
                                Icons.collections,
                                color: Colors.black45,
                              ),
                            ),
                            const Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                            ListTile(
                              title: Row(children: [
                                Text(
                                  "Meeting: ${meetingValues(widget.faculty['meetingmethod'])}",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Color.fromRGBO(21, 70, 160, 1),
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  widget.faculty['meetingmethod'] == "online"
                                      ? " (Click Me)"
                                      : " (${widget.faculty['mettingmethodinfo'] ?? "--"})",
                                  style: TextStyle(
                                      decoration:
                                          widget.faculty['meetingmethod'] ==
                                                  "online"
                                              ? TextDecoration.underline
                                              : null,
                                      fontSize: 15,
                                      color:
                                          const Color.fromRGBO(21, 70, 160, 1),
                                      fontWeight: FontWeight.w600),
                                ),
                              ]),
                              onTap: () => {
                                if (widget.faculty['meetingmethod'] ==
                                        "online" &&
                                    widget.faculty['mettingmethodinfo'] != "")
                                  {
                                    launchUrlString(
                                        widget.faculty['mettingmethodinfo'])
                                  }
                              },
                              // title: const Text("Meeting",
                              //     style: TextStyle(
                              //         fontSize: 12,
                              //         color: Colors.lightBlueAccent)),
                              leading: const Icon(
                                Icons.meeting_room,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 30,
          left: 30,
          child: ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.transparent),
                  shadowColor: MaterialStateColor.resolveWith(
                      (states) => Colors.transparent),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 16))),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: Text("Back",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: themeData.colorScheme.onPrimary,
                      letterSpacing: 0.5))),
        ),
      ],
    ));
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

  void sendPushMessege(String token, String msg) async {
    print(token);
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAIqZZfrY:APA91bGmyg-TtTdQSaXgauRdN1LmyCWHL18IWSzI5UxqHk3TYdCFegHCDysMhyEvEYFBi9o7ofyiAQE-HZOG_TGH9AnfknXWUZmZpbKvBJ0Wx4zsQ8BJPx21NDiZloaCoyfetjjPkRP4'
        },
        body: jsonEncode(
          <String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': msg,
              'title': 'appointment cancelation',
            },
            "notification": <String, dynamic>{
              "title": "Consultation appointment",
              "body": msg,
              "android_channel_id": "dbfood",
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error push notifcathion");
      }
    }
  }

  pushNotification() async {
    // final FirebaseAuth auth = await FirebaseAuth.instance;
    // final User? user = await auth.currentUser;
    // userid = user!.uid;

    var facultyName =
        "${widget.faculty['firstname']} ${widget.faculty['lastname']}";
    DateTime StartTimeDate = widget.appointment['starttime'].toDate();
    print(StartTimeDate);
    DateTime now = new DateTime.now();
    print(now);
    DateTime TimeFromNowTo24Hours = now.add(Duration(hours: 24));
    print(TimeFromNowTo24Hours);
    DateTime At4Pm = new DateTime(now.year, now.month, now.day, 16, 0, 0);
    print(At4Pm);
    print("ddddeeeeeeeeeemmmmmmmmmm1111");
    //print("ddddeeeeeeeeeemmmmmmmmmm");
    // while (students.length != null) {
    await Future.delayed(Duration(seconds: 1));
    print(students.length);
    print("ddddeeeeeeeeeemmmmmmmmmm22222");
    print(students);
    // }
    print("in the If ###################");
    if (now.isAfter(At4Pm)) {
      print("in the If ###################");
      if (StartTimeDate.isBefore(TimeFromNowTo24Hours)) {
        print("in the If ###################");
        //send t the faculty
        var facultyToken = widget.faculty['token'];
        //group name
        final DocumentSnapshot firstDtudentRef = await students[0].get();
        var projectName = firstDtudentRef['projectname'];
        //get time fo the appointment

        String facultymsg =
            "You have a new appointment tomorrow at ${formattedDateTime.format(widget.appointment['starttime']!.toDate())}";
        sendPushMessege(facultyToken, facultymsg);
        print("ddddeeeeeeeeeemmmmmmmmmm3333");

        for (int i = 0; i < students.length; i++) {
          String studentMsg =
              "Tomorrow at ${formattedDateTime.format(widget.appointment['starttime']!.toDate())}";
          final DocumentSnapshot StudentdocRef = await students[i].get();
          var studentToken = StudentdocRef['token'];
          sendPushMessege(studentToken, studentMsg);
        }
      }
    }
  }
}

class _MyCustomClipper extends CustomClipper<Path> {
  final BuildContext _context;

  _MyCustomClipper(this._context);

  @override
  Path getClip(Size size) {
    final path = Path();
    Size size = MediaQuery.of(_context).size;
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.3);
    path.lineTo(0, size.height * 0.6);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
//end
