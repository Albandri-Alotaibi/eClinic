import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/CommonIssueViewScreen.dart';
import 'package:myapp/style/Mycolors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/facultyViewFAQ.dart';

class facultyListFAQ extends StatefulWidget {
  const facultyListFAQ({super.key});

  @override
  State<facultyListFAQ> createState() => _facultyListFAQState();
}

class _facultyListFAQState extends State<facultyListFAQ> {
  @override
  late ThemeData themeData;

  Map<String, dynamic>? specialityDropdownValue;
  Map<String, dynamic>? semesterDropdownValue;
  List commonIssuesList = [];
  List<Map<String, dynamic>?> specialityList = [];
  List<Map<String, dynamic>?> semesterList = [];
  List specalityforfaculty = [];
  List toremoveid = [];
  var firstLoading = true;
  var secondLoading = false;
  var noResults = true;
  var searchClicked = false;
  bool downloadissue = true;
  var userid;
  @override
  void initState() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    userid = user!.uid;
    super.initState();
    retrivespeciality();
    // initSpeciality();
    //initSpeciality();
    //get specialities for dropdown
    //get semesters for dropdown
    initSemester();

    //initSpeciality1nnoooo();
  }

  bool ciempty = true;
  retrivespeciality() async {
    // specalityforfaculty.clear();
    final snap = await FirebaseFirestore.instance
        .collection('faculty')
        .doc(userid)
        .get();
    List facultyspecialityRef = snap["specialty"];
    // sp = snap["specialty"];
    // print(sp);
    for (var i = 0; i < facultyspecialityRef.length; i++) {
      final DocumentSnapshot docRef = await facultyspecialityRef[i].get();
      setState(() {
        specalityforfaculty.add(docRef.id);
        //print(docRef["specialityname"]);
        //   print(docRef.id);
        // print("222222222222222222222");
      });
    }
    print("222222222222222222222");
    print(specalityforfaculty);
    initSpeciality();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {});
    });
  }

  // Future initSpecialitynnoo() async {
  //   Map<String, dynamic>? speciality;
  //   CollectionReference cats =
  //       FirebaseFirestore.instance.collection('facultyspeciality');

  //   QuerySnapshot q = await cats.get(const GetOptions(source: Source.server));
  //   //specialityList.clear();
  //   specialityList = q.docs.map((doc) {
  //     // for (var i = 0; i < specalityforfaculty.length; i++) {
  //     //   // print(specalityforfaculty.length);
  //     //   if (doc.id == specalityforfaculty[i]) {
  //     speciality = doc.data() as Map<String, dynamic>?;
  //     speciality!['id'] = doc.reference.id;
  //     speciality!['ref'] = doc.reference;
  //     //   print(
  //     //       "////////////////////////specialityList//////////////////////////////////////");
  //     //   print(speciality);
  //     // }

  //     // print(speciality);

  //     //}
  //     return speciality;
  //   }).toList();
  //   // Future.delayed(Duration(seconds: 1), () {
  //   //   setState(() {});
  //   // });
  //   //add all Specialties to dropdown
  //   specialityList.insert(
  //       0, <String, dynamic>{"specialityname": "All Specialties", "id": "0"});
  //   specialityDropdownValue = specialityList[0];
  //   // print("99999999999999999999999999999999999999999999999");
  //   specialityList.forEach((element) {
  //     print(element?["id"]);
  //     for (var i = 0; i < element!.length; i++) {
  //       if (specalityforfaculty[i] == element["id"]) {
  //         print("999999999999999999999yyyeesss99999999999999999999999999");
  //       }
  //     }
  //   });
  //   print(specalityforfaculty.length);
  //   print(speciality!.length);
  //   print(specialityList.length);
  // }

  Future initSpeciality() async {
    CollectionReference cats =
        FirebaseFirestore.instance.collection('facultyspeciality');
    QuerySnapshot q = await cats.get(const GetOptions(source: Source.server));

    specialityList = q.docs.map((doc) {
      var speciality = doc.data() as Map<String, dynamic>;
      // bool c = false;
      // for (var i = 0; i < specalityforfaculty.length; i++) {
      //   print(specalityforfaculty[i]);
      //   // print("44444444444444444444444444444444444444444");
      //   // print(speciality.entries);
      //   if (speciality.containsValue(specalityforfaculty[i])) {
      //     c = false;
      //     // if (doc.id == specalityforfaculty[i]) {
      //     speciality.removeWhere((key, value) => c);

      //     speciality.forEach((key, value) {
      //       if (speciality.containsValue("--")) {
      //         c = false;
      //         speciality.removeWhere((key, value) => c);
      //       }
      //     });
      //   }
      // }
      speciality['id'] = doc.reference.id;
      speciality['ref'] = doc.reference;

      return speciality;
    }).toList();

    //add all Specialties to dropdown
    specialityList.insert(
        0, <String, dynamic>{"specialityname": "All Specialties", "id": "0"});

    specialityDropdownValue = specialityList[0];

    specialityList.forEach((element) {
      // for (var i = 0; i < specalityforfaculty.length; i++) {
      if ((element?["id"]) != "0") {
        // print("wwwwhhhhhsssss deeleetteeee");
        if (!(specalityforfaculty.contains((element?["id"])))) {
          print("wwwwhhhhhsssss deeleetteeee");
          toremoveid.add(element);
          //specialityList.remove(element);
          //}
        }
      }
    });
    specialityList.removeWhere((element) => toremoveid.contains(element));
    // specialityList.forEach((element) {
    //   // print("44444444444444444444444444444444444444444");
    //   print(element?["id"]);

    //   // print("44444444444444444444444444444444444444444");
    //   // print(element['id']);
    //   // print(specalityforfaculty);
    //   if (!(specalityforfaculty.contains(element!['id']))) {
    //     specialityList.remove(element);
    //     print("444444444444444yyyessss44444444444444444444444444");
    //     print(specialityList);
    //   }
    // });
    //       specialityList.forEach((element) {

    //     if ((specalityforfaculty.contains(element!['id']))) {

    //     }
    //   });
    initCommonIssues();
  }

  ///try
  // Future initSpeciality1nnoooo() async {
  //   QuerySnapshot<Object?> cats = FirebaseFirestore.instance
  //       .collection('facultyspeciality')
  //       .where("specialityname", whereIn: [specalityforfaculty]).get(
  //           const GetOptions(source: Source.server)) as QuerySnapshot<Object?>;
  //   //var c = cats.where("specialityname", whereIn: [specalityforfaculty]);
  //   print("////////////////////////////////////////////");
  //   //print(c.firestore.doc("Ai"));
  //   //QuerySnapshot q = await cats.get(const GetOptions(source: Source.server));

  //   specialityList = cats.docs.map((doc) {
  //     var speciality = doc.data() as Map<String, dynamic>;

  //     speciality['id'] = doc.reference.id;
  //     speciality['ref'] = doc.reference;

  //     return speciality;
  //   }).toList();

  //   //add all Specialties to dropdown
  //   specialityList.insert(
  //       0, <String, dynamic>{"specialityname": "All Specialties", "id": "0"});

  //   specialityDropdownValue = specialityList[0];
  // }

//try
  // gets() async {
  //   var snap = await FirebaseFirestore.instance
  //       .collection('facultyspeciality')
  //       .where("specialityname", whereIn: [specalityforfaculty]).get();
  //   print("//////////////////////////////////////");
  //   print(snap.size);
  //   print("////////////////44444//////////////////////");
  //   print(specalityforfaculty);
  // }

  Future initSemester() async {
    CollectionReference cats =
        FirebaseFirestore.instance.collection('semester');
    QuerySnapshot q = await cats.get(const GetOptions(source: Source.server));

    semesterList = q.docs.map((doc) {
      var semester = doc.data() as Map<String, dynamic>;

      semester['id'] = doc.reference.id;
      semester['ref'] = doc.reference;

      return semester;
    }).toList();

    //add all semesters option to dropdown
    semesterList.insert(
        0, <String, dynamic>{"semestername": "All Semesters", "id": "0"});

    semesterDropdownValue = semesterList[0];
    setState(() {
      firstLoading = false;
    });
    initCommonIssues();
  }

  //get common issues by selected dropdowns (speciality / semester) refs
  void initCommonIssues() async {
    downloadissue = true;
    commonIssuesList = [];
    setState(() {
      secondLoading = true;
      searchClicked = true;
    });

    var ci = FirebaseFirestore.instance.collection('commonissue');

    //depends on the dropdown, make the query to database
    QuerySnapshot<Map<String, dynamic>> q;
    if (semesterDropdownValue != null &&
        semesterDropdownValue?['id'] != "0" &&
        specialityDropdownValue != null &&
        specialityDropdownValue?['id'] != "0") {
      q = await ci
          .where('semester', isEqualTo: semesterDropdownValue?['ref'])
          .where('issuecategory', isEqualTo: specialityDropdownValue?['ref'])
          .get(const GetOptions(source: Source.server));
    } else if (semesterDropdownValue != null &&
        semesterDropdownValue?['id'] != "0") {
      q = await ci
          .where('semester', isEqualTo: semesterDropdownValue?['ref'])
          .get(const GetOptions(source: Source.server));
    } else if (specialityDropdownValue != null &&
        specialityDropdownValue?['id'] != "0") {
      q = await ci
          .where('issuecategory', isEqualTo: specialityDropdownValue?['ref'])
          .get(const GetOptions(source: Source.server));
    } else {
      q = await ci.get(const GetOptions(source: Source.server));
    }

    commonIssuesList = [];

    var i = 0;
    for (var doc in q.docs) {
      var commonIssue = doc.data();

      commonIssue['id'] = doc.reference.id;
      commonIssue['ref'] = doc.reference;

      i++;

      setState(() {
        //  List fordownloudnow = [];
        print("تدخل هينا وهي ماسوت فلتر");

        if (specalityforfaculty.contains(commonIssue['issuecategory'].id)) {
          commonIssuesList.add(commonIssue);
          ciempty = false;

          if (i > 0) {
            secondLoading = false;
          }
        }
      });
    }
    // downloadissue = false;

    setState(() {
      noResults = q.docs.isEmpty;

      secondLoading = false;
    });
    print('finish download 66666666666666666666666666');
  }

  @override
  Widget build(BuildContext context) {
    print(specialityList);
    themeData = Theme.of(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Common Issues",
        home: SafeArea(
          child: Scaffold(
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              //show the app bar above
              // appBar: AppBar(
              //   title: const Text("Common Issues"),
              //   leading: InkWell(
              //     onTap: () {
              //       Navigator.pop(context);
              //     },
              //     child: const Icon(
              //       Icons.arrow_back,
              //       color: Colors.white,
              //     ),
              //   ),
              // ),
              body: firstLoading
                  //show progress bar during dropdowns loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  //when loading if done, show everything.
                  : ListView(
                      padding: const EdgeInsets.all(24),
                      children: <Widget>[
                        //------------------------- dropdowns [speciality/semester]
                        Column(children: [
                          Row(children: [
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: Mycolors.mainShadedColorBlue,
                                      width: 1),
                                ),
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(bottom: 8),
                                child: DropdownButton<Map<String, dynamic>?>(
                                    // icon: const Icon(Icons.face),

                                    underline: const SizedBox(),
                                    disabledHint: Row(children: const [
                                      Text("Wait ... "),
                                      SizedBox(
                                          height: 15.0,
                                          width: 15.0,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                          ))
                                    ]),
                                    hint: Text(
                                      "Select Speciality",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: themeData.colorScheme.primary,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                    value: specialityDropdownValue,
                                    items: specialityList
                                        .map((Map<String, dynamic>? item) {
                                      return DropdownMenuItem(
                                          value: item,
                                          child: Text(
                                              item?['specialityname'] ?? "--"));
                                    }).toList(),
                                    onChanged: (newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          //reset variables, to remove results and show messages
                                          specialityDropdownValue = newValue;
                                          commonIssuesList = [];
                                          searchClicked = false;
                                          noResults = true;
                                          initCommonIssues();
                                        });
                                      }
                                    })),
                            const Spacer(),
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: Mycolors.mainShadedColorBlue,
                                      width: 1),
                                ),
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(bottom: 8),
                                child: DropdownButton<Map<String, dynamic>?>(
                                    // icon: const Icon(Icons.pages),
                                    disabledHint: Row(children: const [
                                      Text("Wait ... "),
                                      SizedBox(
                                          height: 15.0,
                                          width: 15.0,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                          ))
                                    ]),
                                    underline: const SizedBox(),
                                    hint: Text(
                                      "Select Semester",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: themeData.colorScheme.primary,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    value: semesterDropdownValue,
                                    items: semesterList
                                        .map((Map<String, dynamic>? item) {
                                      return DropdownMenuItem(
                                          value: item,
                                          child: Text(
                                              item?['semestername'] ?? "--"));
                                    }).toList(),
                                    onChanged: (newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          //reset variables, to remove results and show messages
                                          semesterDropdownValue = newValue;
                                          commonIssuesList = [];
                                          searchClicked = false;
                                          initCommonIssues();
                                        });
                                      }
                                    })),
                          ]),
                          // Row(children: [
                          //   Expanded(
                          //       child: ElevatedButton(
                          //     onPressed: () => {initCommonIssues()},
                          //     child: const Text('Search'),
                          //   ))
                          // ]),
                        ]),
                        //--------------------------- end dropdowns
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, 'addcommonissue');
                          },
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Card(
                                    color: Mycolors.mainColorWhite,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            17), // <-- Radius
                                        side: BorderSide(
                                            color:
                                                Mycolors.mainShadedColorBlue)),
                                    shadowColor:
                                        const Color.fromARGB(94, 114, 168, 243),
                                    child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: ListTile(
                                          title: Text("new common issue",
                                              style: const TextStyle(
                                                  fontSize: 18)),

                                          textColor: Mycolors.mainColorBlack,
                                          trailing: const Icon(
                                            Icons.add,
                                            color: Colors.black,
                                          ),

                                          // fontFamily: 'main',
                                          // fontWeight: FontWeight.w600
                                          // ),
                                        )),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        //show message if no results and still loading or user didnt click search
                        noResults || secondLoading || !searchClicked
                            ? SizedBox(
                                height: 800,
                                //if no semester/speciality is selected, show message, if no results show message
                                child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Text(
                                        //if common issues list is loading from database
                                        secondLoading
                                            ? 'Wait...'
                                            //if loading is done but dropdowns are null
                                            : (specialityDropdownValue == null
                                                ? 'Please select speciality to find common issues.'
                                                //if no search clicked then tell user to click search, otherwise if it's clicked, no results are found
                                                : (searchClicked
                                                    ? 'There are no common issues available ${specialityDropdownValue?['id'] == '0' && semesterDropdownValue?['id'] == "0" ? 'currently.' : 'with the selected options.'}'
                                                    : 'Please click search to continue..')),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            height: 2,
                                            fontSize: 18,
                                            color: Colors.black54))))
                            : ciempty
                                ? Text("There are no common issues available",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        height: 2,
                                        fontSize: 18,
                                        color: Colors.black54))
                                :
                                //show all items if no loading and there are result from search

                                ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: commonIssuesList.length,
                                    itemBuilder: (context, index) {
                                      return _commonIssueDetails(
                                          title: commonIssuesList[index]
                                              ['issuetitle'],
                                          semester: semesterList.isNotEmpty
                                              ? (semesterList.firstWhereOrNull((element) =>
                                                          element?['ref'] ==
                                                          commonIssuesList[index]
                                                              ['semester'])?[
                                                      'semestername'] ??
                                                  "--")
                                              : "--",
                                          speciality: specialityList.isNotEmpty
                                              ? (specialityList.firstWhereOrNull(
                                                      (element) =>
                                                          element?['ref'] ==
                                                          commonIssuesList[index]
                                                              ['issuecategory'])?['specialityname'] ??
                                                  "--")
                                              : "--",
                                          commonIssue: commonIssuesList[index]);
                                    })
                      ],
                    )),
        ));
  }

  //to show every common issue as an item in the list
  _commonIssueDetails(
      {required String title,
      required String semester,
      required String speciality,
      required Map<String, dynamic> commonIssue}) {
    return InkWell(
      onTap: () {
        //after clicking on the issue, move to common issue view page
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    //we send common issue object item to the next page to show it
                    facultyViewFAQ(commonIssue: commonIssue))).then(
            (value) => setState(() {}));
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Card(
                color: Mycolors.mainColorBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17), // <-- Radius
                ),
                shadowColor: const Color.fromARGB(94, 114, 168, 243),
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(title, style: const TextStyle(fontSize: 18)),
                      subtitle: Text(
                        "\nSpeciality: $speciality\nSemester: $semester",
                        style: const TextStyle(fontSize: 14),
                      ),
                      textColor: Mycolors.mainColorWhite,
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),

                      // fontFamily: 'main',
                      // fontWeight: FontWeight.w600
                      // ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
