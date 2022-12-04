import 'dart:html';

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

class facultysignup extends StatefulWidget {
  const facultysignup({super.key});

  @override
  State<facultysignup> createState() => _facultysignupState();
}

class _facultysignupState extends State<facultysignup> {
  final formkey = GlobalKey<FormState>();
  List<String> options = [];
  List<String> semester = [];
  late String docsforsemestername;
  Rx<List<String>> selectedoptionlist = Rx<List<String>>([]);
  var selectedoption = "".obs;
  void initState() {
    retrivespecilty();
    retrievesemester();
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
    try {
      await FirebaseFirestore.instance
          .collection('semester')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          setState(() {
            semester.add(element['semestername']);
          });
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future checkid(String? semstername) async {
    try {
      await FirebaseFirestore.instance
          .collection('semester')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          setState(() {
            if (semstername == element['semestername']) {
              docsforsemestername = element.id;
              print(docsforsemestername);
            }
          });
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //to get user input
  var fname = '';
  var lname = '';
  var email = '';
  var password = '';
  var meetingmethod = '';
  var dep = '';
  var spec = '';
  var year = '';
  var collage = '';
  var userid = "";

  late String? departmentselectedvalue;
  late String? collageselectedvalue;
  late String? semesterselectedvalue;
  late String semstername;

  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _meetingmethodcontroller = TextEditingController();
  static final RegExp nameRegExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
  static final RegExp emailRegExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  RegExp uperRegExp = RegExp(r"(?=.*[A-Z])");
  RegExp numbRegExp = RegExp(r"[0-9]");
  RegExp smallRegExp = RegExp(r"(?=.*[a-z])");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('signup'),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _fnameController,
                    decoration: InputDecoration(
                        labelText: 'Frist Name',
                        hintText: "Enter your first name",
                        border: OutlineInputBorder()),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty || _fnameController.text == "") {
                        return 'Please enter your frist name ';
                      } else {
                        if (nameRegExp.hasMatch(_fnameController.text)) {
                          return 'Please frist name only letters accepted ';
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
                        hintText: "Enter your last name",
                        border: OutlineInputBorder()),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty || _lnameController.text == "") {
                        return 'Please enter your last name ';
                      } else {
                        if (nameRegExp.hasMatch(_lnameController.text)) {
                          return 'Please last name only letters accepted ';
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        hintText: "Enter your KSU email",
                        labelText: 'KSU Email',
                        border: OutlineInputBorder()),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty || _emailController.text == "") {
                        return 'Please enter your KSU email ';
                      } else {
                        if (!(emailRegExp.hasMatch(_emailController.text))) {
                          return 'Please write email format correctly ';
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: "Enter your Password",
                          border: OutlineInputBorder()),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty || _passwordController.text == "") {
                          return 'Please enter your password';
                        } else {
                          if (value.length < 8 &&
                              !uperRegExp.hasMatch(value) &&
                              !numbRegExp.hasMatch(value) &&
                              !smallRegExp.hasMatch(value)) {
                            return "Your password must be at least 8 characters and contain both uppercase and lowercase letters";
                          } else if (value.length < 8 &&
                              !uperRegExp.hasMatch(value)) {
                            return "Your password must be at least 8 characters and contain uppercase letters";
                          } else if (value.length < 8 &&
                              !smallRegExp.hasMatch(value)) {
                            return "Your password must be at least 8 characters and contain lowercase letters";
                          } else if (!uperRegExp.hasMatch(value) &&
                              !smallRegExp.hasMatch(value)) {
                            return "Your password must be contain both uppercase and lowercase letters";
                          } else if (value.length < 8) {
                            return "Your password must be at least 8 characters";
                          } else if (!uperRegExp.hasMatch(value)) {
                            return "Your password must be contain uppercase letters";
                          } else if (!smallRegExp.hasMatch(value)) {
                            return "Your password must be contain lowercase letters";
                          } else if (!numbRegExp.hasMatch(value)) {
                            return "Your password must be contain number";
                          }
                        }
                      }),
                  SizedBox(
                    height: 8,
                  ),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      // labelText: "Department",
                      hintText: 'choose your department',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem<String>(child: Text('IT'), value: 'IT'),
                      DropdownMenuItem<String>(child: Text('CS'), value: 'CS'),
                      DropdownMenuItem<String>(child: Text('SE'), value: 'SE'),
                      DropdownMenuItem<String>(child: Text('IS'), value: 'IS')
                    ],
                    onChanged: (value) {
                      setState(() {
                        departmentselectedvalue = value;
                      });
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      // labelText: "collage",
                      hintText: 'choose your collage',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem<String>(
                          child: Text('CCIS'), value: 'CCIS'),
                    ],
                    onChanged: (value) {
                      setState(() {
                        collageselectedvalue = value;
                      });
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  //
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: 'choose a semester',
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
                        checkid(semesterselectedvalue);
                      });
                    },
                    value: semesterselectedvalue,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          labelText:
                              "Enter your metting method(office number or Zoom link )",
                          border: OutlineInputBorder()),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty ||
                            _meetingmethodcontroller.text == "") {
                          return 'Please enter your metting method';
                        }
                      }),
                  SizedBox(
                    height: 8,
                  ),

                  DropDownMultiSelect(
                    decoration: InputDecoration(
                        labelText: " select your speciality",
                        border: OutlineInputBorder()),
                    options: options,
                    whenEmpty: "",
                    onChanged: (value) {
                      selectedoptionlist.value = value;
                      selectedoption.value = "";
                      selectedoptionlist.value.forEach((element) {
                        selectedoption.value =
                            selectedoption.value + " " + element;
                        ////////////////not work
                        (value) {
                          if (value == null ||
                              selectedoptionlist.value.isEmpty ||
                              selectedoptionlist.value == null) {
                            return 'please enter your speciality';
                          }
                        };
                      });
                    },
                    selectedValues: selectedoptionlist.value,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        fname = _fnameController.text;
                        lname = _lnameController.text;
                        email = _emailController.text;
                        password = _passwordController.text;
                        meetingmethod = _meetingmethodcontroller.text;
                      });

                      try {
                        if (formkey.currentState!.validate()) {
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: email, password: password)
                              .then((value) async {
                            final FirebaseAuth auth = FirebaseAuth.instance;
                            final User? user = auth.currentUser;
                            final Uid = user!.uid;

                            try {
                              if (!(user.emailVerified)) {
                                user.sendEmailVerification();
                              }
                            } catch (error) {
                              print(error);
                            }

                            await FirebaseFirestore.instance
                                .collection('faculty')
                                .doc(Uid)
                                .set({
                              'firstname': fname,
                              'lastname': lname,
                              'ksuemail': email,
                              'meetingmethod': meetingmethod,
                              'department': departmentselectedvalue,
                              'collage': collageselectedvalue,
                              'semester': docsforsemestername,
                              'specialty': selectedoptionlist.value,
                            });
                          });
                        }
                      } on FirebaseAuthException catch (error) {
                        print(error.message);
                        if (error.message ==
                            "The email address is badly formatted.") {
                          Fluttertoast.showToast(
                            msg: "check the email format",
                            gravity: ToastGravity.TOP,
                            toastLength: Toast.LENGTH_SHORT,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Color.fromARGB(255, 239, 91, 91),
                            textColor: Color.fromARGB(255, 250, 248, 248),
                            fontSize: 18.0,
                          );
                        }

                        if (error.message ==
                            "The email address is already in use by another account.") {
                          Fluttertoast.showToast(
                            msg:
                                "The email address is already in use by another account",
                            gravity: ToastGravity.TOP,
                            toastLength: Toast.LENGTH_SHORT,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Color.fromARGB(255, 127, 166, 233),
                            textColor: Color.fromARGB(255, 248, 249, 250),
                            fontSize: 18.0,
                          );
                        }
                      }
                    },
                    child: Text('Signup'),
                  ),
                ],
              ),
            ),
          ),
        ));
    // void verfityemail() {
    //   final FirebaseAuth auth = FirebaseAuth.instance;
    //   final User? user = auth.currentUser;
    //   if (!(user!.emailVerified)) {
    //     user.sendEmailVerification();
    //   }
    // }
  }
}
