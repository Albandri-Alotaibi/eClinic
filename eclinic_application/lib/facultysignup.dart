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
  List<String> options = ["software analysis", "database"];
  Rx<List<String>> selectedoptionlist = Rx<List<String>>([]);
  var selectedoption = "".obs;
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
  // var value = '';
  var userid = "";

  String? departmentselectedvalue = '';
  String? collageselectedvalue = '';
  String? semesterselectedvalue = '';

  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _meetingmethodcontroller = TextEditingController();
  static final RegExp nameRegExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');

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
                    height: 15,
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
                    height: 15,
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
                      } else {}
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: "Enter your Password",
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      // labelText: "Department",
                      hintText: 'choose your department ',
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
                  ),
                  SizedBox(
                    height: 15,
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
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      //labelText: "Semester",
                      hintText: 'choose a semester ',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem<String>(
                          child: Text('1st 2022/2023'), value: '1st 2022/2023'),
                    ],
                    onChanged: (value) {
                      setState(() {
                        semesterselectedvalue = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // TextField(
                  //   controller: _meetingmethodcontroller,
                  //   decoration: InputDecoration(
                  //       // labelText: 'Meetting method',
                  //       labelText:
                  //           "Enter your metting method(office number or Zoom link )",
                  //       border: OutlineInputBorder()),
                  // ),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  DropDownMultiSelect(
                    options: options,
                    whenEmpty: "select your specialty",
                    onChanged: (value) {
                      selectedoptionlist.value = value;
                      selectedoption.value = "";
                      selectedoptionlist.value.forEach((element) {
                        selectedoption.value =
                            selectedoption.value + " " + element;
                      });
                    },
                    selectedValues: selectedoptionlist.value,
                  ),
                  SizedBox(
                    height: 15,
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
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: email, password: password)
                            .then((value) async {
                          final FirebaseAuth auth = FirebaseAuth.instance;
                          final User? user = auth.currentUser;
                          final Uid = user!.uid;
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
                            'semester': semesterselectedvalue,
                            'specialty': selectedoptionlist.value,
                          });
                        });
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
                        // Fluttertoast.showToast(
                        //     msg: erorrmeassage, gravity: ToastGravity.TOP);

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
