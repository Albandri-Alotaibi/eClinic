import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/facultyhome.dart';
import 'package:myapp/screeens/resources/snackbar.dart';
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

class FacultyViewBookedAppointment extends StatefulWidget {
  const FacultyViewBookedAppointment({super.key});

  @override
  State<FacultyViewBookedAppointment> createState() => _sState();
}

class _sState extends State<FacultyViewBookedAppointment> {
  String? email = '';
  String? userid = '';
  List<Appointment> BookedAppointments = []; //availableHours
  bool? isExists;
  //  bool  isExists=false;
  //bool AleardyintheArray=false;
  bool? AleardyintheArray;
  int numOfBookedApp = 0;
// var studentsArrayOfRef;
// List students=[];
// String projectname="";

// @override
//   void initState() {
//     super.initState();
//   BookedAppointmentsExists(); // use a helper method because initState() cannot be async
//   getBookedappointments();
//   }
//+++++++++++++++++++++++++++++++++++++DEEM++++++++++++++++++++++++++++++++
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  TextEditingController username = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
  //+

  void initState() {
    super.initState();
    BookedAppointments.clear();
//WidgetsBinding. instance. addPostFrameCallback((_) => getBookedappointments(context));
//makeachange();
    BookedAppointmentsExists();
    getBookedappointments();

    //++++++++++++++++++++++++++DEEM++++++++++++++++++++++++++++++++
    requestPremission();
    getToken();
    initInfo();
  }

  //Future<bool?>
  BookedAppointmentsExists() async {
    final FirebaseAuth auth = await FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    userid = user!.uid;
    email = user.email!;

//  Timestamp timestampofnow =new Timestamp.now();
// //as Timestamp
//   final snap = await FirebaseFirestore.instance
//         .collection("faculty")
//         .doc(userid)
//         .collection('appointment')
//         .where("Booked", isEqualTo: true)
//         //.where("starttime", isGreaterThanOrEqualTo: timestampofnow)
//         .snapshots()
//         .listen((event) {
// if (event.size == 0) { //if no booked appointments at all
//         print('NOT exist');
//         }
//         else{
//        print(' exist');
//         }
//         });

    final snap = await FirebaseFirestore.instance
        .collection("faculty")
        .doc(userid)
        .collection('appointment')
        .snapshots()
        .listen((event) {
      bool? found;
      if (event.size == 0) {
        //if no booked appointments at all
        setState(() {
          isExists = false;
        });
      } //end if no appointments at all
      else {
        // else there are appointments

        found = false;

        event.docs.forEach((element) async {
          DateTime now = new DateTime.now();
          Timestamp t = element['starttime'] as Timestamp;
          DateTime StartTimeDateTest = t.toDate();
          if ((element['Booked'] == true) &&
              (now.isBefore(StartTimeDateTest))) {
            // setState(() {
            //     isExists = true;
            //       });
            found = true;
          } //end if
        }); //end for each appointment
      } //end else

      if (found == true) {
        setState(() {
          isExists = true;
        });
      } else if (found == false) {
        setState(() {
          isExists = false;
        });
      }
    }); //end all event

    return isExists;
  } //end function

  getBookedappointments() async {
    //BuildContext context// Future
    BookedAppointments.clear();
    BookedAppointments.length = 0;
    // numOfBookedApp = 0;
    //await Future.delayed(Duration(seconds: 5));

    final FirebaseAuth auth = await FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    userid = user!.uid;
    email = user.email!;

    // print("yes");

    final snap2 = await FirebaseFirestore.instance
        .collection("faculty")
        .doc(userid)
        .collection('appointment')
        //.where("Booked", isEqualTo: true)
        // .orderBy('starttime')
        .snapshots()
        .listen((event) {
      //event ترجع كل شي مو بس الجديد
      numOfBookedApp = event.size;
      print("######################################");
      print(event.size);

      BookedAppointments.clear();
      BookedAppointments.length = 0;
      print("xxxxxxxx");
      event.docs.forEach((element) async {
        //print(element.id);
        print("1");

        DateTime now = new DateTime.now();
        Timestamp t = element['starttime'] as Timestamp;
        DateTime StartTimeDateTest = t.toDate();
        if ((element['Booked'] == true) && (now.isBefore(StartTimeDateTest))) {
          print(element.id);

          print("2");

          //  setState(() {
          //  AleardyintheArray=false;
          //    });

          //  String id=element.id;
          // for (var j = 0; j < BookedAppointments.length; j++) {
          //   print("3");
          //    if(BookedAppointments[j].id == element.id){
          //     print("4");
          //      setState(() {
          //    AleardyintheArray=true;
          //      });
          //   }
          //  }

          print("5");
          //AleardyintheArray= BookedAppointments[0].id.contains(id);

          // if(AleardyintheArray==false){
          print("6");
          //students.clear();
          var studentsArrayOfRef;
          var group;
          List students = [];
          students.clear();
          String projectname = "";

          Timestamp t1 = element['starttime'] as Timestamp;
          DateTime StartTimeDate = t1.toDate();
          print("element.reference");
          print(element.reference);

          Timestamp t2 = element['endtime'] as Timestamp;
          DateTime EndTimeDate = t2.toDate();

          String dayname = DateFormat("EEE").format(
              StartTimeDate); //عشان يطلع اليوم الي فيه هذا التاريخ الجديد- الاحد او الاثنين... كسترنق

          print(dayname);
          var specialtyRef = element['specialty'];
          final DocumentSnapshot specialtyDocRef2 = await specialtyRef.get();
          String spName = specialtyDocRef2['specialityname'];
          print(spName);
// ******************************HERE START ***********************************************************
          group = await element['group'];
          final DocumentSnapshot groupRef = await group.get();
          var Students = await groupRef['students'];
          print("HOW MANNNNNNY STUDEEEEEEEENTSSSSS***********");
          print(Students.length);

          projectname = groupRef['projectname'];

          for (var i = 0; i < Students.length; i++) {
            final DocumentSnapshot docRef2 = await Students[i]['ref'].get();

            print(docRef2['firstname']);
            String name = docRef2['firstname'] + " " + docRef2['lastname'];
            students.add(name);
            print(students);
          }

// ******************************HERE END ***********************************************************

          //if(AleardyintheArray==false){
          setState(() {
            BookedAppointments.add(new Appointment(
                reference: element.reference,
                id: element.id,
                Day: dayname,
                startTime: StartTimeDate,
                endTime: EndTimeDate,
                projectName: projectname,
                students: students,
                specialty: spName));
          });

          // }//if not AleardyintheArray
        } //end if booked
//         else{
//  setState(() {
//       isExists = false;
//         });

//         }

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
            if ((BookedAppointments[i].id == BookedAppointments[j].id)) {
              setState(() {
                dynamic res = BookedAppointments.removeAt(j);
              });
            }
          }
        } //end deleting duplicate

        // else{

        // for (var i = 0; i < BookedAppointments.length; i++) {
        //  if(BookedAppointments[i].id == element.id){
        //  setState(() {
        //  dynamic res = BookedAppointments.removeAt(i);
        //  print(res);
        //   //numOfBookedApp=numOfBookedApp-1;
        //   //Exist=false; if event size==0
        //   });

        //  }//end if

        // }//end for
        // }//else not booked
      }); //end for each
    });
    print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%1");
    print(BookedAppointments.length);
    print(BookedAppointments.toString());

    //      .get()
    //     .then((QuerySnapshot snapshot) {

    //   // print("############################################");
    //    //print(snapshot.size);

    //  numOfBookedApp = snapshot.size;

    //   snapshot.docs.forEach((DocumentSnapshot doc) async {
    //    //if(doc['Booked']==true){

    //     // numOfBookedApp=numOfBookedApp+1;

    //    Timestamp t1= doc['starttime'] as Timestamp;
    //    DateTime StartTimeDate=t1.toDate();

    //    Timestamp t2= doc['endtime'] as Timestamp;
    //    DateTime EndTimeDate=t2.toDate();

    //    studentsArrayOfRef=doc['students'];
    //   print("######################################");
    //    print(studentsArrayOfRef);
    //    print(studentsArrayOfRef.length);
    //   int len =studentsArrayOfRef.length;

    //   for (var i = 0; i < len; i++) {
    // final DocumentSnapshot docRef2 = await studentsArrayOfRef[i].get();
    //  print(docRef2['Name']);
    //  students.add(docRef2['Name']);
    //  projectname=docRef2['ProjectName'];
    //   }

    //    setState(() {
    //     BookedAppointments.add(new Appointment(id: doc.id, Day: doc['Day'], startTime: StartTimeDate, endTime: EndTimeDate,projectName:projectname, students:  students));
    //     });

    //   // }
    //   });

    // });// end then
    //for()
//     BookedAppointments.startTime.sort((a, b){ //sorting in descending order
//     return b.compareTo(a);
// });

//numOfBookedApp=BookedAppointments.length;
    // print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%1");
    //  print(numOfBookedApp);
    //  print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%2");
    //  print(BookedAppointments.length);
    //  print(BookedAppointments.toString());
  } //end method get

  @override
  Widget build(BuildContext context) {
    //getBookedappointments();

    if (isExists == false && BookedAppointments.isEmpty) {
      //|| numOfBookedApp==0
      return SafeArea(
        child: Scaffold(
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            body: Container(
              alignment: Alignment.topCenter,
              child: Column(
                children: const [
                  Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Text(
                      "No Booked Appointments",
                      overflow: TextOverflow.clip,
                      style: TextStyle(color: Colors.black54, fontSize: 20),
                    ),
                  ),
                  // ),
                ],
              ),
            )),
      );
    } else {
      if (BookedAppointments.isEmpty == false) {
        return SafeArea(
          child: Scaffold(
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              body: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: 350,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                              itemCount:
                                  numOfBookedApp, //BookedAppointments.length,//numOfBookedApp
                              itemBuilder: ((context, index) {
                                if (index < BookedAppointments.length) {
                                  return Card(
                                      margin: EdgeInsets.only(bottom: 20),
                                      color: Color.fromARGB(68, 221, 221, 221),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            17), // <-- Radius
                                      ),
                                      // shadowColor:
                                      //     Color.fromARGB(94, 250, 250, 250),
                                      elevation: 0,
                                      child: ExpansionTile(
                                        // backgroundColor:
                                        //     Mycolors.mainColorBlue,
                                        iconColor: Mycolors.mainShadedColorBlue,
                                        collapsedIconColor:
                                            Mycolors.mainShadedColorBlue,
                                        collapsedTextColor:
                                            Mycolors.mainShadedColorBlue,

                                        title: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20, bottom: 20),
                                          child: Row(
                                            children: [
                                              Text(
                                                  BookedAppointments[index]
                                                          .Day +
                                                      ",  " +
                                                      BookedAppointments[index]
                                                          .StringDate() +
                                                      "  " +
                                                      BookedAppointments[index]
                                                          .StringTimeRange(),
                                                  style: TextStyle(
                                                      color: Mycolors
                                                          .mainShadedColorBlue,
                                                      fontSize: 16)),
                                            ],
                                          ),
                                        ),

                                        //BookedAppointments[index].Day),

                                        //subtitle: Text("Date : "+ BookedAppointments[index].StringDate()+"\n Time : "+BookedAppointments[index].StringTimeRange()),
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 18),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "Speciality : " +
                                                        BookedAppointments[
                                                                index]
                                                            .specialty +
                                                        "\n",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        color: Mycolors
                                                            .mainColorBlack,
                                                        //fontFamily: 'Semibold',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15),
                                                  ),
                                                  Text(
                                                    "Project : " +
                                                        BookedAppointments[
                                                                index]
                                                            .projectName +
                                                        "\n",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      color: Mycolors
                                                          .mainColorBlack,
                                                      // fontFamily: 'Semibold',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  Text(
                                                      "Students : " +
                                                          BookedAppointments[
                                                                  index]
                                                              .StringStudents() +
                                                          "",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          color: Mycolors
                                                              .mainColorBlack,
                                                          //  fontFamily: 'Semibold',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 15)),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 7),
                                                        height: 40,
                                                        width: 100,
                                                        child:
                                                            FloatingActionButton
                                                                .extended(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30), // <-- Radius
                                                            side: BorderSide(
                                                              width: 1,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      169,
                                                                      43,
                                                                      34),
                                                            ),
                                                          ),
                                                          splashColor:
                                                              Colors.red[900],
                                                          elevation: 0,
                                                          foregroundColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  255,
                                                                  255,
                                                                  255),
                                                          label: Text(
                                                            'Cancel',
                                                          ), // <-- Text
                                                          backgroundColor:
                                                              Colors.red[900],
                                                          icon: Icon(
                                                            // <-- Icon
                                                            Icons.cancel,
                                                            size: 24.0,
                                                          ),
                                                          onPressed: () => {
                                                            showConfirmationDialog(
                                                                context, index)
                                                            // CancelAppointment(index)
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ]),
                                          ),
                                          //crossAxisAlignment: CrossAxisAlignment.start,
                                          // Row(
                                          //     crossAxisAlignment:
                                          //         CrossAxisAlignment.end,
                                          //     mainAxisAlignment:
                                          //         MainAxisAlignment.end,
                                          //     verticalDirection:
                                          //         VerticalDirection.up,
                                          //     children: <Widget>[
                                          //       IconButton(
                                          //         icon: Icon(
                                          //           Icons.cancel,
                                          //           color: Color.fromARGB(
                                          //               255, 175, 48, 38),
                                          //         ),
                                          //         onPressed: () => {
                                          //           showConfirmationDialog(
                                          //               context, index)
                                          //           //CancelAppointment(index)
                                          //         },
                                          //       ),
                                          //     ])
                                          //  ])
                                        ],
                                      ));
                                } //index smaller than length
                                else {
                                  return Row();
                                  // return Column(
                                  //         children: <Widget>[
                                  //         Text("inside else"),
                                  //         Text("${BookedAppointments.length}"),
                                  //         Text("${numOfBookedApp}"),

                                  //         ]);
                                }
                              })),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        );
      } else {
        return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
                child: CircularProgressIndicator(
                    color: Mycolors.mainShadedColorBlue)));
      }
    } //end else there is booked appointments
    //   else{
    // return Scaffold(
    //         appBar: AppBar(
    //           title: Text('Booked Appointments'),
    //         ),
    //         body: Row()
    // );

    //   }
  }

  //+++++++++++++++++++++++++++++++++++++++++DEEM+++++++++++++++++++++++++++++++++++++++++++++++++++++++
  void requestPremission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
      print("User granted premission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
      print("User granted provisional permission");
    } else {
      print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
      print("User declined or has not accepted premission");
    }
  }

  String? mtoken = " ";

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print("My token is $mtoken");
      });
      saveToken(token!);
    });
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance
        .collection("faculty")
        .doc(userid)
        .update({'token': token});
  }

  initInfo() async {
    var androidInitialize =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var initializationSettings =
        InitializationSettings(android: androidInitialize);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        final String? payload = notificationResponse.payload;
        if (notificationResponse.payload != null) {
          debugPrint('notification payload: $payload');
        }
        await Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (context) => facultyhome(0)),
        );
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("...................onMessage................");
      print(
          "onMessage: ${message.notification?.title}/${message.notification?.body}");

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
          message.notification!.body.toString(),
          htmlFormatBigText: true,
          contentTitle: message.notification!.title.toString(),
          htmlFormatContentTitle: true);

      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        "dbfood",
        "dbfood",
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
      );

      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
          message.notification?.body, platformChannelSpecifics,
          payload: message.data['body']);
    });
  }

  void sendPushMessege(String token, String Fname, String time) async {
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
              "title": "Appointment cancelation",
              "body": "Your appointment with $Fname$time has been canceled.",
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

//+++++++++++++++++++++++++++++++++++++++++end DEEM+++++++++++++++++++++++++++++++++++++++++++++++++++++++

  CancelAppointment(int index) async {
    String id = BookedAppointments[index].id;
    var ref = BookedAppointments[index].reference;
    //+++++++++++++++++++++++++++++++start Deem+++++++++++++++++++++++++++++++++++
    final snap = await FirebaseFirestore.instance
        .collection("faculty")
        .doc(userid)
        .collection('appointment')
        .doc(BookedAppointments[index].id)
        .get();

    DocumentReference? groupData = snap['group'];
    print(
        "+++++++++++++++++++fff++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    final snap2 = await FirebaseFirestore.instance
        .collection("faculty")
        .doc(userid)
        .get();
    String Fname = snap2['firstname'] + ' ' + snap2['lastname'];
    String time = " on " +
        BookedAppointments[index].StringDate() +
        " at " +
        BookedAppointments[index].StringStartTime12H();
    Map<String, dynamic>? group;
    String? projectName;
    late List groupStudents;
    if (groupData != null) {
      var gData = await groupData.get();

      if (gData.exists) {
        group = gData.data() as Map<String, dynamic>;
        projectName = group?['projectname'] + " team";
        groupStudents = group?['students'];
      }
    }
    for (int i = 0; i < groupStudents.length; i++) {
      final DocumentSnapshot StudentdocSnap =
          await groupStudents[i]['ref'].get();
      final docData = StudentdocSnap.data() as Map<String, dynamic>;
      if (docData.containsKey("token")) {
        var studentToken = StudentdocSnap['token'];
        sendPushMessege(studentToken, Fname, time);
      }
    }
    final docData = snap2.data() as Map<String, dynamic>;
    if (docData.containsKey("token")) {
      // sendPushMessege(snap2['token'], projectName!, "");
      showInSnackBar(
          context, "Your appointment with $projectName has been successfully canceled.");
    }

    //await
    FirebaseFirestore.instance
        .collection("faculty")
        .doc(userid)
        .collection('appointment')
        .doc(id) //Is there a specific id i should put for the appointments
        .update({
      'Booked': false, //string if booked then it should have a student refrence
      "group": FieldValue.delete(),
      'specialty': FieldValue.delete(),
    });

    groupData?.update({
      "appointments": FieldValue.arrayRemove([ref]),
    });
  }

  showConfirmationDialog(BuildContext context, int index) {
    DateTime StartTimeDate = BookedAppointments[index].startTime;

    DateTime now = new DateTime.now();
    DateTime TimeFromNowTo12Hours = now.add(Duration(hours: 12));

    print(
        "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    print(TimeFromNowTo12Hours);

    if (StartTimeDate.isAfter(TimeFromNowTo12Hours)) {
      /////CAN CANCLE

      // set up the buttons
      bool deleteappointment = false;
      Widget dontCancelAppButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(fontSize: 16),
          // shadowColor: Colors.blue[900],
          elevation: 0,
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
          textStyle: TextStyle(fontSize: 16),
          //shadowColor: Colors.blue[900],
          elevation: 0,
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
          //deleteappointment=true;
          // Navigator.pushNamed(context, 'facultyhome');
        },
      );

      AlertDialog alert = AlertDialog(
        // title: Text(""),
        content: Text("Are you sure you want to cancel the appointment on " +
            BookedAppointments[index].StringDate() +
            " at " +
            BookedAppointments[index].StringTimeRange() +
            " ?"),
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
    } //end if can cancel
    else {
      //// CANNOT CANCLE

      Widget OkButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(fontSize: 16),
          //shadowColor: Colors.blue[900],
          elevation: 0,
          backgroundColor: Mycolors.mainShadedColorBlue,
          minimumSize: Size(60, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // <-- Radius
          ),
        ),
        child: Text("OK"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );

      AlertDialog alert = AlertDialog(
        // title: Text(""),
        content: Text("You CANNOT cancel your appointment with on " +
            BookedAppointments[index].StringDate() +
            " at " +
            BookedAppointments[index].StringTimeRange() +
            " because it is within the next 24 hours."),
        actions: [
          OkButton,
        ],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    } //end else cant cancel
  } //end function
} //end class
