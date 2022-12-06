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
  List<String> collage = [];
  List<String> department = [];
  List speciality = [];
  late String docsforsemestername;
  late String docsforcollage;
  late String docfordepatment;
  var departmentselectedvalue;
  var collageselectedvalue;
  var semesterselectedvalue;
  var year;
  late String semstername;
  Rx<List<String>> selectedoptionlist = Rx<List<String>>([]);
  var selectedoption = "".obs;
  void initState() {
    retrivespecilty();
    retrievesemester();
    retrivecollage();
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
    try {
      await FirebaseFirestore.instance
          .collection('semester')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          setState(() {
            DateTime now = DateTime.now();
            year = now.year;
            String s = year.toString();
            String sn = element['semestername'];
            if ((sn.contains(s))) {
              semester.add(element['semestername']);
            }
            ;
          });
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

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

  Future checkidc(String? collagename) async {
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

  Future checkidd(String? departmentename) async {
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

  checkidspecialty(List<String?> specialityoption) async {
    speciality.length = 0;
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
                speciality.add(ref);
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

  //to get user input
  var fname = '';
  var lname = '';
  var email = '';
  var password = '';
  var meetingmethod = '';
  var dep = '';
  var spec = '';
  var userid = "";

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
                        } else {
                          if (!(english.hasMatch(_fnameController.text))) {
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
                        hintText: "Enter your last name",
                        border: OutlineInputBorder()),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty || _lnameController.text == "") {
                        return 'Please enter your last name ';
                      } else {
                        if (nameRegExp.hasMatch(_lnameController.text)) {
                          return 'Please last name only letters accepted ';
                        } else {
                          if (!(english.hasMatch(_lnameController.text))) {
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
                    decoration: InputDecoration(
                        hintText: "Enter your KSU email",
                        labelText: 'KSU Email',
                        border: OutlineInputBorder()),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty || _emailController.text == "") {
                        return 'Please enter your KSU email ';
                      } else {
                        if (!(ksuEmailRegEx.hasMatch(_emailController.text))) {
                          return 'Please write email format correctly, example@ksu.edu.sa ';
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
                          if (!(english.hasMatch(_passwordController.text))) {
                            return "only english is allowed";
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
                        }
                      }),
                  SizedBox(
                    height: 8,
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: 'choose your collage',
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
                        checkidc(collageselectedvalue);
                      });
                    },
                    value: collageselectedvalue,
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
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: 'choose your department',
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
                        checkidd(departmentselectedvalue);
                      });
                    },
                    value: departmentselectedvalue,
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
                        checkids(semesterselectedvalue);
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
                        } else {
                          if (!(english.hasMatch(_passwordController.text))) {
                            return "only english is allowed";
                          }
                        }
                      }),
                  SizedBox(
                    height: 8,
                  ),
                  DropDownMultiSelect(
                    decoration: InputDecoration(
                        labelText: "select your speciality",
                        border: OutlineInputBorder()),
                    options: options,
                    whenEmpty: "",
                    onChanged: (value) {
                      setState(() {
                        selectedoptionlist.value = value;
                        selectedoption.value = "";
                        selectedoptionlist.value.forEach((element) {
                          selectedoption.value =
                              selectedoption.value + " " + element;
                        });
                      });
                      checkidspecialty(selectedoptionlist.value);
                    },
                    selectedValues: selectedoptionlist.value,

                    // validator: ((selectedOptions) {
                    //   if (selectedOptions == "" || selectedOptions == null) {
                    //     return "Please select your speciality";
                    //   }
                    //   return "";
                    // }),
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
                                Navigator.pushNamed(context, 'verfication');
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
                              'specialty': speciality,
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
  }
}
