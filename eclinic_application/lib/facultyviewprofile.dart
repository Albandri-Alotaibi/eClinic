import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multiselect/multiselect.dart';
import 'package:myapp/login.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class facultyviewprofile extends StatefulWidget {
  const facultyviewprofile({super.key});

  @override
  State<facultyviewprofile> createState() => _facultyviewprofileState();
}

class _facultyviewprofileState extends State<facultyviewprofile> {
  void initState() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    userid = user!.uid;
    email = user.email!;
    retrivespeciality();

    // final _lnameController = TextEditingController();
    // final _emailController = TextEditingController();
    // final _meetingmethodcontroller = TextEditingController();
    super.initState();
  }

  List<String> specality = [];
  String? email = '';
  String? userid = '';
  String? fname;
  String? lname;
  String? mettingmethod;
  String? ksuemail;
  // final fnameController = TextEditingController();
  // final _lnameController = TextEditingController();
  // final _emailController = TextEditingController();
  // final _meetingmethodcontroller = TextEditingController();
  final double coverheight = 280;
  final double profileheight = 144;
  final double top = 136 / 2; //coverheight - profileheight/2;
  final formkey = GlobalKey<FormState>();
  static final RegExp nameRegExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
  RegExp uperRegExp = RegExp(r"(?=.*[A-Z])");
  RegExp numbRegExp = RegExp(r"[0-9]");
  RegExp smallRegExp = RegExp(r"(?=.*[a-z])");
  RegExp ksuEmailRegEx = new RegExp(r'^([a-z\d\._]+)@ksu.edu.sa$',
      multiLine: false, caseSensitive: false);
  RegExp english = RegExp("^[\u0000-\u007F]+\$");

  @override
  Future retrivespeciality() async {
    final snap = await FirebaseFirestore.instance
        .collection('faculty')
        .doc(userid)
        .get();
    List facultyspecialityRef = snap["specialty"];
    for (var i = 0; i < facultyspecialityRef.length; i++) {
      final DocumentSnapshot docRef = await facultyspecialityRef[i].get();
      specality.add(docRef["specialityname"]);
      print(docRef["specialityname"]);
    }
    fname = snap["firstname"];
    lname = snap["lastname"];
    mettingmethod = snap["meetingmethod"];
    ksuemail = snap["ksuemail"];
    print(fname);
    print(lname);
    print(mettingmethod);
    print(ksuemail);
    // var semesterRef = snap["semester"];
    // final DocumentSnapshot docRef2 = await semesterRef.get();
    // print(docRef2["specialityname"]);
  }

  Future userinfo() async {
    final snap = await FirebaseFirestore.instance
        .collection('faculty')
        .doc(userid)
        .get();
    return snap;
  }

  @override
  Widget build(BuildContext context) {
    body:
    StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return facultyviewprofile();
          } else {
            return login();
          }
        }));

    return Scaffold(
      appBar: AppBar(
        title: const Text('view profile'),
      ),
      body: SingleChildScrollView(
        clipBehavior: Clip.none,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formkey,
            child: Column(children: [
              FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('faculty')
                      .doc(userid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasData) {
                      print("snapshot");
                      print(snapshot);
                      final cuser =
                          snapshot.data!.data() as Map<String, dynamic>;
                      final fn = cuser['firstname'];
                      final ln = cuser['lastname'];
                      final fnameController = TextEditingController(text: fn);

                      print(fn);
                      print(ln);
                      print(
                          "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");

                      //    final _lnameController = TextEditingController(text: ln);
                      // final _emailController =
                      //     TextEditingController(text: cuser['ksuemail']);
                      // final _meetingmethodcontroller =
                      //     TextEditingController(text: cuser['meetingmethod']);
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildCoverImage(),
                          Positioned(
                            top: top,
                            child: buildprofileImage(),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: fnameController,
                            decoration: InputDecoration(
                                // labelText: 'Frist Name',
                                // hintText: "Enter your first name",
                                border: OutlineInputBorder()),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty ||
                                  fnameController.text == "") {
                                return 'Please enter your frist name ';
                              } else {
                                if (nameRegExp.hasMatch(fnameController.text)) {
                                  return 'Please frist name only letters accepted ';
                                } else {
                                  if (!(english
                                      .hasMatch(fnameController.text))) {
                                    return "only english is allowed";
                                  }
                                  // ;
                                  // setState(() {
                                  //   fnameController.text = fname;
                                  // });
                                }
                              }
                            },
                          ),
                        ],
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
              ElevatedButton(
                onPressed: () {},
                child: Text("Log out"),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget buildCoverImage() => Container(
        color: Colors.grey,
        // child: Image.asset(
        //   'assets/images/profilebackground.png.png',
        //   width: double.infinity,
        //   height: coverheight,
        //   fit: BoxFit.cover,
        // ),
      );

  Widget buildprofileImage() => CircleAvatar(
        radius: profileheight / 2,
        backgroundColor: Colors.grey.shade800,
        backgroundImage: AssetImage('assets/images/woman.png'),
      );
}
