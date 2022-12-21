import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/login.dart';
import 'package:myapp/studentlogin.dart';
import 'style/Mycolors.dart';

class studenthome extends StatefulWidget {
  // This class is the configuration for the state.
  // It holds the values (in this case nothing) provided
  // by the parent and used by the build  method of the
  // State. Fields in a Widget subclass are always marked
  // "final".

  const studenthome({super.key});

  @override
  State<studenthome> createState() => _sState();
}

class _sState extends State<studenthome> {
  var fname;
  var lname;
  void initState() {
    super.initState();
    // getusername();
    //++++++++++++++++++++++++++DEEM++++++++++++++++++++++++++++++++
    requestPremission();
    getToken();
    initInfo();
  }

  getusername() async {
    final snap = await FirebaseFirestore.instance
        .collection('student')
        .doc(userid)
        .get();
    fname = snap['firstname'];
    lname = snap['lastname'];
  }

  String? email = '';
  String? userid = '';
  final double profileheight = 144;
  @override
  Widget build(BuildContext context) {
    StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return studenthome();
          } else {
            return login();
          }
        }));
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    userid = user!.uid;
    email = user.email!;
    setSemester();
    getusername();

    //calling the method
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        primary: false,
        centerTitle: true,
        backgroundColor: Mycolors.mainColorWhite,
        shadowColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Color.fromARGB(255, 12, 12, 12), //change your color here
        ),
      ),
      backgroundColor: Mycolors.BackgroundColor,
      drawer: Drawer(
          child: ListView(children: [
        Card(
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
                  "assets/images/woman.png",
                  width: 100,
                  height: 100,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text("${fname} ${lname}",
                    style: TextStyle(
                        fontFamily: 'bold',
                        fontSize: 16,
                        color: Mycolors.mainColorBlack)),
              ),
            ],
          )),
        ),
        ListTile(
          leading: Icon(Icons.edit_note),
          title: Text(
            "Edit profile",
            style: TextStyle(
                fontFamily: 'main',
                fontSize: 16,
                color: Mycolors.mainColorBlack),
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
          leading: Icon(Icons.password),
          title: Text(
            "Reset password",
            style: TextStyle(
                fontFamily: 'main',
                fontSize: 16,
                color: Mycolors.mainColorBlack),
          ),
          onTap: (() {
            // Navigator.pushNamed(context, 'resetpasswprd');
          }),
        ),
        Divider(
          color: Mycolors.mainColorBlue,
          thickness: 1,
          endIndent: 15,
          indent: 15,
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text(
            "Log out",
            style: TextStyle(
                fontFamily: 'main',
                fontSize: 16,
                color: Mycolors.mainColorBlack),
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
      body: Padding(
        padding: const EdgeInsets.all(100.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Navigator.pushNamed(context, 'viewfaculty');
                Navigator.pushNamed(context, 'FacultyListScreen');
              },
              child: Text('Schdule'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'StudentViewBookedAppointment');
              },
              child: Text('view'),
            ),
          ],
        ),
      ),
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
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    userid = user!.uid;
    email = user.email!;
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
          MaterialPageRoute<void>(builder: (context) => studenthome()),
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
            context, MaterialPageRoute(builder: (context) => studentlogin())));
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
