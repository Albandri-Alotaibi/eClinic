import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/CommonIssuesListScreen.dart';
import 'package:myapp/FacultyListScreen.dart';
import 'package:myapp/StudentViewBookedAppointment.dart';
import 'package:myapp/home.dart';
import 'package:myapp/login.dart';
import 'package:myapp/studentlogin.dart';
import 'package:myapp/viewGPlibrary.dart';
import 'style/Mycolors.dart';

class studenthome extends StatefulWidget {
  // This class is the configuration for the state.
  // It holds the values (in this case nothing) provided
  // by the parent and used by the build  method of the
  // State. Fields in a Widget subclass are always marked
  // "final".

  int selectedIndex;
  studenthome(this.selectedIndex);

  @override
  State<studenthome> createState() => _sState();
}

class _sState extends State<studenthome> {
  String? fname;
  String? lname;
  String? email = '';
  String? userid = '';
  bool havename = false;

  //late int selectedIndex;

  void initState() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    while (user != null && user.email != null) {
      userid = user.uid;
      email = user.email!;
      break;
    }

    super.initState();

    getusername();
    //++++++++++++++++++++++++++DEEM++++++++++++++++++++++++++++++++
    requestPremission();
    getToken();
    initInfo();
    setSemester();
  }

  getusername() async {
    while (userid != '') {
      final snap = await FirebaseFirestore.instance
          .collection('student')
          .doc(userid)
          .get();
      setState(() {
        fname = snap['firstname'];
        lname = snap['lastname'];
      });
      setState(() {
        havename = true;
      });
      break;
    }
  }

  final double profileheight = 144;
  @override
  Widget build(BuildContext context) {
    // StreamBuilder<User?>(
    //     stream: FirebaseAuth.instance.authStateChanges(),
    //     builder: ((context, snapshot) {
    //       if (snapshot.hasData) {
    //         return studenthome();
    //       } else {
    //         return login();
    //       }
    //     }));

    // setSemester();
    // getusername();

    final List<Widget> _pages = [
      StudentViewBookedAppointment(),
      FacultyListScreen(),
      viewGPlibrary(),
      CommonIssuesListScreen(),
    ];
    final List<String> appbar = [
      "Booked Appointments",
      "Schedule appointment",
      "GP library",
      "Common Issues"
    ];

    return SafeArea(
        child: Scaffold(
      // appBar: AppBar(
      //   primary: false,
      //   centerTitle: true,
      //   backgroundColor: Mycolors.mainColorWhite,
      //   shadowColor: Colors.transparent,
      //   iconTheme: IconThemeData(
      //     color: Color.fromARGB(255, 12, 12, 12), //change your color here
      //   ),
      // ),
      appBar: AppBar(
          title: Text(appbar[widget.selectedIndex],
              style: TextStyle(
                  //  fontFamily: 'bold',
                  fontSize: 20,
                  color: Mycolors.mainColorBlack)),
          foregroundColor: Mycolors.mainColorBlack,
          primary: false,
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          shadowColor: Color.fromARGB(0, 0, 0, 0),
          iconTheme: IconThemeData(
            color: Color.fromARGB(255, 12, 12, 12), //change your color here
          ),
          actions: [
            if (widget.selectedIndex == 2)
              IconButton(
                icon: const Icon(
                  Icons.add,
                  color: Colors.green,
                ),
                onPressed: () {
                  // handle the press
                  Navigator.pushNamed(context, 'UploadGP');
                },
              ),
          ]),
      backgroundColor: Colors.white,
      drawer: Drawer(
          width: 210,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.zero,
                topLeft: Radius.zero,
                bottomRight: Radius.circular(40),
                topRight: Radius.circular(40)),
          ),
          child: ListView(children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(70), // <-- Radius
              ),
              shadowColor: Color.fromARGB(94, 114, 168, 243),
              elevation: 0,
              child: DrawerHeader(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 0,
                    ),
                    child: Image.asset(
                      "assets/images/User1.png",
                      width: 100,
                      height: 100,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //  if (havename)

                  Center(
                    child: Text("${fname} ${lname}",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Mycolors.mainColorBlack)),
                  ),
                ],
              )),
            ),
            ListTile(
              leading: Icon(Icons.edit_note, color: Mycolors.mainColorBlue),
              title: Text(
                "My profile",
                style: TextStyle(
                    fontSize: 15,
                    color: Mycolors.mainColorBlack,
                    fontWeight: FontWeight.w400),
              ),
              // hoverColor: Mycolors.mainColorBlue,
              onTap: (() {
                Navigator.pushNamed(context, 'studentviewprofile');
              }),
            ),
            Divider(
              color: Mycolors.mainColorBlue,
              thickness: 1,
              endIndent: 15,
              indent: 15,
            ),
            ListTile(
              leading: Icon(Icons.password, color: Mycolors.mainColorBlue),
              title: Text(
                "Reset password",
                style: TextStyle(
                    fontSize: 16,
                    color: Mycolors.mainColorBlack,
                    fontWeight: FontWeight.w400),
              ),
              onTap: (() {
                Navigator.pushNamed(context, 'innereset');
              }),
            ),
            Divider(
              color: Mycolors.mainColorBlue,
              thickness: 1,
              endIndent: 15,
              indent: 15,
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Mycolors.mainColorBlue),
              title: Text(
                "Log out",
                style: TextStyle(
                    fontSize: 16,
                    color: Mycolors.mainColorBlack,
                    fontWeight: FontWeight.w400),
              ),
              onTap: (() {
                showConfirmationDialog(context);
              }),
            ),
            Divider(
              color: Mycolors.mainColorBlue,
              thickness: 1,
              endIndent: 15,
              indent: 15,
            ),
          ])),
      body: _pages[widget.selectedIndex],

      //---------------------------Nav bar------------------------------
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
            backgroundColor: Color.fromARGB(124, 255, 255, 255),
            indicatorColor: Colors.transparent,
            labelTextStyle: MaterialStateProperty.all(
              TextStyle(
                  //fontFamily: 'Semibold',
                  fontSize: 10,
                  color: Mycolors.mainColorBlack),
            )),
        child: NavigationBar(
          height: 60,
          onDestinationSelected: (index) {
            // print(index);
            setState(() {
              widget.selectedIndex = index;
            });
          },
          surfaceTintColor: Mycolors.mainColorShadow,
          selectedIndex: widget.selectedIndex,
          destinations: [
            NavigationDestination(
                selectedIcon: Icon(Icons.calendar_month_outlined,
                    color: Mycolors.mainShadedColorBlue, size: 28),
                icon: Icon(
                  Icons.calendar_month_outlined,
                  size: 28,
                  color: Color.fromARGB(108, 0, 0, 0),
                ),
                label: 'Appointments'),
            NavigationDestination(
                selectedIcon: Icon(Icons.schedule_outlined,
                    color: Mycolors.mainShadedColorBlue, size: 27),
                icon: Icon(
                  Icons.schedule_outlined,
                  size: 27,
                  color: Color.fromARGB(108, 0, 0, 0),
                ),
                label: 'Book appointment'),
            NavigationDestination(
                selectedIcon: Icon(Icons.school,
                    color: Mycolors.mainShadedColorBlue, size: 27),
                icon: Icon(
                  Icons.school,
                  size: 27,
                  color: Color.fromARGB(108, 0, 0, 0),
                ),
                label: 'GP library'),
            NavigationDestination(
                selectedIcon: Icon(Icons.question_answer_outlined,
                    color: Mycolors.mainShadedColorBlue, size: 27),
                icon: Icon(
                  Icons.question_answer_outlined,
                  size: 27,
                  color: Color.fromARGB(108, 0, 0, 0),
                ),
                label: 'Common Issues'),
          ],
        ),
      ),
      // body: Padding(
      //     padding: const EdgeInsets.all(100.0),
      //     child: Column(
      //       children: [
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: <Widget>[
      //             ElevatedButton(
      //               onPressed: () {
      //                 // Navigator.pushNamed(context, 'viewfaculty');
      //                 Navigator.pushNamed(context, 'FacultyListScreen');
      //               },
      //               child: Text('Schdule'),
      //             ),
      //             const SizedBox(width: 16),
      //             ElevatedButton(
      //               onPressed: () {
      //                 Navigator.pushNamed(
      //                     context, 'StudentViewBookedAppointment');
      //               },
      //               child: Text('view'),
      //             ),
      //           ],
      //         ),
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: <Widget>[
      //             ElevatedButton(
      //               onPressed: () {
      //                 // Navigator.pushNamed(context, 'viewfaculty');
      //                 Navigator.pushNamed(context, 'UploadGP');
      //               },
      //               child: Text('Upload GP'),
      //             ),
      //             const SizedBox(width: 16),
      //             Expanded(
      //               child: ElevatedButton(
      //                 onPressed: () {
      //                   // Navigator.pushNamed(context, 'viewfaculty');
      //                   Navigator.pushNamed(context, 'viewGPlibrary');
      //                 },
      //                 child: Text('GP library'),
      //               ),
      //             ),
      //           ],
      //         ),
      //         //---------- add  common issue button
      //         Row(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: <Widget>[
      //               Expanded(
      //                 child: ElevatedButton(
      //                   onPressed: () {
      //                     Navigator.pushNamed(context, 'commonIssuesList');
      //                   },
      //                   child: Text('Common Issues'),
      //                 ),
      //               ),
      //             ])
      //         //-------------- end row of common issues button
      //       ],
      //     )),
    ));
  } //end build

  setSemester() async {
    DateTime now = new DateTime.now();
    var semester = null;

    final snap = await FirebaseFirestore.instance
        .collection("semester")
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) async {
        Timestamp t1 = doc['startdate'] as Timestamp;
        DateTime StartTimeDate = t1.toDate();

        Timestamp t2 = doc['enddate'] as Timestamp;
        DateTime EndTimeDate = t2.toDate();

        if (now.isAfter(StartTimeDate) && now.isBefore(EndTimeDate)) {
          semester = doc.reference;
        }
      });
    });

    FirebaseFirestore.instance
        .collection("student")
        .doc(userid) //**************************************************** */
        .update({
      'semester': semester,
    });
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

  //+++++++++++++++++++++++++++++++++++++DEEM++++++++++++++++++++++++++++++++
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  TextEditingController username = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
  //+++++++++++++++++++++++++++++++++++++DEEM++++++++++++++++++++++++++++++++

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
    // final FirebaseAuth auth = FirebaseAuth.instance;
    // final User? user = auth.currentUser;
    // userid = user!.uid;
    // email = user.email!;
    await FirebaseFirestore.instance
        .collection("student")
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
          MaterialPageRoute<void>(builder: (context) => studenthome(0)),
        );
      },
      // onDidReceiveBackgroundNotificationResponse:
      //     (NotificationResponse notificationResponse) async {
      //   final String? payload = notificationResponse.payload;
      //   //   //   if (notificationResponse.payload != null) {
      //   //   //     debugPrint('notification payload: $payload');
      //   //   //   }
      //   //
      //   //
      //   await Navigator.push(
      //     context,
      //     MaterialPageRoute<void>(builder: (context) => studenthome()),
      //   );
      // },
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

  void sendPushMessege(String token) async {
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
              'body': 'your appointment has been canceled',
              'title': 'appointment cancelation',
            },
            "notification": <String, dynamic>{
              "title": "appointment cancelation",
              "body": "your appointment has been canceled",
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

  showConfirmationDialog(BuildContext context) {
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
        FirebaseAuth.instance.signOut().then((value) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => home())));
      },
    );

    AlertDialog alert = AlertDialog(
      // title: Text("LogOut"),
      content: Text("Are you sure you want to logout ?"),
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

//+++++++++++++++++++++++++++++++++++++++++DEEM+++++++++++++++++++++++++++++++++++++++++++++++++++++++
  }
}
