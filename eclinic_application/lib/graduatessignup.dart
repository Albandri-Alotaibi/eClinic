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
import 'package:myapp/graduatelogin.dart';

class graduatessignup extends StatefulWidget {
  const graduatessignup({super.key});

  @override
  State<graduatessignup> createState() => _graduatessignupState();
}

class _graduatessignupState extends State<graduatessignup> {
  var fname = '';
  var lname = '';
  var email = '';
  var password = '';
  var meetingmethod;
  var mettingmethodinfo;
  var dep = '';
  var spec = '';
  var userid = "";
  var socialmediaaccount;
  var socialmedia;
  var social;
  final formkey = GlobalKey<FormState>();
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _socialmedialink1 = TextEditingController();
  final _socialmedialink2 = TextEditingController();
  static final RegExp nameRegExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
  RegExp uperRegExp = RegExp(r"(?=.*[A-Z])");
  RegExp numbRegExp = RegExp(r"[0-9]");
  RegExp smallRegExp = RegExp(r"(?=.*[a-z])");
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
                              controller: _lnameController,
                              decoration: InputDecoration(
                                  labelText: ' Last Name : ',
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
                              decoration: InputDecoration(
                                  hintText: "Enter your email",
                                  labelText: ' Email :',
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
                                  return 'Please enter your email ';
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
                                      if (!(english
                                          .hasMatch(_socialmedialink2.text))) {
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
                                    socialmedia = social;
                                    socialmediaaccount = _socialmedialink2.text;
                                  });

                                  try {
                                    if (formkey.currentState!.validate()) {
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

                                        await FirebaseFirestore.instance
                                            .collection('graduates')
                                            .doc(Uid)
                                            .set({
                                          'firstname': fname,
                                          'lastname': lname,
                                          'email': email,
                                          'socialmedia': socialmedia,
                                          'socialmediaaccount':
                                              socialmediaaccount,
                                          'uploadgp': false,
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
                                            context, "graduatelogin");
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
