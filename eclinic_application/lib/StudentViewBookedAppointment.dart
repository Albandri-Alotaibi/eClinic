import 'package:flutter/material.dart';
import 'model/StudentAppointment.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/login.dart';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'style/Mycolors.dart';



import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/facultyhome.dart';
import 'package:simple_time_range_picker/simple_time_range_picker.dart';
import 'model/Appointment.dart';
import 'model/checkbox_state.dart';
import 'model/startEnd.dart';
import 'package:jiffy/jiffy.dart';
import 'package:intl/intl.dart';
import 'model/timesWithDates.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/login.dart';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'style/Mycolors.dart';

class StudentViewBookedAppointment extends StatefulWidget {
  const StudentViewBookedAppointment({super.key});

  @override
  State<StudentViewBookedAppointment> createState() =>
      _StudentViewBookedAppointmentState();
}

class _StudentViewBookedAppointmentState extends State<StudentViewBookedAppointment> {

  String? email = '';
  String? userid = '';
  List<StudentAppointment> BookedAppointments = []; //availableHours
  bool? isExists;
  int numOfDaysOfHelp = 0;



 void initState() {
    super.initState();
    BookedAppointments.clear();
    BookedAppointmentsExists();
  getBookedappointments();
  }

  Future<bool?> BookedAppointmentsExists() async {
    final FirebaseAuth auth = await FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    userid = user!.uid;
    email = user.email!;

    final snap = await FirebaseFirestore.instance
        .collection("student")
        .doc(userid)
        .snapshots()
        .listen((event) {
     
if(event.data()!.containsKey('appointments')== true){
  print("Booked Appoinyments Exist");
//setState(() {
          isExists = false;
    //    });

} else {//or null   --- if (event.data()!.containsKey("name")==false) 
print("No Booked Appoinyments");
  // setState(() {
          isExists = true;
       // });
      }
    });
    return isExists;

  } //end function


 getBookedappointments() async {
    //BuildContext context// Future
    BookedAppointments.clear();
    BookedAppointments.length = 0;
    // numOfDaysOfHelp = 0;
    //await Future.delayed(Duration(seconds: 5));

    final FirebaseAuth auth = await FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    userid = user!.uid;
    email = user.email!;


    final snap = await FirebaseFirestore.instance
        .collection("student")
        .doc(userid)
        .snapshots()
        .listen((event) {
    var appdbarray= event['appointments'];
    print(appdbarray.length);
   // print(appdbarray[0]);
print(appdbarray[0].get());


// final DocumentSnapshot docRef2 =
//                 await studentsArrayOfRef[i].get(); //await


//final Future DocumentSnapshot = appdbarray[0].get();



//print(DocumentSnapshot);

  //final DocumentReference? docRef2 =  appdbarray[0].get();
 // print(docRef2);
//   var time= await docRef2['starttime'];
// print(time);


// for (var i = 0; i < appdbarray.length; i++) {
//             final DocumentSnapshot docRef2 =  await appdbarray[i].get(); //await
        
        
//          Timestamp t1 = docRef2['starttime'] as Timestamp;
//           DateTime StartTimeDate = t1.toDate();

//           Timestamp t2 = docRef2['endtime'] as Timestamp;
//           DateTime EndTimeDate = t2.toDate();
        
// //          var faculty=docRef2.reference.parent.parent!.get().then(
// //   (DocumentSnapshot doc) {
// //     //final data = doc.data() as Map<String, dynamic>;
// //    String fname= doc['firstname'];
// //    print(fname);
// //   },
// // );
         
         


//           }





        }

 );
 
 
 }


















  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

}
  
