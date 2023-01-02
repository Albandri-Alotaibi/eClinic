import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/StudentViewBookedAppointment.dart';
import 'package:myapp/addHoursFaculty.dart';
import 'package:myapp/FacultyViewBookedAppointment.dart';
import 'package:myapp/addcommonissue.dart';
import 'package:myapp/facultyhome.dart';
import 'package:myapp/facultyviewprofile.dart';
import 'package:myapp/home.dart';
import 'package:myapp/login.dart';
import 'package:myapp/reusable.dart';
import 'package:myapp/studenthome.dart';
import 'package:myapp/facultysignup.dart';
import 'package:myapp/studentlogin.dart';
import 'package:myapp/studentsignup.dart';
import 'package:myapp/studentverfication.dart';
import 'package:myapp/studentviewprofile.dart';
import 'package:myapp/verfication.dart';
import 'package:myapp/FacultyViewScreen.dart';
import 'package:myapp/FacultyListScreen.dart';
import 'package:myapp/facultyFAQ.dart';
import 'package:myapp/viewFAQ.dart';
import 'UploadGP.dart';

Future<void> _firebaseMsgBackgroundHanler(RemoteMessage message) async {
  print("handling msg ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMsgBackgroundHanler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'main',
        theme: ThemeData(
          primaryColor: Color(0xFF55C1EF),
        ),
        // initialRoute: '/', //<----- deleted
        home: getLandingPage(),
        // <--------- new
        routes: {
          // '/': (context) => home(), //<----- deleted
          'addHoursFaculty': (context) => addHoursFaculty(),
          'facultyhome': (context) => facultyhome(0),
          'studenthome': (context) => studenthome(),
          'facultysignup': (context) => facultysignup(),
          'reusable': (context) => reusable(),
          'FacultyListScreen': (context) => FacultyListScreen(),
          'login': (context) => login(),
          'FacultyViewBookedAppointment': (context) =>
              FacultyViewBookedAppointment(),
          'verfication': (context) => verfication(),
          'studentsignup': (context) => studentsignup(),
          'studentlogin': (context) => studentlogin(),
          'facultyviewprofile': (context) => facultyviewprofile(),
          'facultyFAQ': (context) => facultyFAQ(),
          'studentverfication': (context) => studentverfication(),
          'studentviewprofile': (context) => studentviewprofile(),
          'StudentViewBookedAppointment': (context) =>
              StudentViewBookedAppointment(),
          'UploadGP': (context) => UploadGP(),
          'addcommonissue': (context) => addcommonissue(),
          'viewFAQ': (context) => viewFAQ(),
        });
  }

  //for auto login  <---- new
  StreamBuilder<User?> getLandingPage() {
    final FirebaseAuth auth = FirebaseAuth.instance;

    return StreamBuilder<User?>(
      stream: auth.userChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState != ConnectionState.waiting) {
          if (snapshot.hasData &&
              (!snapshot.data!.isAnonymous) &&
              auth.currentUser != null) {
            if (auth.currentUser?.email?.contains("@student.ksu.edu.sa") ??
                false) {
              return studenthome();
            } else if (auth.currentUser?.email?.isNotEmpty ?? false) {
              return facultyhome(0);
            }
          }
          return home();
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
