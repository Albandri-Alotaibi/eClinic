import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/domain/extension.dart';
import 'package:myapp/model/GPlist.dart';

import 'package:myapp/style/Mycolors.dart';
import 'package:myapp/viewOneGP.dart';

class viewGPlibrary extends StatefulWidget {
  const viewGPlibrary({super.key});

  @override
  State<viewGPlibrary> createState() => _viewGPlibraryState();
}

class _viewGPlibraryState extends State<viewGPlibrary> {

  List<String> category = [];
 
  String? value;

  var searchClicked = false;
  var noResults = true;
  var firstLoading = true;
  var secondLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initGP();
  
    initCategory();
    initSemester();
  }

  List<Map<String, dynamic>?> categoryList = [];
  Map<String, dynamic>? categoryDropdownValue;
  Future initCategory() async {
    CollectionReference cats =
        FirebaseFirestore.instance.collection('gpcategory');
    QuerySnapshot q = await cats.get(const GetOptions(source: Source.server));

    categoryList = q.docs.map((doc) {
      var category = doc.data() as Map<String, dynamic>;

      category['id'] = doc.reference.id;
      category['ref'] = doc.reference;

      return category;
    }).toList();

    //add all Specialties to dropdown
    categoryList.insert(
        0, <String, dynamic>{"gpcategoryname": "All Categories", "id": "0"});

    categoryDropdownValue = categoryList[0];
  }

  List<Map<String, dynamic>?> semesterList = [];
  Map<String, dynamic>? semesterDropdownValue;
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

    //to sort the semesters from old to new
    semesterList.sortBySemesterAndYear();
    //add all semesters option to dropdown
    semesterList.insert(
        0, <String, dynamic>{"semestername": "All Semesters", "id": "0"});

    semesterDropdownValue = semesterList[0];

    setState(() {
      firstLoading = false;
    });

    // initGP();
  }

  List GPList = [];

  //get common issues by selected dropdowns (category / semester) refs
  void initGP() async {
    setState(() {
      secondLoading = true;
      searchClicked = true;
    });

    var gp = FirebaseFirestore.instance.collection('GPlibrary');

    //depends on the dropdown, make the query to database
    QuerySnapshot<Map<String, dynamic>> q;
    // QuerySnapshot<Map<String, dynamic>> q0;
    if (semesterDropdownValue != null &&
        semesterDropdownValue?['id'] != "0" &&
        categoryDropdownValue != null &&
        categoryDropdownValue?['id'] != "0") {
      q = await gp
          .where('semester', isEqualTo: semesterDropdownValue?['ref'])
          .where('GPcategory', arrayContains: categoryDropdownValue?['ref'])
          .get(const GetOptions(source: Source.server));
    } else if (semesterDropdownValue != null &&
        semesterDropdownValue?['id'] != "0") {
      q = await gp
          .where('semester', isEqualTo: semesterDropdownValue?['ref'])
          .get(const GetOptions(source: Source.server));
    } else if (categoryDropdownValue != null &&
        categoryDropdownValue?['id'] != "0") {
      q = await gp
          .where('GPcategory', arrayContains: categoryDropdownValue?['ref'])
          .get(const GetOptions(source: Source.server));
    } else {
      q = await gp.get(const GetOptions(source: Source.server));
    }

    GPList = [];

    var i = 0;
    for (var doc in q.docs) {
      var gps = doc.data();
      gps['id'] = doc.reference.id;
      gps['ref'] = doc.reference;

      //get gp name
      // List arrayOfStudent = doc['Students'];
      gps['projectname'] = "--";

      if (doc["group"] != null) {
        final DocumentSnapshot group = await doc["group"].get();
        if (group.exists) {
          String GPName = group?['projectname'] ?? "---";
          gps['projectname'] = GPName;
        }
        // print(gps['projectname']);
      }

      //get GP category and store the category names in a string w/o the last name so we dont hav , at the end
      List GPcatRef = doc['GPcategory'];
      // List AllCat = [];
      String gpCat = "";
      for (int i = 0; i < GPcatRef.length - 1; i++) {
        final DocumentSnapshot oneCat = await GPcatRef[i].get();
        // AllCat.add(oneCat['gpcategoryname']);
        gpCat = gpCat + oneCat['gpcategoryname'] + ", ";
      }
      //get last name
      final DocumentSnapshot oneCat = await GPcatRef.last.get();
      gpCat = gpCat + oneCat['gpcategoryname'];
      //stor the sting in gps
      gps['gpcategoryname'] = gpCat;
      print(gps['gpcategoryname']);

     

      i++;
      setState(() {
        GPList.add(gps);
        if (i > 0) {
          // secondLoading = false;
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
    //if (isExists == true) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Column(children: [
           
            Center(
              child: Row(children: [
                Expanded(
                  child: Container(
                    // padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: DropdownButtonFormField<Map<String, dynamic>?>(
                        // icon: const Icon(Icons.face),

                        isExpanded: true,
                        iconEnabledColor: Mycolors.mainShadedColorBlue,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Mycolors.mainShadedColorBlue)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Mycolors.mainShadedColorBlue))),
                        disabledHint: Row(children: const [
                          Text("---"),
                         
                        ]),
                        hint: Text(
                          "Select Category",
                          style: TextStyle(
                              fontSize: 14,
                              //color: themeData.colorScheme.primary,
                              fontWeight: FontWeight.w400),
                        ),
                        value: categoryDropdownValue,
                        items: categoryList.map((Map<String, dynamic>? item) {
                          return DropdownMenuItem(
                              value: item,
                              child: Text(item?['gpcategoryname'] ?? "--"));
                        }).toList(),
                        onChanged: secondLoading
                            ? null
                            : (newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    //reset variables, to remove results and show messages
                                    categoryDropdownValue = newValue;
                                    GPList = [];
                                    searchClicked = false;
                                    noResults = true;
                                    initGP();
                                  });
                                }
                              }),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Container(
                    //padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: DropdownButtonFormField<Map<String, dynamic>?>(
                        // icon: const Icon(Icons.pages),
                        iconEnabledColor: Mycolors.mainShadedColorBlue,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Mycolors.mainShadedColorBlue)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Mycolors.mainShadedColorBlue))),
                        disabledHint: Row(children: const [
                          Text("---"),
                        
                        ]),
                        hint: Text(
                          "Select Semester",
                          style: TextStyle(
                              fontSize: 14,
                              // color: themeData.colorScheme.primary,
                              fontWeight: FontWeight.w400),
                        ),
                        value: semesterDropdownValue,
                        items: semesterList.map((Map<String, dynamic>? item) {
                          return DropdownMenuItem(
                              value: item,
                              child: Text(item?['semestername'] ?? "--"));
                        }).toList(),
                        onChanged: secondLoading
                            ? null
                            : (newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    //reset variables, to remove results and show messages
                                    semesterDropdownValue = newValue;
                                    GPList = [];
                                    searchClicked = false;
                                    initGP();
                                    // noResults = true;
                                  });
                                }
                              }),
                  ),
                ),
              ]),
            ),
           
            //show message if no results and still loading or user didnt click search
            noResults || secondLoading || !searchClicked
                ? SizedBox(
                    height: 800,
                    //if no semester/speciality is selected, show message, if no results show message
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: secondLoading
                          ? Center(
                              child: CircularProgressIndicator(
                              color: Mycolors.mainShadedColorBlue,
                            ))
                          : categoryDropdownValue == null
                              ? Center(
                                  child: CircularProgressIndicator(
                                  color: Mycolors.mainShadedColorBlue,
                                ))
                              : Text(
                                  ((searchClicked
                                      ? 'There are no graduation projects available.'
                                      : 'Please click filter to continue..')),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      height: 2,
                                      fontSize: 18,
                                      color: Colors.black54),
                                ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: GPList.length,
                    itemBuilder: ((context, index) {
                      if (index < GPList.length) {
                        return Card(
                          margin: EdgeInsets.only(bottom: 10, top: 10),
                          color: Mycolors.mainShadedColorBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(17), // <-- Radius
                          ),
                          shadowColor: Color.fromARGB(94, 250, 250, 250),
                          elevation: 20,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              textColor: Mycolors.mainColorWhite,
                              title: Text(
                                GPList[index]['projectname'],
                                style: TextStyle(
                                    //color: Mycolors.mainColorBlack,
                                    fontFamily: 'main',
                                    fontSize: 20),
                              ),
                              subtitle: Text(
                                  "\nCategory: " +
                                      GPList[index]['gpcategoryname'] +
                                      "\n" +
                                      "Semester: " +
                                      (semesterList.isNotEmpty
                                          ? (semesterList.firstWhereOrNull(
                                                      (element) =>
                                                          element?['ref'] ==
                                                          GPList[index]
                                                              ['semester'])?[
                                                  'semestername'] ??
                                              "--")
                                          : "--"),
                                  style: TextStyle(
                                      //color: Mycolors.mainColorBlack,
                                      fontFamily: 'main',
                                      fontSize: 14)),
                              trailing: const Icon(
                                Icons.chevron_right,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => viewOneGP(
                                      GPid: GPList[index]['id'],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }),
                  )
            //  }),
          ]),
        ],
      ),
    ));
    // } else {
    //   return Center(child: CircularProgressIndicator());
    // }
  }

  getInfo(index) async {
    print("=======================getinfo====================");
    DocumentSnapshot doc = await GPList[index]["ref"].get();
    //get gp name
    print(doc['Students']);
    // Map<String, dynamic> gps;
    List arrayOfStudent = doc['Students'];
    final DocumentSnapshot oneStudent = await arrayOfStudent[0].get();
    String GPName = oneStudent['projectname'];
    GPList[index]['projectname'] = GPName;
    print(GPList[index]['projectname']);

    //get GP category and store the category names in a string w/o the last name so we dont hav , at the end
    List GPcatRef = doc['GPcategory'];
    // List AllCat = [];
    String gpCat = "";
    for (int i = 0; i < GPcatRef.length - 1; i++) {
      final DocumentSnapshot oneCat = await GPcatRef[i].get();
      // AllCat.add(oneCat['gpcategoryname']);
      gpCat = gpCat + oneCat['gpcategoryname'] + ", ";
    }
    //get last name
    final DocumentSnapshot oneCat = await GPcatRef.last.get();
    gpCat = gpCat + oneCat['gpcategoryname'];
    //stor the sting in gps
    GPList[index]['gpcategoryname'] = gpCat;
    print(GPList[index]['gpcategoryname']);

    return Text(GPList[index]['projectname'] +
        "Category: " +
        GPList[index]['gpcategoryname']);
  }

  getGPname(index) async {
    // DocumentSnapshot doc = await GPList[index]["ref"].get();
    //get gp name
    print(GPList[index]['Students']);
    // Map<String, dynamic> gps;
    List arrayOfStudent = GPList[index]['Students'];
    final DocumentSnapshot oneStudent = await arrayOfStudent[0].get();
    String GPName = oneStudent['projectname'];
    GPList[index]['projectname'] = GPName;
    print(GPList[index]['projectname']);
    return Text(GPName);
  }
}
