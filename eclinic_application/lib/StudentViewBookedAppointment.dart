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
          isExists = true;
    //    });

} else {//or null   --- if (event.data()!.containsKey("name")==false) 
print("No Booked Appoinyments");
  // setState(() {
          isExists = false;
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



  final snap =  FirebaseFirestore.instance
        .collection("student")
        .doc(userid)
        .get().then(
  (DocumentSnapshot doc) async{
    // final data = doc.data() as Map<String, dynamic>;
    // // ...
 var appdbarray= doc['appointments'];
 numOfDaysOfHelp = appdbarray.length;
    print(appdbarray.length);
   // print(appdbarray[0]);
//print(appdbarray[0].get());
for (var i = 0; i < appdbarray.length; i++) {
final DocumentSnapshot docRef3 = await appdbarray[i].parent.parent.get();

String facultyName= docRef3['firstname']+ ' '+ docRef3['lastname'];
String meetingMethod=docRef3['meetingmethod'];
String meetingInfo= docRef3['mettingmethodinfo'];

// *******************END FACULTY NEEDED INFO ****************************


  final DocumentSnapshot docRef2 =   await appdbarray[i].get();
  Timestamp t1 = docRef2['starttime'] as Timestamp;
  DateTime StartTimeDate = t1.toDate();
String dayname = DateFormat("EEE").format(
              StartTimeDate);


          Timestamp t2 = docRef2['endtime'] as Timestamp;
          DateTime EndTimeDate = t2.toDate();



 setState(() {
  BookedAppointments.add(new StudentAppointment(appointmentId: docRef2.id,FacultytId:docRef3.id ,Day: dayname, startTime: StartTimeDate,endTime: EndTimeDate, FacultyName: facultyName, meetingMethod: meetingMethod, meetingInfo: meetingInfo)
       );
          });




}








  
  
  
  }
);






//     final snap =  FirebaseFirestore.instance
//         .collection("student")
//         .doc(userid)
//         .snapshots()
//         .listen((event) {
//     var appdbarray= event['appointments'];
//     print(appdbarray.length);
//    // print(appdbarray[0]);
// print(appdbarray[0].get());


//  final DocumentSnapshot docRef2 =   await appdbarray[0].get(); //await


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





//         }

//  );
 
 
 }


















  @override
  Widget build(BuildContext context) {
    //return Scaffold();

    if (isExists == false) {
      //|| numOfDaysOfHelp==0
      return SafeArea(
        child: Scaffold(
            body: Container(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 19),
                child: Text(
                  "Booked Appointments",
                  style: TextStyle(
                      color: Mycolors.mainColorBlack,
                      fontFamily: 'main',
                      fontSize: 24),
                ),
              ),
              Card(
                color: Mycolors.mainShadedColorBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17), // <-- Radius
                ),
                shadowColor: Color.fromARGB(94, 114, 168, 243),
                elevation: 20,
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Text(
                    "No Booked Appointments",
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        color: Mycolors.mainColorWhite,
                        fontFamily: 'main',
                        fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        )),
      );
    } else {
      //BookedAppointments.isEmpty==false //numOfDaysOfHelp==BookedAppointments.length
      //if(BookedAppointments.length!=0){
      return SafeArea(
        child: Scaffold(
            // appBar: AppBar(
            //   title: Text('Booked Appointments'),
            // ),
            body: //Row()
                //  FutureBuilder(
                //   future: getBookedappointments(),
                //   builder: (context, snapshot) {
                //     return
                Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: 350,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30, bottom: 10),
                        child: Text(
                          "Booked Appointments",
                          style: TextStyle(
                              color: Mycolors.mainColorBlack,
                              fontFamily: 'main',
                              fontSize: 24),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount:
                                numOfDaysOfHelp, //BookedAppointments.length,//numOfDaysOfHelp
                            itemBuilder: ((context, index) {
                              if (index < BookedAppointments.length) {
                                return Card(
                                    margin: EdgeInsets.only(bottom: 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          17), // <-- Radius
                                    ),
                                    shadowColor:
                                        Color.fromARGB(94, 250, 250, 250),
                                    elevation: 20,
                                    child: ExpansionTile(
                                      iconColor: Mycolors.mainShadedColorBlue,
                                      collapsedIconColor:
                                          Mycolors.mainShadedColorBlue,
                                      collapsedTextColor:
                                          Mycolors.mainShadedColorBlue,

                                      title: Text(
                                          BookedAppointments[index].Day +
                                              ",  " +
                                              BookedAppointments[index]
                                                  .StringDate() +
                                              "  " +
                                              BookedAppointments[index]
                                                  .StringTimeRange(),
                                          style: TextStyle(
                                              color: Mycolors.mainColorBlue,
                                              fontFamily: 'main',
                                              fontSize: 17)),

                                      //BookedAppointments[index].Day),

                                      //subtitle: Text("Date : "+ BookedAppointments[index].StringDate()+"\n Time : "+BookedAppointments[index].StringTimeRange()),
                                      children: [
                                        Row(children: <Widget>[
                                          Column(children: <Widget>[
                                            // Text("  Date : "+ BookedAppointments[index].StringDate()),
                                            // Text("  Time : "+BookedAppointments[index].StringTimeRange()),
                                            Text(""),
                                            Text(
                                                " With : " +
                                                    BookedAppointments[index]
                                                        .FacultyName +
                                                    "\n",
                                                style: TextStyle(
                                                    color:
                                                        Mycolors.mainColorBlack,
                                                    fontFamily: 'main',
                                                    fontSize: 15)),
                                            Text(
                                                "  Meeting type : " +
                                                    BookedAppointments[index]
                                                        .meetingMethod+
                                                    "\n",
                                                style: TextStyle(
                                                    color:
                                                        Mycolors.mainColorBlack,
                                                    fontFamily: 'main',
                                                    fontSize: 15)),
                                                    Text(
                                                " Info : " +
                                                    BookedAppointments[index]
                                                        .meetingInfo+
                                                    "\n",
                                                style: TextStyle(
                                                    color:
                                                        Mycolors.mainColorBlack,
                                                    fontFamily: 'main',
                                                    fontSize: 15))
                                          ]),
                                          //crossAxisAlignment: CrossAxisAlignment.start,
                                          Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              verticalDirection:
                                                  VerticalDirection.up,
                                              children: <Widget>[
                                                IconButton(
                                                  icon: Icon(Icons.cancel),
                                                  onPressed: () => {
                                                    // showConfirmationDialog(
                                                    //     context, index)
                                                    //CancelAppointment(index)
                                                  },
                                                ),
                                              ])
                                        ])
                                      ],
                                    ));

                                //       }),
                                //     )
                                //     ;
                                //   },
                                // )

                                // );
                                //}

                              } //index smaller than length
                              else {
                                return Row();
                                // return Column(
                                //         children: <Widget>[
                                //         Text("inside else"),
                                //         Text("${BookedAppointments.length}"),
                                //         Text("${numOfDaysOfHelp}"),

                                //         ]);
                              }
                            })),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )),
      ); //scaffold

    } //end els
  }



showConfirmationDialog(BuildContext context, int index) {
    // set up the buttons
    bool deleteappointment = false;
    Widget dontCancelAppButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
        shadowColor: Colors.blue[900],
        elevation: 20,
        backgroundColor: Mycolors.mainShadedColorBlue,
        minimumSize: Size(60, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // <-- Radius
        ),
      ),
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget YesCancelAppButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
        shadowColor: Colors.blue[900],
        elevation: 20,
        backgroundColor: Mycolors.mainShadedColorBlue,
        minimumSize: Size(60, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // <-- Radius
        ),
      ),
      child: Text("Yes"),
      onPressed: () {
        Navigator.of(context).pop();
        CancelAppointment(index);
        //deleteappointment=true;
        // Navigator.pushNamed(context, 'facultyhome');
      },
    );

//   if(deleteappointment == true){
// CancelAppointment(index);
// deleteappointment == false;
//   }

    AlertDialog alert = AlertDialog(
      // title: Text(""),
      content: Text("Are you sure you want to cancel the appointment ?"),
      actions: [
        dontCancelAppButton,
        YesCancelAppButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


   CancelAppointment(int index) async {
  

    String appointmentId = BookedAppointments[index].appointmentId;
    String FacultytId = BookedAppointments[index].FacultytId;
    
    FirebaseFirestore.instance
        .collection("faculty")
        .doc(FacultytId)
        .collection('appointment')
        .doc(appointmentId) 
        .update({
      'Booked': false, 
    });
    

    
  }























}
  
