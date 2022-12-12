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

class facultyviewprofile extends StatefulWidget {
  const facultyviewprofile({super.key});

  @override
  State<facultyviewprofile> createState() => _facultyviewprofileState();
}

class _facultyviewprofileState extends State<facultyviewprofile> {
  List<String> specality = [];
  String? email = '';
  String? userid = '';
  final double coverheight = 280;
  @override
  void initState() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    userid = user!.uid;
    email = user.email!;
    retrivespeciality();
    super.initState();
  }

//  retrivesmester() async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('faculty').doc(userid).collection('semester').doc().get()

//           .then((querySnapshot) {
//         querySnapshot.get("").forEach((element) {
//           setState(() {
//             specality.add(element['semestername']);
//           });
//         });
//       });
//     } catch (e) {
//       print(e.toString());
//       return null;
//     }
//   }
  @override
  Widget build(BuildContext context) {
    body:
    StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return facultyviewprofile();
          } else {
            return login();
          }
        }));

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [],
      ),
    );
  }

  Widget buildCoverImage() => Container(
        color: Colors.grey,
        child: Image.asset(
          "images/profilebackground",
          width: double.infinity,
          height: coverheight,
          fit: BoxFit.cover,
        ),
      );

  retrivespeciality() async {
    final snap = await FirebaseFirestore.instance
        .collection('faculty')
        .doc(userid)
        .get();
    List facultyspecialityRef = snap["specialty"];
    for (var i = 0; i < facultyspecialityRef.length; i++) {
      final DocumentSnapshot docRef = await facultyspecialityRef[i].get();
      specality.add(docRef["specialityname"]);
      print(docRef["specialityname"]);
    }
    var fname = snap["firstname"];
    var lname = snap["lastname"];
    var mettingmethod = snap["meetingmethod"];
    var ksuemail = snap["ksuemail"];
    print(fname);
    print(lname);
    print(mettingmethod);
    print(ksuemail);
    // var semesterRef = snap["semester"];
    // final DocumentSnapshot docRef2 = await semesterRef.get();
    // print(docRef2["specialityname"]);
  }
}
