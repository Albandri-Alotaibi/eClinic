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

@override
  void initState() {
    super.initState();
  BookedAppointmentsExists(); // use a helper method because initState() cannot be async
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








Future getBookedappointments() async {
 // BookedAppointments.clear();
  // numOfDaysOfHelp = 0;
    final FirebaseAuth auth = await FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    userid = user!.uid;
    email = user.email!;

     // print("yes");

    final snap = await FirebaseFirestore.instance
        .collection("faculty")
        .doc(userid)
        .collection('appointment')
        //.orderBy('starttime')
        .where("Booked", isEqualTo: true)
         .get()
        .then((QuerySnapshot snapshot) {
          
      // print("############################################");
       //print(snapshot.size);
      
     numOfDaysOfHelp = snapshot.size;

      snapshot.docs.forEach((DocumentSnapshot doc) {
       //if(doc['Booked']==true){
        
        // numOfDaysOfHelp=numOfDaysOfHelp+1; 
      
       Timestamp t1= doc['starttime'] as Timestamp;
       DateTime StartTimeDate=t1.toDate();
       
       Timestamp t2= doc['endtime'] as Timestamp;
       DateTime EndTimeDate=t2.toDate();

        BookedAppointments.add(new Appointment(Day: doc['Day'], startTime: StartTimeDate, endTime: EndTimeDate));
        
      // }
      });
      
    });// end then 
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

    if (isExists == false) {
        return Scaffold(
          appBar: AppBar(
            title: Text('View hours'),
          ),
          body: Row(
            children: <Widget>[
        Text("No Booked Appointments**")
      ],
      ) 
      );

    }else{
     //if(BookedAppointments.length!=0){
    return Scaffold(
          appBar: AppBar(
            title: Text('Booked Appointments'),
          ),
          body: //Row()
          //  FutureBuilder(
          //   future: getBookedappointments(),
          //   builder: (context, snapshot) {
              //return 
              
              ListView.builder(
                itemCount: numOfDaysOfHelp,
                itemBuilder: ((context, index) {
                  return Card(
                      child: 
                      ExpansionTile(
                    title: Text(BookedAppointments[index].Day),
                    //subtitle: Text("Date : "+ BookedAppointments[index].StringDate()+"\n Time : "+BookedAppointments[index].StringTimeRange()),
                  children: [
                    Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                    Text("   Date : "+ BookedAppointments[index].StringDate()),
                    Text("   Time : "+BookedAppointments[index].StringTimeRange()),
                          ]),
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                       mainAxisAlignment : MainAxisAlignment.end,
                       verticalDirection : VerticalDirection.up,

                      children: <Widget>[
                   IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () => {},
                     ),
                      ]
                    )


                  ])
                    
                   ],
                  









                  
                  
                  ));
                
                }),
              )
              //;
          //   },
          // )

          );
     //}
    }//end else there is booked appointments

  }
}
