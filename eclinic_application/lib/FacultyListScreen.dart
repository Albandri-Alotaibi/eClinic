import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/FacultyViewScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FacultyListScreen extends StatefulWidget {
  const FacultyListScreen();

  @override
  _FacultyListScreenState createState() => _FacultyListScreenState();
}

class _FacultyListScreenState extends State<FacultyListScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
  //late ThemeData themeData;

  // Map<String, dynamic>? dropdownvalue;
  // List facultyList = [];
  // List<Map<String, dynamic>?> specialityList = [];
  // var loading = false;
  // String? userid;
  // String? email;
  // Map<String, dynamic>? student;

  // void initState() {
  //   super.initState();
  //   final FirebaseAuth auth = FirebaseAuth.instance;
  //   final User? user = auth.currentUser;
  //   userid = user!.uid;
  //   email = user.email!;

  //   loading = true;
  //   initStudent();
  //   initFaculty();
  //   initSpeciality();
  // }

  // initStudent() async {
  //   CollectionReference studentCollection =
  //       FirebaseFirestore.instance.collection('student');
  //   DocumentSnapshot studentData = await studentCollection.doc(userid).get();

  //   if (studentData.exists) {
  //     student = studentData.data() as Map<String, dynamic>;

  //     var college;
  //     if (student?.containsKey("collage") ?? false) {
  //       DocumentReference? collageData = studentData['collage'];

  //       if (collageData != null) {
  //         var cData = await collageData.get();

  //         if (cData.exists) {
  //           college = cData.data() as Map<String, dynamic>;
  //           college?['id'] = cData.reference.id;
  //         }
  //       }
  //     }

  //     student?['collage'] = college;

  //     var department;
  //     if (student?.containsKey("department") ?? false) {
  //       DocumentReference? departmentData = studentData['department'];

  //       if (departmentData != null) {
  //         var dData = await departmentData.get();

  //         if (dData.exists) {
  //           department = dData.data() as Map<String, dynamic>;
  //           department['id'] = dData.reference.id;
  //         }
  //       }
  //     }

  //     student?['department'] = department;

  //     var semester;
  //     if (student?.containsKey("department") ?? false) {
  //       DocumentReference? semesterData = studentData['semester'];

  //       if (semesterData != null) {
  //         var sData = await semesterData.get();

  //         if (sData.exists) {
  //           semester = sData.data() as Map<String, dynamic>;
  //           semester?['id'] = sData.reference.id;
  //         }
  //       }
  //     }
  //     student?['semester'] = semester;
  //   } else {
  //     student = null;
  //   }
  // }

  // void initSpeciality() async {
  //   CollectionReference cats =
  //       FirebaseFirestore.instance.collection('facultyspeciality');
  //   QuerySnapshot q = await cats.get();

  //   specialityList = q.docs.map((doc) {
  //     var speciality = doc.data() as Map<String, dynamic>;
  //     speciality['id'] = doc.reference.id;
  //     return speciality;
  //   }).toList();
  // }

  // void initFaculty() async {
  //   CollectionReference faculty =
  //       FirebaseFirestore.instance.collection('faculty');
  //   var q = await faculty.get();

  //   facultyList = [];
  //   for (var doc in q.docs) {
  //     var faculty = doc.data() as Map<String, dynamic>;
  //     faculty['id'] = doc.reference.id;

  //     List<DocumentReference> specialityIds = [...doc['specialty'] ?? []];
  //     faculty['specialty'] = [];
  //     for (DocumentReference? sId in specialityIds) {
  //       if (sId != null) {
  //         var xdata = await sId.get();
  //         if (xdata.exists) {
  //           var specialty = xdata.data() as Map<String, dynamic>;
  //           specialty['id'] = xdata.reference.id;
  //           debugPrint(specialty.toString());
  //           faculty['specialty'].add(specialty);
  //         }
  //       }
  //     }

  //     var college;
  //     if (faculty.containsKey("collage")) {
  //       DocumentReference? collageData = doc['collage'];

  //       if (collageData != null) {
  //         var cData = await collageData.get();

  //         if (cData.exists) {
  //           college = cData.data() as Map<String, dynamic>;
  //           college?['id'] = cData.reference.id;
  //         }
  //       }
  //     }
  //     faculty['collage'] = college;

  //     var department;
  //     if (faculty.containsKey("department")) {
  //       DocumentReference? departmentData = doc['department'];

  //       if (departmentData != null) {
  //         var dData = await departmentData.get();

  //         if (dData.exists) {
  //           department = dData.data() as Map<String, dynamic>;
  //           department?['id'] = dData.reference.id;
  //         }
  //       }
  //     }
  //     faculty['department'] = department;

  //     var semester;
  //     if (faculty.containsKey("department")) {
  //       DocumentReference? semesterData = doc['semester'];

  //       if (semesterData != null) {
  //         var sData = await semesterData.get();

  //         if (sData.exists) {
  //           semester = sData.data() as Map<String, dynamic>;
  //           semester?['id'] = sData.reference.id;
  //         }
  //       }
  //     }
  //     faculty['semester'] = semester;

  //     facultyList.add(faculty);
  //   }

  //   setState(() {
  //     facultyList = facultyList;
  //   });

  //   //show only faculty from same college and department.
  //   // if (facultyList.isNotEmpty) {
  //   //   setState(() {
  //   //     facultyList = facultyList
  //   //         //to get only faculty with same college as current student college
  //   //         .where((element) =>
  //   //             element['collage']?['id']
  //   //                 .compareTo(student?['collage']?['id'] ?? "") ==
  //   //             0)
  //   //         //to get only faculty with same department as current student department
  //   //         .where((element) =>
  //   //             element['department']?['id']
  //   //                 .compareTo(student?['department']?['id'] ?? "") ==
  //   //             0)
  //   //         //to get only faculty with same semester as current student semester
  //   //         .where((element) =>
  //   //             element['semester']?['id']
  //   //                 .compareTo(student?['semester']?['id'] ?? "") ==
  //   //             0)
  //   //         .toList();
  //   //   });
  //   // }

  //   loading = false;
  // }

  // Widget build(BuildContext context) {
  //   themeData = Theme.of(context);
  //   return MaterialApp(
  //       debugShowCheckedModeBanner: false,
  //       home: SafeArea(
  //         child: Scaffold(
  //             body: loading
  //                 ? Center(
  //                     child: CircularProgressIndicator(),
  //                   )
  //                 : Container(
  //                     child: ListView(
  //                     padding: EdgeInsets.all(24),
  //                     children: <Widget>[
  //                       Container(
  //                         alignment: Alignment.topLeft,
  //                         child: IconButton(
  //                           onPressed: () => Navigator.of(context).pop(),
  //                           icon: Icon(Icons.chevron_left),
  //                         ),
  //                       ),
  //                       Container(
  //                           child: Column(children: [
  //                         Text(
  //                           "Choose Faculty",
  //                           style: TextStyle(
  //                               color: themeData.colorScheme.primary,
  //                               fontWeight: FontWeight.w400),
  //                         ),
  //                         SafeArea(
  //                             child: Row(children: [
  //                           if (specialityList.length > 0)
  //                             DropdownButton<Map<String, dynamic>?>(
  //                                 icon: Icon(Icons.face),
  //                                 hint: Text(
  //                                   "Select Speciality",
  //                                   style: TextStyle(
  //                                       color: themeData.colorScheme.primary,
  //                                       fontWeight: FontWeight.w500),
  //                                 ),
  //                                 value: dropdownvalue,
  //                                 items: specialityList
  //                                     .map((Map<String, dynamic>? item) {
  //                                   return DropdownMenuItem(
  //                                       value: item,
  //                                       child: Text(
  //                                           item?['specialityname'] ?? "--"));
  //                                 }).toList(),
  //                                 onChanged: (newValue) {
  //                                   if (newValue != null) {
  //                                     setState(() {
  //                                       dropdownvalue = newValue;
  //                                     });
  //                                   }
  //                                 }),
  //                           if (specialityList.length > 0) Spacer(),
  //                           if (dropdownvalue != null)
  //                             IconButton(
  //                                 onPressed: () => {
  //                                       setState(() {
  //                                         dropdownvalue = null;
  //                                       })
  //                                     },
  //                                 icon: Icon(Icons.delete_sweep))
  //                         ])),
  //                       ])),
  //                       Container(
  //                           height: 800,
  //                           child: ListView.builder(
  //                               itemCount: facultyList.length,
  //                               itemBuilder: (context, index) {
  //                                 if ((dropdownvalue != null &&
  //                                         facultyList[index]['specialty']
  //                                             .where((r) =>
  //                                                 r?['specialityname'] ==
  //                                                 dropdownvalue?[
  //                                                     'specialityname'])
  //                                             .isEmpty) ||
  //                                     facultyList.length == 0) {
  //                                   return Column(
  //                                     mainAxisAlignment:
  //                                         MainAxisAlignment.center,
  //                                     crossAxisAlignment:
  //                                         CrossAxisAlignment.center,
  //                                     children: [
  //                                       SizedBox(height: 100),
  //                                       Text(
  //                                           facultyList.length == 0
  //                                               ? 'There are no appointment available currently'
  //                                               : 'There are no appointment available with the selected speciality.',
  //                                           style: TextStyle(
  //                                               fontWeight: FontWeight.w600,
  //                                               color: Colors.blue)),
  //                                     ],
  //                                   );
  //                                 }
  //                                 return _facultyDetails(
  //                                   image: "assets/images/User1.png",
  //                                   specialisation: facultyList[index]
  //                                           ['specialty']
  //                                       .map((e) => e['specialityname'])
  //                                       .join(', '),
  //                                   facultyName: facultyList[index]
  //                                           ['firstname'] +
  //                                       " " +
  //                                       facultyList[index]['lastname'],
  //                                   college:
  //                                       "${facultyList[index]['collage']?['collagename'] ?? "--"}/${facultyList[index]['department']?['departmentname'] ?? "--"}",
  //                                   faculty: facultyList[index],
  //                                 );
  //                               }))
  //                     ],
  //                   ))),
  //       ));
  // }

  // _facultyDetails({
  //   required String image,
  //   required String specialisation,
  //   required String college,
  //   required String facultyName,
  //   required Map faculty,
  // }) {
  //   return InkWell(
  //     onTap: () {
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => FacultyViewScreen(
  //                     facultyId: faculty['id'],
  //                   )));
  //     },
  //     child: Container(
  //       margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           ClipRRect(
  //               clipBehavior: Clip.antiAliasWithSaveLayer,
  //               borderRadius: BorderRadius.all(Radius.circular(12)),
  //               child: Image.asset(
  //                 image,
  //                 width: 90,
  //                 height: 90,
  //                 fit: BoxFit.cover,
  //               )),
  //           SizedBox(
  //             width: 16,
  //             height: 40,
  //           ),
  //           Container(
  //             width: 200,
  //             padding: EdgeInsets.all(11),
  //             color: themeData.colorScheme.background.withOpacity(0.3),
  //             child: Column(children: [
  //               Row(children: [
  //                 Expanded(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         specialisation,
  //                         style: TextStyle(
  //                           color: themeData.colorScheme.primary,
  //                           fontWeight: FontWeight.w600,
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: 4,
  //                       ),
  //                       Text(
  //                         facultyName,
  //                         style: TextStyle(
  //                             color: themeData.colorScheme.primary,
  //                             fontWeight: FontWeight.w600),
  //                       ),
  //                       SizedBox(
  //                         height: 4,
  //                       ),
  //                       Text(
  //                         college,
  //                         style: TextStyle(
  //                             color: themeData.colorScheme.primary,
  //                             fontWeight: FontWeight.w500),
  //                       ),
  //                     ],
  //                   ),
  //                 )
  //               ])
  //             ]),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
