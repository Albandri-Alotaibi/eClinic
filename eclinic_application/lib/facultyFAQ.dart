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
import 'model/commonissue.dart';

class facultyFAQ extends StatefulWidget {
  // const deem({super.key});

  @override
  State<facultyFAQ> createState() => _facultyFAQState();
}

class _facultyFAQState extends State<facultyFAQ> {
  @override
  @override
  List<String> specality = [];
  List sp = [];
  List<commonissue> Allcommonissue = [];
  final formkey = GlobalKey<FormState>();
  var userid;
  var specialityselectedvalue;
  var numofcommonissueunderfacultyspeciality = 0;
  void initState() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    userid = user!.uid;
    print(userid);
    // TODO: implement initState
    retrivespeciality();
    getcommonissue();
    super.initState();
  }

  retrivespeciality() async {
    specality.clear();
    final snap = await FirebaseFirestore.instance
        .collection('faculty')
        .doc(userid)
        .get();
    List facultyspecialityRef = snap["specialty"];
    sp = snap["specialty"];
    print(sp);
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

  getcommonissue() async {
    await FirebaseFirestore.instance
        .collection('commonissue')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        String title = element['issuetitle'];
        String id = element.id;
        // print(sp);
        // print(element.id);
        setState(() {
          if (sp.contains(element['issuecategory'])) {
            print(sp);
            print(element.id);
            numofcommonissueunderfacultyspeciality++;
            Allcommonissue.add(
                new commonissue(cid: element.id, issuetitle: title));
            print(element.id);
          }
        });
      });
    });
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
      body: SingleChildScrollView(
        child: Container(
            child: Form(
          key: formkey,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
            //  Expanded(child: ListView.builder(itemCount: numofcommonissueunderfacultyspeciality,itemBuilder: ((context, index){
            //    if (index < Allcommonissue.length){
            //       return Card()
            //    }
            //  })),),
            SizedBox(
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: numofcommonissueunderfacultyspeciality,
                itemBuilder: ((context, index) {
                  if (index < Allcommonissue.length) {
                    return Card(
                      margin: EdgeInsets.only(bottom: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17), // <-- Radius
                      ),
                      shadowColor: Color.fromARGB(94, 250, 250, 250),
                      elevation: 20,
                      child: Row(
                        children: [
                          Text(Allcommonissue[index].issuetitle),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, 'addcommonissue');
                            },
                            child: Text("learnMore>>"),
                          )
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
              ),
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
        )),
      ),
    ));
  }
}
