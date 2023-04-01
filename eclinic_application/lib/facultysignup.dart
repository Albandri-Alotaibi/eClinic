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
import 'package:intl/intl.dart';
import 'style/Mycolors.dart';
import 'package:myapp/screeens/resources/snackbar.dart';

class facultysignup extends StatefulWidget {
  const facultysignup({super.key});

  @override
  State<facultysignup> createState() => _facultysignupState();
}

class _facultysignupState extends State<facultysignup> {
  final formkey = GlobalKey<FormState>();
  List<String> options = [];
  List<String> semester = [];
  List<String> semesteraftersort = [];
  List<String> collage = [];
  List<String> department = [];
  List speciality = [];
  List spName = [];
  List faculty = [];
  late String docsforsemestername;
  late String docsforcollage;
  late String docfordepatment;
  var departmentselectedvalue;
  var collageselectedvalue;
  var semesterselectedvalue;
  var year;
  var monthe;
  var day;
  var mettingmethoddrop;
  late String semstername;
  Rx<List<String>> selectedoptionlist = Rx<List<String>>([]);
  var selectedoption = "".obs;
  List<String> t = [];
  List<String> e = [];
  List<String> t2 = [];
  List<String> e2 = [];
  List<String> first = [];
  List<String> second = [];
  void initState() {
    retrivespecilty();
    retrievesemester();
    retrivedepartment();
    super.initState();
  }

  retrivespecilty() async {
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
            print(year);
            DateTime Dateoftoday = DateTime.now();

            String s = year.toString();
            print(s);
            String sn = element['semestername'];
            var startdate = element['startdate'];
            startdate.toString();

            if ((sn.contains(s))) {
              print(element['semestername']);
              // print("ppppppppppppppppppppppppppppppppppppppp");
              // print(sn);
              semester.add(element['semestername']);
              // print("ppppppppppppppppppppppppppppppppppppppp");
              // print(semester);
            }

            // if (Dateoftoday.year <= enddate.year) {
            //   if (Dateoftoday.month > enddate.month &&
            //       Dateoftoday.day > enddate.day) {
            //     semester.remove(element['semestername']);
            //   }
            // }

            // if (Dateoftoday.year <= enddate.year) {
            //   if (Dateoftoday.month == enddate.month &&
            //       Dateoftoday.day > enddate.day) {
            //     semester.remove(element['semestername']);
            //   }
            // }
            if (startdate != null) {
              Timestamp t = element['enddate'];
              DateTime enddate = t.toDate();
              if (Dateoftoday.isAfter(enddate)) {
                print("rrrrrrrrrrrrrreeeeeeeeeeeeeeemmmmmmmmmmmoooveeeeeee");
                print(element['semestername']);
                semester.remove(element['semestername']);
              }
            }
          });
          //calling sort function

          semester.sort();
        });
        print(semester);
      });
      sortsemester(semester);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  sortsemester(List<String> sem) {
    //     List<String> t = [];
    // List<String> e = [];
    // List<String> t2 = [];
    // List<String> e2 = [];
    // List<String> first = [];
    // List<String> second = [];
    // List<String> slash = [];

    // print("befor sort");
    // print(sem);
    // print("after sort");
    sem.sort();
    print("befor sort by f s t ");
    print(sem);
    // for (var i = 0; i < sem.length; i++) {
    //   t = sem[i].split(" ");
    //   e = t[1].split("/");
    // if (t[0].contains("1")) {
    //   var s = t[0].substring(0, 1);
    //   print(s);
    //   print("first semester");
    // }
    // if (double.parse(e[0]) < double.parse(e[1])) {
    //   print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
    //   print(e[0]);
    //   print(e[1]);
    //   if (t[0].contains("1")) {
    //     print("hi");
    //   }
    // }
    //   first.add(e[0]);
    //   second.add(e[1]);

    //   //print(e[i]);
    // }
    // for (var b = 0; b < sem.length; b++) {
    //   for (var b2 = 1; b2 < sem.length; b2++) {
    //     for (var s = 0; s < second.length; s++) {
    //       for (var s2 = 1; s2 < second.length; s2++) {
    //         t = sem[b].split(" ");
    //         e = t[1].split("/");
    //         t2 = sem[b2].split(" ");
    //         e2 = t[1].split("/");
    //         if (double.parse(t[0].substring(0, 1)) <
    //             double.parse(t2[0].substring(0, 1))) {
    //           if (double.parse(e[1]) > double.parse(e2[1])) {
    //             var temp = sem[b];
    //             sem[b] = sem[b2];
    //             sem[b2] = temp;
    //           }
    //         }
    //       }
    //     }
    //   }
    // }
    for (var b = 0; b < sem.length; b++) {
      for (var b2 = 1; b2 < sem.length; b2++) {
        t = sem[b].split(" ");
        e = t[1].split("/");
        t2 = sem[b2].split(" ");
        e2 = t2[1].split("/");
        print(t[0]);
        // print(e[1]);
        print("///////////////////////////////////////////");
        print(e[1]);
        print(e2[1]);
        if (double.parse(e[1]) > double.parse(e2[1])) {
          if (double.parse(t[0].substring(0, 1)) <
              double.parse(t2[0].substring(0, 1))) {
            print("hi hanouf ");
            var temp = sem[b];
            sem[b] = sem[b2];
            sem[b2] = temp;
          }
        }
      }
    }
    print("hhhhhhhhh after sort hhhhhhhhhhhhhhhhhhhhh");
    print(sem);

    // String test = "3rd 2023/2024";
    // List<String> t = test.split(" ");
    // List<String> e = t[1].split("/");
    // print("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
    // print(t);
    // print("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
    // print(e[1]);
  }

  retrivedepartment() async {
    try {
      await FirebaseFirestore.instance
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

  Future checkids(String? semstername) async {
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

  Future checkidd(String? departmentename) async {
    try {
      await FirebaseFirestore.instance
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

  checkidspecialty(List<String?> specialityoption) async {
    speciality.clear();
    spName.clear();
    print(specialityoption);
    print(speciality.length);
    print(speciality);

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
                speciality.add(ref);
                spName.add(element['specialityname']);
                print("99999999999999999999999999999999999999999");
                print(spName);
                print(speciality);
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

  addfacultyRefonspeciality(List sp, uid) async {
    print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
    print(sp);
    final ref = FirebaseFirestore.instance.collection("faculty").doc(uid);
    faculty.add(ref);
    await FirebaseFirestore.instance
        .collection('facultyspeciality')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        setState(() {
          for (var i = 0; i < sp.length; i++) {
            if (element['specialityname'] == sp[i]) {
              FirebaseFirestore.instance
                  .collection('facultyspeciality')
                  .doc(element.id)
                  .update({
                'faculty': FieldValue.arrayUnion(faculty),
              });
            }
          }
        });
      });
    });
  }

  //to get user input
  var fname = '';
  var lname = '';
  var email = '';
  var password = '';
  var meetingmethod;
  var mettingmethodinfo;
  var dep = '';
  var spec = '';
  var userid = "";
  var checklengthforspeciality = 0;
  bool isshow = false;

  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _meetingmethodcontroller = TextEditingController();
  static final RegExp nameRegExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
  RegExp uperRegExp = RegExp(r"(?=.*[A-Z])");
  RegExp numbRegExp = RegExp(r"[0-9]");
  RegExp smallRegExp = RegExp(r"(?=.*[a-z])");
  RegExp ksuEmailRegEx = new RegExp(r'^([a-z\d\._]+)@ksu.edu.sa$',
      multiLine: false, caseSensitive: false);
  RegExp english = RegExp("^[\u0000-\u007F]+\$");

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            primary: false,
            centerTitle: true,
            backgroundColor: Mycolors.mainColorWhite,
            shadowColor: Colors.transparent,
            //foregroundColor: Mycolors.mainColorBlack,
            // automaticallyImplyLeading: false,
            iconTheme: IconThemeData(
              color: Color.fromARGB(255, 12, 12, 12), //change your color here
            ),
            title: Text('Create account'),

            titleTextStyle: TextStyle(
              fontFamily: 'bold',
              fontSize: 24,
              color: Mycolors.mainColorBlack,
            ),
          ),
          backgroundColor: Mycolors.BackgroundColor,
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 30, bottom: 10),
                  //   child: Text(
                  //     "Create account",
                  //     style: TextStyle(
                  //         color: Mycolors.mainColorBlack,
                  //         fontFamily: 'main',
                  //         fontSize: 24),
                  //   ),
                  // ),
                  Image.asset(
                    "assets/images/eClinicLogo-blue1.png",
                    width: 300,
                    height: 200,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Form(
                      key: formkey,
                      child: Padding(
                        padding: const EdgeInsets.all(13),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 10,
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
                                  // labelText: ' First Name :',
                                  hintText: "Enter the first name",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(13),
                                      borderSide: const BorderSide(
                                        width: 0,
                                      ))),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty ||
                                    _fnameController.text == "") {
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
                                  // labelText: ' Last Name : ',
                                  hintText: "Enter the last name",
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
                                "Email:",
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
                              decoration: InputDecoration(
                                  hintText: "Enter the email",
                                  // labelText: '  Email :',
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
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Password:",
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
                                controller: _passwordController,
                                decoration: InputDecoration(
                                    // labelText: ' Password :',
                                    hintText: "Enter the password",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(13),
                                        borderSide: const BorderSide(
                                          width: 0,
                                        ))),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      _passwordController.text == "") {
                                    return 'Please enter your password';
                                  } else {
                                    if (!(english
                                        .hasMatch(_passwordController.text))) {
                                      return "only english is allowed";
                                    } else {
                                      if (value.length < 8 &&
                                          !uperRegExp.hasMatch(value) &&
                                          !numbRegExp.hasMatch(value) &&
                                          !smallRegExp.hasMatch(value)) {
                                        return "must be at least 8 characters and contain uppercase,lowercase letters";
                                      } else if (value.length < 8 &&
                                          !uperRegExp.hasMatch(value)) {
                                        return "must be at least 8 characters and contain uppercase letters";
                                      } else if (value.length < 8 &&
                                          !smallRegExp.hasMatch(value)) {
                                        return "must be at least 8 characters and contain lowercase letters";
                                      } else if (!uperRegExp.hasMatch(value) &&
                                          !smallRegExp.hasMatch(value)) {
                                        return "must be contain both uppercase and lowercase letters";
                                      } else if (value.length < 8) {
                                        return " must be at least 8 characters";
                                      } else if (!uperRegExp.hasMatch(value)) {
                                        return "must be contain uppercase letters";
                                      } else if (!smallRegExp.hasMatch(value)) {
                                        return "must be contain lowercase letters";
                                      } else if (!numbRegExp.hasMatch(value)) {
                                        return "must be contain number";
                                      }
                                    }
                                  }
                                }),
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
                                hintText: ' Choose the department',
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
                                  checkidd(departmentselectedvalue);
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
                                hintText: ' Choose the semester',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(13),
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
                            SizedBox(
                              height: 4,
                            ),

                            // TextFormField(
                            //     controller: _meetingmethodcontroller,
                            //     decoration: InputDecoration(
                            //         labelText:
                            //             "Enter your metting method(office number or Zoom link )",
                            //         border: OutlineInputBorder()),
                            //     autovalidateMode: AutovalidateMode.onUserInteraction,
                            //     validator: (value) {
                            //       if (value!.isEmpty ||
                            //           _meetingmethodcontroller.text == "") {
                            //         return 'Please enter your metting method';
                            //       } else {
                            //         if (!(english
                            //             .hasMatch(_meetingmethodcontroller.text))) {
                            //           return "only english is allowed";
                            //         }
                            //       }
                            //     }),
                            // DropdownButtonFormField(
                            //   decoration: InputDecoration(
                            //     // suffixIcon: Icon(Icons.edit),
                            //     hintText: "Choose meeting method",
                            //     border: OutlineInputBorder(),
                            //   ),
                            //   items: const [
                            //     DropdownMenuItem(
                            //         child: Text("In person metting"),
                            //         value: "inperson"),
                            //     DropdownMenuItem(
                            //         child: Text("Online meeting "), value: "online"),
                            //   ],
                            //   onChanged: (value) {
                            //     setState(() {
                            //       mettingmethoddrop = value;
                            //     });
                            //   },
                            //   autovalidateMode: AutovalidateMode.onUserInteraction,
                            //   validator: (value) {
                            //     if (value == null || mettingmethoddrop == null) {
                            //       return 'Please Choose meeting method';
                            //     }
                            //   },
                            // ),

                            // if (mettingmethoddrop != null &&
                            //     mettingmethoddrop == "inperson")
                            //   TextFormField(
                            //       controller: _meetingmethodcontroller,
                            //       decoration: InputDecoration(
                            //           labelText: 'Office number',
                            //           hintText: "Enter your office number",
                            //           // suffixIcon: Icon(Icons.edit),
                            //           border: OutlineInputBorder()),
                            //       autovalidateMode: AutovalidateMode.onUserInteraction,
                            //       validator: (value) {
                            //         if (value!.isEmpty ||
                            //             _meetingmethodcontroller.text == "") {
                            //           return 'Please enter your office number';
                            //         } else {
                            //           if (!(english
                            //               .hasMatch(_meetingmethodcontroller.text))) {
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
                            //           // suffixIcon: Icon(Icons.edit),
                            //           border: OutlineInputBorder()),
                            //       autovalidateMode: AutovalidateMode.onUserInteraction,
                            //       validator: (value) {
                            //         if (value!.isEmpty ||
                            //             _meetingmethodcontroller.text == "") {
                            //           return 'Please enter your meeting link';
                            //         } else {
                            //           if (!(english
                            //               .hasMatch(_meetingmethodcontroller.text))) {
                            //             return "only english is allowed";
                            //           }
                            //         }
                            //       }),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Specialty:",
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
                                  // labelText: "select your speciality",
                                  hintText: "Select the specialty :",
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
                                          : Colors.blueAccent,
                                    ),
                                    borderRadius: BorderRadius.circular(13),
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
                                    checklengthforspeciality =
                                        selectedoptionlist.value.length;
                                    isshow = selectedoption.value.isEmpty;
                                    print(
                                        "////////////////during//////////////////");
                                    print(selectedoptionlist.value.length);
                                    print(checklengthforspeciality);
                                    print(isshow);
                                    if (checklengthforspeciality < 1) {
                                      isshow = true;
                                    }
                                    if (checklengthforspeciality > 0 ||
                                        selectedoption.value.isEmpty ||
                                        selectedoption.value == null) {
                                      isshow = false;
                                    }
                                  });
                                });
                                checkidspecialty(selectedoptionlist.value);
                                //isshow = selectedoptionlist.value.isEmpty;
                                checklengthforspeciality =
                                    selectedoptionlist.value.length;
                                if (checklengthforspeciality < 1) {
                                  isshow = true;
                                }
                                print(
                                    "///////////////////////////////////////////////////");
                                print(checklengthforspeciality);
                                print(isshow);
                              },
                              selectedValues: selectedoptionlist.value,
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 7),
                              child: Visibility(
                                visible: isshow,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Please choose your specialty",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 211, 56, 45),
                                            fontSize: 12),
                                        textAlign: TextAlign.left,
                                      ),
                                    ]),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(
                                      fontFamily: 'main', fontSize: 16),
                                  // shadowColor: Colors.blue[900],
                                  elevation: 0,
                                  backgroundColor: Mycolors.mainShadedColorBlue,
                                  minimumSize: Size(150, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(17), // <-- Radius
                                  ),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    fname = _fnameController.text;
                                    lname = _lnameController.text;
                                    email = _emailController.text;
                                    password = _passwordController.text;
                                    // meetingmethod = mettingmethoddrop;
                                    // mettingmethodinfo =
                                    //     _meetingmethodcontroller.text;

                                    if (checklengthforspeciality < 1) {
                                      isshow = true;
                                      checklengthforspeciality = 0;
                                    }
                                    if (checklengthforspeciality > 0) {
                                      isshow = false;
                                    }
                                  });

                                  try {
                                    if (formkey.currentState!.validate() &&
                                        checklengthforspeciality > 0) {
                                      await FirebaseAuth.instance
                                          .createUserWithEmailAndPassword(
                                              email: email, password: password)
                                          .then((value) async {
                                        final FirebaseAuth auth =
                                            FirebaseAuth.instance;
                                        final User? user = auth.currentUser;
                                        final Uid = user!.uid;
                                        Navigator.pushNamed(
                                            context, 'verfication');
                                        addfacultyRefonspeciality(spName, Uid);
                                        addfacultyinsemester(speciality, Uid);
                                        await FirebaseFirestore.instance
                                            .collection('faculty')
                                            .doc(Uid)
                                            .set({
                                          'firstname': fname,
                                          'lastname': lname,
                                          'ksuemail': email,
                                          'meetingmethod': meetingmethod,
                                          'mettingmethodinfo':
                                              mettingmethodinfo,
                                          'department':
                                              FirebaseFirestore.instance
                                                  // .collection("collage")
                                                  // .doc(docsforcollage)
                                                  .collection("department")
                                                  .doc(docfordepatment),
                                          // 'collage': FirebaseFirestore.instance
                                          //     .collection("collage")
                                          //     .doc(docsforcollage),
                                          'semester': FirebaseFirestore.instance
                                              .collection("semester")
                                              .doc(docsforsemestername),
                                          'specialty': speciality,
                                        });
                                      });
                                    }
                                  } on FirebaseAuthException catch (error) {
                                    print(error.message);
                                    if (error.message ==
                                        "The email address is badly formatted.") {
                                      //error message
                                      showInSnackBar(
                                          context, "check the email format",
                                          onError: true);
                                    }

                                    if (error.message ==
                                        "The email address is already in use by another account.") {
                                      showInSnackBar(context,
                                          "The email address is already in use by another user",
                                          onError: true);
                                    }
                                  }
                                },
                                child: Text('Sign up'),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 40),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Already have an account ? ",
                                    style: TextStyle(
                                        color: Mycolors.mainColorBlack,
                                        fontFamily: 'main',
                                        fontSize: 14),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context, "login");
                                      },
                                      child: Text(
                                        " Log in",
                                        style: TextStyle(
                                            color: Mycolors.mainColorBlack,
                                            fontFamily: 'bold',
                                            fontSize: 14),
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
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
                      // Text(
                      //   "Oh snap!",
                      //   style: TextStyle(
                      //     color: Colors.white,
                      //     fontSize: 12,
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12, left: 0),
                        child: Text(
                          msg,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
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

  addfacultyinsemester(List spe, var fid) async {
    var ref = FirebaseFirestore.instance.collection("faculty").doc(fid);
    print(ref);

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
}
