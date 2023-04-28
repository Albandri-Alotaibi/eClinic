import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/CommonIssueViewScreen.dart';
import 'package:myapp/style/Mycolors.dart';

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

    //add all Specialties to dropdown
    specialityList.insert(
        0, <String, dynamic>{"specialityname": "All Specialties", "id": "0"});

    specialityDropdownValue = specialityList[0];
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
        commonIssuesList.add(commonIssue);
        if (i > 0) {
          secondLoading = false;
        }
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
              backgroundColor: Colors.white,
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
                      child: CircularProgressIndicator(
                          color: Color.fromRGBO(21, 70, 160, 1)),
                    )
                  //when loading if done, show everything.
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                      children: <Widget>[
                        //------------------------- dropdowns [speciality/semester]
                        Column(children: [
                          Row(children: [
                            Expanded(
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Mycolors.mainShadedColorBlue,
                                          width: 1),
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(bottom: 0),
                                    child: DropdownButton<
                                            Map<String, dynamic>?>(
                                        // icon: const Icon(Icons.face),
                                        icon: const Icon(
                                          // Add this
                                          Icons.arrow_drop_down, // Add this
                                          color: Color.fromRGBO(
                                              21, 70, 160, 1), // Add this
                                        ),
                                        isExpanded: true,
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
                                              color:
                                                  themeData.colorScheme.primary,
                                              fontWeight: FontWeight.w400),
                                        ),

                                        // borderRadius: BorderRadius.circular(25),
                                        value: specialityDropdownValue,
                                        items: specialityList
                                            .map((Map<String, dynamic>? item) {
                                          return DropdownMenuItem(
                                              value: item,
                                              child: Text(
                                                  item?['specialityname'] ??
                                                      "--"));
                                        }).toList(),
                                        onChanged: (newValue) {
                                          if (newValue != null) {
                                            setState(() {
                                              //reset variables, to remove results and show messages
                                              specialityDropdownValue =
                                                  newValue;
                                              commonIssuesList = [];
                                              searchClicked = false;
                                              noResults = true;
                                              initCommonIssues();
                                            });
                                          }
                                        }))),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Mycolors.mainShadedColorBlue,
                                          width: 1),
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(bottom: 0),
                                    child: DropdownButton<
                                            Map<String, dynamic>?>(
                                        // icon: const Icon(Icons.pages),
                                        icon: const Icon(
                                          // Add this
                                          Icons.arrow_drop_down, // Add this
                                          color: Color.fromRGBO(
                                              21, 70, 160, 1), // Add this
                                        ),
                                        isExpanded: true,
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
                                              color:
                                                  themeData.colorScheme.primary,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        value: semesterDropdownValue,
                                        items: semesterList
                                            .map((Map<String, dynamic>? item) {
                                          return DropdownMenuItem(
                                              value: item,
                                              child: Text(
                                                  item?['semestername'] ??
                                                      "--"));
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
                                        }))),
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
                        const SizedBox(height: 10,),
                        //show message if no results and still loading or user didnt click search
                        noResults || secondLoading || !searchClicked
                            ? SizedBox(
                                height: 800,
                                //if no semester/speciality is selected, show message, if no results show message
                                child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Text(
                                        //if common issues list is loading from database
                                        secondLoading
                                            ? '' //add wait... later
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
                            :
                            //show all items if no loading and there are result from search
                            ListView.builder(

                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
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
                                          ? (specialityList.firstWhereOrNull((element) =>
                                                      element?['ref'] ==
                                                      commonIssuesList[index]
                                                          ['issuecategory'])?[
                                                  'specialityname'] ??
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
                    CommonIssueViewScreen(commonIssue: commonIssue))).then(
            (value) => setState(() {}));
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Card(
                color: Mycolors.mainShadedColorBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18), // <-- Radius
                ),
                shadowColor: const Color.fromARGB(94, 114, 168, 243),
                child: Padding(
                    padding: const EdgeInsets.all(15),
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
