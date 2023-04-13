import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myapp/FacultyViewScreen.dart';
import 'package:myapp/screeens/resources/snackbar.dart';
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

      if (student?.containsKey("group") ?? false) {
        DocumentReference? group = studentData['group'];
        print("student?.containsKey(group)");
        if (group != null) {
          var gData = await group.get();
          DocumentReference? dep = gData['department'];

          print("group != null");

          if (dep != null) {
            var dData = await dep.get();
            if (dData.exists) {
              department = dData.data() as Map<String, dynamic>;
              department['id'] = dData.reference.id;
              department['ref'] = dData.reference;
              print(department['ref']);
            }
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
    if (student?['department']?['ref'] == null) {
      if (mounted) {
        setState(() {
          facultyLoading = false;
        });
      }
      return;
    }
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

      if (mounted) {
        setState(() {
          facultyList.add(faculty);
        });
      }
    }

    if (mounted) {
      setState(() {
        facultyLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: Scaffold(
              backgroundColor: Colors.white,
              body: dropdownvalue == null &&
                      (!facultyLoading && facultyList.isNotEmpty)
                  ? _showMenu(this)
                  : ListView(
                      padding: const EdgeInsets.all(24),
                      children: <Widget>[
                        Column(children: [
                          if (facultyList.isNotEmpty && !facultyLoading)
                            SafeArea(
                              child: Container(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    textStyle: const TextStyle(
                                        fontFamily: 'main', fontSize: 16),
                                    // shadowColor: Colors.blue[900],
                                    elevation: 20,
                                    backgroundColor: facultyList.isNotEmpty
                                        ? Mycolors.mainShadedColorBlue
                                        : Mycolors.mainColorGray,
                                    shadowColor: Colors.transparent,
                                    minimumSize: const Size(200, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          17), // <-- Radius
                                    ),
                                  ),
                                  child: Text(facultyList.isNotEmpty
                                      ? "Choose Another Speciality"
                                      : "Choose Speciality"),
                                  onPressed: () {
                                    if (facultyList.isNotEmpty) {
                                      if (mounted) {
                                        setState(() {
                                          dropdownvalue = null;
                                        });
                                      }
                                    } else {
                                      showInSnackBar(context,
                                          "No appointments available for you currently.",
                                          color: const Color.fromRGBO(
                                              21, 70, 160, 1));
                                    }
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
                                    child: facultyLoading
                                        ? const Center(
                                            child: CircularProgressIndicator(
                                                color: Color.fromRGBO(
                                                    21, 70, 160, 1)),
                                          )
                                        : Text(
                                            (facultyList.isEmpty
                                                ? "No appointments found for you currently (0 appointments in all specialities)."
                                                : 'There are no appointments available with the selected speciality (${dropdownvalue?['specialityname']}).'),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                height: 2,
                                                fontSize: 18,
                                                color: Colors.black54)))
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
              // dropdownvalue = null;
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
              width: 230,
              // padding: const EdgeInsets.all(11),
              // color: themeData.colorScheme.background.withOpacity(0.3),
              child: Card(
                  color: const Color.fromRGBO(21, 70, 160, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // <-- Radius
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(children: [
                        Row(children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  facultyName,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  specialisation,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  college,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          )
                        ])
                      ]))),
            )
          ],
        ),
      ),
    );
  }

  List getResults() {
    if (facultyLoading) return [];

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

  bool hasResults(specialty) {
    return facultyList.firstWhere(
            (t) => t?['specialty']
                ?.map((e) => e['id'])
                ?.contains(specialty?['id']),
            orElse: () => null) !=
        null;
  }

  _showMenu(thisContext) {
    return specialityList.isEmpty || facultyLoading
        ? const Center(
            child: CircularProgressIndicator(
                color: Color.fromRGBO(21, 70, 160, 1)),
          )
        : ListView(
            children: <Widget>[
              const ListTile(
                title: Text(
                  'Choose a Speciality',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                // style: ListTileStyle(f),
              ),
              for (var item = 0; item < specialityList.length; item++)
                Card(
                  color: hasResults(specialityList[item])
                      ? const Color.fromRGBO(21, 70, 160, 1)
                      : const Color.fromARGB(255, 140, 142, 145),
                  borderOnForeground: true,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    title: Text(
                      specialityList[item]!['specialityname'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      if (hasResults(specialityList[item])) {
                        if (mounted) {
                          setState(() {
                            isItVisible = false;
                            dropdownvalue = specialityList[item];
                          });
                        }
                      } else {
                        showInSnackBar(
                            context,
                            "No Appointments available in (" +
                                specialityList[item]?['specialityname'] +
                                ")",
                            onError: true);
                      }
                    },
                  ),
                ),
            ],
          );
  }
}
