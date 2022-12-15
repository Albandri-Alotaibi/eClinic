import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multiselect/multiselect.dart';
import 'package:myapp/login.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class studentviewprofile extends StatefulWidget {
  const studentviewprofile({super.key});

  @override
  State<studentviewprofile> createState() => _studentviewprofileState();
}

class _studentviewprofileState extends State<studentviewprofile> {
  var collageselectedvalue;
  var departmentselectedvalue;
  String? email = '';
  String? userid = '';
  void initState() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    userid = user!.uid;
    email = user.email!;
    // retriveAllspecilty();
    // retrivesuserinfo();
    // retrievesemester();
    // retrivecollage();
    // retrivedepartment();
    // retrivecolldepsem();
    // isshow = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
