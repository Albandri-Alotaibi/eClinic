import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentConfirmationScreen extends StatefulWidget {
  const AppointmentConfirmationScreen(
      {required this.appointment, required this.faculty});

  final Map<String, dynamic> appointment;
  final Map<String, dynamic> faculty;

  @override
  _AppointmentConfirmationScreenState createState() =>
      _AppointmentConfirmationScreenState();
}

class _AppointmentConfirmationScreenState
    extends State<AppointmentConfirmationScreen> {
  late ThemeData themeData;
  var formattedDate = new DateFormat('dd-MM-yyyy hh:mm a');
  var formattedDateTime = new DateFormat('hh:mm a');

  var loading = false;
  Map<String, dynamic>? student;
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
    initStudent();
    bookAnAppointment();
  }

  initStudent() async {
    CollectionReference studentCollection =
        FirebaseFirestore.instance.collection('student');
    DocumentSnapshot studentData = await studentCollection.doc(userid).get();

    if (studentData.exists) {
      student = studentData.data() as Map<String, dynamic>;

      var college;
      if (student?.containsKey("collage") ?? false) {
        DocumentReference? collageData = studentData['collage'];

        if (collageData != null) {
          var cData = await collageData.get();

          if (cData.exists) {
            college = cData.data() as Map<String, dynamic>;
            college?['id'] = cData.reference.id;
          }
        }
      }

      student?['collage'] = college;

      var department;
      if (student?.containsKey("department") ?? false) {
        DocumentReference? departmentData = studentData['department'];

        if (departmentData != null) {
          var dData = await departmentData.get();

          if (dData.exists) {
            department = dData.data() as Map<String, dynamic>;
            department['id'] = dData.reference.id;
          }
        }
      }

      student?['department'] = department;

      var semester;
      if (student?.containsKey("department") ?? false) {
        DocumentReference? semesterData = studentData['semester'];

        if (semesterData != null) {
          var sData = await semesterData.get();

          if (sData.exists) {
            semester = sData.data() as Map<String, dynamic>;
            semester?['id'] = sData.reference.id;
          }
        }
      }
      student?['semester'] = semester;
    } else {
      student = null;
    }
  }

  void bookAnAppointment() async {
    try {
      CollectionReference studentsRef =
          FirebaseFirestore.instance.collection('student');
      DocumentReference? appointmentDoc = FirebaseFirestore.instance
          .collection('faculty')
          .doc(widget.faculty['id'])
          .collection('appointment')
          .doc(widget.appointment['id']);

      await studentsRef.doc(userid).update({
        'appointments': FieldValue.arrayUnion([appointmentDoc])
      });

      var studentsDoc =
          await studentsRef.where("group", isEqualTo: student?['group']).get();

      var students = studentsDoc.docs.map((doc) {
        return doc.reference;
      }).toList();

      await appointmentDoc
          .update({'Booked': true, 'student': FieldValue.arrayUnion(students)});
    } catch (e) {
      debugPrint(e.toString());
      //show error message
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    if (loading) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('./assets/images/eClinicLogo-blue.png'),
              height: 180,
            ),
            Center(child: CircularProgressIndicator()),
            SizedBox(height: 20),
            Text(
              "Booking an appointment with ${widget.faculty['firstname']} ${widget.faculty['lastname']}\n\nPlease wait.....",
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
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  child: Column(
                    children: <Widget>[
                      Image(
                          image: AssetImage('./assets/images/check-mark.png'),
                          height: 180),
                      Container(
                        margin: EdgeInsets.only(bottom: 24, top: 0),
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 10.0),
                            child: Text(
                              "The selected appointment is now booked for your group.",
                              style: TextStyle(fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            )),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              readOnly: true,
                              initialValue:
                                  "${widget.faculty['firstname']} ${widget.faculty['lastname']}",
                              style: TextStyle(
                                  letterSpacing: 0.1,
                                  color: themeData.colorScheme.primary,
                                  fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                hintText: "Faculty",
                                hintStyle: TextStyle(
                                    letterSpacing: 0.1,
                                    color: themeData.colorScheme.primary,
                                    fontWeight: FontWeight.w500),
                                prefixIcon: Icon(Icons.face_outlined),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 16),
                              child: TextFormField(
                                readOnly: true,
                                initialValue: formattedDate.format(widget
                                        .appointment['starttime']!
                                        .toDate()) +
                                    "-" +
                                    formattedDateTime.format(widget
                                        .appointment['endtime']!
                                        .toDate()),
                                style: TextStyle(
                                    letterSpacing: 0.1,
                                    color: themeData.colorScheme.primary,
                                    fontWeight: FontWeight.w500),
                                decoration: InputDecoration(
                                  hintText: "Day/Time",
                                  hintStyle: TextStyle(
                                      letterSpacing: 0.1,
                                      color: themeData.colorScheme.primary,
                                      fontWeight: FontWeight.w500),
                                  prefixIcon: Icon(Icons.timer),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 16),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24)),
                                boxShadow: [
                                  BoxShadow(
                                    color: themeData.colorScheme.primary
                                        .withAlpha(18),
                                    blurRadius: 3,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.symmetric(vertical: 16))),
                                  onPressed: () {
                                    Navigator.popUntil(
                                        context, ModalRoute.withName('/'));
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
