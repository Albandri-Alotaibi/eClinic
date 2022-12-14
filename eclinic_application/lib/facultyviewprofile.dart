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
    retriveAllspecilty();
    retrivespeciality();
    retrievesemester();
    retrivecollage();
    retrivedepartment();
    selectedoptionlist.value = specality;
    super.initState();
  }

  List<String> options = [];
  List<String> specality = [];
  List specalityid = [];
  List<String> semester = [];
  List<String> collage = [];
  List<String> department = [];
  String? email = '';
  String? userid = '';
  String? fname;
  String? lname;
  String? mettingmethod;
  String? ksuemail;
  var semesterselectedvalue;
  late String docsforcollage;
  var collageselectedvalue;
  var departmentselectedvalue;

  var year;
  var monthe;
  var day;
  var zag = 0;
  bool isshow = false;
  Rx<List<String>> selectedoptionlist = Rx<List<String>>([]);
  var selectedoption = "".obs;

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
  retrivecollage() async {
    try {
      await FirebaseFirestore.instance
          .collection('collage')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          setState(() {
            collage.add(element['collagename']);
          });
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  retriveAllspecilty() async {
    try {
      await FirebaseFirestore.instance
          .collection('facultyspeciality')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          setState(() {
            options.add(element['specialityname']);
          });
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  retrivespeciality() async {
    final snap = await FirebaseFirestore.instance
        .collection('faculty')
        .doc(userid)
        .get();
    List facultyspecialityRef = snap["specialty"];
    for (var i = 0; i < facultyspecialityRef.length; i++) {
      final DocumentSnapshot docRef = await facultyspecialityRef[i].get();
      setState(() {
        specality.add(docRef["specialityname"]);
      });
    }

    fname = snap["firstname"];
    lname = snap["lastname"];
    mettingmethod = snap["meetingmethod"];
    ksuemail = snap["ksuemail"];
    print(fname);
    print(lname);
    print(mettingmethod);
    print(ksuemail);
    //  List semesterRef = snap["semester"];
    //  for (var n = 0; n < semesterRef.length; n++) {
    //  final DocumentSnapshot docRef2 = await semesterRef[n].get();
    //  print(docRef2["specialityname"]);
  }

  // Future userinfo() async {
  //   final snap = await FirebaseFirestore.instance
  //       .collection('faculty')
  //       .doc(userid)
  //       .get();
  //   return snap;
  // }
  retrievesemester() async {
    bool past = true;
    try {
      await FirebaseFirestore.instance
          .collection('semester')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          setState(() {
            DateTime now = DateTime.now();
            year = now.year;
            DateTime Dateoftoday = DateTime.now();

            String s = year.toString();
            String sn = element['semestername'];
            var startdate = element['startdate'];
            startdate.toString();

            if ((sn.contains(s))) {
              print(sn);
              semester.add(element['semestername']);
            }

            if (startdate != null) {
              Timestamp t = element['enddate'];
              DateTime enddate = t.toDate();
              if (Dateoftoday.year <= enddate.year) {
                if (Dateoftoday.month > enddate.month) {
                  semester.remove(element['semestername']);
                }

                if (Dateoftoday.month == enddate.month &&
                    Dateoftoday.day > enddate.day) {
                  semester.remove(element['semestername']);
                }
              }
            }
          });
        });
        print(semester);
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  retrivedepartment() async {
    try {
      await FirebaseFirestore.instance
          .collection('collage')
          .doc("CCIS")
          .collection("department")
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          setState(() {
            department.add(element['departmentname']);
          });
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
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

                      final fname = cuser['firstname'];
                      final lname = cuser['lastname'];
                      final ksuemail = cuser['ksuemail'];
                      final mettingmethod = cuser['meetingmethod'];
                      final _fnameController =
                          TextEditingController(text: fname);
                      final _lnameController =
                          TextEditingController(text: lname);
                      final _emailController =
                          TextEditingController(text: ksuemail);
                      final _meetingmethodcontroller =
                          TextEditingController(text: mettingmethod);

                      // if (specality.length > 1) {
                      //   selectedoptionlist.value = specality;
                      // }
                      // final sp = cuser["specialty"];

                      // for (var i = 0; i < sp.length; i++) {
                      //   final DocumentSnapshot docRef = sp[i].get();
                      //   print(docRef["specialityname"]);

                      //   //final DocumentSnapshot specialitywitoutrefrance = docRef("specialityname");
                      //   print("1111111111111111111111111111111111111111");
                      //   print(sp);
                      //   // print(
                      //   //     "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
                      //   // print(docRef.toString());

                      //   //  selectedoptionlist.value = docRef["specialityname"];
                      // }

                      // final _lnameController = TextEditingController(text: ln);
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
                            controller: _fnameController,
                            decoration: InputDecoration(
                                labelText: 'Frist Name',
                                // hintText: "Enter your first name",
                                suffixIcon: Icon(Icons.edit),
                                border: OutlineInputBorder()),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty ||
                                  _fnameController.text == "") {
                                return 'Please enter your frist name ';
                              } else {
                                if (nameRegExp
                                    .hasMatch(_fnameController.text)) {
                                  return 'Please frist name only letters accepted ';
                                } else {
                                  if (!(english
                                      .hasMatch(_fnameController.text))) {
                                    return "only english is allowed";
                                  }
                                }
                              }
                            },
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: _lnameController,
                            decoration: InputDecoration(
                                labelText: 'Last Name',
                                // hintText: "Enter your last name",
                                suffixIcon: Icon(Icons.edit),
                                border: OutlineInputBorder()),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty ||
                                  _lnameController.text == "") {
                                return 'Please enter your last name ';
                              } else {
                                if (nameRegExp
                                    .hasMatch(_lnameController.text)) {
                                  return 'Please last name only letters accepted ';
                                } else {
                                  if (!(english
                                      .hasMatch(_lnameController.text))) {
                                    return "only english is allowed";
                                  }
                                }
                              }
                            },
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: _emailController,
                            readOnly: true,
                            decoration: InputDecoration(
                                // hintText: "Enter your KSU email",
                                labelText: 'KSU Email',
                                border: OutlineInputBorder()),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty ||
                                  _emailController.text == "") {
                                return 'Please enter your KSU email ';
                              } else {
                                if (!(ksuEmailRegEx
                                    .hasMatch(_emailController.text))) {
                                  return 'Please write email format correctly, example@ksu.edu.sa ';
                                }
                              }
                            },
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.edit),
                              labelText: 'collage',
                              border: OutlineInputBorder(),
                            ),
                            isExpanded: true,
                            items: collage.map((String dropdownitems) {
                              return DropdownMenuItem<String>(
                                value: dropdownitems,
                                child: Text(dropdownitems),
                              );
                            }).toList(),
                            onChanged: (String? newselect) {
                              setState(() {
                                collageselectedvalue = newselect;
                                //checkidc(collageselectedvalue);
                              });
                            },
                            value: collageselectedvalue,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null ||
                                  collageselectedvalue!.isEmpty ||
                                  collageselectedvalue == null) {
                                return 'Please choose your collage';
                              }
                            },
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.edit),
                              labelText: ' department',
                              border: OutlineInputBorder(),
                            ),
                            isExpanded: true,
                            items: department.map((String dropdownitems) {
                              return DropdownMenuItem<String>(
                                value: dropdownitems,
                                child: Text(dropdownitems),
                              );
                            }).toList(),
                            onChanged: (String? newselect) {
                              setState(() {
                                departmentselectedvalue = newselect;
                                //checkidd(departmentselectedvalue);
                              });
                            },
                            value: departmentselectedvalue,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null ||
                                  departmentselectedvalue!.isEmpty ||
                                  departmentselectedvalue == null) {
                                return 'Please choose your department';
                              }
                            },
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          DropDownMultiSelect(
                            decoration: InputDecoration(
                                suffixIcon: Icon(Icons.edit),
                                labelText: " speciality",
                                // hintText: "select your specialty",
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            isshow ? Colors.red : Colors.grey)),
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: isshow
                                            ? Colors.red
                                            : Colors.blueAccent)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: isshow
                                            ? Colors.red
                                            : Colors.blueAccent))),
                            options: options,
                            whenEmpty: "",
                            onChanged: (value) {
                              setState(() {
                                selectedoptionlist.value = value;
                                selectedoption.value = "";
                                selectedoptionlist.value.forEach((element) {
                                  selectedoption.value =
                                      selectedoption.value + " " + element;

                                  zag = selectedoptionlist.value.length;
                                  isshow = selectedoption.value.isEmpty;

                                  if (zag < 1) {
                                    isshow = true;
                                  }
                                  if (zag > 0 ||
                                      selectedoption.value.isEmpty ||
                                      selectedoption.value == null) {
                                    isshow = false;
                                  }
                                });
                                print(
                                    "/////////////////ممههههممم//////////////////");
                                print(selectedoptionlist.value);
                              });
                              checkidspecialty(selectedoptionlist.value);
                              isshow = selectedoptionlist.value.isEmpty;
                            },
                            selectedValues: selectedoptionlist.value,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Visibility(
                            visible: isshow,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Please choose your specialty",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 211, 56, 45)),
                                    textAlign: TextAlign.left,
                                  ),
                                ]),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.edit),
                              labelText: 'semester',
                              border: OutlineInputBorder(),
                            ),
                            isExpanded: true,
                            items: semester.map((String dropdownitems) {
                              return DropdownMenuItem<String>(
                                value: dropdownitems,
                                child: Text(dropdownitems),
                              );
                            }).toList(),
                            onChanged: (String? newselect) {
                              setState(() {
                                semesterselectedvalue = newselect;
                                // checkids(semesterselectedvalue);
                              });
                            },
                            value: semesterselectedvalue,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null ||
                                  semesterselectedvalue!.isEmpty ||
                                  semesterselectedvalue == null) {
                                return 'Please choose a semester';
                              }
                            },
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                              controller: _meetingmethodcontroller,
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.edit),
                                  labelText: "Metting method",
                                  border: OutlineInputBorder()),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty ||
                                    _meetingmethodcontroller.text == "") {
                                  return 'Please enter your metting method';
                                } else {
                                  if (!(english.hasMatch(
                                      _meetingmethodcontroller.text))) {
                                    return "only english is allowed";
                                  }
                                }
                              }),
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
  checkidspecialty(List<String?> specialityoption) async {
    specalityid.length = 0;
    // print(specialityoption);
    // print(speciality.length);
    // print(speciality);

    try {
      await FirebaseFirestore.instance
          .collection('facultyspeciality')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          setState(() {
            for (var i = 0; i < specialityoption.length; i++) {
              if (element['specialityname'] == specialityoption[i]) {
                final ref = FirebaseFirestore.instance
                    .collection("facultyspeciality")
                    .doc(element.id);
                specalityid.add(ref);
                print(specalityid);
              }
            }
          });
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
