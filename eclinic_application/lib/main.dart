import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/deem.dart';
import 'package:myapp/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      },
    );
  }
}

