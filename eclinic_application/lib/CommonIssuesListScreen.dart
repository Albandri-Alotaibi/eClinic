import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/CommonIssueViewScreen.dart';

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

    semesterList.insert(
        0, <String, dynamic>{"semestername": "All Semesters", "id": "0"});

    semesterDropdownValue = semesterList[0];

    setState(() {
      firstLoading = false;
    });
  }

  //get common issues by selected dropdowns (speciality / semester) refs
  void initCommonIssues() async {
    if (specialityDropdownValue == null) {
      return;
    }

    setState(() {
      secondLoading = true;
      searchClicked = true;
    });

    var ci = FirebaseFirestore.instance.collection('commonissue');

    // print(specialityDropdownValue?['ref'].toString());
    QuerySnapshot<Map<String, dynamic>> q;
    if (semesterDropdownValue != null && semesterDropdownValue?['id'] != "0") {
      q = await ci
          .where('semester', isEqualTo: semesterDropdownValue?['ref'])
          .where('issuecategory', isEqualTo: specialityDropdownValue?['ref'])
          .get(const GetOptions(source: Source.server));
    } else {
      q = await ci
          .where('issuecategory', isEqualTo: specialityDropdownValue?['ref'])
          .get(const GetOptions(source: Source.server));
    }
    commonIssuesList = [];

    for (var doc in q.docs) {
      var commonIssue = doc.data();
      commonIssue['id'] = doc.reference.id;
      commonIssue['ref'] = doc.reference;

      setState(() {
        commonIssuesList.add(commonIssue);
      });
    }

    setState(() {
      noResults = q.docs.isEmpty;

      secondLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Common Issues",
        home: SafeArea(
          child: Scaffold(
              appBar: AppBar(
                title: const Text("Common Issues"),
                leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
              body: firstLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView(
                      padding: const EdgeInsets.all(24),
                      children: <Widget>[
                        //------------------------- dropdowns [speciality/semester]
                        Column(children: [
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
                                      //reset variables, to remove results and show messages
                                      specialityDropdownValue = newValue;
                                      commonIssuesList = [];
                                      searchClicked = false;
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
                                      //reset variables, to remove results and show messages
                                      semesterDropdownValue = newValue;
                                      commonIssuesList = [];
                                      searchClicked = false;
                                      noResults = true;
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
                                        //if common issues list is loading from database
                                        secondLoading
                                            ? 'Wait...'
                                            //if loading is done but dropdowns are null
                                            : (specialityDropdownValue == null
                                                ? 'Please select speciality to find common issues.'
                                                //if no search clicked
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
  _commonIssueDetails(
      {required String title, required Map<String, dynamic> commonIssue}) {
    return InkWell(
      onTap: () {
        //after clicking on the issue, move to common issue view page
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    //we send common issue object item to the next page to show it
                    CommonIssueViewScreen(commonIssue: commonIssue))).then(
            (value) => setState(() {
                  //..
                }));
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
