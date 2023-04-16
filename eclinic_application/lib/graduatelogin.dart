import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'style/Mycolors.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myapp/home.dart';
import 'package:myapp/app/constants.dart';
import 'package:myapp/app/shardPreferense.dart';
import 'package:myapp/bloc/select_group/bloc.dart';
import 'package:myapp/screeens/resources/snackbar.dart';

class graduatelogin extends StatefulWidget {
  const graduatelogin({super.key});

  @override
  State<graduatelogin> createState() => _graduateloginState();
}

class _graduateloginState extends State<graduatelogin> {
  bool exist = false;
  checkemail(String email1) async {
    final snap = await FirebaseFirestore.instance
        .collection("graduate")
        .where("email", isEqualTo: email1)
        .get();
    if (snap.size > 0) {
      print("exxiissttteeeeeee");
      exist = true;
    }
  }

  var email = '';
  var password = '';
  final formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
          iconTheme: IconThemeData(
            color: Color.fromARGB(255, 12, 12, 12), //change your color here
          ),
          title: Text('Welcome back'),
          titleTextStyle: TextStyle(
            fontFamily: 'bold',
            fontSize: 24,
            color: Mycolors.mainColorBlack,
          ),
        ),
        backgroundColor: Mycolors.BackgroundColor,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                                " Email:",
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Mycolors.mainColorBlack,
                                    fontFamily: 'bold',
                                    fontSize: 13),
                                textAlign: TextAlign.start,
                              )),
                          TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                hintText: "Enter your email ",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(13),
                                    borderSide: const BorderSide(
                                      width: 0,
                                    )),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty ||
                                    _emailController.text == "") {
                                  return 'Please enter your email ';
                                } else {
                                  if (!(english
                                      .hasMatch(_emailController.text))) {
                                    return "only english is allowed";
                                  }
                                }
                                checkemail(_emailController.text);
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
                                  Navigator.pushNamed(context, "graduatereset");
                                },
                                child: Text(
                                  "Forgot password ?",
                                  style: TextStyle(
                                      color: Mycolors.mainColorGray,
                                      fontFamily: 'bold',
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
                                textStyle:
                                    TextStyle(fontFamily: 'main', fontSize: 16),
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
                                  email = _emailController.text;
                                  password = _passwordController.text;
                                });
                                try {
                                  if (formkey.currentState!.validate()) {
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                            email: email, password: password)
                                        // Navigator.pushNamed(context, 'graduatehome')
                                        .then((value) async {
                                      final FirebaseAuth auth =
                                          FirebaseAuth.instance;
                                      final User? user = auth.currentUser;
                                      final Uid = user!.uid;
                                      if (exist) {
                                        ///////////////verfication code ///////////////////////////////////////////////
                                        if (user.emailVerified) {
                                          TypeUser.type = 'graduate';
                                          // save type user
                                          StorageManager.saveData(
                                              'TypeUser', 'graduate');
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              'graduatehome',
                                              (route) => false);
                                        } else {
                                          if (!(user.emailVerified)) {
                                            Navigator.pushNamed(
                                                context, 'graduateverfication');
                                          }
                                        }
                                      } else {
                                        showInSnackBar(context,
                                            "Invalid email or password",
                                            onError: true);
                                      }
                                    });
                                  }
                                } on FirebaseAuthException catch (error) {
                                  print(error.message);
                                  // if (error.message ==
                                  //     "The email address is badly formatted.") {
                                  //   Fluttertoast.showToast(
                                  //     msg: "check the email format",
                                  //     gravity: ToastGravity.TOP,
                                  //     toastLength: Toast.LENGTH_SHORT,
                                  //     timeInSecForIosWeb: 2,
                                  //     backgroundColor:
                                  //         Color.fromARGB(255, 239, 91, 91),
                                  //     textColor:
                                  //         Color.fromARGB(255, 250, 248, 248),
                                  //     fontSize: 18.0,
                                  //   );
                                  // }

                                  if (error.message ==
                                          "The password is invalid or the user does not have a password." ||
                                      error.message ==
                                          "There is no user record corresponding to this identifier. The user may have been deleted.") {
                                    showInSnackBar(
                                        context, "Invalid email or password",
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
                                      fontFamily: 'main',
                                      fontSize: 14),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      TypeUser.type = 'graduate';
                                      // save type user
                                      StorageManager.saveData(
                                          'TypeUser', 'graduate');

                                      Navigator.pushNamed(
                                          context, "studentsignup");
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
