import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myapp/screeens/resources/snackbar.dart';
import 'style/Mycolors.dart';
import 'package:quickalert/quickalert.dart';
import 'package:myapp/home.dart';
import 'package:myapp/studentresetpassword.dart';
import 'package:myapp/screeens/signUp/studentsignup.dart';
import 'package:myapp/app/constants.dart';
import 'package:myapp/app/shardPreferense.dart';
import 'package:myapp/bloc/select_group/bloc.dart';

class studentlogin extends StatefulWidget {
  const studentlogin({super.key});

  @override
  State<studentlogin> createState() => _studentloginState();
}

class _studentloginState extends State<studentlogin> {
  @override
  var email = '';
  var password = '';
  final formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  RegExp ksuStudentEmail = new RegExp(r'4[\d]{8}@student.ksu.edu.sa$',
      multiLine: false, caseSensitive: false);
  RegExp english = RegExp("^[\u0000-\u007F]+\$");
  bool _obsecuretext = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          primary: false,
          centerTitle: true,
          backgroundColor: Mycolors.mainColorWhite,
          shadowColor: Colors.transparent,
          leading: BackButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => home()));
            },
          ),
          //foregroundColor: Mycolors.mainColorBlack,
          // automaticallyImplyLeading: false,
          iconTheme: IconThemeData(
            color: Color.fromARGB(255, 12, 12, 12), //change your color here
          ),
          title: Text('Welcome back'),

          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Mycolors.mainColorBlack,
          ),
        ),
        backgroundColor: Mycolors.BackgroundColor,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: Image.asset(
                    "assets/images/eClinicLogo-blue1.png",
                    width: 300,
                    height: 250,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Form(
                    key: formkey,
                    child: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              " KSU email:",
                              style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Mycolors.mainColorBlack,
                                  fontFamily: 'bold',
                                  fontSize: 13),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                  hintText: "Enter your KSU email ",
                                  prefixIcon: Icon(Icons.email),
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
                                  return 'Please enter your KSU email ';
                                } else {
                                  if (!(english
                                      .hasMatch(_emailController.text))) {
                                    return "only english is allowed";
                                  }
                                }
                              }),
                          SizedBox(
                            height: 15,
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                " Password:",
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Mycolors.mainColorBlack,
                                    fontFamily: 'bold',
                                    fontSize: 13),
                                textAlign: TextAlign.start,
                              )),
                          TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                  hintText: "Enter your password",
                                  prefixIcon: Icon(Icons.lock),
                                  suffixIcon: GestureDetector(
                                    onTap: (() {
                                      setState(() {
                                        _obsecuretext = !_obsecuretext;
                                      });
                                    }),
                                    child: Icon(_obsecuretext
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(13),
                                      borderSide: const BorderSide(
                                        width: 0,
                                      ))),
                              obscureText: _obsecuretext,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty ||
                                    _passwordController.text == "") {
                                  return 'Please enter password ';
                                } else {
                                  return null;
                                }
                              }),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 230,
                            ),
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, "studentresetpassword");
                                },
                                child: Text(
                                  "Forget password ?",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Mycolors.mainColorGray,
                                      fontSize: 14),
                                )),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                textStyle: TextStyle(fontSize: 16),
                                shadowColor: Colors.blue[900],
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
                                  email = _emailController.text;
                                  password = _passwordController.text;
                                });
                                try {
                                  if (formkey.currentState!.validate()) {
                                    if (!(_emailController.text
                                        .contains("student"))) {
                                      showInSnackBar(
                                          context, "invalid email or password",
                                          onError: true);
                                    } else {
                                      await FirebaseAuth.instance
                                          .signInWithEmailAndPassword(
                                              email: email, password: password)
                                          .then((value) async {
                                        final FirebaseAuth auth =
                                            FirebaseAuth.instance;
                                        final User? user = auth.currentUser;
                                        final Uid = user!.uid;
                                        Navigator.pushNamed(
                                            context, 'studenthome');
                                        // if (user.emailVerified) {
                                        //                           if (TypeUser.type == 'student') {
                                        // TypeUser.type = 'student';
                                        // StorageManager.saveData('TypeUser', 'student');
                                        // Navigator.pushNamedAndRemoveUntil(
                                        //     context, 'studenthome', (route) => false);
                                        // } else {
                                        //   Navigator.pushNamed(
                                        //       context, 'studentverfication');
                                        // }
                                      });
                                    }
                                  }
                                } on FirebaseAuthException catch (error) {
                                  // print(error.message);
                                  // if (error.message ==
                                  //     "The email address is badly formatted.") {
                                  //   showerror(
                                  //       context, "check the email format");
                                  // }

                                  if (error.message ==
                                          "The password is invalid or the user does not have a password." ||
                                      error.message ==
                                          "There is no user record corresponding to this identifier. The user may have been deleted.") {
                                    showInSnackBar(
                                        context, "invalid email or password",
                                        onError: true);
                                  }
                                }
                              },
                              child: Text('Log in'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "You don't have an account ? ",
                                  style: TextStyle(
                                      color: Mycolors.mainColorBlack,
                                      fontSize: 14),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      TypeUser.type = 'student';
                                      StorageManager.saveData(
                                          'TypeUser', 'student');
                                      Navigator.pushNamed(
                                          context, "studentsignup");
                                    },
                                    child: Text(
                                      " Sign up",
                                      style: TextStyle(
                                          color: Mycolors.mainColorBlack,
                                          fontWeight: FontWeight.bold,
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
        ),
      ),
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
