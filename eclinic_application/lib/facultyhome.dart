import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:myapp/login.dart';
import 'package:myapp/style/Mycolors.dart';
import 'package:myapp/FacultyViewBookedAppointment.dart';
import 'package:myapp/addHoursFaculty.dart';
import 'package:myapp/facultyFAQ.dart';

class facultyhome extends StatefulWidget {
  // This class is the configuration for the state.
  // It holds the values (in this case nothing) provided
  // by the parent and used by the build  method of the
  // State. Fields in a Widget subclass are always marked
  // "final".

  //const facultyhome({super.key});

  int selectedIndex;
  facultyhome(this.selectedIndex);
  @override
  State<facultyhome> createState() => _fState();
}

class _fState extends State<facultyhome> {
  String? email = '';
  String? userid = '';
  //int selectedIndex = 0;
  final List<Widget> _pages = [
    FacultyViewBookedAppointment(),
    addHoursFaculty(),
    facultyFAQ(),
  ];
  @override
  Widget build(BuildContext context) {
    body:
    StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return facultyhome(0);
          } else {
            return login();
          }
        }));
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    userid = user!.uid;
    email = user.email!;

    // final ButtonStyle style =
    //     ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Home'),
      // ),
      body: _pages[widget.selectedIndex],
      //-------------------------Nav Bar------------------------------
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              // color: Colors.grey.withOpacity(0.5),
              color: Mycolors.mainColorShadow,
              spreadRadius: 10,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            selectedIndex: widget.selectedIndex,
            onTabChange: (index) {
              print(index);
              setState(() {
                widget.selectedIndex = index;
              });
            },

            backgroundColor: Mycolors.BackgroundColor,
            color: Mycolors.mainColorBlack,
            activeColor: Mycolors.mainColorBlue,
            gap: 8,
            padding: EdgeInsets.all(16),
            //curve: Curves.easeInOut,
            tabs: [
              GButton(
                icon: Icons.group,
                text: 'Appointments',
              ),
              GButton(
                icon: Icons.schedule,
                text: 'Available Hours ',
              ),
              GButton(
                icon: Icons.question_answer,
                text: 'FAQ',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// body: Container(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               style: style,
//               onPressed: () {
//                 Navigator.pushNamed(context, 'addHoursFaculty');
//               },
//               child: Text('addHoursFaculty'),
//             ),
//             //const SizedBox(width: 16),
//             ElevatedButton(
//               style: style,
//               onPressed: () {
//                 Navigator.pushNamed(context, 'FacultyViewBookedAppointment');
//               },
//               child: Text('BookedAppointment'),
//             ),
//             //const SizedBox(width: 16),
//           ],
//         ),
//       ),
