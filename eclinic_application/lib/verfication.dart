import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myapp/facultyhome.dart';
import 'package:myapp/login.dart';
import 'package:myapp/addHoursFaculty.dart';
import 'dart:async';
import 'style/Mycolors.dart';
import 'package:myapp/screeens/resources/snackbar.dart';

class verfication extends StatefulWidget {
  const verfication({super.key});

  @override
  State<verfication> createState() => _verficationState();
}

class _verficationState extends State<verfication> {
  bool ifnull = true;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? email = '';
  String? userid = '';
  User? user;
  int _selectedIndex = 0;
  @override
  void initState() {
    user = auth.currentUser;

    userid = user?.uid;
    email = user?.email;
    user?.sendEmailVerification();

    super.initState();
  }

  Future<bool> currentuseremailverified() async {
    user = auth.currentUser;
    await user!.reload();
    print(user);
    if (user != null && user!.emailVerified) {
      print("0000000000000000000000000000000000");

      user!.reload().then((_) => user == FirebaseAuth.instance.currentUser);
    }

    return user?.emailVerified ?? false;
  }

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
            fontFamily: 'main',
            fontSize: 24,
            color: Mycolors.mainColorBlack,
          ),
          leading: BackButton(
            onPressed: () {
              Navigator.pushNamed(context, 'login');
            },
          ),
        ),
        backgroundColor: Mycolors.BackgroundColor,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 70,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Verification link has been sent on this email:",
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
                  height: 20,
                ),
                Text(
                  " ${email}",
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
                    "  Please check your email and click in \nthe received link to verify your account",
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
                  height: 10,
                ),
                // Align(
                //   alignment: Alignment.center,
                //   child: Text(
                //     "  Please check your email and click \nin the received link to verify your account",
                //     style: TextStyle(
                //         fontWeight: FontWeight.w500,
                //         overflow: TextOverflow.ellipsis,
                //         color: Mycolors.mainColorGray,
                //         fontFamily: 'main',
                //         fontSize: 17),
                //     textAlign: TextAlign.start,
                //   ),
                // ),
                SizedBox(
                  height: 70,
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
                  height: 50,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
                    //shadowColor: Colors.blue[900],
                    elevation: 0,
                    backgroundColor: Mycolors.mainShadedColorBlue,
                    minimumSize: Size(150, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17), // <-- Radius
                    ),
                  ),
                  onPressed: () async {
                    print(user);
                    print(await currentuseremailverified());
                    user = auth.currentUser;
                    if (await currentuseremailverified()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => facultyhome(_selectedIndex),
                        ),
                      );
                    } else {
                      // ignore: use_build_context_synchronously
                      showInSnackBar(context,
                          "Please check your email to verify your account",
                          onError: true);
                    }

                    // checkemailverfication();
                  },
                  child: Text("Done "),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't receive the verification link ? ",
                        style: TextStyle(
                            color: Mycolors.mainColorBlack,
                            fontFamily: 'main',
                            fontSize: 14),
                      ),
                      GestureDetector(
                          onTap: () async {
                            try {
                              /////// message resend succecflly
                              ///
                              user!.sendEmailVerification();
                              showInSnackBar(
                                  context, "Another link has been sent ");
                            } on FirebaseAuthException catch (e) {
                              return;
                            }
                            print(email);
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
            ),
          ),
        ),
      ),
    );
  }
}
