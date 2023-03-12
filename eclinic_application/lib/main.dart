import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/CommonIssuesListScreen.dart';
import 'package:myapp/StudentViewBookedAppointment.dart';
import 'package:myapp/addHoursFaculty.dart';
import 'package:myapp/FacultyViewBookedAppointment.dart';
import 'package:myapp/addcommonissue.dart';
import 'package:myapp/editFAQ.dart';
import 'package:myapp/facultyListFAQ.dart';
import 'package:myapp/facultyViewFAQ.dart';
import 'package:myapp/facultyhome.dart';
import 'package:myapp/facultyviewprofile.dart';
import 'package:myapp/home.dart';
import 'package:myapp/innereset.dart';
import 'package:myapp/login.dart';
import 'package:myapp/resetpassword.dart';
import 'package:myapp/studenthome.dart';
import 'package:myapp/facultysignup.dart';
import 'package:myapp/studentlogin.dart';
import 'package:myapp/studentresetpassword.dart';
import 'package:myapp/screeens/signUp/studentsignup.dart';
import 'package:myapp/studentverfication.dart';
import 'package:myapp/studentviewprofile.dart';
import 'package:myapp/style/Mycolors.dart';
import 'package:myapp/verfication.dart';
import 'package:myapp/FacultyViewScreen.dart';
import 'package:myapp/FacultyListScreen.dart';
import 'package:myapp/viewGPlibrary.dart';
import 'package:myapp/screeens/signUp/screen_shoss_group.dart';
import 'UploadGP.dart';
import 'package:myapp/bloc/select_group/bloc.dart';
import 'package:myapp/home.dart';
import 'package:myapp/screeens/signUp/screen_shoss_group.dart';
import 'package:myapp/screeens/signUp/studentsignup.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => BlocGroupSelect()),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'main',
            theme: ThemeData(
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Mycolors.mainShadedColorBlue,
                  textStyle: const TextStyle(fontSize: 15),
                ),
              ),
              timePickerTheme: TimePickerThemeData(
                dialHandColor: Mycolors.mainShadedColorBlue,
                inputDecorationTheme: InputDecorationTheme(
                    fillColor: Mycolors.mainShadedColorBlue),

                //dialBackgroundColor: Mycolors.mainColorGreen,
                //dayPeriodBorderSide: BorderSide(color: Colors.black),

                dayPeriodColor: MaterialStateColor.resolveWith((states) =>
                    states.contains(MaterialState.selected)
                        ? Mycolors.mainShadedColorBlue
                        : Color.fromARGB(47, 255, 255, 255)),
                dayPeriodTextColor: MaterialStateColor.resolveWith((states) =>
                    states.contains(MaterialState.selected)
                        ? Colors.white
                        : Mycolors.mainColorBlack),
                hourMinuteColor: MaterialStateColor.resolveWith((states) =>
                    states.contains(MaterialState.selected)
                        ? Mycolors.mainShadedColorBlue
                        : Color.fromARGB(30, 102, 102, 102)),
                hourMinuteTextColor: MaterialStateColor.resolveWith((states) =>
                    states.contains(MaterialState.selected)
                        ? Colors.white
                        : Mycolors.mainColorBlack),
              ),
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

              'FacultyListScreen': (context) => FacultyListScreen(),
              'login': (context) => login(),
              'FacultyViewBookedAppointment': (context) =>
                  FacultyViewBookedAppointment(),
              'verfication': (context) => verfication(),
              'studentsignup': (context) => studentsignup(),
              'studentlogin': (context) => studentlogin(),
              'facultyviewprofile': (context) => facultyviewprofile(),
              'studentverfication': (context) => studentverfication(),
              'studentviewprofile': (context) => studentviewprofile(),
              'StudentViewBookedAppointment': (context) =>
                  StudentViewBookedAppointment(),
              'UploadGP': (context) => UploadGP(),
              'addcommonissue': (context) => addcommonissue(),
              'viewGPlibrary': (context) => viewGPlibrary(),
              'commonIssuesList': (context) => CommonIssuesListScreen(),
              'facultyListFAQ': (context) => facultyListFAQ(),
              'editFAQ': (context) => editFAQ(value: ""),
              'facultyViewFAQ': (context) => facultyViewFAQ(commonIssue: {}),
              'resetpassword': (context) => resetpassword(),
              "innereset": (context) => innereset(),
              "studentresetpassword": (context) => studentresetpassword(),
            }));
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
