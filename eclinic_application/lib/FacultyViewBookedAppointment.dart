import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_time_range_picker/simple_time_range_picker.dart';
import 'model/Appointment.dart';
import 'model/checkbox_state.dart';
import 'model/startEnd.dart';
import 'package:jiffy/jiffy.dart';
import 'package:intl/intl.dart';
import 'model/timesWithDates.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/login.dart';

class FacultyViewBookedAppointment extends StatefulWidget {


  const FacultyViewBookedAppointment({super.key});

  @override
  State<FacultyViewBookedAppointment> createState() => _sState();
}



class _sState extends State<FacultyViewBookedAppointment> {
 String? email = '';
  String? userid = '';
  List<Appointment> BookedAppointments = [];//availableHours
  bool? isExists;
int numOfDaysOfHelp = 0;
// var studentsArrayOfRef;
// List students=[];
// String projectname="";


// @override
//   void initState() {
//     super.initState();
//   BookedAppointmentsExists(); // use a helper method because initState() cannot be async
//   getBookedappointments();
//   }


void initState() {
super. initState();
//WidgetsBinding. instance. addPostFrameCallback((_) => getBookedappointments(context));
BookedAppointmentsExists();
getBookedappointments();
}




    Future<bool?> BookedAppointmentsExists() async {
    final FirebaseAuth auth = await FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    userid = user!.uid;
    email = user.email!;
   

  final snap = await FirebaseFirestore.instance
        .collection("faculty")
        .doc(userid)
        .collection('appointment')
        .where("Booked", isEqualTo: true).get();

    if (snap.size == 0) {
      print("*******&&&&&&&&&&&&&&&&&&&^^^^^^^^^^^^^^^^^^");
      print("No Booked Appoinyments");
      setState(() {
        isExists = false;
      });

      return isExists;
    } else {
      print("*******&&&&&&&&&&&&&&&&&&&^^^^^^^^^^^^^^^^^^");
      print("Booked Appoinyments Exist");
      setState(() {
        isExists = true;
      });

      return isExists;
    }
  }//end function








Future getBookedappointments() async {//BuildContext context
 // BookedAppointments.clear();
  // numOfDaysOfHelp = 0;
  //await Future.delayed(Duration(seconds: 5));

    final FirebaseAuth auth = await FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    userid = user!.uid;
    email = user.email!;

     // print("yes");

   final snap = await FirebaseFirestore.instance
        .collection("faculty")
        .doc(userid)
        .collection('appointment')
        .where("Booked", isEqualTo: true)
        //.orderBy('starttime')
        .snapshots().listen((event) {
         numOfDaysOfHelp = event.size;
          print("######################################");
           print(event.size);
          event.docs.forEach((element) async {
       //students.clear(); 
        var studentsArrayOfRef;
        List students=[];
        students.clear(); 
        String projectname="";
       Timestamp t1= element['starttime'] as Timestamp;
       DateTime StartTimeDate=t1.toDate();
       
       Timestamp t2= element['endtime'] as Timestamp;
       DateTime EndTimeDate=t2.toDate();

       studentsArrayOfRef=element['students'];
      print("**********************************************");
      print("777777777777777777777777777777777777777777777777777");
       print(studentsArrayOfRef);
       print("8888888888888888888888888888888888888888888888888888");
       print(studentsArrayOfRef.length);
      int len =studentsArrayOfRef.length;
      //DocumentSnapshot docRef2 = await studentsArrayOfRef[0].get();
      
      for (var i = 0; i < studentsArrayOfRef.length; i++) {
      final DocumentSnapshot docRef2 = await studentsArrayOfRef[i].get(); //await
     print(docRef2['Name']);
     students.add(docRef2['Name']);
      print(students);
     projectname=docRef2['ProjectName'];
      }

       setState(() {
        BookedAppointments.add(new Appointment(id: element.id, Day: element['Day'], startTime: StartTimeDate, endTime: EndTimeDate,projectName:projectname, students:  students));
        });
        
    
           });

        });
         
         
         
    //      .get()
    //     .then((QuerySnapshot snapshot) {
          
    //   // print("############################################");
    //    //print(snapshot.size);
      
    //  numOfDaysOfHelp = snapshot.size;

    //   snapshot.docs.forEach((DocumentSnapshot doc) async {
    //    //if(doc['Booked']==true){
        
    //     // numOfDaysOfHelp=numOfDaysOfHelp+1; 
      
    //    Timestamp t1= doc['starttime'] as Timestamp;
    //    DateTime StartTimeDate=t1.toDate();
       
    //    Timestamp t2= doc['endtime'] as Timestamp;
    //    DateTime EndTimeDate=t2.toDate();

    //    studentsArrayOfRef=doc['students'];
    //   print("######################################");
    //    print(studentsArrayOfRef);
    //    print(studentsArrayOfRef.length);
    //   int len =studentsArrayOfRef.length;

    //   for (var i = 0; i < len; i++) {
    // final DocumentSnapshot docRef2 = await studentsArrayOfRef[i].get();
    //  print(docRef2['Name']);
    //  students.add(docRef2['Name']);
    //  projectname=docRef2['ProjectName'];
    //   }

    //    setState(() {
    //     BookedAppointments.add(new Appointment(id: doc.id, Day: doc['Day'], startTime: StartTimeDate, endTime: EndTimeDate,projectName:projectname, students:  students));
    //     });
        
    //   // }
    //   });
      
    // });// end then 
    //for()
//     BookedAppointments.startTime.sort((a, b){ //sorting in descending order
//     return b.compareTo(a);
// });


//numOfDaysOfHelp=BookedAppointments.length;
    print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%1");
     print(numOfDaysOfHelp);
     print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%2");
     print(BookedAppointments.length);
     print(BookedAppointments.toString());

  }//end method get









  @override
  Widget build(BuildContext context) {
  //getBookedappointments();

    if (isExists == false ) {//|| numOfDaysOfHelp==0
        return Scaffold(
          appBar: AppBar(
            title: Text('Booked Appointments'),
          ),
          body: Row(
            children: <Widget>[
        Text("No Booked Appointments**")
      ],
      ) 
      );

    }else{//BookedAppointments.isEmpty==false //numOfDaysOfHelp==BookedAppointments.length
     //if(BookedAppointments.length!=0){
    return Scaffold(
          appBar: AppBar(
            title: Text('Booked Appointments'),
          ),
          body: //Row()
          //  FutureBuilder(
          //   future: getBookedappointments(),
          //   builder: (context, snapshot) {
          //     return
               ListView.builder(
                itemCount: numOfDaysOfHelp,
                itemBuilder: ((context, index) {
                  if(index<BookedAppointments.length){
                  return Card(
                      child: 
                      ExpansionTile(
                    title: Text(BookedAppointments[index].Day+",  "+BookedAppointments[index].StringDate() + "  " + BookedAppointments[index].StringTimeRange() ),
                      
                      //BookedAppointments[index].Day),

                    //subtitle: Text("Date : "+ BookedAppointments[index].StringDate()+"\n Time : "+BookedAppointments[index].StringTimeRange()),
                  children: [
                    Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                   // Text("  Date : "+ BookedAppointments[index].StringDate()),
                   // Text("  Time : "+BookedAppointments[index].StringTimeRange()),
                     Text(""),
                    Text("  Project : "+BookedAppointments[index].projectName+"\n"),
                     Text("  Students : "+BookedAppointments[index].StringStudents())     
                          ]),
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                       mainAxisAlignment : MainAxisAlignment.end,
                       verticalDirection : VerticalDirection.up,

                      children: <Widget>[
                   IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () => {CancelAppointment(index)},
                     ),
                      ]
                    )


                  ])
                    
                   ],
                  









                  
                  
                  )
                  );
                
          //       }),
          //     )
          //     ;
          //   },
          // )

          // );
     //}



                }//index smaller than length
                else{
                  return Row();
                }
                })
                )
                );//scaffold

    }//end else there is booked appointments
  //   else{
  // return Scaffold(
  //         appBar: AppBar(
  //           title: Text('Booked Appointments'),
  //         ),
  //         body: Row()
  // );

  //   }


  }



  CancelAppointment(int index) async{//async
// final FirebaseAuth auth = await FirebaseAuth.instance;
//     final User? user = await auth.currentUser;
//     userid = user!.uid;
//     email = user.email!;
    print(index);
          await FirebaseFirestore.instance
          .collection("faculty")
          .doc(userid)
          .collection('appointment')
          .doc(BookedAppointments[index].id) //Is there a specific id i should put for the appointments
          .update({
        'Booked': false, //string if booked then it should have a student refrence
        });

    setState(() {
     dynamic res = BookedAppointments.removeAt(index);
     //numOfDaysOfHelp=numOfDaysOfHelp-1;
    });

  }
}

