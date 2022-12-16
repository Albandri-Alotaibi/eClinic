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

class studentviewprofile extends StatefulWidget {
  const studentviewprofile({super.key});

  @override
  State<studentviewprofile> createState() => _studentviewprofileState();
}

class _studentviewprofileState extends State<studentviewprofile> {
  final formkey = GlobalKey<FormState>();
  var collageselectedvalue;
  var departmentselectedvalue;
  var _fnameController = TextEditingController();
  var _lnamecontroller = TextEditingController();
  var _idController = TextEditingController();
  var _emailController = TextEditingController();
  var _projectname = TextEditingController();
  var _socialmed = TextEditingController();
  var _socialmediaccount = TextEditingController();
  var _gpcategory = TextEditingController();
  var _graduationdate = TextEditingController();
  var _date = TextEditingController();
  var date;
  var social;
  String? email = '';
  String? userid = '';
  void initState() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    userid = user!.uid;
    email = user.email!;
    // retriveAllspecilty();
    // retrivesuserinfo();
    // retrievesemester();
    // retrivecollage();
    // retrivedepartment();
    // retrivecolldepsem();
    // isshow = false;
    super.initState();
  }

  final double coverheight = 280;
  final double profileheight = 144;
  final double top = 136 / 2; //coverheight - profileheight/2;
  RegExp nameRegExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
  RegExp idRegEx = RegExp(r'^[0-9]+$');
  RegExp countRegEx = RegExp(r'^\d{9}$');
  RegExp countRegEx10 = RegExp(r'^\d{10}$');
  RegExp english = RegExp("^[\u0000-\u007F]+\$");
  @override
  Widget build(BuildContext context) {
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
                      .collection('student')
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
                      final projectname = cuser['projectname'];
                      final studentid = cuser['studentId'];
                      final so = cuser[' socialmedia'];
                      final soaccount = cuser[' socialmediaaccount'];
                      Timestamp gd = cuser["graduationDate"];
                      // final gdtostring =
                      // DateFormat('dd-MM-yyyy').format(gd).toString();
                      print("//////////////////////////////////////////");
                      print(gd);
                      // print(gdtostring);
                      _fnameController = TextEditingController(text: fname);
                      _lnamecontroller = TextEditingController(text: lname);
                      _emailController = TextEditingController(text: ksuemail);
                      _idController = TextEditingController(text: studentid);
                      _projectname = TextEditingController(text: projectname);
                      _socialmed = TextEditingController(text: so);
                      _socialmediaccount =
                          TextEditingController(text: soaccount);

                      // _date = TextEditingController(text: gdtostring);
                      social = so;
                      // selectedoptionlist.value = specality;
                      // collageselectedvalue = collageselectedfromDB;
                      // departmentselectedvalue = departmentselectedfromDB;
                      // semesterselectedvalue = semesterselectedfromDB;
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
                            controller: _lnamecontroller,
                            decoration: InputDecoration(
                                labelText: 'Last Name',
                                // hintText: "Enter your last name",
                                suffixIcon: Icon(Icons.edit),
                                border: OutlineInputBorder()),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty ||
                                  _lnamecontroller.text == "") {
                                return 'Please enter your last name ';
                              } else {
                                if (nameRegExp
                                    .hasMatch(_lnamecontroller.text)) {
                                  return 'Please last name only letters accepted ';
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
                            readOnly: true,
                            decoration: InputDecoration(
                                // hintText: "Enter your KSU email",
                                labelText: 'KSU Email',
                                border: OutlineInputBorder()),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: _idController,
                            decoration: InputDecoration(
                                labelText: 'Student ID',
                                hintText: "Enter your ID number",
                                suffixIcon: Icon(Icons.edit),
                                border: OutlineInputBorder()),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty || _idController.text == "") {
                                return 'Please enter your ID  ';
                              } else {
                                if (!(idRegEx.hasMatch(_idController.text))) {
                                  return 'Please ID number only number accepted ';
                                } else {
                                  if (!(countRegEx
                                      .hasMatch(_idController.text))) {
                                    return 'Please ID number must be only 9 numbers';
                                  } else {
                                    if (!(english
                                        .hasMatch(_idController.text))) {
                                      return "only english is allowed";
                                    }
                                  }
                                }
                              }
                            },
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                              controller: _projectname,
                              decoration: InputDecoration(
                                  labelText: 'Graduation project name',
                                  hintText:
                                      "Enter your Graduation project name",
                                  suffixIcon: Icon(Icons.edit),
                                  border: OutlineInputBorder()),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty || _projectname.text == "") {
                                  return 'Please enter Graduation project name ';
                                } else {
                                  if (!(english.hasMatch(_projectname.text))) {
                                    return "only english is allowed";
                                  }
                                }
                              }),
                          SizedBox(
                            height: 8,
                          ),
                          DropdownButtonFormField(
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.edit),
                                labelText: "Social media contact",
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(
                                    child: Text("Twitter"), value: "Twitter"),
                                DropdownMenuItem(
                                    child: Text("LinkedIn"), value: "LinkedIn"),
                                DropdownMenuItem(
                                    child: Text("WhatsApp"), value: "WhatsApp")
                              ],
                              value: social,
                              onChanged: (value) {
                                setState(() {
                                  social = value;
                                });
                              }),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                              controller: _socialmediaccount,
                              decoration: InputDecoration(
                                  labelText: 'Account',
                                  hintText: "Enter your account",
                                  border: OutlineInputBorder()),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (!(english
                                    .hasMatch(_socialmediaccount.text))) {
                                  return "only english is allowed";
                                }
                              }),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: _date,
                            decoration: InputDecoration(
                              hintText: 'Enter your graduation date',
                              labelText: "Graduation date",
                              border: OutlineInputBorder(),
                            ),
                            onTap: () async {
                              DateTime? pickerdate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100));
                              if (pickerdate != null) {
                                setState(() {
                                  _date.text = DateFormat('dd-MM-yyyy')
                                      .format(pickerdate);
                                  date = pickerdate;
                                });
                              }
                            },
                            validator: ((value) {
                              if (_date.text == "" || date == null)
                                return 'Please enter your graduation date ';

                              return null;
                            }),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                        ],
                      ); //here
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      //showConfirmationDialog(context);
                    },
                    child: Text("Log out"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // fn = _fnameController.text;
                        // ln = _lnameController.text;
                        // mm = _meetingmethodcontroller.text;

                        // if (zag < 1) {
                        //   isshow = true;
                        // }
                        // if (zag > 0) {
                        //   isshow = false;
                        // }
                      });

                      if (formkey.currentState!.validate()) {
                        try {
                          FirebaseFirestore.instance
                              .collection('faculty')
                              .doc(userid)
                              .update({
                            // "firstname": fn,
                            // "lastname": ln,
                            // "meetingmethod": mm,
                            // 'department': FirebaseFirestore.instance
                            //     .collection("collage")
                            //     .doc(docsforcollage)
                            //     .collection("department")
                            //     .doc(docfordepatment),
                            // 'collage': FirebaseFirestore.instance
                            //     .collection("collage")
                            //     .doc(docsforcollage),
                            // 'semester': FirebaseFirestore.instance
                            //     .collection("semester")
                            //     .doc(docsforsemestername),
                            // "specialty": specalityid,
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
                ],
              )
            ]),
          ), ////here
        ),
      ),
    );
  }

  Widget buildprofileImage() => CircleAvatar(
        radius: profileheight / 2,
        backgroundColor: Colors.grey.shade800,
        backgroundImage: AssetImage('assets/images/woman.png'),
      );
}
