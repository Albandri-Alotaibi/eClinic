import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multiselect/multiselect.dart';
import 'package:intl/intl.dart';
import 'style/Mycolors.dart';
import 'package:myapp/home.dart';

class facultyFAQ extends StatefulWidget {
  // const deem({super.key});

  @override
  State<facultyFAQ> createState() => _facultyFAQState();
}

class _facultyFAQState extends State<facultyFAQ> {
  @override
  @override
  List<String> specality = [];
  final formkey = GlobalKey<FormState>();
  var userid;
  var specialityselectedvalue;
  void initState() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    userid = user!.uid;
    print(userid);
    // TODO: implement initState
    retrivespeciality();
    super.initState();
  }

  retrivespeciality() async {
    specality.clear();
    final snap = await FirebaseFirestore.instance
        .collection('faculty')
        .doc(userid)
        .get();
    List facultyspecialityRef = snap["specialty"];
    for (var i = 0; i < facultyspecialityRef.length; i++) {
      final DocumentSnapshot docRef = await facultyspecialityRef[i].get();
      setState(() {
        specality.add(docRef["specialityname"]);
        print(docRef["specialityname"]);
        print(specality);
        print("222222222222222222222");
      });
    }
  }

  Widget build(BuildContext context) {
    StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return facultyFAQ();
          } else {
            return home();
          }
        }));

    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Form(
            key: formkey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: ' Choose your specialty : ',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(
                        width: 0,
                      )),
                ),
                isExpanded: true,
                items: specality.map((String dropdownitems) {
                  return DropdownMenuItem<String>(
                    value: dropdownitems,
                    child: Text(dropdownitems),
                  );
                }).toList(),
                onChanged: (String? newselect) {
                  setState(() {
                    specialityselectedvalue = newselect;
                  });
                },
                value: specialityselectedvalue,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null ||
                      specialityselectedvalue!.isEmpty ||
                      specialityselectedvalue == null) {
                    return 'Please choose your specialty';
                  }
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
                  shadowColor: Colors.blue[900],
                  elevation: 16,
                  backgroundColor: Mycolors.mainShadedColorBlue,
                  minimumSize: Size(150, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17), // <-- Radius
                  ),
                ),
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    Navigator.pushNamed(context, 'addcommonissue');
                  }
                },
                child: Text("Add"),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
