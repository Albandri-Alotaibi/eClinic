import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'style/Mycolors.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  var email = '';
  var password = '';
  final formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obsecuretext = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Mycolors.BackgroundColor,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Text(
                    "Welcome back",
                    style: TextStyle(
                        color: Mycolors.mainColorBlack,
                        fontFamily: 'main',
                        fontSize: 24),
                  ),
                ),
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
                          TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'KSU email : ',
                                prefixIcon: Icon(Icons.email),
                                hintText: "Enter your KSU email ",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: const BorderSide(
                                      width: 0,
                                    )),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty ||
                                    _emailController.text == "") {
                                  return 'Please enter your KSU email ';
                                } else {
                                  return null;
                                }
                              }),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                  labelText: 'Password:',
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
                                      borderRadius: BorderRadius.circular(25),
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
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: ElevatedButton(
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
                                  email = _emailController.text;
                                  password = _passwordController.text;
                                });
                                try {
                                  if (formkey.currentState!.validate()) {
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                            email: email, password: password);
                                    Navigator.pushNamed(context, 'facultyhome')
                                        .then((value) async {
                                      final FirebaseAuth auth =
                                          FirebaseAuth.instance;
                                      final User? user = auth.currentUser;
                                      final Uid = user!.uid;
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
                                          "The password is invalid or the user does not have a password." ||
                                      error.message ==
                                          "There is no user record corresponding to this identifier. The user may have been deleted.") {
                                    Fluttertoast.showToast(
                                      msg: "invalid email or password ",
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
                                      fontFamily: 'main',
                                      fontSize: 14),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, "facultysignup");
                                    },
                                    child: Text(
                                      " Sign up",
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
        ),
      ),
    );
  }
}
