import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/FacultyViewScreen.dart';
import 'dart:async';
import 'package:myapp/style/Mycolors.dart';

class FacultyListScreen extends StatefulWidget {
  const FacultyListScreen({super.key});

  @override
  FacultyListScreenState createState() => FacultyListScreenState();
}

class FacultyListScreenState extends State<FacultyListScreen> {
  late ThemeData themeData;

  Map<String, dynamic>? dropdownvalue;
  List facultyList = [];
  List<Map<String, dynamic>?> specialityList = [];
  var loading = false;
  var facultyLoading = true;
  String? userid;
  String? email;
  Map<String, dynamic>? student;
  bool isItVisible = false;

  @override
  void initState() {
    super.initState();

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    userid = user!.uid;
    email = user.email!;

    initSpeciality();
    initStudent();
  }

  Future initStudent() async {
    CollectionReference studentCollection =
        FirebaseFirestore.instance.collection('student');
    DocumentSnapshot studentData = await studentCollection.doc(userid).get();

    if (studentData.exists) {
      student = studentData.data() as Map<String, dynamic>;

      Map<String, dynamic>? department;
      if (student?.containsKey("department") ?? false) {
        DocumentReference? departmentData = studentData['department'];

        if (departmentData != null) {
          var dData = await departmentData.get();

          if (dData.exists) {
            department = dData.data() as Map<String, dynamic>;
            department['id'] = dData.reference.id;
          }
        }
      }

      student?['department'] = department;

      Map<String, dynamic>? semester;

      if (student?.containsKey("semester") ?? false) {
        DocumentReference? semesterData = studentData['semester'];

        if (semesterData != null) {
          var sData = await semesterData.get();

          if (sData.exists) {
            semester = sData.data() as Map<String, dynamic>;
            semester['id'] = sData.reference.id;
            semester['ref'] = sData.reference;
          }
        }
      }
      student?['semester'] = semester;
    } else {
      student = null;
    }

    initFaculty();
  }

  Future initSpeciality() async {
    CollectionReference cats =
        FirebaseFirestore.instance.collection('facultyspeciality');
    QuerySnapshot q = await cats.get(const GetOptions(source: Source.server));

    specialityList = q.docs.map((doc) {
      var speciality = doc.data() as Map<String, dynamic>;

      speciality['id'] = doc.reference.id;
      speciality['ref'] = doc.reference;

      return speciality;
    }).toList();
  }

  void initFaculty() async {
    var faculty = FirebaseFirestore.instance.collection('faculty');
    var q = await faculty
        .where('semester', isEqualTo: student?['semester']?['ref'])
        .where('department', isEqualTo: student?['department']?['ref'])
        .get(const GetOptions(source: Source.server));

    facultyList = [];
    for (var doc in q.docs) {
      var faculty = doc.data();
      faculty['id'] = doc.reference.id;

      List<DocumentReference> specialityIds = [...doc['specialty'] ?? []];
      faculty['specialty'] = [];
      for (DocumentReference? sId in specialityIds) {
        if (sId != null) {
          var xdata = await sId.get();
          if (xdata.exists) {
            var specialty = xdata.data() as Map<String, dynamic>;
            specialty['id'] = xdata.reference.id;

            faculty['specialty'].add(specialty);
          }
        }
      }

      var appointmentCounts = (await FirebaseFirestore.instance
              .collection('faculty')
              .doc(faculty['id'])
              .collection('appointment')
              .where("starttime", isGreaterThan: Timestamp.now())
              // .where("Booked", isEqualTo: false)
              .get())
          .docs
          .where((element) => element.data()['Booked'] == false)
          .length;

      faculty['appointments_count'] = appointmentCounts;

      if (faculty['appointments_count'] == 0) {
        continue;
      }

      setState(() {
        facultyList.add(faculty);
      });
    }

    setState(() {
      facultyLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    Future.delayed(
        Duration.zero,
        () => {
              if (!isItVisible &&
                  dropdownvalue == null &&
                  specialityList.isNotEmpty)
                showMenu(context)
            });

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: const Color.fromRGBO(21, 70, 160, 1),
                title: const Text("Schedule An Appointment"),
                leading: InkWell(
                  onTap: () {
                    Navigator.pop(this.context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
              body: loading || dropdownvalue == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView(
                      padding: const EdgeInsets.all(24),
                      children: <Widget>[
                        Column(children: [
                          // Text(
                          //   "Choose Faculty",
                          //   style: TextStyle(
                          //       color: themeData.colorScheme.primary,
                          //       fontWeight: FontWeight.w400),
                          // ),
                          SafeArea(
                            child: Container(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  textStyle: const TextStyle(
                                      fontFamily: 'main', fontSize: 16),
                                  shadowColor: Colors.blue[900],
                                  elevation: 20,
                                  backgroundColor: Mycolors.mainShadedColorBlue,
                                  minimumSize: const Size(200, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(17), // <-- Radius
                                  ),
                                ),
                                child: const Text("Select Another Speciality"),
                                onPressed: () {
                                  setState(() {
                                    dropdownvalue = null;
                                  });
                                },
                              ),
                            ),
                          ),
                        ]),
                        SizedBox(
                            height: 800,
                            child: getResults().isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Text(
                                        facultyLoading
                                            ? 'Wait...'
                                            : (facultyList.isEmpty
                                                ? "No faculty found for you currently."
                                                : (dropdownvalue == null
                                                    ? 'Please select speciality first...'
                                                    : 'There are no appointments available with the selected speciality.')),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            height: 2,
                                            fontSize: 18,
                                            color: Colors.blue)))
                                : ListView.builder(
                                    itemCount: getResults().length,
                                    itemBuilder: (context, index) {
                                      return _facultyDetails(
                                        image: "assets/images/User1.png",
                                        specialisation: getResults()[index]
                                                ['specialty']
                                            .map((e) => e['specialityname'])
                                            .join(', '),
                                        facultyName: getResults()[index]
                                                ['firstname'] +
                                            " " +
                                            getResults()[index]['lastname'],
                                        college:
                                            "${student?['department']?['departmentname'] ?? "--"}",
                                        faculty: getResults()[index],
                                      );
                                    }))
                      ],
                    )),
        ));
  }

  _facultyDetails({
    required String image,
    required String specialisation,
    required String college,
    required String facultyName,
    required Map<String, dynamic> faculty,
  }) {
    return InkWell(
      onTap: () {
        if (dropdownvalue == null) {
          return;
        }

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FacultyViewScreen(
                    faculty: faculty,
                    speciality: dropdownvalue!))).then((value) => setState(() {
              facultyList = [];
              facultyLoading = true;
              initFaculty();
            }));
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: Image.asset(
                  image,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                )),
            const SizedBox(
              width: 16,
              height: 40,
            ),
            Container(
              width: 200,
              padding: const EdgeInsets.all(11),
              color: themeData.colorScheme.background.withOpacity(0.3),
              child: Column(children: [
                Row(children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          specialisation,
                          style: TextStyle(
                            color: themeData.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          facultyName,
                          style: TextStyle(
                              color: themeData.colorScheme.primary,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          college,
                          style: TextStyle(
                              color: themeData.colorScheme.primary,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                ])
              ]),
            )
          ],
        ),
      ),
    );
  }

  List getResults() {
    if (dropdownvalue != null) {
      var results = [];
      for (Map r in facultyList) {
        if (r['specialty']
            ?.where(
                (t) => t['specialityname'] == dropdownvalue?['specialityname'])
            .isNotEmpty) {
          results.add(r);
        }
      }

      return results;
    } else {
      return [];
    }
  }

  void showMenu(thisContext) {
    setState(() {
      isItVisible = true;
    });

    showDialog(
        context: thisContext,
        builder: (context) {
          return SimpleDialog(
            title:
                Text(specialityList.isEmpty ? 'Wait...' : 'Chose a Speciality'),
            children: [
              for (var item = 0; item < specialityList.length; item++)
                SimpleDialogOption(
                  onPressed: () {
                    setState(() {
                      isItVisible = false;
                      dropdownvalue = specialityList[item];
                    });
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: Text(specialityList[item]!['specialityname']),
                ),
            ],
          );
        });
  }
}
