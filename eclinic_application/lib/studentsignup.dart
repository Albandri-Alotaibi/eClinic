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
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'style/Mycolors.dart';

class studentsignup extends StatefulWidget {
  const studentsignup({super.key});

  @override
  State<studentsignup> createState() => _studentsignupState();
}

class _studentsignupState extends State<studentsignup> {
  List<String> options = [];
  List<String> collage = [];
  List<String> department = [];
  List category = [];
  late String docsforcollage;
  late String docfordepatment;
  var departmentselectedvalue;
  var collageselectedvalue;
  var semesterselectedvalue;
  var year;
  var social;
  var fname;
  var lname;
  var email;
  var password;
  var studentid;
  var date;
  var GPdate;
  var GPtitle;
  var socialmedia;
  var account;
  var phonenumber;
  var socialmediaaccount;
  var zag = 0;
  bool isshow = false;

  late String semstername;
  Rx<List<String>> selectedoptionlist = Rx<List<String>>([]);
  var selectedoption = "".obs;
  void initState() {
    retrivecollage();
    retrivedepartment();
    retrivegpcategory();
    genrateyear();
    super.initState();
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

  retrivegpcategory() async {
    try {
      await FirebaseFirestore.instance
          .collection('gpcategory')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          setState(() {
            options.add(element['gpcategoryname']);
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

  checkidcategory(List<String?> categoryoption) async {
    category.length = 0;
    // print(specialityoption);
    // print(speciality.length);
    // print(speciality);

    try {
      await FirebaseFirestore.instance
          .collection('gpcategory')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          setState(() {
            for (var i = 0; i < categoryoption.length; i++) {
              if (element['gpcategoryname'] == categoryoption[i]) {
                final ref = FirebaseFirestore.instance
                    .collection("gpcategory")
                    .doc(element.id);
                category.add(ref);
                print(category);
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

  check(String? soc) async {
    if (social == "Twitter" || social == "LinkedIn") {
      socialmediaaccount = account;
    } else {
      if (social == "WhatsApp") {
        socialmediaaccount = phonenumber;
      }
    }
  }

  genrateyear() {
    DateTime now = DateTime.now();
    nowyear = now.year;
    DateTime Dateoftoday = DateTime.now();

    String s = year.toString();
    nextyear = nowyear + 1;
    print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
    // print(nextyear);
    years.add(nowyear.toString());
    years.add(nextyear.toString());
    print(years);
  }

  dategp(String? year, String? month) {
    print(selctedyear);
    print(month);
    var gpdate = selctedyear + "-" + month + "-" + "15" + " " + "00:00:00.000";
    DateTime dt = DateTime.parse(gpdate);
    print(gpdate);
    print(dt);
    return dt;
    //2022-12-20 00:00:00.000
    //2023-09-15 00:00:00.000
  }

  final formkey = GlobalKey<FormState>();
  final _fnameController = TextEditingController();
  final _lnamecontroller = TextEditingController();
  final _idController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _projecttitle = TextEditingController();
  final _socialmedialink1 = TextEditingController();
  final _socialmedialink2 = TextEditingController();
  final _gpcategory = TextEditingController();

  final _date = TextEditingController();
  var month;
  var nowyear;
  var nextyear;
  var selctedyear;
  List<String> years = [];
  RegExp nameRegExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
  RegExp uperRegExp = RegExp(r"(?=.*[A-Z])");
  RegExp numbRegExp = RegExp(r"[0-9]");
  RegExp smallRegExp = RegExp(r"(?=.*[a-z])");
  RegExp ksuStudentEmail = new RegExp(r'4[\d]{8}@student.ksu.edu.sa$',
      multiLine: false, caseSensitive: false);
  RegExp idRegEx = RegExp(r'^[0-9]+$');
  RegExp countRegEx = RegExp(r'^\d{9}$');
  RegExp countRegEx10 = RegExp(r'^\d{10}$');
  RegExp english = RegExp("^[\u0000-\u007F]+\$");
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Mycolors.BackgroundColor,
          body: Container(
              child: SingleChildScrollView(
                  child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 10),
                child: Text(
                  "Create account",
                  style: TextStyle(
                      color: Mycolors.mainColorBlack,
                      fontFamily: 'main',
                      fontSize: 24),
                ),
              ),
              Image.asset(
                "assets/images/eClinicLogo-blue1.png",
                width: 300,
                height: 200,
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Form(
                      key: formkey,
                      child: Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              controller: _fnameController,
                              decoration: InputDecoration(
                                  labelText: ' First Name :',
                                  hintText: "Enter your first name",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
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
                            TextFormField(
                              controller: _lnamecontroller,
                              decoration: InputDecoration(
                                  labelText: ' Last Name :',
                                  hintText: "Enter your last name",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                        width: 0,
                                      ))),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty ||
                                    _lnamecontroller.text == "") {
                                  return 'Please enter your full name ';
                                } else {
                                  if (nameRegExp
                                      .hasMatch(_lnamecontroller.text)) {
                                    return 'Please full name only letters accepted ';
                                  } else {
                                    if (!(english
                                        .hasMatch(_lnamecontroller.text))) {
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
                                  labelText: ' KSU Email :',
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
                                  if (!(ksuStudentEmail
                                      .hasMatch(_emailController.text))) {
                                    return 'Please write email format correctly,ID@student.ksu.edu.sa ';
                                  } else {
                                    if (!(english
                                        .hasMatch(_emailController.text))) {
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
                                controller: _passwordController,
                                decoration: InputDecoration(
                                    labelText: ' Password :',
                                    hintText: "Enter your Password",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
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
                            // SizedBox(
                            //   height: 8,
                            // ),
                            // TextFormField(
                            //   controller: _idController,
                            //   decoration: InputDecoration(
                            //       labelText: 'Student ID',
                            //       hintText: "Enter your ID number",
                            //       border: OutlineInputBorder()),
                            //   autovalidateMode:
                            //       AutovalidateMode.onUserInteraction,
                            //   validator: (value) {
                            //     if (value!.isEmpty ||
                            //         _idController.text == "") {
                            //       return 'Please enter your ID  ';
                            //     } else {
                            //       if (!(idRegEx.hasMatch(_idController.text))) {
                            //         return 'Please ID number only number accepted ';
                            //       } else {
                            //         if (!(countRegEx
                            //             .hasMatch(_idController.text))) {
                            //           return 'Please ID number must be only 9 numbers';
                            //         } else {
                            //           if (!(english
                            //               .hasMatch(_idController.text))) {
                            //             return "only english is allowed";
                            //           }
                            //         }
                            //       }
                            //     }
                            //   },
                            // ),
                            SizedBox(
                              height: 8,
                            ),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                hintText: ' Choose your collage :',
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
                                  checkidc(collageselectedvalue);
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
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                hintText: ' Choose your department :',
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

                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                hintText: 'Choose month :',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: const BorderSide(
                                      width: 0,
                                    )),
                              ),
                              items: const [
                                DropdownMenuItem(
                                    child: Text("Jan"), value: "01"),
                                DropdownMenuItem(
                                    child: Text("Feb"), value: "02"),
                                DropdownMenuItem(
                                    child: Text("Mar"), value: "03"),
                                DropdownMenuItem(
                                    child: Text("Apr"), value: "04"),
                                DropdownMenuItem(
                                    child: Text("May"), value: "05"),
                                DropdownMenuItem(
                                    child: Text("Jun"), value: "06"),
                                DropdownMenuItem(
                                    child: Text("Jul"), value: "07"),
                                DropdownMenuItem(
                                    child: Text("Aug"), value: "08"),
                                DropdownMenuItem(
                                    child: Text("Sep"), value: "09"),
                                DropdownMenuItem(
                                    child: Text("Oct"), value: "10"),
                                DropdownMenuItem(
                                    child: Text("Nov"), value: "11"),
                                DropdownMenuItem(
                                    child: Text("Dec"), value: "12")
                              ],
                              onChanged: (value) {
                                setState(() {
                                  month = value;
                                  print(month);
                                });
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || month == "") {
                                  return 'Please Choose month';
                                }
                              },
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                hintText: ' Choose year :',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: const BorderSide(
                                      width: 0,
                                    )),
                              ),
                              isExpanded: true,
                              items: years.map((String dropdownitems) {
                                return DropdownMenuItem<String>(
                                  value: dropdownitems,
                                  child: Text(dropdownitems),
                                );
                              }).toList(),
                              onChanged: (String? newselect) {
                                setState(() {
                                  selctedyear = newselect;
                                  print(selctedyear);
                                });
                              },
                              value: selctedyear,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || selctedyear == "") {
                                  return 'Please choose year';
                                }
                              },
                            ),
                            // DropdownButtonFormField(
                            //   decoration: InputDecoration(
                            //     hintText: 'Choose month',
                            //     border: OutlineInputBorder(),
                            //   ),

                            //   items: const [
                            //     DropdownMenuItem(
                            //         child: Text(nowyear), value: nowyear),
                            //     DropdownMenuItem(
                            //         child: Text(nextyear), value: nextyear),
                            //   ],
                            //   onChanged: (value) {
                            //     setState(() {
                            //       year = value;
                            //     });
                            //   },
                            //   autovalidateMode:
                            //       AutovalidateMode.onUserInteraction,
                            //   validator: (value) {
                            //     if (value == null || month == "") {
                            //       return 'Please Choose month';
                            //     }
                            //   },
                            // ),

                            // TextFormField(
                            //   controller: _date,
                            //   readOnly: true,
                            //   decoration: InputDecoration(
                            //     hintText: 'Enter your graduation date',
                            //     labelText: "Graduation date",
                            //     border: OutlineInputBorder(),
                            //   ),
                            //   onTap: () async {
                            //     DateTime? pickerdate = await showDatePicker(
                            //       context: context,
                            //       initialDate: DateTime.now(),
                            //       firstDate: DateTime.now(),
                            //       lastDate: DateTime(2100),
                            //     );

                            //     if (pickerdate != null) {
                            //       setState(() {
                            //         _date.text = DateFormat('dd-MM-yyyy')
                            //             .format(pickerdate);
                            //         date = pickerdate;
                            //         // 2022-12-20 00:00:00.000
                            //         print(date);
                            //       });
                            //     }
                            //   },
                            //   autovalidateMode:
                            //       AutovalidateMode.onUserInteraction,
                            //   validator: ((value) {
                            //     if (_date.text == "" || date == null)
                            //       return 'Please enter your graduation date ';

                            //     return null;
                            //   }),
                            // ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                                controller: _projecttitle,
                                decoration: InputDecoration(
                                    labelText: 'Graduation project name :',
                                    hintText:
                                        "Enter your Graduation project name",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(
                                          width: 0,
                                        ))),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      _projecttitle.text == "") {
                                    return 'Please enter Graduation project name ';
                                  } else {
                                    if (!(english
                                        .hasMatch(_projecttitle.text))) {
                                      return "only english is allowed";
                                    }
                                  }
                                }),
                            SizedBox(
                              height: 8,
                            ),
                            DropDownMultiSelect(
                              decoration: InputDecoration(
                                  hintText:
                                      "Select your graduation project category",
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
                                  )
                                  // border: OutlineInputBorder(
                                  //     borderSide: BorderSide(
                                  //         color: isshow ? Colors.red : Colors.grey)
                                  ),
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
                                });
                                checkidcategory(selectedoptionlist.value);
                                // isshow = selectedoptionlist.value.isEmpty;
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
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 7),
                              child: Visibility(
                                visible: isshow,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Please choose your graduation project category",
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
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                hintText:
                                    'Choose how can other communicate with you',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: const BorderSide(
                                      width: 0,
                                    )),
                              ),
                              items: const [
                                DropdownMenuItem(
                                    child: Text("Twitter"), value: "Twitter"),
                                DropdownMenuItem(
                                    child: Text("LinkedIn"), value: "LinkedIn"),
                                DropdownMenuItem(
                                    child: Text("WhatsApp"), value: "WhatsApp"),
                                DropdownMenuItem(
                                    child: Text("None"), value: "None")
                              ],
                              onChanged: (value) {
                                setState(() {
                                  social = value;
                                });
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || social == null) {
                                  return 'Please Choose how can other communicate with you';
                                }
                              },
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            // if (social != null && social == "WhatsApp")
                            //   TextFormField(
                            //     controller: _socialmedialink1,
                            //     decoration: InputDecoration(
                            //         labelText: 'phone number',
                            //         hintText: "Enter your number",
                            //         border: OutlineInputBorder()),
                            //     autovalidateMode:
                            //         AutovalidateMode.onUserInteraction,
                            //     validator: ((value) {
                            //       if (value!.isEmpty ||
                            //           _socialmedialink1.text == "") {
                            //         return 'Please enter your phone number';
                            //       } else {
                            //         if (!(english
                            //             .hasMatch(_socialmedialink1.text))) {
                            //           return "only english is allowed";
                            //         } else {
                            //           if (!(idRegEx
                            //               .hasMatch(_socialmedialink1.text))) {
                            //             return 'Please only number allowed ';
                            //           } else {
                            //             if (!(countRegEx10.hasMatch(
                            //                 _socialmedialink1.text))) {
                            //               return 'Please number must be only 10 numbers';
                            //             }
                            //           }
                            //         }
                            //       }
                            //     }),
                            //   ),
                            if (social != null && social != "None")
                              TextFormField(
                                  controller: _socialmedialink2,
                                  decoration: InputDecoration(
                                      labelText: 'Link account',
                                      hintText: "Enter your link account",
                                      border: OutlineInputBorder()),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        _socialmedialink2.text == "") {
                                      return 'Please enter your account';
                                    } else {
                                      if (!(english
                                          .hasMatch(_socialmedialink2.text))) {
                                        return "only english is allowed";
                                      }
                                    }
                                  }),
                            SizedBox(
                              height: 12,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                textStyle:
                                    TextStyle(fontFamily: 'main', fontSize: 16),
                                shadowColor: Colors.blue[900],
                                elevation: 16,
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
                                  lname = _lnamecontroller.text;
                                  email = _emailController.text;
                                  password = _passwordController.text;
                                  // studentid = _idController.text;
                                  // var sy = selctedyear;
                                  // var sm = month;
                                  //  GPdate = dategp(sy, sm);
                                  GPtitle = _projecttitle.text;
                                  socialmedia = social;
                                  socialmediaaccount = _socialmedialink2.text;
                                  // phonenumber = _socialmedialink1.text;
                                  if (zag < 1) {
                                    isshow = true;
                                  }
                                  if (zag > 0) {
                                    isshow = false;
                                  }
                                });

                                //check(social);

                                try {
                                  if (formkey.currentState!.validate() &&
                                      zag > 0) {
                                    GPdate = dategp(selctedyear, month);
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                            email: email, password: password)
                                        .then((value) async {
                                      final FirebaseAuth auth =
                                          FirebaseAuth.instance;
                                      final User? user = auth.currentUser;
                                      final Uid = user!.uid;
                                      Navigator.pushNamed(
                                          context, 'studentverfication');

                                      await FirebaseFirestore.instance
                                          .collection('student')
                                          .doc(Uid)
                                          .set({
                                        'firstname': fname,
                                        "lastname": lname,
                                        'ksuemail': email,
                                        // 'studentId': studentid,
                                        'department': FirebaseFirestore.instance
                                            .collection("collage")
                                            .doc(docsforcollage)
                                            .collection("department")
                                            .doc(docfordepatment),
                                        'college': FirebaseFirestore.instance
                                            .collection("collage")
                                            .doc(docsforcollage),
                                        'projectCategory': category,
                                        'projectname': GPtitle,
                                        'graduationDate': GPdate,
                                        'socialmedia': socialmedia,
                                        'socialmediaaccount':
                                            socialmediaaccount,
                                        'uploadgp': false,
                                        'semester': null,
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
                                      backgroundColor:
                                          Color.fromARGB(255, 239, 91, 91),
                                      textColor:
                                          Color.fromARGB(255, 250, 248, 248),
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
                                      backgroundColor:
                                          Color.fromARGB(255, 127, 166, 233),
                                      textColor:
                                          Color.fromARGB(255, 248, 249, 250),
                                      fontSize: 18.0,
                                    );
                                  }
                                }
                              },
                              child: Text('Sign up'),
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
                                        Navigator.pushNamed(
                                            context, "studentlogin");
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
                      ))),
            ],
          )))),
    );
  }
}
