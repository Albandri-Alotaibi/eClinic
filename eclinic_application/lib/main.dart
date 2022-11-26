import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/deem.dart';
import 'package:myapp/facultyhome.dart';
import 'package:myapp/home.dart';
import 'package:myapp/studenthome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'main',
      theme: ThemeData(
        primaryColor: Color(0xFF55C1EF),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => home(),
        'deem': (context) => deem(),
        'facultyhome': (context) => facultyhome(),
        'studenthome': (context) => studenthome(),
        
      },
    );
  }
}
