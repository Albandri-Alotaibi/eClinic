import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/UploadGPG.dart';
import 'package:myapp/graduatehome.dart';
import 'package:myapp/style/Mycolors.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _Loading();
}

class _Loading extends State<Loading> {
  bool contain = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: CircularProgressIndicator(
                color: Mycolors.mainShadedColorBlue)));
  }

  String? userid = '';
  @override
  void initState() {
    super.initState;
    repet();
  }

  bool found = false;
  repet() async {
    while (!found) {
      await Future.delayed(Duration(seconds: 1));
      cry();
    }
  }

  cry() async {
    //await Future.delayed(Duration(seconds: 2));
    print("in cry");
    final FirebaseAuth auth = await FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    userid = user!.uid;
    final snap = await FirebaseFirestore.instance
        .collection("graduate")
        .doc(userid)
        .get();
    var group = await snap['group'];
    final DocumentSnapshot groupRef = await group.get();
    // var GPname = groupRef['projectname'];
    // var groupid = groupRef.id;
    print("befor snap3");
    final snap3 = await FirebaseFirestore.instance
        .collection("GPlibrary")
        .where("group", isEqualTo: group)
        .get()
        .then((QuerySnapshot snapshot) {
      print("befor forEach");
      snapshot.docs.forEach((DocumentSnapshot doc) async {
        print("befor snapK");
        final snapK = doc.data() as Map<String, dynamic>;
        print("befor containsKey");
        if (snapK.containsKey("FileUrl")) {
          found = true;
          // if (snap["FileUrl"] != null)

          print("جا الزفت");
        }
      });
    });

    if (found == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => graduatehome(),
        ),
      );
    }
  }


}
