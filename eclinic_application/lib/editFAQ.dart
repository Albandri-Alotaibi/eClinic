import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myapp/viewFAQ.dart';
import 'editFAQ.dart';
import 'style/Mycolors.dart';
import 'package:url_launcher/url_launcher.dart';

class editFAQ extends StatefulWidget {
  String? value;
  editFAQ({super.key, required this.value});

  @override
  State<editFAQ> createState() => _editFAQState();
}

class _editFAQState extends State<editFAQ> {
  @override
  void initState() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    userid = user!.uid;
    // TODO: implement initState
    super.initState();
    getcommonissue();
    getfacultysemester();
  }

  var userid;
  final formkey = GlobalKey<FormState>();
  final formkeyforlink = GlobalKey<FormState>();
  var link;
  var title;
  var problem;
  var solution;
  var newproblem;
  var newsolution;
  List newlinks = [];
  List links = [];
  var i;
  var snap;
  bool exist = false;
  var semesterref;
  var _issuetitleconstroller = TextEditingController();
  var _problemController = TextEditingController();
  var _solutioncontroll = TextEditingController();
  final _linkcontroll = TextEditingController();
  RegExp english = RegExp("^[\u0000-\u007F]+\$");

  getcommonissue() async {
    snap = await FirebaseFirestore.instance
        .collection('commonissue')
        .doc(widget.value)
        .get();
    title = snap["issuetitle"];
    problem = snap["problem"];
    solution = snap["solution"];
    links = snap["links"];
    if (title != null) {
      exist = true;
    }
    print(problem);
    print(solution);
    print(links);

    print(widget.value);
  }

  getfacultysemester() async {
    var snap = await FirebaseFirestore.instance
        .collection('faculty')
        .doc(userid)
        .get();
    semesterref = snap["semester"];
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
            clipBehavior: Clip.none,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formkey,
                child: Column(children: [
                  FutureBuilder(
                      future: getcommonissue(),
                      builder: ((context, snapshot) {
                        _issuetitleconstroller =
                            TextEditingController(text: title);
                        _problemController =
                            TextEditingController(text: problem);
                        _solutioncontroll =
                            TextEditingController(text: solution);
                        return Column(
                          children: [
                            TextFormField(
                              controller: _issuetitleconstroller,
                              readOnly: true,
                              decoration: InputDecoration(
                                  labelText: ' issue title :',
                                  // hintText: "Enter issue title",

                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                        width: 0,
                                      ))),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              controller: _problemController,
                              minLines: 4,
                              maxLines: 10,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.edit),
                                  labelText: ' problem :',
                                  hintText: "Enter issue description ",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                        width: 0,
                                      ))),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty ||
                                    _problemController.text == "") {
                                  return 'Please enter issue description';
                                } else {
                                  if (!(english
                                      .hasMatch(_problemController.text))) {
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
                                  suffixIcon: Icon(Icons.edit),
                                  labelText: ' Solution :',
                                  hintText: "Enter the solution ",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                        width: 0,
                                      ))),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty ||
                                    _solutioncontroll.text == "") {
                                  return 'Please enter the solution';
                                } else {
                                  if (!(english
                                      .hasMatch(_solutioncontroll.text))) {
                                    return "only english is allowed";
                                  }
                                }
                              },
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            if (links.length > 0)
                              for (i = 0; i < links.length; i++)
                                Padding(
                                  padding: const EdgeInsets.only(right: 200),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "More Resources ${links.length}",
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Mycolors.mainColorBlue,
                                            fontFamily: 'bold',
                                            fontSize: 17),
                                        textAlign: TextAlign.start,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                  text: links[i],
                                                  style: TextStyle(
                                                      decoration: TextDecoration
                                                          .underline,
                                                      color: Colors.blue),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () async {
                                                          var url = links[i];
                                                          // ignore: deprecated_member_use
                                                          if (await canLaunch(
                                                              url)) {
                                                            // ignore: deprecated_member_use
                                                            launch(url);
                                                          } else {
                                                            throw "Cannot load url";
                                                          }
                                                        })
                                            ]),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 1),
                                            child: IconButton(
                                                onPressed: (() {
                                                  links.remove(links[i]);
                                                  getcommonissue();
                                                }),
                                                icon: Icon(
                                                  Icons.cancel,
                                                  size: 20,
                                                )),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    textStyle: TextStyle(
                                        fontFamily: 'main', fontSize: 16),
                                    shadowColor: Colors.blue[900],
                                    elevation: 16,
                                    backgroundColor:
                                        Mycolors.mainShadedColorBlue,
                                    minimumSize: Size(150, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          17), // <-- Radius
                                    ),
                                  ),
                                  onPressed: (() {
                                    //
                                  }),
                                  child: Text("upload file"),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    textStyle: TextStyle(
                                        fontFamily: 'main', fontSize: 16),
                                    shadowColor: Colors.blue[900],
                                    elevation: 16,
                                    backgroundColor:
                                        Mycolors.mainShadedColorBlue,
                                    minimumSize: Size(150, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          17), // <-- Radius
                                    ),
                                  ),
                                  onPressed: (() {
                                    _linkcontroll.text = "";
                                    showConfirmationDialog(context);
                                  }),
                                  child: Text("add link"),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    textStyle: TextStyle(
                                        fontFamily: 'main', fontSize: 16),
                                    shadowColor: Colors.blue[900],
                                    elevation: 16,
                                    backgroundColor:
                                        Mycolors.mainShadedColorBlue,
                                    minimumSize: Size(150, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          17), // <-- Radius
                                    ),
                                  ),
                                  onPressed: (() {
                                    ConfirmationDialogfordelete(context);
                                  }),
                                  child: Text("delete common issue"),
                                ),
                              ],
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
                              onPressed: () {
                                ConfirmationDialogforupdate(context);
                              },
                              child: Text("Save changes"),
                            ),
                          ],
                        );
                      }))
                ]),
              ),
            )),
      ),
    );
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
          link = _linkcontroll.text;
          print("llllllllllllllllllllliiiiiiiiinnnnnnnnkkkkkkkkkssssss");
          links.add(link);

          Navigator.of(context).pop();
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

  ConfirmationDialogfordelete(BuildContext context) {
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
        await FirebaseFirestore.instance
            .collection("commonissue")
            .doc(widget.value)
            .delete();
        Navigator.pushNamed(context, 'facultyFAQ');
      },
    );

    AlertDialog alert = AlertDialog(
      // title: Text("LogOut"),
      content: Text("Are you sure you want to delete the common issue ?"),
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

  ConfirmationDialogforupdate(BuildContext context) {
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
        setState(() {
          newproblem = _problemController.text;
          newsolution = _solutioncontroll.text;
          newlinks = links;
        });

        if (formkey.currentState!.validate()) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => viewFAQ(value: widget.value)));
          try {
            FirebaseFirestore.instance
                .collection('commonissue')
                .doc(widget.value)
                .update({
              'problem': newproblem,
              'solution': newsolution,
              'links': newlinks,
              'semester': semesterref,
            });

            Fluttertoast.showToast(
              msg: " Your information has been updated successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Color.fromARGB(255, 127, 166, 233),
              textColor: Color.fromARGB(255, 248, 249, 250),
              fontSize: 18.0,
            );
          } on FirebaseAuthException catch (error) {
            Fluttertoast.showToast(
              msg: "Something wronge",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 5,
              backgroundColor: Color.fromARGB(255, 127, 166, 233),
              textColor: Color.fromARGB(255, 252, 253, 255),
              fontSize: 18.0,
            );
          }
        }
      },
    );

    AlertDialog alert = AlertDialog(
      // title: Text("LogOut"),
      content: Text("Are you sure you want to update the common issue ?"),
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
