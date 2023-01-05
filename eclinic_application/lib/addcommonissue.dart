import 'dart:io';

import 'package:flutter/gestures.dart';
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
import 'package:url_launcher/url_launcher.dart';

class addcommonissue extends StatefulWidget {
  const addcommonissue({super.key});

  @override
  State<addcommonissue> createState() => _addcommonissueState();
}

class _addcommonissueState extends State<addcommonissue> {
  @override
  List<String> specality = [];
  var semesterRef;
  var userid;
  var problem;
  var solution;
  var isuuetitle;
  var uploud;
  var docforspeciality;
  var refforspe;
  var link;
  List links = [];
  bool exist = true;
  var title;
  var showlink;
  final formkey = GlobalKey<FormState>();
  final formkeyforlink = GlobalKey<FormState>();
  final _issuetitleconstroller = TextEditingController();
  final _problemController = TextEditingController();
  final _solutioncontroll = TextEditingController();
  final _linkcontroll = TextEditingController();
  RegExp english = RegExp("^[\u0000-\u007F]+\$");
  var specialityselectedvalue;
  void initState() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    userid = user!.uid;
    retrivespeciality();
    print(userid);
    // TODO: implement initState
    super.initState();
  }

  retrivespeciality() async {
    specality.clear();
    final snap = await FirebaseFirestore.instance
        .collection('faculty')
        .doc(userid)
        .get();
    List facultyspecialityRef = snap["specialty"];
    semesterRef = snap["semester"];
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

  retriveissuetitle(String title) async {
    // exist = true;
    // print("00000000000000000000000000000");
    var snap = await FirebaseFirestore.instance
        .collection('commonissue')
        .where("issuetitle", isEqualTo: title)
        .get();
    print(snap.docs);
    if (snap.size > 0) {
      print("ddddddddddddddddddddddd");
      exist = false;
    } else {
      exist = true;
    }
    //   .then((querySnapshot) {
    // querySnapshot.docs.forEach((element) {
    //   print("llllllllllllllllllllllllllllllll");
    //   print(element['issuecategory'].id);
    //   print("HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH");
    //   print(docforspeciality);

    //   if (element['issuecategory'].id == docforspeciality &&
    //       title == element['issuetitle']) {
    //     print("i get it");

    //     setState(() {
    //       exist = false;
    //       return;
    //     });
    //   } else if (element['issuecategory'].id == docforspeciality &&
    //       title != element['issuetitle'] &&
    //       exist) {
    //     exist = true;
    //   }

    //  else if (element['issuecategory'].id == docforspeciality &&
    //     title != element['issuetitle']) {
    //   print("i take it ");

    //   exist = true;
    // }

    // if (element['issuecategory'].id != docforspeciality) {
    //   print("");
    //   exist = true;
    // }
    //   });
    // });
  }

  checkids(String? spe) async {
    try {
      print(spe);
      await FirebaseFirestore.instance
          .collection('facultyspeciality')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          setState(() {
            if (spe == element['specialityname']) {
              print(element.id);
              docforspeciality = element.id;
              retriveissuetitle(_issuetitleconstroller.text);

              print(refforspe);
            }
          });
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Widget build(BuildContext context) {
    var userid;

    RegExp english = RegExp("^[\u0000-\u007F]+\$");
    StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return addcommonissue();
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
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                          checkids(specialityselectedvalue);
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
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                        controller: _issuetitleconstroller,
                        decoration: InputDecoration(
                            labelText: ' issue title :',
                            hintText: "Enter issue title",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: const BorderSide(
                                  width: 0,
                                ))),
                        onChanged: (value) {
                          setState(() {
                            retriveissuetitle(_issuetitleconstroller.text);
                          });
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty ||
                              _issuetitleconstroller.text == "") {
                            return 'Please enter issue title ';
                          } else {
                            if (!(english
                                .hasMatch(_issuetitleconstroller.text))) {
                              return "only english is allowed";
                            }
                          }
                          if (!(value.isEmpty ||
                              _issuetitleconstroller.text == "")) {
                            // retriveissuetitle(
                            //     _issuetitleconstroller.text);
                          }
                        }),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: _problemController,
                      minLines: 4,
                      maxLines: 10,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          //   labelText: ' problem :',
                          hintText: "Enter issue description ",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                width: 0,
                              ))),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty || _problemController.text == "") {
                          return 'Please enter issue description';
                        } else {
                          if (!(english.hasMatch(_problemController.text))) {
                            return "only english is allowed";
                          }
                        }
                      },
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: _solutioncontroll,
                      minLines: 4,
                      maxLines: 10,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          // labelText: ' Solution :',
                          hintText: "Enter the solution ",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                width: 0,
                              ))),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty || _solutioncontroll.text == "") {
                          return 'Please enter the solution';
                        } else {
                          if (!(english.hasMatch(_solutioncontroll.text))) {
                            return "only english is allowed";
                          }
                        }
                      },
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    if (links.length > 0)
                      for (var i = 0; i < links.length; i++)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: links[i],
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        var url = links[i];
                                        // ignore: deprecated_member_use
                                        if (await canLaunch(url)) {
                                          // ignore: deprecated_member_use
                                          launch(url);
                                        } else {
                                          throw "Cannot load url";
                                        }
                                      })
                              ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 1),
                              child: IconButton(
                                  onPressed: (() =>
                                      ConfirmationDialogfordelete(context, i)),
                                  icon: Icon(
                                    Icons.cancel,
                                    size: 20,
                                  )),
                            )
                          ],
                        ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            textStyle:
                                TextStyle(fontFamily: 'main', fontSize: 16),
                            shadowColor: Colors.blue[900],
                            elevation: 16,
                            backgroundColor: Mycolors.mainShadedColorBlue,
                            minimumSize: Size(150, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(17), // <-- Radius
                            ),
                          ),
                          onPressed: (() {
                            //
                          }),
                          child: Text("upload file "),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            textStyle:
                                TextStyle(fontFamily: 'main', fontSize: 16),
                            shadowColor: Colors.blue[900],
                            elevation: 16,
                            backgroundColor: Mycolors.mainShadedColorBlue,
                            minimumSize: Size(150, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(17), // <-- Radius
                            ),
                          ),
                          onPressed: (() {
                            _linkcontroll.text = "";
                            showConfirmationDialog(context);
                          }),
                          child: Text("add link"),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
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
                      onPressed: () async {
                        if (formkey.currentState!.validate()) {
                          retriveissuetitle(_issuetitleconstroller.text);

                          if (exist == true) {
                            confirm(context);
                          }
                          if (exist == false) {
                            showerror(context,
                                "there is common issue with the same title please check ");
                          }
                        }
                      },
                      child: Text("Add"),
                    ),
                  ]))),
    )));
  }

  showConfirmationDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
        shadowColor: Colors.blue[900],
        elevation: 20,
        backgroundColor: Mycolors.mainShadedColorBlue,
        minimumSize: Size(60, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // <-- Radius
        ),
      ),
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog

    Widget continueButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
        shadowColor: Colors.blue[900],
        elevation: 20,
        backgroundColor: Mycolors.mainShadedColorBlue,
        minimumSize: Size(70, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // <-- Radius
        ),
      ),
      child: Text("Add"),
      onPressed: () {
        if (formkeyforlink.currentState!.validate()) {
          setState(() {
            link = _linkcontroll.text;
            print(link);
            links.add(link);

            Navigator.of(context).pop();
          });
        }
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(""),
      content: SizedBox(
        height: 100,
        child: Form(
          key: formkeyforlink,
          child: Column(
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: 350,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              SizedBox(
                width: 350,
                child: TextFormField(
                    controller: _linkcontroll,
                    decoration: InputDecoration(
                        labelText: 'Link',
                        hintText: "Paste the link ",
                        border: OutlineInputBorder()),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty || _linkcontroll.text == "") {
                        return 'Please paste the link';
                      } else {
                        if (!(english.hasMatch(_linkcontroll.text))) {
                          return "only english is allowed";
                        }
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    // show the dialog
  }

  confirm(BuildContext context) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
        shadowColor: Colors.blue[900],
        elevation: 20,
        backgroundColor: Mycolors.mainShadedColorBlue,
        minimumSize: Size(60, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // <-- Radius
        ),
      ),
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog

    Widget continueButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
        shadowColor: Colors.blue[900],
        elevation: 20,
        backgroundColor: Mycolors.mainShadedColorBlue,
        minimumSize: Size(70, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // <-- Radius
        ),
      ),
      child: Text("confirm"),
      onPressed: () async {
        if (formkey.currentState!.validate()) {
          setState(() async {
            problem = _problemController.text;
            solution = _solutioncontroll.text;
            isuuetitle = _issuetitleconstroller.text;
            await FirebaseFirestore.instance
                .collection('commonissue')
                .doc()
                .set({
              "issuetitle": isuuetitle,
              "problem": problem,
              "solution": solution,
              "document": null,
              "semester": semesterRef,
              "issuecategory": FirebaseFirestore.instance
                  .collection("facultyspeciality")
                  .doc(docforspeciality),
              "links": links,
            });
            Navigator.pushNamed(context, 'facultyFAQ');
          });
        }
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(""),
      content: SizedBox(
        height: 100,
        child: Form(
          key: formkeyforlink,
          child: Column(
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: 350,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                  "Note : you will add common issue under ${specialityselectedvalue} specialty "),
            ],
          ),
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    // show the dialog
  }

  showerror(BuildContext context, String msg) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            height: 90,
            decoration: BoxDecoration(
                color: Color(0xFFC72C41),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Row(
              children: [
                SizedBox(
                  width: 48,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   "Oh snap!",
                      //   style: TextStyle(
                      //     color: Colors.white,
                      //     fontSize: 12,
                      //   ),
                      // ),
                      Text(
                        msg,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ));
  }

  ConfirmationDialogfordelete(BuildContext context, var i) {
    Widget dontCancelAppButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
        shadowColor: Colors.blue[900],
        elevation: 20,
        backgroundColor: Mycolors.mainShadedColorBlue,
        minimumSize: Size(60, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // <-- Radius
        ),
      ),
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget YesCancelAppButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
        shadowColor: Colors.blue[900],
        elevation: 20,
        backgroundColor: Mycolors.mainShadedColorBlue,
        minimumSize: Size(60, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // <-- Radius
        ),
      ),
      child: Text("Yes"),
      onPressed: () async {
        links.remove(links[i]);
        Future.delayed(Duration(seconds: 0), () {
          setState(() {});
        });
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      // title: Text("LogOut"),
      content: Text("Are you sure you want to delete this link ?"),
      actions: [
        dontCancelAppButton,
        YesCancelAppButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
