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
  //bool AleardyintheArray=false;
   bool? AleardyintheArray;
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
BookedAppointments.clear();
//WidgetsBinding. instance. addPostFrameCallback((_) => getBookedappointments(context));
//makeachange();
BookedAppointmentsExists();
getBookedappointments();
}

// makeachange() async {
//               var exchange;
//               var idexchange;

//              //if(isExists== true){
//                  final snap = await FirebaseFirestore.instance
//                 .collection("faculty")
//                 .doc(userid)
//                 .collection('appointment')
//               //.where("Booked", isEqualTo: true)
//               .limit(1) .get().then((QuerySnapshot snapshot) {
//                 snapshot.docs.forEach((DocumentSnapshot doc) async {
//                       exchange= doc['Booked'];
//                      idexchange = doc.id;
                    
//                 });
//               });

//               final snap2 = await FirebaseFirestore.instance
//                 .collection("faculty")
//                 .doc(userid)
//                 .collection('appointment') .doc(idexchange).update({
//                     'Booked': !exchange, 
//                   });   

//               final snap3 = await FirebaseFirestore.instance
//                 .collection("faculty")
//                 .doc(userid)
//                 .collection('appointment') .doc(idexchange).update({
//                     'Booked': exchange, 
//                   });  

// }


    Future<bool?> BookedAppointmentsExists() async {
    final FirebaseAuth auth = await FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    userid = user!.uid;
    email = user.email!;

    final snap = await FirebaseFirestore.instance
        .collection("faculty")
        .doc(userid)
        .collection('appointment')
       .where("Booked", isEqualTo: true)
       // .orderBy('starttime')
        .snapshots().listen((event) {

   if (event.size == 0) {
      print("*******&&&&&&&&&&&&&&&&&&&^^^^^^^^^^^^^^^^^^");
      print("No Booked Appoinyments");
      setState(() {
        isExists = false;
      });

     // return isExists;
    } else {
      print("*******&&&&&&&&&&&&&&&&&&&^^^^^^^^^^^^^^^^^^");
      print("Booked Appoinyments Exist");
      setState(() {
        isExists = true;
      });

     // return isExists;
    }



    });
    return isExists;


  // final snap = await FirebaseFirestore.instance
  //       .collection("faculty")
  //       .doc(userid)
  //       .collection('appointment')
  //       .where("Booked", isEqualTo: true).get();

  //   if (snap.size == 0) {
  //     print("*******&&&&&&&&&&&&&&&&&&&^^^^^^^^^^^^^^^^^^");
  //     print("No Booked Appoinyments");
  //     setState(() {
  //       isExists = false;
  //     });

  //     return isExists;
  //   } else {
  //     print("*******&&&&&&&&&&&&&&&&&&&^^^^^^^^^^^^^^^^^^");
  //     print("Booked Appoinyments Exist");
  //     setState(() {
  //       isExists = true;
  //     });

  //     return isExists;
  //   }



    
  }//end function








 getBookedappointments() async {//BuildContext context// Future
BookedAppointments.clear();
BookedAppointments.length=0;
  // numOfDaysOfHelp = 0;
  //await Future.delayed(Duration(seconds: 5));


   final FirebaseAuth auth = await FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    userid = user!.uid;
    email = user.email!;

     // print("yes");






   final snap2 = await FirebaseFirestore.instance
        .collection("faculty")
        .doc(userid)
        .collection('appointment')
       //.where("Booked", isEqualTo: true)
       // .orderBy('starttime')
        .snapshots().listen((event) {//event ترجع كل شي مو بس الجديد
         numOfDaysOfHelp = event.size;
          print("######################################");
         print(event.size);

      BookedAppointments.clear();
      //BookedAppointments.length=0;   
     // BookedAppointments.clear();

         
       event.docs.forEach((element) async {
       //print(element.id); 
       print("1");
       if(element['Booked']==true){
     print(element.id); 
      
        print("2");

        //  setState(() {
        //  AleardyintheArray=false;
        //    });
           
      //  String id=element.id;
      // for (var j = 0; j < BookedAppointments.length; j++) {
      //   print("3");
      //    if(BookedAppointments[j].id == element.id){
      //     print("4");
      //      setState(() {
      //    AleardyintheArray=true;
      //      });
      //   }
      //  }

    print("5");
     //AleardyintheArray= BookedAppointments[0].id.contains(id);

       // if(AleardyintheArray==false){
        print("6");
       //students.clear(); 
        var studentsArrayOfRef;
        List students=[];
        students.clear(); 
        String projectname="";

        
       Timestamp t1= element['starttime'] as Timestamp;
       DateTime StartTimeDate=t1.toDate();
       
       Timestamp t2= element['endtime'] as Timestamp;
       DateTime EndTimeDate=t2.toDate();

      String dayname = DateFormat("EEE").format(StartTimeDate); //عشان يطلع اليوم الي فيه هذا التاريخ الجديد- الاحد او الاثنين... كسترنق
    
       print(dayname);




       studentsArrayOfRef=element['students'];
      print("**********************************************");
      print("777777777777777777777777777777777777777777777777777");
       print(studentsArrayOfRef);
       print("8888888888888888888888888888888888888888888888888888");
       print(studentsArrayOfRef.length);
      int len =studentsArrayOfRef.length;
      //DocumentSnapshot docRef2 = await studentsArrayOfRef[0].get();
      print("7");
      for (var i = 0; i < studentsArrayOfRef.length; i++) {
      final DocumentSnapshot docRef2 = await studentsArrayOfRef[i].get(); //await
     print(docRef2['name']);
     students.add(docRef2['name']);
      print(students);
     projectname=docRef2['projectTitle'];
      }

      //if(AleardyintheArray==false){
       setState(() {

        BookedAppointments.add(new Appointment(id: element.id, Day: dayname , startTime: StartTimeDate, endTime: EndTimeDate,projectName:projectname, students:  students));
        });
          
    // }//if not AleardyintheArray



           
          }//end if booked

      
      for (int i = 0; i < BookedAppointments.length; i++) {
        for (int j = i + 1; j < BookedAppointments.length; j++) {
           var temp;
           if ((BookedAppointments[i].startTime).isAfter(BookedAppointments[j].startTime)) {
                temp = BookedAppointments[i];
                BookedAppointments[i] = BookedAppointments[j];
                BookedAppointments[j] = temp;
             }
        }
}//end for date sorting
      

        for (int i = 0; i < BookedAppointments.length; i++) {
          for (int j = i + 1; j < BookedAppointments.length; j++) {
            if ((BookedAppointments[i].id == BookedAppointments[j].id)) {
              setState(() {
                    dynamic res = BookedAppointments.removeAt(j);
                    });
              }
          }
  }//end deleting duplicate
      
      
      






        // else{

        // for (var i = 0; i < BookedAppointments.length; i++) {
        //  if(BookedAppointments[i].id == element.id){
        //  setState(() {
        //  dynamic res = BookedAppointments.removeAt(i);
        //  print(res);
        //   //numOfDaysOfHelp=numOfDaysOfHelp-1;
        //   //Exist=false; if event size==0 
        //   });

        //  }//end if

        // }//end for
        // }//else not booked 









           });//end for each








        });
        print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%1");
        print(BookedAppointments.length);
         print(BookedAppointments.toString());
         
         
         
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
    // print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%1");
    //  print(numOfDaysOfHelp);
    //  print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%2");
    //  print(BookedAppointments.length);
    //  print(BookedAppointments.toString());

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
                itemCount: numOfDaysOfHelp,//BookedAppointments.length,//numOfDaysOfHelp
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
                    onPressed: () => {showConfirmationDialog(context,index)
                      //CancelAppointment(index)
                      },
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
                  // return Column(
                  //         children: <Widget>[
                  //         Text("inside else"),
                  //         Text("${BookedAppointments.length}"),
                  //         Text("${numOfDaysOfHelp}"),
                          
                  //         ]);
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

String id=BookedAppointments[index].id;
    //print(id);
    //print(index);
    //print(BookedAppointments.toString());
    // setState(() {
    //  dynamic res = BookedAppointments.removeAt(index);
    // });

          //await 
          FirebaseFirestore.instance
          .collection("faculty")
          .doc(userid)
          .collection('appointment')
          .doc(id) //Is there a specific id i should put for the appointments
          .update({
        'Booked': false, //string if booked then it should have a student refrence
        });


  //print(BookedAppointments.toString());
  
  }








showConfirmationDialog(BuildContext context,int index) {
    // set up the buttons
    bool deleteappointment=false;
    Widget dontCancelAppButton = ElevatedButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );


   Widget YesCancelAppButton = ElevatedButton(
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








}//end class



