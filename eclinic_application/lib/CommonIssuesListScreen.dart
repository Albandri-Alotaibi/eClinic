import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommonIssuesListScreen extends StatefulWidget {
  const CommonIssuesListScreen({super.key});

  @override
  CommonIssuesListScreenState createState() => CommonIssuesListScreenState();
}

class CommonIssuesListScreenState extends State<CommonIssuesListScreen> {
  late ThemeData themeData;

  Map<String, dynamic>? specialityDropdownValue;
  Map<String, dynamic>? semesterDropdownValue;
  List commonIssuesList = [];
  List<Map<String, dynamic>?> specialityList = [];
  List<Map<String, dynamic>?> semesterList = [];
  var firstLoading = true;
  var secondLoading = false;
  var noResults = true;
  var searchClicked = false;

  @override
  void initState() {
    super.initState();

    //get specialities for dropdown
    initSpeciality();

    //get semesters for dropdown
    initSemester();
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

    setState(() {
      firstLoading = false;
    });
  }

  //get common issues by selected dropdowns (speciality / semester) refs
  void initCommonIssues() async {
    setState(() {
      secondLoading = true;
      searchClicked = true;
    });

    var ci = FirebaseFirestore.instance.collection('commonissue');

    print(specialityDropdownValue?['ref'].toString());

    var q = await ci
        // .where('semester', isEqualTo: semesterDropdownValue?['ref'])
        .where('issuecategory', isEqualTo: specialityDropdownValue?['ref'])
        .get(const GetOptions(source: Source.server));

    commonIssuesList = [];

    for (var doc in q.docs) {
      var commonIssue = doc.data();
      commonIssue['id'] = doc.reference.id;
      commonIssue['ref'] = doc.reference;

      setState(() {
        noResults = q.docs.isEmpty;

        commonIssuesList.add(commonIssue);
      });
    }

    setState(() {
      secondLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "xxx",
        home: SafeArea(
          child: Scaffold(
              body: firstLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView(
                      padding: const EdgeInsets.all(24),
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.chevron_left),
                          ),
                        ),
                        //------------------------- dropdowns [speciality/semester]
                        Column(children: [
                          Row(children: [
                            Text(
                              "Common Issues",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: themeData.colorScheme.primary,
                                  fontWeight: FontWeight.w600),
                            ),
                          ]),
                          Row(children: [
                            DropdownButton<Map<String, dynamic>?>(
                                // icon: const Icon(Icons.face),
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
                                      specialityDropdownValue = newValue;
                                    });
                                  }
                                }),
                            const Spacer(),
                            DropdownButton<Map<String, dynamic>?>(
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
                                      child:
                                          Text(item?['semestername'] ?? "--"));
                                }).toList(),
                                onChanged: (newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      semesterDropdownValue = newValue;
                                    });
                                  }
                                }),
                          ]),
                          Row(children: [
                            Expanded(
                                child: ElevatedButton(
                              onPressed: () => {initCommonIssues()},
                              child: const Text('Search'),
                            ))
                          ]),
                        ]),
                        //--------------------------- end dropdowns
                        SizedBox(
                            height: 800,
                            //if no semester/speciality is selected, show message, if no results show message
                            child: noResults || secondLoading
                                ? Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Text(
                                        secondLoading
                                            ? 'Wait...'
                                            : (specialityDropdownValue ==
                                                        null &&
                                                    semesterDropdownValue ==
                                                        null
                                                ? 'Please select speciality/semester to find common issues.'
                                                : (searchClicked
                                                    ? 'There are no common issues available with the selected options.'
                                                    : 'Please click search to continue..')),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            height: 2,
                                            fontSize: 18,
                                            color: Colors.blue)))
                                : ListView.builder(
                                    itemCount: commonIssuesList.length,
                                    itemBuilder: (context, index) {
                                      return _commonIssueDetails(
                                          title: commonIssuesList[index]
                                              ['issuetitle'],
                                          commonIssue: commonIssuesList[index]);
                                    }))
                      ],
                    )),
        ));
  }

  //to show every common issue as an item in the list
  _commonIssueDetails({required String title, required Map commonIssue}) {
    return InkWell(
      onTap: () {
        //after clicking on the issue, move to common issue view page
        // Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) =>
        //                 CommonIssueViewScreen(commonIssue: commonIssue)))
        //     .then((value) => setState(() {
        //           //..
        //         }));
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                          title,
                          style: TextStyle(
                              color: themeData.colorScheme.primary,
                              fontWeight: FontWeight.w600),
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
}
