import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('login'),
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
                    controller: _emailController,
                    decoration: InputDecoration(
                        labelText: 'KSU email',
                        hintText: "Enter your KSU email ",
                        border: OutlineInputBorder()),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty || _emailController.text == "") {
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
                        labelText: 'password',
                        hintText: "Enter your password",
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
                        border: OutlineInputBorder()),
                    obscureText: _obsecuretext,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty || _passwordController.text == "") {
                        return 'Please enter password ';
                      } else {
                        return null;
                      }
                    }),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      email = _emailController.text;
                      password = _passwordController.text;
                    });
                    try {
                      if (formkey.currentState!.validate()) {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: email, password: password);
                        Navigator.pushNamed(context, 'facultyviewprofile')
                            .then((value) async {
                          final FirebaseAuth auth = FirebaseAuth.instance;
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
                          backgroundColor: Color.fromARGB(255, 239, 91, 91),
                          textColor: Color.fromARGB(255, 250, 248, 248),
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
                          backgroundColor: Color.fromARGB(255, 127, 166, 233),
                          textColor: Color.fromARGB(255, 248, 249, 250),
                          fontSize: 18.0,
                        );
                      }
                    }
                  },
                  child: Text('login'),
                ),
                Text("You don't have an account?"),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'facultysignup');
                  },
                  child: Text('Signup'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
