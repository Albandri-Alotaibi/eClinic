import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'model/StudentAppointment.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/login.dart';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'style/Mycolors.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/facultyhome.dart';
import 'package:simple_time_range_picker/simple_time_range_picker.dart';
import 'model/Appointment.dart';
import 'model/checkbox_state.dart';
import 'model/startEnd.dart';
import 'package:jiffy/jiffy.dart';
import 'package:intl/intl.dart';
import 'model/timesWithDates.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/login.dart';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'style/Mycolors.dart';

class StudentViewBookedAppointment extends StatefulWidget {
  const StudentViewBookedAppointment({super.key});

  @override
  State<StudentViewBookedAppointment> createState() =>
      _StudentViewBookedAppointmentState();
}

class _StudentViewBookedAppointmentState
    extends State<StudentViewBookedAppointment> {
  String? email = '';
  String? userid = '';
  List<StudentAppointment> BookedAppointments = []; //availableHours
  bool? isExists;
  int numOfDaysOfHelp = 0;

  void initState() {
    super.initState();
    BookedAppointments.clear();
    BookedAppointmentsExists();
    getBookedappointments();
  }

  Future<bool?> BookedAppointmentsExists() async {
    final FirebaseAuth auth = await FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    userid = user!.uid;
    email = user.email!;

    final snap = await FirebaseFirestore.instance
        .collection("student")
        .doc(userid)
        .snapshots()
        .listen((event) async {
      bool? found;
      if (event.data()!.containsKey('appointments') == true) {
        if (event['appointments'].length == 0) {
          print("NOOO1 Future booked Appoinyments");
          setState(() {
            isExists = false;
          });
        } else {
          found = false;

          DateTime now = new DateTime.now();
          var appdbarray = event['appointments'];
          print(appdbarray.runtimeType);
          print(appdbarray.length);

          for (var i = 0; i < appdbarray.length; i++) {
            print(appdbarray[i]);
            print(appdbarray[i].runtimeType);

            final DocumentSnapshot docRef2 = await appdbarray[i].get();
// *******************CHECK IN APPOINTMENT IS IN FUTURE ****************************
            Timestamp t1 = docRef2['starttime'] as Timestamp;
            DateTime StartTimeDate = t1.toDate();
            if ((now.isBefore(StartTimeDate))) {
              found = true;
            }
          } //END FOR

        } //end else array size is not zero
      } //END IF IT CONTAIN APPOINTMENTS ARRAY
      else {
        //or null   --- if (event.data()!.containsKey("name")==false)
        print("NOOO2 Future booked Appoinyments");
        setState(() {
          isExists = false;
        });
      }
      if (found == true) {
        print("Future booked Appoinyments Exists");
        setState(() {
          isExists = true;
        });
      } else if (found == false) {
        print("NOOO3 Future booked Appoinyments");
        setState(() {
          isExists = false;
        });
      }
    });

    return isExists;
  } //end function

  getBookedappointments() async {
    BookedAppointments.clear();
    BookedAppointments.length = 0;

    final FirebaseAuth auth = await FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    userid = user!.uid;
    email = user.email!;
    DateTime now = new DateTime.now();

    final snap2 = await FirebaseFirestore.instance
        .collection("student")
        .doc(userid)
        .snapshots()
        .listen((event) async {
      if (event.data()!.containsKey('appointments') == true) {
        BookedAppointments.clear();
        BookedAppointments.length = 0;

        var appdbarray = event['appointments'];
        print(appdbarray);
        numOfDaysOfHelp = appdbarray.length;
        print(appdbarray.length);

        for (var i = 0; i < appdbarray.length; i++) {
          final DocumentSnapshot docRef2 = await appdbarray[i].get();

// *******************CHECK IN APPOINTMENT IS IN FUTURE ****************************

          Timestamp t1 = docRef2['starttime'] as Timestamp;
          DateTime StartTimeDate = t1.toDate();
          if ((now.isBefore(StartTimeDate))) {
            print(
                "22222222222222222222222222222222222222222222222222222222222222222");
            print(docRef2.reference);
            // if appointment is in the future

// *******************START APPOINTMENT INFO ****************************
            print("*****************************0");
            String dayname = DateFormat("EEE").format(StartTimeDate);
            Timestamp t2 = docRef2['endtime'] as Timestamp;
            DateTime EndTimeDate = t2.toDate();
            var studentsrefrences = docRef2['student'];
            var specialityRef = docRef2['specialty'];
            final DocumentSnapshot docRef4 = await specialityRef.get();
            String specialityName = docRef4['specialityname']; //specialityname
            print(specialityName);

// *******************END APPOINTMENT INFO ****************************

// *******************START FACULTY NEEDED INFO ****************************
            final DocumentSnapshot docRef3 =
                await appdbarray[i].parent.parent.get();
            String facultyName =
                docRef3['firstname'] + ' ' + docRef3['lastname'];
            String meetingMethod = docRef3['meetingmethod'];
            String meetingInfo = docRef3['mettingmethodinfo'];
// *******************END FACULTY NEEDED INFO ****************************

            setState(() {
              BookedAppointments.add(new StudentAppointment(
                  appointmentId: docRef2.id,
                  appointmentReference: docRef2.reference,
                  FacultytId: docRef3.id,
                  Day: dayname,
                  startTime: StartTimeDate,
                  endTime: EndTimeDate,
                  FacultyName: facultyName,
                  specialityn: specialityName,
                  meetingMethod: meetingMethod,
                  meetingInfo: meetingInfo,
                  studentsArrayOfReference: studentsrefrences));
            });

            for (int i = 0; i < BookedAppointments.length; i++) {
              for (int j = i + 1; j < BookedAppointments.length; j++) {
                var temp;
                if ((BookedAppointments[i].startTime)
                    .isAfter(BookedAppointments[j].startTime)) {
                  temp = BookedAppointments[i];
                  BookedAppointments[i] = BookedAppointments[j];
                  BookedAppointments[j] = temp;
                }
              }
            } //end for date sorting

            for (int i = 0; i < BookedAppointments.length; i++) {
              for (int j = i + 1; j < BookedAppointments.length; j++) {
                if ((BookedAppointments[i].appointmentId ==
                    BookedAppointments[j].appointmentId)) {
                  setState(() {
                    dynamic res = BookedAppointments.removeAt(j);
                  });
                }
              }
            } //end deleting duplicate

          } //end for loop
        } //end if appointment is in the future
      } else {
        print("appointments array does not exist");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //return Scaffold();

    if (isExists == false) {
      //|| (BookedAppointments.length==0)
      //|| numOfDaysOfHelp==0
      return SafeArea(
        child: Scaffold(
            body: Container(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 19),
                child: Text(
                  "Booked Appointments",
                  style: TextStyle(
                      color: Mycolors.mainColorBlack,
                      fontFamily: 'main',
                      fontSize: 24),
                ),
              ),
              Card(
                color: Mycolors.mainShadedColorBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17), // <-- Radius
                ),
                shadowColor: Color.fromARGB(94, 114, 168, 243),
                elevation: 20,
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Text(
                    "No Booked Appointments",
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        color: Mycolors.mainColorWhite,
                        fontFamily: 'main',
                        fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        )),
      );
    } else {
      //BookedAppointments.isEmpty==false //numOfDaysOfHelp==BookedAppointments.length
      //if(BookedAppointments.length!=0){
      return SafeArea(
        child: Scaffold(
            body: //Row()
                Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: 350,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30, bottom: 10),
                        child: Text(
                          "Booked Appointments",
                          style: TextStyle(
                              color: Mycolors.mainColorBlack,
                              fontFamily: 'main',
                              fontSize: 24),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount:
                                numOfDaysOfHelp, //BookedAppointments.length,//numOfDaysOfHelp
                            itemBuilder: ((context, index) {
                              if (index < BookedAppointments.length) {
                                return Card(
                                    margin: EdgeInsets.only(bottom: 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          17), // <-- Radius
                                    ),
                                    shadowColor:
                                        Color.fromARGB(94, 250, 250, 250),
                                    elevation: 20,
                                    child: ExpansionTile(
                                      iconColor: Mycolors.mainShadedColorBlue,
                                      collapsedIconColor:
                                          Mycolors.mainShadedColorBlue,
                                      collapsedTextColor:
                                          Mycolors.mainShadedColorBlue,
                                      title: Text(
                                          BookedAppointments[index].Day +
                                              ",  " +
                                              BookedAppointments[index]
                                                  .StringDate() +
                                              "  " +
                                              BookedAppointments[index]
                                                  .StringTimeRange(),
                                          style: TextStyle(
                                              color: Mycolors.mainColorBlue,
                                              fontFamily: 'main',
                                              fontSize: 17)),
                                      children: [
                                        Row(children: <Widget>[
                                          Column(children: <Widget>[
                                            // Text("  Date : "+ BookedAppointments[index].StringDate()),
                                            // Text("  Time : "+BookedAppointments[index].StringTimeRange()),
                                            Text(""),
                                            //  Text("XXXXXXXX\n",
                                            //         style: TextStyle(color: Colors.black,)),
                                            Text(
                                                " With : " +
                                                    BookedAppointments[index]
                                                        .FacultyName +
                                                    "\n",
                                                style: TextStyle(
                                                    color:
                                                        Mycolors.mainColorBlack,
                                                    fontFamily: 'main',
                                                    fontSize: 15)),

                                            Text(
                                                " Specialized in : " +
                                                    BookedAppointments[index]
                                                        .specialityn +
                                                    "\n",
                                                style: TextStyle(
                                                    color:
                                                        Mycolors.mainColorBlack,
                                                    fontFamily: 'main',
                                                    fontSize: 15)),

                                            if (BookedAppointments[index]
                                                    .meetingMethod ==
                                                "inperson")
                                              //{
                                              Text(
                                                  "  Meeting type : In-person meeting\n",
                                                  style: TextStyle(
                                                      color: Mycolors
                                                          .mainColorBlack,
                                                      fontFamily: 'main',
                                                      fontSize: 15)),

                                            if (BookedAppointments[index]
                                                    .meetingMethod ==
                                                "inperson")
                                              Text(
                                                  " office number  : " +
                                                      BookedAppointments[index]
                                                          .meetingInfo +
                                                      "\n",
                                                  style: TextStyle(
                                                      color: Mycolors
                                                          .mainColorBlack,
                                                      fontFamily: 'main',
                                                      fontSize: 15)),

                                            if (BookedAppointments[index]
                                                    .meetingMethod ==
                                                "online")
                                              Text(
                                                  "  Meeting type : Online meeting \n",
                                                  style: TextStyle(
                                                      color: Mycolors
                                                          .mainColorBlack,
                                                      fontFamily: 'main',
                                                      fontSize: 15)),

                                            if (BookedAppointments[index]
                                                    .meetingMethod ==
                                                "online")
                                              // Text(
                                              //     " Meeting link  : " +
                                              //         BookedAppointments[index]
                                              //             .meetingInfo +
                                              //         "\n",
                                              //     style: TextStyle(
                                              //         color: Mycolors
                                              //             .mainColorBlack,
                                              //         fontFamily: 'main',
                                              //         fontSize: 15)),

                                              new RichText(
                                                text: new TextSpan(
                                                  //text: 'Meeting Link : ',
                                                  children: [
                                                    new TextSpan(
                                                      // style: defaultText,
                                                      text: "Meeting Link : ",
                                                      style: TextStyle(
                                                          color: Mycolors
                                                              .mainColorBlack,
                                                          fontFamily: 'main',
                                                          fontSize: 15),
                                                    ),
                                                    new TextSpan(
                                                      //new TextStyle(color: Colors.blue)
                                                      text: 'Click here \n',
                                                      style: TextStyle(
                                                          color: Colors.blue,
                                                          fontFamily: 'main',
                                                          fontSize: 15),
                                                      recognizer:
                                                          new TapGestureRecognizer()
                                                            ..onTap = () {
                                                              launch(BookedAppointments[
                                                                      index]
                                                                  .meetingInfo); //''+BookedAppointments[index].meetingInfo+''
                                                            },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ]),

                                          //crossAxisAlignment: CrossAxisAlignment.start,
                                          Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              verticalDirection:
                                                  VerticalDirection.up,
                                              children: <Widget>[
                                                IconButton(
                                                  icon: Icon(Icons.cancel),
                                                  onPressed: () => {
                                                    showConfirmationDialog(
                                                        context, index)
                                                    //CancelAppointment(index)
                                                  },
                                                ),
                                              ])
                                        ])
                                      ],
                                    ));

                                //       }),
                                //     )
                                //     ;
                                //   },
                                // )

                                // );
                                //}

                              } //index smaller than length
                              else {
                                return Row();
                                // return Column(
                                //         children: <Widget>[
                                //         Text("inside else"),
                                //         Text("${BookedAppointments.length}"),
                                //         Text("${numOfDaysOfHelp}"),

                                //         ]);
                              }
                            })),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )),
      ); //scaffold

    } //end els
  }

  var reasone;
  showConfirmationDialog(BuildContext context, int index) async {
// ---------------START OF CHECKING IF THE CANCEL IS ALLOWED----------------------------------------------------------
    // String appointmentId2 = BookedAppointments[index].appointmentId;
    // String FacultytId2 = BookedAppointments[index].FacultytId;
    // DateTime now = new DateTime.now();

    // final DocumentSnapshot docRef = await FirebaseFirestore.instance
    //     .collection("faculty")
    //     .doc(FacultytId2)
    //     .collection('appointment')
    //     .doc(appointmentId2)
    //     .get();

    // Timestamp t3 = docRef['starttime'] as Timestamp;
    // DateTime StartTimeDate = t3.toDate();

    // DateTime TimeFromNowTo10Hours = now.add(Duration(hours: 10));
    // print(
    //     "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    // print(TimeFromNowTo10Hours);

    // if (StartTimeDate.isAfter(TimeFromNowTo10Hours)) {
    /////CAN CANCLE

    Widget dontCancelAppButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
        shadowColor: Colors.blue[900],
        elevation: 20,
        backgroundColor: Mycolors.mainShadedColorBlue,
        minimumSize: Size(60, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // <-- Radius
        ),
      ),
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget YesCancelAppButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
        shadowColor: Colors.blue[900],
        elevation: 20,
        backgroundColor: Mycolors.mainShadedColorBlue,
        minimumSize: Size(60, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // <-- Radius
        ),
      ),
      child: Text("Yes"),
      onPressed: () {
        Navigator.of(context).pop();
        CancelAppointment(index);
      },
    );
    //var reasone;
    AlertDialog alert = AlertDialog(
      // title: Text(""),
      content: Column(children: [
        Text("Choose a  reason to cancel your appointment with " +
            BookedAppointments[index].FacultyName +
            " on " +
            BookedAppointments[index].StringDate() +
            " at " +
            BookedAppointments[index].StringTimeRange() +
            " ?\n"),
        DropdownButtonFormField(
          decoration: InputDecoration(
            hintText: 'Please Choose the reason for cancelation',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(
                  width: 0,
                )),
          ),
          items: const [
            DropdownMenuItem(
                child: Text("Lecture at the same time"),
                value: "Lecture at the same time"),
            DropdownMenuItem(
                child: Text("Exam at the same time"),
                value: "Exam at the same time"),
            DropdownMenuItem(
                child: Text("solution was found "),
                value: "solution was found"),
            DropdownMenuItem(
                child: Text("Other commitment"), value: "Other commitment")
          ],
          onChanged: (value) {
            setState(() {
              reasone = value;
            });
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || reasone == null) {
              return 'Please Choose the reason for cancelation';
            }
          },
        ),
      ]),
      actions: [
        dontCancelAppButton,
        YesCancelAppButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    // } else {
    //   //// CANNOT CANCLE

    //   Widget OkButton = ElevatedButton(
    //     style: ElevatedButton.styleFrom(
    //       textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
    //       shadowColor: Colors.blue[900],
    //       elevation: 20,
    //       backgroundColor: Mycolors.mainShadedColorBlue,
    //       minimumSize: Size(60, 40),
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(10), // <-- Radius
    //       ),
    //     ),
    //     child: Text("OK"),
    //     onPressed: () {
    //       Navigator.of(context).pop();
    //     },
    //   );

    //   AlertDialog alert = AlertDialog(
    //     // title: Text(""),
    //     content: Text("You CANNOT cancel your appointment with " +
    //         BookedAppointments[index].FacultyName +
    //         " on " +
    //         BookedAppointments[index].StringDate() +
    //         " at " +
    //         BookedAppointments[index].StringTimeRange() +
    //         " because it is within the next ten hours."),
    //     actions: [
    //       OkButton,
    //     ],
    //   );

    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return alert;
    //     },
    //   );
    // }//end else cant cancel
  } //END FUNCTION

  void sendPushMessege(
      String token, String Fname, String date, String res) async {
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
              'body': 'your appointment has been canceled with ',
              'title': 'appointment cancelation',
            },
            "notification": <String, dynamic>{
              "title": "Appointment Cancelation",
              "body":
                  "Your appointment with $Fname$date has been canceled. $res",
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

  CancelAppointment(int index) async {
    String appointmentId = BookedAppointments[index].appointmentId;
    String FacultytId = BookedAppointments[index].FacultytId;

//delete students array of reference in appointment and make booked false
    FirebaseFirestore.instance
        .collection("faculty")
        .doc(FacultytId)
        .collection('appointment')
        .doc(appointmentId)
        .update({
      'Booked': false,
      "student": FieldValue.delete(),
      "specialty": FieldValue.delete()
    });

    List studentsArrayOfRef =
        BookedAppointments[index].studentsArrayOfReference;
    print(
        "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    final snap2 = await FirebaseFirestore.instance
        .collection("faculty")
        .doc(FacultytId) //its the faclulty doc id???????????
        .get();
    String Fname = "Dr." + snap2['firstname'] + snap2['lastname'];

    // a msg for the faclulty
    final DocumentSnapshot student0ref = await studentsArrayOfRef[0].get();
    String projectName = student0ref['projectname'];
    sendPushMessege(
        snap2['token'],
        projectName,
        (" at ${BookedAppointments[index].StringDate()}"),
        ("\n Reasone: $reasone"));
    //student notification
    for (var i = 0; i < studentsArrayOfRef.length; i++) {
      final DocumentSnapshot docRef2 =
          await studentsArrayOfRef[i].get(); //await
      print(
          "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
      print(docRef2['token']);
      String st = docRef2['token'];
      print("appintment reference");
      print(BookedAppointments[index].appointmentReference);
      studentsArrayOfRef[i].update({
        "appointments": FieldValue.arrayRemove(
            [BookedAppointments[index].appointmentReference]),
      });
      sendPushMessege(st, Fname, "", "");
      print('++++++++++++++++++++++++++++++++++++++++++++++++++++');
    }

//delete the appointment in each student's appointments array

    // List studentsArrayOfRef =
    //     BookedAppointments[index].studentsArrayOfReference;
    // print(
    //     "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");

    // for (var i = 0; i < studentsArrayOfRef.length; i++) {
    //   final DocumentSnapshot docRef2 =
    //       await studentsArrayOfRef[i].get(); //await
    //   print(
    //       "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    //   //print(docRef2['token']);
    //   // String st = docRef2['token'];
    //   print("appintment reference");
    //   print(BookedAppointments[index].appointmentReference);
    //   studentsArrayOfRef[i].update({
    //     "appointments": FieldValue.arrayRemove(
    //         [BookedAppointments[index].appointmentReference]),
    //   });
    //   //sendPushMessege(st, Fname);
    //   print('++++++++++++++++++++++++++++++++++++++++++++++++++++');
    // }
  } //end cancel function

} //end class
