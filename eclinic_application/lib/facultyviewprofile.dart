import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multiselect/multiselect.dart';
import 'package:myapp/login.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'style/Mycolors.dart';

class facultyviewprofile extends StatefulWidget {
  const facultyviewprofile({super.key});

  @override
  State<facultyviewprofile> createState() => _facultyviewprofileState();
}

class _facultyviewprofileState extends State<facultyviewprofile> {
  var collageselectedvalue;
  var departmentselectedvalue;
  var semesterselectedvalue;

  void initState() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    userid = user!.uid;
    email = user.email!;
    retriveAllspecilty();
    retrivesuserinfo();
    retrievesemester();
    retrivecollage();
    retrivedepartment();
    retrivecolldepsem();
    specialitybeforedit();
    isshow = false;
    super.initState();
  }

  List<String> options = [];
  List<String> specality = [];
  List specalityid = [];
  List editfacultRefspecailty = [];
  List specialitybefore = [];
  List<String> semester = [];
  List<String> collage = [];
  List<String> department = [];
  String? email = '';
  String? userid = '';
  String? fname;
  String? lname;
  String? mettingmethod;
  String? ksuemail;
  var _fnameController = TextEditingController();
  var _lnameController = TextEditingController();
  var _meetingmethodcontroller = TextEditingController();
  var mettingmethoddrop;
  var mettingmethodinfo;
  var fn;
  var ln;
  var mm;
  var mmi;
  var semesterselectedfromDB;
  var collageselectedfromDB;
  var departmentselectedfromDB;
  late String docsforsemestername;
  late String docsforcollage;
  late String docfordepatment;
  var year;
  var monthe;
  var day;
  var zag = 0;
  bool isshow = false;
  var fnDrawer;
  var lnDrawer;
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

  retrivesuserinfo() async {
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
    zag = specality.length;
    checkidspecialty(specality);
  }

  retrivecolldepsem() async {
    final snap = await FirebaseFirestore.instance
        .collection('faculty')
        .doc(userid)
        .get();
    print("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
    var mm = snap['meetingmethod'];
    mettingmethoddrop = mm;
    print(mm);
    var mmi = snap['mettingmethodinfo'];
    print(mmi);
    _meetingmethodcontroller = TextEditingController(text: mmi);
    var semesterRef = snap["semester"];
    final DocumentSnapshot docRef2 = await semesterRef.get();
    semesterselectedfromDB = docRef2["semestername"];
    // print("/////////////////////semester///////////////////////////");
    // print(semesterselectedfromDB);
    /////////////////////////////////////////////////////
    var collageRef = snap["collage"];
    final DocumentSnapshot docRef3 = await collageRef.get();
    collageselectedfromDB = docRef3["collagename"];
    // print("/////////////////////collage///////////////////////////");
    // print(collageselectedfromDB);
    /////////////////////////////////////////////////////
    var departmentRef = snap["department"];
    final DocumentSnapshot docRef4 = await departmentRef.get();
    departmentselectedfromDB = docRef4["departmentname"];
    // print("/////////////////////department///////////////////////////");
    // print(departmentselectedfromDB);
    checkidc(collageselectedfromDB);
    checkidd(departmentselectedfromDB);
    checkids(semesterselectedfromDB);
  }

  retrievesemester() async {
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

  specialitybeforedit() async {
    final snap = await FirebaseFirestore.instance
        .collection('faculty')
        .doc(userid)
        .get();
    List facultyspecialityRef = snap["specialty"];
    for (var i = 0; i < facultyspecialityRef.length; i++) {
      final DocumentSnapshot docRef = await facultyspecialityRef[i].get();
      setState(() {
        specialitybefore.add(docRef["specialityname"]);
      });
    }
  }

  editfacultyarray(List spe) async {
    final ref = FirebaseFirestore.instance.collection("faculty").doc(userid);
    List f = [];
    f.clear();

    await FirebaseFirestore.instance
        .collection('facultyspeciality')
        .get()
        .then((querySnapshot) {
      // ignore: avoid_function_literals_in_foreach_calls
      querySnapshot.docs.forEach((element) async {
        for (var i = 0; i < specality.length; i++) {
          print(
              "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo");
          print(spe[i]);
          ///// for add
          if (element['specialityname'] == spe[i]) {
            f = element['faculty'];
            print(f);
            if (!(f.contains(ref))) {
              f.add(ref);
              FirebaseFirestore.instance
                  .collection('facultyspeciality')
                  .doc(element.id)
                  .update({
                'faculty': FieldValue.arrayUnion([ref]),
              });
            }
          }
          ////////for delete
          if (!(spe.contains(element['specialityname']))) {
            f = element['faculty'];
            print(f);
            if ((f.contains(ref))) {
              FirebaseFirestore.instance
                  .collection('facultyspeciality')
                  .doc(element.id)
                  .update({
                'faculty': FieldValue.arrayRemove([ref]),
              });
            }
          }
          // if (element['specialityname'] != specialitybefore[i]) {
          //   f = element['faculty'];
          //   print(f);
          //   if ((f.contains(ref))) {
          //     FirebaseFirestore.instance
          //         .collection('facultyspeciality')
          //         .doc(element.id)
          //         .update({
          //       'faculty': FieldValue.arrayRemove([ref]),
          //     });
          //   }
          // }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
        // drawer: Drawer(
        //     child: ListView(children: [
        //   Card(
        //     shadowColor: Color.fromARGB(94, 114, 168, 243),
        //     elevation: 0,
        //     child: DrawerHeader(
        //         child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Padding(
        //           padding: const EdgeInsets.only(
        //             bottom: 0,
        //           ),
        //           child: Image.asset(
        //             "assets/images/woman.png",
        //             width: 100,
        //             height: 100,
        //           ),
        //         ),
        //         SizedBox(
        //           height: 10,
        //         ),
        //         Center(
        //           child: Text("${fnDrawer} ${lnDrawer}",
        //               style: TextStyle(
        //                   fontFamily: 'bold',
        //                   fontSize: 16,
        //                   color: Mycolors.mainColorBlack)),
        //         ),
        //       ],
        //     )),
        //   ),
        //   ListTile(
        //     leading: Icon(Icons.edit_note),
        //     title: Text(
        //       "Edit profile",
        //       style: TextStyle(
        //           fontFamily: 'main',
        //           fontSize: 16,
        //           color: Mycolors.mainColorBlack),
        //     ),
        //     // hoverColor: Mycolors.mainColorBlue,
        //     onTap: (() {
        //       Navigator.pushNamed(context, 'facultyviewprofile');
        //     }),
        //   ),
        //   Divider(
        //     color: Mycolors.mainColorBlue,
        //     thickness: 1,
        //     endIndent: 15,
        //     indent: 15,
        //   ),
        //   ListTile(
        //     leading: Icon(Icons.password),
        //     title: Text(
        //       "Reset password",
        //       style: TextStyle(
        //           fontFamily: 'main',
        //           fontSize: 16,
        //           color: Mycolors.mainColorBlack),
        //     ),
        //     onTap: (() {
        //       // Navigator.pushNamed(context, 'resetpasswprd');
        //     }),
        //   ),
        //   Divider(
        //     color: Mycolors.mainColorBlue,
        //     thickness: 1,
        //     endIndent: 15,
        //     indent: 15,
        //   ),
        //   ListTile(
        //     leading: Icon(Icons.logout),
        //     title: Text(
        //       "Log out",
        //       style: TextStyle(
        //           fontFamily: 'main',
        //           fontSize: 16,
        //           color: Mycolors.mainColorBlack),
        //     ),
        //     onTap: (() {
        //       showConfirmationDialog(context);
        //     }),
        //   ),
        //   Divider(
        //     color: Mycolors.mainColorBlue,
        //     thickness: 1,
        //     endIndent: 15,
        //     indent: 15,
        //   ),
        // ])),
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
                      // if (snapshot.connectionState == ConnectionState.waiting) {
                      //   return Center(child: CircularProgressIndicator());
                      // }
                      if (snapshot.hasData) {
                        print("snapshot");
                        print(snapshot);
                        final cuser =
                            snapshot.data!.data() as Map<String, dynamic>;

                        final fname = cuser['firstname'];
                        final lname = cuser['lastname'];
                        final ksuemail = cuser['ksuemail'];
                        final mettingmethod = cuser['meetingmethod'];
                        fnDrawer = cuser['firstname'];
                        lnDrawer = cuser['lastname'];
                        _fnameController = TextEditingController(text: fname);
                        _lnameController = TextEditingController(text: lname);
                        final _emailController =
                            TextEditingController(text: ksuemail);
                        // _meetingmethodcontroller =
                        //     TextEditingController(text: mettingmethod);
                        selectedoptionlist.value = specality;
                        collageselectedvalue = collageselectedfromDB;
                        departmentselectedvalue = departmentselectedfromDB;
                        semesterselectedvalue = semesterselectedfromDB;
                        // print("/////////////////ممههههممم//////////////////");
                        // print(departmentselectedvalue);
                        // print("//////////////////////////////////");
                        // print(departmentselectedfromDB);
                        // print("/////////////////ممههههممم//////////////////");
                        // print(semesterselectedvalue);
                        // print("//////////////////////////////////");
                        // print(semesterselectedfromDB);
                        // print("/////////////////ممههههممم//////////////////");
                        // print(collageselectedvalue);
                        // print("//////////////////////////////////");
                        // print(collageselectedfromDB);

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildprofileImage(),
                            // Positioned(
                            //   top: top,
                            //   child: buildprofileImage(),
                            // ),

                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: _fnameController,
                              decoration: InputDecoration(
                                  labelText: '  First Name',
                                  // hintText: "Enter your first name",
                                  suffixIcon: Icon(Icons.edit),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                        width: 0,
                                      ))),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty ||
                                    _fnameController.text.isEmpty) {
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
                                  labelText: '  Last Name',
                                  // hintText: "Enter your last name",
                                  suffixIcon: Icon(Icons.edit),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                        width: 0,
                                      ))),
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
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                        width: 0,
                                      ))),
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
                                labelText: 'College',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: const BorderSide(
                                      width: 0,
                                    )),
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
                                  collageselectedfromDB = newselect;
                                  checkidc(collageselectedvalue);
                                });
                              },
                              value: collageselectedvalue,

                              // autovalidateMode:
                              //     AutovalidateMode.onUserInteraction,
                              // validator: (value) {
                              //   if (value == null ||
                              //       collageselectedvalue!.isEmpty ||
                              //       collageselectedvalue == null) {
                              //     return 'Please choose your collage';
                              //   }
                              // },
                            ),
                            SizedBox(
                              height: 8,
                            ),

                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.edit),
                                labelText: ' Department',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: const BorderSide(
                                      width: 0,
                                    )),
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
                                  departmentselectedfromDB = newselect;
                                  checkidd(departmentselectedvalue);
                                });
                                print(
                                    "/////////////////ممههههممم//////////////////");
                                print(departmentselectedvalue);
                              },
                              value: departmentselectedvalue,

                              // autovalidateMode:
                              //     AutovalidateMode.onUserInteraction,
                              // validator: (value) {
                              //   if (value == null ||
                              //       departmentselectedvalue!.isEmpty ||
                              //       departmentselectedvalue == null) {
                              //     return 'Please choose your department';
                              //   }
                              // },
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            DropDownMultiSelect(
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.edit),
                                  labelText: " Speciality",
                                  // hintText: "select your specialty",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            isshow ? Colors.red : Colors.grey),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: isshow
                                            ? Colors.red
                                            : Colors.blueAccent),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: isshow
                                            ? Colors.red
                                            : Colors.blueAccent),
                                    borderRadius: BorderRadius.circular(25),
                                  )),
                              options: options,
                              whenEmpty: "",
                              onChanged: (value) {
                                setState(() {
                                  selectedoptionlist.value = value;
                                  selectedoption.value = "";
                                  selectedoptionlist.value.forEach((element) {
                                    selectedoption.value =
                                        selectedoption.value + " " + element;
                                    specality = selectedoptionlist.value;
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
                                });

                                checkidspecialty(selectedoptionlist.value);

                                zag = selectedoptionlist.value.length;
                                if (zag < 1) {
                                  isshow = true;
                                }
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
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: const BorderSide(
                                      width: 0,
                                    )),
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
                                  semesterselectedfromDB = newselect;
                                  checkids(semesterselectedvalue);
                                });
                              },
                              value: semesterselectedvalue,
                              // autovalidateMode:
                              //     AutovalidateMode.onUserInteraction,
                              // validator: (value) {
                              //   if (value == null ||
                              //       semesterselectedvalue!.isEmpty ||
                              //       semesterselectedvalue == null) {
                              //     return 'Please choose a semester';
                              //   }
                              // },
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            // TextFormField(
                            //     controller: _meetingmethodcontroller,
                            //     decoration: InputDecoration(
                            //         suffixIcon: Icon(Icons.edit),
                            //         labelText: "Metting method",
                            //         border: OutlineInputBorder()),
                            //     autovalidateMode:
                            //         AutovalidateMode.onUserInteraction,
                            //     validator: (value) {
                            //       if (value!.isEmpty ||
                            //           _meetingmethodcontroller.text == "") {
                            //         return 'Please enter your metting method';
                            //       } else {
                            //         if (!(english.hasMatch(
                            //             _meetingmethodcontroller.text))) {
                            //           return "only english is allowed";
                            //         }
                            //       }
                            //     }),
                            // DropdownButtonFormField(
                            //     decoration: InputDecoration(
                            //       suffixIcon: Icon(Icons.edit),
                            //       hintText: "Choose meeting method",
                            //       border: OutlineInputBorder(),
                            //     ),
                            //     items: const [
                            //       DropdownMenuItem(
                            //           child: Text("In person metting"),
                            //           value: "inperson"),
                            //       DropdownMenuItem(
                            //           child: Text("Online meeting "),
                            //           value: "online"),
                            //     ],
                            //     value: mettingmethoddrop,
                            //     onChanged: (value) {
                            //       setState(() {
                            //         mettingmethoddrop = value;
                            //         _meetingmethodcontroller.text = "";
                            //       });
                            //     }),
                            // SizedBox(
                            //   height: 8,
                            // ),
                            // if (mettingmethoddrop != null &&
                            //     mettingmethoddrop == "inperson")
                            //   TextFormField(
                            //       controller: _meetingmethodcontroller,
                            //       decoration: InputDecoration(
                            //           labelText: 'Office number',
                            //           hintText: "Enter your office number",
                            //           suffixIcon: Icon(Icons.edit),
                            //           border: OutlineInputBorder()),
                            //       autovalidateMode:
                            //           AutovalidateMode.onUserInteraction,
                            //       validator: (value) {
                            //         if (value!.isEmpty ||
                            //             _meetingmethodcontroller.text == "") {
                            //           return 'Please enter your office number';
                            //         } else {
                            //           if (!(english.hasMatch(
                            //               _meetingmethodcontroller.text))) {
                            //             return "only english is allowed";
                            //           }
                            //         }
                            //       }),
                            // if (mettingmethoddrop != null &&
                            //     mettingmethoddrop == "online")
                            //   TextFormField(
                            //       controller: _meetingmethodcontroller,
                            //       decoration: InputDecoration(
                            //           labelText: 'meeting link',
                            //           hintText: "Enter your meeting link",
                            //           suffixIcon: Icon(Icons.edit),
                            //           border: OutlineInputBorder()),
                            //       autovalidateMode:
                            //           AutovalidateMode.onUserInteraction,
                            //       validator: (value) {
                            //         if (value!.isEmpty ||
                            //             _meetingmethodcontroller.text == "") {
                            //           return 'Please enter your meeting link';
                            //         } else {
                            //           if (!(english.hasMatch(
                            //               _meetingmethodcontroller.text))) {
                            //             return "only english is allowed";
                            //           }
                            //         }
                            //       }),
                          ],
                        ); //here
                      }
                      return Center(child: CircularProgressIndicator());
                    }),
                SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
                    shadowColor: Colors.blue[900],
                    elevation: 16,
                    backgroundColor: Mycolors.mainShadedColorBlue,
                    minimumSize: Size(150, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17), // <-- Radius
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      fn = _fnameController.text;
                      ln = _lnameController.text;
                      mm = mettingmethoddrop;
                      mmi = _meetingmethodcontroller.text;
                      editfacultyarray(editfacultRefspecailty);
                      if (zag < 1) {
                        isshow = true;
                      }
                      if (zag > 0) {
                        isshow = false;
                      }
                    });

                    if (formkey.currentState!.validate() && zag > 0) {
                      try {
                        FirebaseFirestore.instance
                            .collection('faculty')
                            .doc(userid)
                            .update({
                          "firstname": fn,
                          "lastname": ln,
                          "meetingmethod": mm,
                          "mettingmethodinfo": mmi,
                          'department': FirebaseFirestore.instance
                              .collection("collage")
                              .doc(docsforcollage)
                              .collection("department")
                              .doc(docfordepatment),
                          'collage': FirebaseFirestore.instance
                              .collection("collage")
                              .doc(docsforcollage),
                          'semester': FirebaseFirestore.instance
                              .collection("semester")
                              .doc(docsforsemestername),
                          "specialty": specalityid,
                        });

                        Fluttertoast.showToast(
                          msg:
                              " Your information has been updated successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Color.fromARGB(255, 127, 166, 233),
                          textColor: Color.fromARGB(255, 248, 249, 250),
                          fontSize: 18.0,
                        );
                      } on FirebaseAuthException catch (error) {
                        Fluttertoast.showToast(
                          msg: "Something wronge",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 5,
                          backgroundColor: Color.fromARGB(255, 127, 166, 233),
                          textColor: Color.fromARGB(255, 252, 253, 255),
                          fontSize: 18.0,
                        );
                      }
                    }
                  },
                  child: Text("Save changes"),
                ),
              ]),
            ), ////here
          ),
        ),
      ),
    );
  }

  // Widget buildCoverImage() => Container(
  //       color: Colors.grey,
  //       // child: Image.asset(
  //       //   'assets/images/profilebackground.png.png',
  //       //   width: double.infinity,
  //       //   height: coverheight,
  //       //   fit: BoxFit.cover,
  //       // ),
  //     );

  Widget buildprofileImage() => CircleAvatar(
        radius: profileheight / 2,
        backgroundColor: Colors.grey.shade800,
        backgroundImage: AssetImage('assets/images/woman.png'),
      );

  checkidspecialty(List<String?> specialityoption) async {
    editfacultRefspecailty.clear();
    specalityid.length = 0;
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
                editfacultRefspecailty.add(element['specialityname']);
                // editfacultRefspecailty.add(element['specialityname']);
                // print("9999999999999999999999999999999999999999999999999");
                // editfacultyarray(editfacultRefspecailty);

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

  // checkspecialityforfaculty(List<String?> specialityoption) async {
  //   editfacultRefspecailty.clear();
  //   specalityid.length = 0;
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('facultyspeciality')
  //         .get()
  //         .then((querySnapshot) {
  //       querySnapshot.docs.forEach((element) {
  //         setState(() {
  //           for (var i = 0; i < specialityoption.length; i++) {
  //             if (element['specialityname'] == specialityoption[i]) {
  //               final ref = FirebaseFirestore.instance
  //                   .collection("facultyspeciality")
  //                   .doc(element.id);
  //               editfacultRefspecailty.add(element['specialityname']);
  //               editfacultyarray(editfacultRefspecailty);
  //             }
  //           }
  //         });
  //       });
  //     });
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  checkids(String? semstername) async {
    try {
      await FirebaseFirestore.instance
          .collection('semester')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          setState(() {
            if (semstername == element['semestername']) {
              docsforsemestername = element.id;
            }
          });
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  checkidc(String? collagename) async {
    try {
      await FirebaseFirestore.instance
          .collection('collage')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          setState(() {
            if (collagename == element['collagename']) {
              docsforcollage = element.id;
            }
          });
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  checkidd(String? departmentename) async {
    try {
      await FirebaseFirestore.instance
          .collection('collage')
          .doc("CCIS")
          .collection("department")
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          setState(() {
            if (departmentename == element['departmentname']) {
              docfordepatment = element.id;
            }
          });
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // showConfirmationDialog(BuildContext context) {
  //   Widget dontCancelAppButton = ElevatedButton(
  //     style: ElevatedButton.styleFrom(
  //       textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
  //       shadowColor: Colors.blue[900],
  //       elevation: 20,
  //       backgroundColor: Mycolors.mainShadedColorBlue,
  //       minimumSize: Size(60, 40),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10), // <-- Radius
  //       ),
  //     ),
  //     child: Text("No"),
  //     onPressed: () {
  //       Navigator.of(context).pop();
  //     },
  //   );

  //   Widget YesCancelAppButton = ElevatedButton(
  //     style: ElevatedButton.styleFrom(
  //       textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
  //       shadowColor: Colors.blue[900],
  //       elevation: 20,
  //       backgroundColor: Mycolors.mainShadedColorBlue,
  //       minimumSize: Size(60, 40),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10), // <-- Radius
  //       ),
  //     ),
  //     child: Text("Yes"),
  //     onPressed: () {
  //       FirebaseAuth.instance.signOut().then((value) => Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => login())));
  //     },
  //   );

  //   AlertDialog alert = AlertDialog(
  //     // title: Text("LogOut"),
  //     content: Text("Are you sure you want to logout ?"),
  //     actions: [
  //       dontCancelAppButton,
  //       YesCancelAppButton,
  //     ],
  //   );

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }
}
