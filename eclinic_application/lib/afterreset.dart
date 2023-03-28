import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myapp/login.dart';
import 'style/Mycolors.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickalert/quickalert.dart';
import 'package:myapp/screeens/resources/snackbar.dart';

class afterreset extends StatefulWidget {
  String value;
  afterreset({super.key, required this.value});

  @override
  State<afterreset> createState() => _afterresetState();
}

class _afterresetState extends State<afterreset> {
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
          title: Text(''),
          titleTextStyle: TextStyle(
            fontFamily: 'bold',
            fontSize: 18,
            color: Mycolors.mainColorBlack,
          ),
        ),
        backgroundColor: Mycolors.BackgroundColor,
        body: SingleChildScrollView(
          child: Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 70,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Reset link has been sent on this email:",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                              color: Mycolors.mainColorBlack,
                              fontFamily: 'bold',
                              fontSize: 17),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.value,
                        style: TextStyle(
                            fontFamily: 'main',
                            fontSize: 16,
                            color: Mycolors.mainColorBlack),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "  Please check your email and click \nin the received link to reset password",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                              color: Mycolors.mainColorGray,
                              fontFamily: 'main',
                              fontSize: 17),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Image(
                        image: AssetImage('assets/images/checkmailbox .png'),
                        width: 180,
                        height: 180,
                      ),
                      SizedBox(
                        height: 80,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          textStyle:
                              TextStyle(fontFamily: 'main', fontSize: 16),
                          //shadowColor: Colors.blue[900],
                          elevation: 0,
                          backgroundColor: Mycolors.mainShadedColorBlue,
                          minimumSize: Size(150, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(17), // <-- Radius
                          ),
                        ),
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance
                                .sendPasswordResetEmail(email: widget.value);
                            // Navigator.pushNamed(context, "login");

                            setState(() {
                              // ifsend = false;
                              // _emailcontrol.text = "";
                            });
                          } on FirebaseAuthException catch (e) {
                            return;
                          }
                          // print(email);
                        },
                        child: Text("Login"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Didn't receive the reset link ? ",
                              style: TextStyle(
                                  color: Mycolors.mainColorBlack,
                                  fontFamily: 'main',
                                  fontSize: 14),
                            ),
                            GestureDetector(
                                onTap: () async {
                                  try {
                                    // await FirebaseAuth.instance
                                    //     .sendPasswordResetEmail(
                                    //         email: widget.value);

                                    setState(() async {
                                      await FirebaseAuth.instance
                                          .sendPasswordResetEmail(
                                              email: widget.value);
                                      showInSnackBar(context,
                                          "Another link has been sent ");
                                    });
                                  } on FirebaseAuthException catch (e) {
                                    return;
                                  }
                                  // print(email);
                                },
                                child: Text(
                                  " Resend",
                                  style: TextStyle(
                                      color: Mycolors.mainColorBlack,
                                      fontFamily: 'bold',
                                      fontSize: 14),
                                )),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
