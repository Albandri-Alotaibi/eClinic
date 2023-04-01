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
  String? fnDrawer;
  String? lnDrawer;
  String? email = '';
  String? userid = '';
  @override
  void initState() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    userid = user!.uid;
    email = user.email!;
    getfacultname();
    // TODO: implement initState
    super.initState();
  }

  //int selectedIndex = 0;
  getfacultname() async {
    final snap = await FirebaseFirestore.instance
        .collection('faculty')
        .doc(userid)
        .get();
    setState(() {
      fnDrawer = snap['firstname'];
      lnDrawer = snap['lastname'];
    });
    print("999999999999999999999999999999999999999999");
    print(fnDrawer);
  }

  final List<Widget> _pages = [
    FacultyViewBookedAppointment(),
    addHoursFaculty(),
    facultyListFAQ(),
  ];

  final List<String> appbar = ["Booked Appointments", "Help Desk Hours", "FAQ"];
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

    // final ButtonStyle style =
    //     ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return SafeArea(
      child: Scaffold(
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
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 7),
                    height: 20,
                    width: 100,
                    child: FloatingActionButton.extended(
                      heroTag: "btn2",
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // <-- Radius
                        side: BorderSide(
                          width: 0,
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),
                      splashColor: Mycolors.mainColorGreen,
                      elevation: 0,
                      foregroundColor: Colors.green,
                      label: Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ), // <-- Text
                      backgroundColor: Color.fromRGBO(255, 255, 255, 1),

                      icon: Icon(
                        // <-- Icon
                        Icons.add,
                        color: Colors.green,
                        size: 20.0,
                      ),
                      onPressed: (() {
                        Navigator.pushNamed(context, 'addcommonissue');
                      }),
                    ),
                  ),
                ),
            ]),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
                    Center(
                      child: Text("${fnDrawer} ${lnDrawer}",
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
                  "My Profile",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
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
                leading: Icon(Icons.password, color: Mycolors.mainColorBlue),
                title: Text(
                  "Reset Password",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
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
                leading: Icon(Icons.logout, color: Mycolors.mainColorBlue),
                title: Text(
                  "Log Out",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
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
                  label: 'Available Hours'),
              NavigationDestination(
                  selectedIcon: Icon(Icons.question_answer_outlined,
                      color: Mycolors.mainShadedColorBlue, size: 27),
                  icon: Icon(
                    Icons.question_answer_outlined,
                    size: 27,
                    color: Color.fromARGB(108, 0, 0, 0),
                  ),
                  label: 'FAQ'),
            ],
          ),
        ),
      ),
    );
  }

  showConfirmationDialog(BuildContext context) {
    Widget dontCancelAppButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
        //shadowColor: Colors.blue[900],
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
        textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
        // shadowColor: Colors.blue[900],
        elevation: 0,
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
      content: Text("Are you sure you want to logout?"),
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
