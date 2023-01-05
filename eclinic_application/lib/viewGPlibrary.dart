import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/model/GPlist.dart';
import 'package:myapp/viewOneGP.dart';

class viewGPlibrary extends StatefulWidget {
  const viewGPlibrary({super.key});

  @override
  State<viewGPlibrary> createState() => _viewGPlibraryState();
}

class _viewGPlibraryState extends State<viewGPlibrary> {
  String? email = '';
  String? userid = '';
  int numOfGPdocs = 0; // DELETE THIS !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  bool? isExists;
  List GPdocs = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    userid = user!.uid;
    email = user.email!;
    IsGPExists();
    Future.delayed(Duration(seconds: 2), (() {
      setState(() {});
    }));
  }

  @override
  Widget build(BuildContext context) {
    if (isExists == true) {
      return SafeArea(
          child: Scaffold(
        body: Column(children: [
          Expanded(
            child: FutureBuilder(
                future: getAllGPdocs(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: GPdocs.length,
                    itemBuilder: ((context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(GPdocs[index].GPname),
                          subtitle: Text(GPdocs[index].categoryAndsemester()),
                          trailing: Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => viewOneGP(
                                  GPid: GPdocs[index].id,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  );
                }),
          )
        ]),
      ));
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Future<bool?> IsGPExists() async {
    final snap = await FirebaseFirestore.instance.collection("GPlibrary").get();
    if (snap.size == 0) {
      // print("*******&&&&&&&&&&&&&&&&&&&^^^^^^^^^^^^^^^^^^");
      // print("empty");
      setState(() {
        isExists = false;
      });

      return isExists;
    } else {
      // print("*******&&&&&&&&&&&&&&&&&&&^^^^^^^^^^^^^^^^^^");
      // print("full");
      setState(() {
        isExists = true;
      });

      return isExists;
    }
  }

  //return GP doc
  Future getAllGPdocs() async {
    final GPdocSnapshot = await FirebaseFirestore.instance
        .collection("GPlibrary")
        .get()
        .then((QuerySnapshot snapshot) {
      numOfGPdocs = snapshot.size;
      snapshot.docs.forEach((DocumentSnapshot doc) async {
        // numOfGPdocs++;
        List arrayOfStudent = doc['Students'];
        print(arrayOfStudent);
        final DocumentSnapshot oneStudent = await arrayOfStudent[0].get();
        print(oneStudent);
        String GPName = oneStudent['projectname'];
        print(GPName);

        //get GP category refrence and store the category names in an array
        List GPcatRef = doc['GPcategory'];
        List AllCat = [];
        for (int i = 0; i < GPcatRef.length; i++) {
          final DocumentSnapshot oneCat = await GPcatRef[i].get();
          AllCat.add(oneCat['gpcategoryname']);
        }
        print(AllCat);

        //doing the same thing for semester
        var semesterRef = doc['semester'];
        final DocumentSnapshot onesem = await semesterRef.get();
        String semesterName = onesem['semestername'];
        GPdocs.add(GPlist(
            id: doc.id,
            GPname: GPName,
            CodeLink: doc['CodeLink'],
            FileUrl: doc['FileUrl'],
            GPcategory: AllCat,
            Students: doc['Students'],
            semester: semesterName));
        print(GPdocs[0].toString());
      });
    });
  }
}
