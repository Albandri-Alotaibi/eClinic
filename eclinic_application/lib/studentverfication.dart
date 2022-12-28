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
import 'package:myapp/studenthome.dart';
import 'dart:async';
import 'style/Mycolors.dart';

import 'package:myapp/studentviewprofile.dart';

class studentverfication extends StatefulWidget {
  const studentverfication({super.key});

  @override
  State<studentverfication> createState() => _studentverficationState();
}

class _studentverficationState extends State<studentverfication> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? email = '';
  String? userid = '';
  User? user;
  Timer timer = Timer.periodic(Duration(seconds: 3), (timer) {});
  @override
  void initState() {
    final User? user = auth.currentUser;
    userid = user!.uid;
    email = user.email!;
    user.sendEmailVerification();
    Timer timer = Timer.periodic(Duration(seconds: 1), (timer) {});
    // checkemailverfication();
    super.initState();
  }

  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> checkemailverfication() async {
    user = auth.currentUser;
    await user!.reload();
    if (user!.emailVerified) {
      timer.cancel();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => studenthome()));
    }
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
          title: Text('Verfication'),
          titleTextStyle: TextStyle(
            fontFamily: 'main',
            fontSize: 24,
            color: Mycolors.mainColorBlack,
          ),
        ),
        backgroundColor: Mycolors.BackgroundColor,
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(72.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "A verfication link has been sent to :",
                  style: TextStyle(
                      fontFamily: 'main',
                      fontSize: 16,
                      color: Mycolors.mainColorBlack),
                ),
                Text(
                  " ${email}",
                  style: TextStyle(
                      fontFamily: 'bold',
                      fontSize: 16,
                      color: Mycolors.mainColorBlack),
                ),
                Text(
                  " please verfiy your email ",
                  style: TextStyle(
                      fontFamily: 'main',
                      fontSize: 16,
                      color: Mycolors.mainColorBlack),
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
                    shadowColor: Colors.blue[900],
                    elevation: 16,
                    backgroundColor: Mycolors.mainShadedColorBlue,
                    minimumSize: Size(150, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17), // <-- Radius
                    ),
                  ),
                  onPressed: () {
                    checkemailverfication();
                  },
                  child: Text("I verified my email "),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
