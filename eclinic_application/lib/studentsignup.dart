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
  List gpcategoryname = [];
  List student = [];
  late String docsforcollage;
  String? docfordepatment;
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
  var checklengthforspeciality = 0;
  bool isshow = false;

  late String semstername;
  Rx<List<String>> selectedoptionlist = Rx<List<String>>([]);
  var selectedoption = "".obs;
  void initState() {
    //retrivecollage();
    retrivedepartment();
    //retrivegpcategory();
    genrateyear();
    super.initState();
  }

  // retrivecollage() async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('collage')
  //         .get()
  //         .then((querySnapshot) {
  //       querySnapshot.docs.forEach((element) {
  //         setState(() {
  //           collage.add(element['collagename']);
  //         });
  //       });
  //     });
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  retrivedepartment() async {
    try {
      await FirebaseFirestore.instance
          // .collection('collage')
          // .doc("CCIS")
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

  // retrivegpcategory() async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('gpcategory')
  //         .get()
  //         .then((querySnapshot) {
  //       querySnapshot.docs.forEach((element) {
  //         setState(() {
  //           options.add(element['gpcategoryname']);
  //         });
  //       });
  //     });
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  // Future checkidc(String? collagename) async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('collage')
  //         .get()
  //         .then((querySnapshot) {
  //       querySnapshot.docs.forEach((element) {
  //         setState(() {
  //           if (collagename == element['collagename']) {
  //             docsforcollage = element.id;
  //           }
  //         });
  //       });
  //     });
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

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

  // checkidcategory(List<String?> categoryoption) async {
  //   category.clear();
  //   gpcategoryname.clear();
  //   // print(specialityoption);
  //   // print(speciality.length);
  //   // print(speciality);

  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('gpcategory')
  //         .get()
  //         .then((querySnapshot) {
  //       querySnapshot.docs.forEach((element) {
  //         setState(() {
  //           for (var i = 0; i < categoryoption.length; i++) {
  //             if (element['gpcategoryname'] == categoryoption[i]) {
  //               final ref = FirebaseFirestore.instance
  //                   .collection("gpcategory")
  //                   .doc(element.id);
  //               category.add(ref);
  //               gpcategoryname.add(element['gpcategoryname']);
  //               print(category);
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
    var gpdate = selctedyear + "-" + month + "-" + "15" + " " + "12:00:00.000";
    DateTime dt = DateTime.parse(gpdate);
    print(gpdate);
    print(dt);
    return dt;
    //2022-12-20 00:00:00.000
    //2023-09-15 00:00:00.000
  }

  // addstudentRefongpcategory(List sp, uid) async {
  //   print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
  //   print(sp);
  //   final ref = FirebaseFirestore.instance.collection("student").doc(uid);
  //   student.add(ref);
  //   await FirebaseFirestore.instance
  //       .collection('gpcategory')
  //       .get()
  //       .then((querySnapshot) {
  //     querySnapshot.docs.forEach((element) {
  //       setState(() {
  //         for (var i = 0; i < sp.length; i++) {
  //           if (element['gpcategoryname'] == sp[i]) {
  //             FirebaseFirestore.instance
  //                 .collection('gpcategory')
  //                 .doc(element.id)
  //                 .update({
  //               'student': FieldValue.arrayUnion(student),
  //             });
  //           }
  //         }
  //       });
  //     });
  //   });
  // }

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
  //https://iwtsp.com/966591356970?fbclid=PAAaZvXSh0XdYn3drgv1lQLEIyU_-_pJ6SLCKzopLNfd0bgHTZ8fec3ua6mc4
  //https://api.whatsapp.com/send/?phone=%2B966542806668&text&type=phone_number&app_absent=0
  //wa.me/ above
  //https://mobile.twitter.com/10Deem
  //https://www.linkedin.com/in/asmaa-alqahtani-08a114190

  RegExp whatsappformat = new RegExp(r'https://iwtsp.com/.*',
      multiLine: false, caseSensitive: false);

  RegExp whatsapp2format = new RegExp(r'https://api.whatsapp.com/.*',
      multiLine: false, caseSensitive: false);

  RegExp linkedinformat = new RegExp(r'https://www.linkedin.com/.*',
      multiLine: false, caseSensitive: false);

  RegExp twitterformat = new RegExp(r'https://mobile.twitter.com/.*',
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
            children: [
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
                        child: Expanded(
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
                                      return 'Please write email format correctly,ID@student.ksu.edu.sa';
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
                                          borderRadius:
                                              BorderRadius.circular(25),
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
                                      if (!(english.hasMatch(
                                          _passwordController.text))) {
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
                                        } else if (!uperRegExp
                                                .hasMatch(value) &&
                                            !smallRegExp.hasMatch(value)) {
                                          return " must be contain both uppercase and lowercase letters";
                                        } else if (value.length < 8) {
                                          return " must be at least 8 characters";
                                        } else if (!uperRegExp
                                            .hasMatch(value)) {
                                          return "must be contain uppercase letters";
                                        } else if (!smallRegExp
                                            .hasMatch(value)) {
                                          return "must be contain lowercase letters";
                                        } else if (!numbRegExp
                                            .hasMatch(value)) {
                                          return "must be contain number";
                                        }
                                      }
                                    }
                                  }),
                             
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
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 170, bottom: 4),
                                child: Text(" graduation date : "),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(
                                        hintText: 'Choose month :',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
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
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        hintText: ' Choose year :',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            borderSide: const BorderSide(
                                              width: 0,
                                            )),
                                      ),
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
                                        if (value == null ||
                                            selctedyear == "") {
                                          return 'Please choose year';
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              )

                              ,
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
                                          borderRadius:
                                              BorderRadius.circular(25),
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
                                      child: Text("LinkedIn"),
                                      value: "LinkedIn"),
                                  DropdownMenuItem(
                                      child: Text("WhatsApp"),
                                      value: "WhatsApp"),
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
                            
                          
                              if (social != null && social != "None")
                                TextFormField(
                                    controller: _socialmedialink2,
                                    decoration: InputDecoration(
                                        labelText: 'Link account',
                                        hintText: "Enter your link account",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            borderSide: const BorderSide(
                                              width: 0,
                                            ))),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          _socialmedialink2.text == "") {
                                        return 'Please enter your link account';
                                      } else {
                                        if (!(english.hasMatch(
                                            _socialmedialink2.text))) {
                                          return "only english is allowed";
                                        }
                                        if (social == "WhatsApp") {
                                          if (!(whatsappformat.hasMatch(
                                                  _socialmedialink2.text)) &&
                                              !(whatsapp2format.hasMatch(
                                                  _socialmedialink2.text))) {
                                            return 'Make sure your link account related to selected social media';
                                          }
                                        }
                                        if (social == "LinkedIn") {
                                          if (!(linkedinformat.hasMatch(
                                              _socialmedialink2.text))) {
                                            return 'Make sure your link account related to selected social media';
                                          }
                                        }
                                        if (social == "Twitter") {
                                          if (!(twitterformat.hasMatch(
                                              _socialmedialink2.text))) {
                                            return 'Make sure your link account related to selected social media';
                                          }
                                        }
                                      }
                                    }),
                              SizedBox(
                                height: 12,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(
                                      fontFamily: 'main', fontSize: 16),
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
                                  });

                                  //check(social);

                                  try {
                                    if (formkey.currentState!.validate()) {
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
                                        // addstudentRefongpcategory(
                                        //     gpcategoryname, Uid);
                                        await FirebaseFirestore.instance
                                            .collection('student')
                                            .doc(Uid)
                                            .set({
                                          'firstname': fname,
                                          "lastname": lname,
                                          'ksuemail': email,
                                          // 'studentId': studentid,
                                          'department':
                                              FirebaseFirestore.instance
                                                  // .collection("collage")
                                                  // .doc(docsforcollage)
                                                  .collection("department")
                                                  .doc(docfordepatment),
                                         
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
                                      showerror(
                                          context, "check the email format");
                                    }

                                    if (error.message ==
                                        "The email address is already in use by another account.") {
                                      showerror(context,
                                          "The email address is already in use by another account");
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
                        ),
                      ))),
            ],
          )))),
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
