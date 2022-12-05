import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class verfication extends StatefulWidget {
  const verfication({super.key});

  @override
  State<verfication> createState() => _verficationState();
}

class _verficationState extends State<verfication> {
  @override
  bool verfiy = false;
  void initState() {
    checkverfication();
    super.initState();
  }

  checkverfication() async {
    final User? user = await FirebaseAuth.instance.currentUser;

    if (user!.emailVerified) {
      verfiy = true;
      print("verfiy");
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
                "We sent a verfication link on your email please verfiy your account"),
            ElevatedButton(
              onPressed: () async {
                checkverfication();
                try {
                  final User? user = await FirebaseAuth.instance.currentUser;
                  checkverfication();
                  if (verfiy) {
                    Navigator.pushNamed(context, 'facultyhome');
                  }
                } catch (error) {
                  print(error);
                }
              },
              child: Text("I verfiy my email"),
            ),
          ],
        ),
      ),
    );
  }
}
