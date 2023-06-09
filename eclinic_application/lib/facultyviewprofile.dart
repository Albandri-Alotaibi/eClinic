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
import 'package:myapp/domain/extension.dart';
import 'package:myapp/login.dart';
import 'package:myapp/screeens/resources/snackbar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'style/Mycolors.dart';
import 'package:quickalert/quickalert.dart';
import 'package:myapp/screeens/resources/dialog.dart';

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
    // retrievesemester();
    // retrivecollage();
    retrivedepartment();
    retrivecolldepsem();
    specialitybeforedit();
    isshow = false;
    super.initState();
  }

  List<String> options = [];
  List<String> specality = [];
  List<String> fixspecality = [];
  List specalityid = [];
  List fixspecalityid = [];
  List editfacultRefspecailty = [];
  List specialitybefore = [];
  // List<String> semester = [];
  List<Map<String, dynamic>?> semester = [];
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
  var fixedselectedsemester;
  var fixedselctedepartment;
  var fixedfn;
  var fixdln;
  bool fix = true;
  bool fix2 = false;
  late String docsforsemestername;
  late String docsforcollage;
  late String docfordepatment;
  var year;
  var monthe;
  var day;
  var checklengthforspecialty = 0;
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
    checklengthforspecialty = specality.length;
    checkidspecialty(specality);
  }

  retrivecolldepsem() async {
    final snap = await FirebaseFirestore.instance
        .collection('faculty')
        .doc(userid)
        .get();
    print("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");

    var semesterRef = snap["semester"];
    final DocumentSnapshot docRef2 = await semesterRef.get();
    semesterselectedfromDB = docRef2["semestername"];
    fixedselectedsemester = docRef2["semestername"];
    final fname = snap['firstname'];
    final lname = snap['lastname'];
    fixedfn = snap['firstname'];
    fixdln = snap['lastname'];
    _fnameController = TextEditingController(text: fname);
    _lnameController = TextEditingController(text: lname);

    var departmentRef = snap["department"];
    final DocumentSnapshot docRef4 = await departmentRef.get();
    departmentselectedfromDB = docRef4["departmentname"];
    fixedselctedepartment = docRef4["departmentname"];

    checkidd(departmentselectedfromDB);
    checkids(semesterselectedfromDB);
    retrievesemester();
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
            var secondyear = year + 1;
            String s = year.toString();
            String sy = secondyear.toString();
            String sn = element['semestername'];
            var startdate = element['startdate'];
            startdate.toString();
            print("second year");
            print(secondyear);
            print("after parse");
            print(sy);
            if ((sn.contains(s)) || (sn.contains(sy))) {
              print(sn);
              semester.add(element.data());
            }

          

            if (startdate != null) {
              Timestamp t = element['enddate'];
              DateTime enddate = t.toDate();
              // after && becuase if faculty was choose semester that the end date become in the past
              if (Dateoftoday.isAfter(enddate) &&
                  element['semestername'] != semesterselectedfromDB) {
                semester.remove(element.data());
              }

             
            }
          });
        });
     
      });
      semester.sortBySemesterAndYear();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  retrivedepartment() async {
    try {
      await FirebaseFirestore.instance
          .
          // .collection('collage')
          // .doc("CCIS")
          // .
          collection("department")
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
          leading: BackButton(
            onPressed: () {
              Navigator.pushNamed(context, 'facultyhome');
            },
          ),
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: Mycolors.mainColorBlack,
          ),
          title: Text("My profile"),
          backgroundColor: Mycolors.mainColorWhite,
          shadowColor: Colors.transparent,
          iconTheme: IconThemeData(
            color: Color.fromARGB(255, 12, 12, 12), //change your color here
          ),
        ),
        backgroundColor: Mycolors.BackgroundColor,
        body: SingleChildScrollView(
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
                    
                      if (snapshot.hasData) {
                        print("snapshot");
                        print(snapshot);
                        final cuser =
                            snapshot.data!.data() as Map<String, dynamic>;

                        final ksuemail = cuser['ksuemail'];

                        fnDrawer = cuser['firstname'];
                        lnDrawer = cuser['lastname'];
                        
                        final _emailController =
                            TextEditingController(text: ksuemail);
                        // _meetingmethodcontroller =
                        //     TextEditingController(text: mettingmethod);
                        selectedoptionlist.value = specality;

                        departmentselectedvalue = departmentselectedfromDB;
                        semesterselectedvalue = semesterselectedfromDB;
                        

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
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "First name:",
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Mycolors.mainColorBlack,
                                    fontFamily: 'bold',
                                    fontSize: 13),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            TextFormField(
                              controller: _fnameController,
                              decoration: InputDecoration(
                                  // labelText: '  First Name',
                                  hintText: "Enter the first name",
                                  suffixIcon: Icon(Icons.edit),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(13),
                                      borderSide: const BorderSide(
                                        width: 0,
                                      ))),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty ||
                                    _fnameController.text.isEmpty) {
                                  return 'Please enter your first name ';
                                } else {
                                  if (nameRegExp
                                      .hasMatch(_fnameController.text)) {
                                    return 'Please first name only letters accepted ';
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
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Last name:",
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Mycolors.mainColorBlack,
                                    fontFamily: 'bold',
                                    fontSize: 13),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            TextFormField(
                              controller: _lnameController,
                              decoration: InputDecoration(
                                  // labelText: '  Last Name',
                                  hintText: "Enter your last name",
                                  suffixIcon: Icon(Icons.edit),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(13),
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
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "KSU Email:",
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Mycolors.mainColorBlack,
                                    fontFamily: 'bold',
                                    fontSize: 13),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            TextFormField(
                              controller: _emailController,
                              readOnly: true,
                              decoration: InputDecoration(
                                  hintText: "Enter the email",
                                  // labelText: ' Email',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(13),
                                      borderSide: const BorderSide(
                                        width: 0,
                                      ))),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty ||
                                    _emailController.text == "") {
                                  return 'Please enter your email ';
                               
                                }
                              },
                            ),
                            SizedBox(
                              height: 8,
                            ),
                          
                            
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Department:",
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Mycolors.mainColorBlack,
                                    fontFamily: 'bold',
                                    fontSize: 13),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.edit),
                                // labelText: ' Department',
                                hintText: "Please choose the department",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(13),
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

                            
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Speciality:",
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Mycolors.mainColorBlack,
                                    fontFamily: 'bold',
                                    fontSize: 13),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            DropDownMultiSelect(
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.edit),
                                  // labelText: " Speciality",
                                  hintText: "choose the specialty",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            isshow ? Colors.red : Colors.grey),
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: isshow
                                            ? Colors.red
                                            : Colors.blueAccent),
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: isshow
                                            ? Colors.red
                                            : Colors.blueAccent),
                                    borderRadius: BorderRadius.circular(13),
                                  )),
                              options: options,
                              whenEmpty: "",
                              onChanged: (value) {
                                setState(() {
                                  fix = false;
                                  fix2 = true;
                                  selectedoptionlist.value = value;
                                  selectedoption.value = "";
                                  selectedoptionlist.value.forEach((element) {
                                    selectedoption.value =
                                        selectedoption.value + " " + element;
                                    specality = selectedoptionlist.value;
                                    checklengthforspecialty =
                                        selectedoptionlist.value.length;
                                    isshow = selectedoption.value.isEmpty;

                                    if (checklengthforspecialty < 1) {
                                      isshow = true;
                                    }
                                    if (checklengthforspecialty > 0 ||
                                        selectedoption.value.isEmpty ||
                                        selectedoption.value == null) {
                                      isshow = false;
                                    }
                                  });
                                });

                                checkidspecialty(selectedoptionlist.value);

                                checklengthforspecialty =
                                    selectedoptionlist.value.length;
                                if (checklengthforspecialty < 1) {
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
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Semester:",
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Mycolors.mainColorBlack,
                                    fontFamily: 'bold',
                                    fontSize: 13),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.edit),
                                // labelText: 'semester',
                                hintText: "Please choose the semester",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(13),
                                    borderSide: const BorderSide(
                                      width: 0,
                                    )),
                              ),
                              isExpanded: true,
                              items: semester
                                  .map((e) => e!['semestername'])
                                  .toList()
                                  .map((dropdownitems) {
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
                         
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                textStyle:
                                    TextStyle(fontFamily: 'main', fontSize: 16),
                                //shadowColor: Colors.blue[900],
                                elevation: 0,
                                backgroundColor: Mycolors.mainShadedColorBlue,
                                minimumSize: Size(150, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(17), // <-- Radius
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  fn = _fnameController.text;
                                  ln = _lnameController.text;
                                  editfacultyarray(editfacultRefspecailty);
                                  if (checklengthforspecialty < 1) {
                                    isshow = true;
                                  }
                                  if (checklengthforspecialty > 0) {
                                    isshow = false;
                                  }
                                });
                                if (formkey.currentState!.validate() &&
                                    checklengthforspecialty > 0) {
                                  print("0000000000000000000");
                                  print(specalityid);
                                  print("999999999999999999999");
                                  print(fixspecalityid);
                                  if (fn == fixedfn &&
                                      ln == fixdln &&
                                      fix &&
                                      semesterselectedvalue ==
                                          fixedselectedsemester &&
                                      departmentselectedvalue ==
                                          fixedselctedepartment) {
                                    showInSnackBar(
                                        context, "No change have been made",
                                        onError: true);
                                  }
                                  if ((fn != fixedfn || ln != fixdln || fix2) &&
                                      semesterselectedvalue ==
                                          fixedselectedsemester &&
                                      departmentselectedvalue ==
                                          fixedselctedepartment) {
                                    try {
                                      addfacultyinsemester(specalityid, userid);
                                      FirebaseFirestore.instance
                                          .collection('faculty')
                                          .doc(userid)
                                          .update({
                                        "firstname": fn,
                                        "lastname": ln,
                                        'department': FirebaseFirestore.instance
                                            .collection("department")
                                            .doc(docfordepatment),
                                        'semester': FirebaseFirestore.instance
                                            .collection("semester")
                                            .doc(docsforsemestername),
                                        "specialty": specalityid,
                                      });

                                      showInSnackBar(context,
                                          "Your information has been updated successfully ");
                                    } on FirebaseAuthException catch (error) {
                                      showInSnackBar(
                                          context, "Something wronge",
                                          onError: true);
                                    }
                                  }
                                  // }

                                  if (semesterselectedvalue !=
                                      fixedselectedsemester) {
                                    confirm2(context);
                                  }
                                  if (departmentselectedvalue !=
                                      fixedselctedepartment) {
                                    //dep confirm
                                    confirm2dep(context);
                                  }

                                  //if semester changed
                                }
                                //if department change
                              },
                              child: Text("Save"),
                            ),
                          ],
                        ); //here
                      }
                      return Center(child: CircularProgressIndicator());
                    }),
                SizedBox(
                  height: 12,
                ),
              
              
              
             
              ]),
            ), ////here
          ),
        ),
      ),
    );
  }

  confirm(BuildContext context) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
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
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog

    Widget continueButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
        // shadowColor: Colors.blue[900],
        elevation: 0,
        backgroundColor: Mycolors.mainShadedColorBlue,
        minimumSize: Size(70, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // <-- Radius
        ),
      ),
      child: Text("Confirm"),
      onPressed: () async {
        if (formkey.currentState!.validate() && checklengthforspecialty > 0) {
          setState(() {
            fn = _fnameController.text;
            ln = _lnameController.text;
            editfacultyarray(editfacultRefspecailty);
            if (checklengthforspecialty < 1) {
              isshow = true;
            }
            if (checklengthforspecialty > 0) {
              isshow = false;
            }
          });

          try {
            addfacultyinsemester(specalityid, userid);
            FirebaseFirestore.instance
                .collection('faculty')
                .doc(userid)
                .update({
              "firstname": fn,
              "lastname": ln,
              'department': FirebaseFirestore.instance
                  .collection("department")
                  .doc(docfordepatment),
              'semester': FirebaseFirestore.instance
                  .collection("semester")
                  .doc(docsforsemestername),
              "specialty": specalityid,
              "availablehours": FieldValue.delete(),
            });

            showInSnackBar(
                context, "Your information has been updated successfully ");
          } on FirebaseAuthException catch (error) {
            showInSnackBar(context, "Something wronge", onError: true);
          }
          Navigator.pushNamed(context, 'facultyviewprofile');
        }
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(""),
      content: SizedBox(
        height: 100,
        child: Column(
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: 350,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
                "Changing your semester will affect your current office hours by deleting them & your appointments by canceling them"),
          ],
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    // show the dialog
  }

  confirm2(BuildContext context) {
    // set up the buttons
    buildShowDialog(
      context: context,
      title: 'Warning',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.sd_card_alert_rounded,
            size: 80,
            color: Colors.amber,
          ),
          SizedBox(
            height: 4,
          ),
          Text(
              "Changing your semester will affect your current office hours by deleting them & your appointments by canceling them"),
          SizedBox(
            height: 8,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
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
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(
                width: 5,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
                  // shadowColor: Colors.blue[900],
                  elevation: 0,
                  backgroundColor: Mycolors.mainShadedColorBlue,
                  minimumSize: Size(70, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // <-- Radius
                  ),
                ),
                child: Text("Confirm"),
                onPressed: () async {
                  if (formkey.currentState!.validate() &&
                      checklengthforspecialty > 0) {
                    setState(() {
                      fn = _fnameController.text;
                      ln = _lnameController.text;
                      editfacultyarray(editfacultRefspecailty);
                      if (checklengthforspecialty < 1) {
                        isshow = true;
                      }
                      if (checklengthforspecialty > 0) {
                        isshow = false;
                      }
                    });

                    try {
                      addfacultyinsemester(specalityid, userid);
                      FirebaseFirestore.instance
                          .collection('faculty')
                          .doc(userid)
                          .update({
                        "firstname": fn,
                        "lastname": ln,
                        'department': FirebaseFirestore.instance
                            .collection("department")
                            .doc(docfordepatment),
                        'semester': FirebaseFirestore.instance
                            .collection("semester")
                            .doc(docsforsemestername),
                        "specialty": specalityid,
                        "availablehours": FieldValue.delete(),
                      });

                      showInSnackBar(context,
                          "Your information has been updated successfully ");
                    } on FirebaseAuthException catch (error) {
                      showInSnackBar(context, "Something wronge",
                          onError: true);
                    }
                    Navigator.pushNamed(context, 'facultyviewprofile');
                  }
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  confirm2dep(BuildContext context) {
    // set up the buttons
    buildShowDialog(
      context: context,
      title: 'Warning',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.sd_card_alert_rounded,
            size: 80,
            color: Colors.amber,
          ),
          SizedBox(
            height: 4,
          ),
          Text(
              "Changing your department will affect your current office hours by deleting them & your appointments by canceling them"),
          SizedBox(
            height: 8,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
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
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(
                width: 5,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
                  // shadowColor: Colors.blue[900],
                  elevation: 0,
                  backgroundColor: Mycolors.mainShadedColorBlue,
                  minimumSize: Size(70, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // <-- Radius
                  ),
                ),
                child: Text("Confirm"),
                onPressed: () async {
                  if (formkey.currentState!.validate() &&
                      checklengthforspecialty > 0) {
                    setState(() {
                      fn = _fnameController.text;
                      ln = _lnameController.text;
                      editfacultyarray(editfacultRefspecailty);
                      if (checklengthforspecialty < 1) {
                        isshow = true;
                      }
                      if (checklengthforspecialty > 0) {
                        isshow = false;
                      }
                    });

                    try {
                      addfacultyinsemester(specalityid, userid);
                      FirebaseFirestore.instance
                          .collection('faculty')
                          .doc(userid)
                          .update({
                        "firstname": fn,
                        "lastname": ln,
                        'department': FirebaseFirestore.instance
                            .collection("department")
                            .doc(docfordepatment),
                        'semester': FirebaseFirestore.instance
                            .collection("semester")
                            .doc(docsforsemestername),
                        "specialty": specalityid,
                        "availablehours": FieldValue.delete(),
                      });

                      showInSnackBar(context,
                          "Your information has been updated successfully ");
                    } on FirebaseAuthException catch (error) {
                      showInSnackBar(context, "Something wronge",
                          onError: true);
                    }
                    Navigator.pushNamed(context, 'facultyviewprofile');
                  }
                },
              )
            ],
          ),
        ],
      ),
    );
  }


  Widget buildprofileImage() => CircleAvatar(
        radius: profileheight / 2,
        backgroundColor: Colors.grey.shade800,
        backgroundImage: AssetImage("assets/images/User1.png"),
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

 

  checkidd(String? departmentename) async {
    try {
      await FirebaseFirestore.instance
          // .collection('collage')
          // .doc("CCIS")
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

  addfacultyinsemester(List spe, var fid) async {
    // bool flag = true;
    var ref = FirebaseFirestore.instance.collection("faculty").doc(fid);
    print(ref);
    var snap = await FirebaseFirestore.instance
        .collection('semester')
        .doc(docsforsemestername)
        .get();
    int index = 0;
    if (snap.data()!.containsKey('facultymembers') == true) {
      List faculty = snap.data()!["facultymembers"] as List;
      // print(docsforsemestername);

      faculty.forEach(
        (element) async {
          print("hiiiiiiiiiiiiiiiiiiiiiiiiiii");
          print(ref);
          print(element["faculty"]);
          if (element["faculty"] == ref) {
            // flag = false;
            print("yeeeeeeeeeeeeeesssssssssssssssssssssssss");
            element["specialty"] = spe;
            await FirebaseFirestore.instance
                .collection('semester')
                .doc(docsforsemestername)
                .update({
              "facultymembers": faculty,
            });
          }
          index++;
          if (element["faculty"] != ref && index == faculty.length) {
            print("kkkkkkkkkkkkkkkkkkkkkkkkkWHY??????");

            await FirebaseFirestore.instance
                .collection('semester')
                .doc(docsforsemestername)
                .update({
              "facultymembers": FieldValue.arrayUnion([
                {
                  'faculty': ref,
                  'specialty': spe,
                }
              ]),
            });
          }

        },
      );
    } else {
      await FirebaseFirestore.instance
          .collection('semester')
          .doc(docsforsemestername)
          .update({
        "facultymembers": FieldValue.arrayUnion([
          {
            'faculty': ref,
            'specialty': spe,
          }
        ]),
      });
    }

    print(ref);
    print(spe);
  }

  confirmDep(BuildContext context) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
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
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog

    Widget continueButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
        // shadowColor: Colors.blue[900],
        elevation: 0,
        backgroundColor: Mycolors.mainShadedColorBlue,
        minimumSize: Size(70, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // <-- Radius
        ),
      ),
      child: Text("Confirm"),
      onPressed: () async {
        if (formkey.currentState!.validate() && checklengthforspecialty > 0) {
          setState(() {
            fn = _fnameController.text;
            ln = _lnameController.text;
            editfacultyarray(editfacultRefspecailty);
            if (checklengthforspecialty < 1) {
              isshow = true;
            }
            if (checklengthforspecialty > 0) {
              isshow = false;
            }
          });

          try {
            addfacultyinsemester(specalityid, userid);
            FirebaseFirestore.instance
                .collection('faculty')
                .doc(userid)
                .update({
              "firstname": fn,
              "lastname": ln,
              'department': FirebaseFirestore.instance
                  .collection("department")
                  .doc(docfordepatment),
              'semester': FirebaseFirestore.instance
                  .collection("semester")
                  .doc(docsforsemestername),
              "specialty": specalityid,
              "availablehours": FieldValue.delete(),
            });

            showInSnackBar(
                context, "Your information has been updated successfully ");
          } on FirebaseAuthException catch (error) {
            showInSnackBar(context, "Something wronge", onError: true);
          }
          Navigator.pushNamed(context, 'facultyviewprofilfe');
        }
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(""),
      content: SizedBox(
        height: 100,
        child: Column(
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: 350,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
                "Changing your department will affect your current office hours by deleting them & your appointments by canceling them"),
          ],
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    // show the dialog
  }


  showerror(BuildContext context, String msg) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            height: 90,
            decoration: BoxDecoration(
                color: Color(0xFFC72C41),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Row(
              children: [
                SizedBox(
                  width: 48,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  
                      Text(
                        msg,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ));
  }
}
