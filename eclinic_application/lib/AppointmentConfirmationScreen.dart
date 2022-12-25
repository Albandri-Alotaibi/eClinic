import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

      // Map<String, dynamic>? college;
      // if (student?.containsKey("collage") ?? false) {
      //   DocumentReference? collageData = studentData['collage'];
      //
      //   if (collageData != null) {
      //     var cData = await collageData.get();
      //
      //     if (cData.exists) {
      //       college = cData.data() as Map<String, dynamic>;
      //       college['id'] = cData.reference.id;
      //     }
      //   }
      // }
      //
      // student?['collage'] = college;

      // Map<String, dynamic>? department;
      // if (student?.containsKey("department") ?? false) {
      //   DocumentReference? departmentData = studentData['department'];
      //
      //   if (departmentData != null) {
      //     var dData = await departmentData.get();
      //
      //     if (dData.exists) {
      //       department = dData.data() as Map<String, dynamic>;
      //       department['id'] = dData.reference.id;
      //     }
      //   }
      // }
      //
      // student?['department'] = department;

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
      var students = studentsDoc.docs
          .map((doc) {
            setState(() {
              currentProgressStatus =
                  "getting student: ${doc.data()['firstname']}";
            });
            var projectname = doc.data()['projectname'] as String?;
            projectname = projectname?.replaceAll(' ', '').toLowerCase() ?? "";
            if (projectname ==
                student?['projectname']?.replaceAll(' ', '')?.toLowerCase()) {
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
      debugPrintStack();
      debugPrint(e.toString());
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
              height: 180,
            ),
            const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 20),
            Text(
              "Booking an appointment with ${widget.faculty['firstname']} ${widget.faculty['lastname']}\n\nPlease wait.....\n\n ", //(${currentProgressStatus})
              textAlign: TextAlign.center,
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
              color: themeData.colorScheme.background,
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
                          height: 180),
                      Container(
                        margin: const EdgeInsets.only(bottom: 24, top: 0),
                        child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 10.0),
                            child: Text(
                              "The selected appointment is now booked for your group.",
                              style: TextStyle(fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            )),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              readOnly: true,
                              initialValue:
                                  "Faculty: ${widget.faculty['firstname']} ${widget.faculty['lastname']}",
                              style: TextStyle(
                                  letterSpacing: 0.1,
                                  color: themeData.colorScheme.primary,
                                  fontWeight: FontWeight.w500),
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.face_outlined),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              child: TextFormField(
                                readOnly: true,
                                initialValue:
                                    "Time: ${formattedDate.format(widget.appointment['starttime']!.toDate())}-${formattedDateTime.format(widget.appointment['endtime']!.toDate())}",
                                style: TextStyle(
                                    letterSpacing: 0.1,
                                    fontSize: 13,
                                    color: themeData.colorScheme.primary,
                                    fontWeight: FontWeight.w500),
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.timer),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              child: TextFormField(
                                readOnly: true,
                                initialValue:
                                    "Speciality: ${widget.speciality['specialityname']}",
                                style: TextStyle(
                                    letterSpacing: 0.1,
                                    color: themeData.colorScheme.primary,
                                    fontWeight: FontWeight.w500),
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.collections),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              child: TextFormField(
                                readOnly: true,
                                maxLines: 2,
                                minLines: 2,
                                initialValue:
                                    "Meeting: ${widget.faculty['meetingmethod']}\n${widget.faculty['mettingmethodinfo']}",
                                style: TextStyle(
                                    letterSpacing: 0.1,
                                    color: themeData.colorScheme.primary,
                                    fontWeight: FontWeight.w500),
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.meeting_room),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(24)),
                                boxShadow: [
                                  BoxShadow(
                                    color: themeData.colorScheme.primary
                                        .withAlpha(18),
                                    blurRadius: 3,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.symmetric(
                                              vertical: 16))),
                                  onPressed: () {
                                    Navigator.pushNamed(context, 'studenthome');
                                  },
                                  child: Text("Back to Home.",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color:
                                              themeData.colorScheme.onPrimary,
                                          letterSpacing: 0.5))),
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
          top: 24,
          left: 12,
          child: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: themeData.colorScheme.primary,
          ),
        ),
      ],
    ));
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
