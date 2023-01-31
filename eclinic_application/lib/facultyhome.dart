import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:myapp/facultyListFAQ.dart';
import 'package:myapp/home.dart';
import 'package:myapp/login.dart';
import 'package:myapp/style/Mycolors.dart';
import 'package:myapp/FacultyViewBookedAppointment.dart';
import 'package:myapp/addHoursFaculty.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/resetpassword.dart';

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
  var fnDrawer;
  var lnDrawer;
  @override
  void initState() {
    // getfacultname();
    // TODO: implement initState
    super.initState();
  }

  String? email = '';
  String? userid = '';
  //int selectedIndex = 0;
  // getfacultname() async {
  //   final snap = await FirebaseFirestore.instance
  //       .collection('faculty')
  //       .doc(userid)
  //       .get();
  //   setState(() {
  //     fnDrawer = snap['firstname'];
  //     lnDrawer = snap['lastname'];
  //   });

  //   print(fnDrawer);
  // }

  final List<Widget> _pages = [
    FacultyViewBookedAppointment(),
    addHoursFaculty(),
    facultyListFAQ(),
  ];

  final List<String> appbar = [
    "Booked Appointments",
    "Help Desk Hours",
    "Common Issues"
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

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(appbar[widget.selectedIndex],
              style: TextStyle(
                  fontFamily: 'bold',
                  fontSize: 20,
                  color: Mycolors.mainColorBlack)),
          foregroundColor: Mycolors.mainColorBlack,
          primary: false,
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 246, 246, 246),
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
                  child: Text(" ",
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
              "My profile",
              style: TextStyle(
                  fontFamily: 'main',
                  fontSize: 16,
                  color: Mycolors.mainColorBlack),
            ),
            onTap: (() {
              Navigator.pushNamed(context, 'facultyviewprofile');
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
              activeColor: Mycolors.mainColorWhite,
              tabBackgroundColor: Mycolors.mainShadedColorBlue,
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
      ),
    );
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
