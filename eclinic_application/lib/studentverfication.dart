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
          MaterialPageRoute(builder: (context) => studentviewprofile()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('verfication'),
      ),
      body: Container(
        child: Column(
          children: [
            Text(
                "A verfication link has been sent to ${email} Please verfiy your account"),
            ElevatedButton(
              onPressed: () {
                checkemailverfication();
              },
              child: Text("I verified my email "),
            ),
          ],
        ),
      ),
    );
  }
}
