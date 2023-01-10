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
import 'editFAQ.dart';
import 'style/Mycolors.dart';
import 'package:url_launcher/url_launcher.dart';

class viewFAQ extends StatefulWidget {
  String? value;
  viewFAQ({super.key, required this.value});
  @override
  State<viewFAQ> createState() => _viewFAQState(value);
}

class _viewFAQState extends State<viewFAQ> {
  String? value;

  _viewFAQState(this.value);
  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {});
    });
    // TODO: implement initState
    getcommonissue();
    super.initState();
  }

  var title;
  var problem;
  var solution;
  List links = [];
  List linkname = [];
  var snap;
  getcommonissue() async {
    snap = await FirebaseFirestore.instance
        .collection('commonissue')
        .doc(widget.value)
        .get();
    title = snap["issuetitle"];
    problem = snap["problem"];
    solution = snap["solution"];
    links = snap["links"];
    linkname = snap["linkname"];

    print(snap["issuetitle"]);
    print(problem);
    print(solution);
    print(links);
    print(linkname);
    print(value);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Mycolors.BackgroundColor,
      body: snap != null
          ? Container(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Card(
                      color: Mycolors.mainColorWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17), // <-- Radius
                      ),
                      shadowColor: Color.fromARGB(94, 114, 168, 243),
                      elevation: 20,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 100, left: 150, top: 30, bottom: 30),
                        child: Row(
                          children: [
                            Text(
                              title,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                  color: Mycolors.mainColorBlue,
                                  fontFamily: 'main',
                                  fontSize: 17),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3),
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                editFAQ(value: value))));
                                  },
                                  icon: Icon(
                                    Icons.edit_note,
                                    size: 20,
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                    Card(
                      color: Mycolors.mainColorWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17), // <-- Radius
                      ),
                      shadowColor: Color.fromARGB(94, 114, 168, 243),
                      elevation: 20,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 100, left: 150, top: 30, bottom: 30),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 6, right: 70),
                              child: Text(
                                "Problem:",
                                style: TextStyle(
                                    color: Mycolors.mainColorBlue,
                                    fontFamily: 'bold',
                                    fontSize: 17),
                              ),
                            ),
                            Text(
                              problem,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                  color: Mycolors.mainColorBlue,
                                  fontFamily: 'main',
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      color: Mycolors.mainColorWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17), // <-- Radius
                      ),
                      shadowColor: Color.fromARGB(94, 114, 168, 243),
                      elevation: 20,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 100, left: 150, top: 30, bottom: 30),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 6, right: 70),
                              child: Text(
                                "Solution:",
                                style: TextStyle(
                                    color: Mycolors.mainColorBlue,
                                    fontFamily: 'bold',
                                    fontSize: 17),
                              ),
                            ),
                            Text(
                              solution,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                  color: Mycolors.mainColorBlue,
                                  fontFamily: 'main',
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (links.length > 0)
                      for (var i = 0; i < links.length; i++)
                        Card(
                          color: Mycolors.mainColorWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(17), // <-- Radius
                          ),
                          shadowColor: Color.fromARGB(94, 114, 168, 243),
                          elevation: 20,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 100, left: 150, top: 30, bottom: 30),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 6, right: 10),
                                  child: Text(
                                    "More resourses:",
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: Mycolors.mainColorBlue,
                                        fontFamily: 'bold',
                                        fontSize: 17),
                                  ),
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                              text: linkname[i],
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: Colors.blue),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  //var url = links[i];
                                                  // final uri = Uri.parse(url);
                                                  // ignore: deprecated_member_use
                                                  // if (await canLaunch(url)) {
                                                  // ignore: deprecated_member_use
                                                  launch(links[i]);
                                                  // } else {
                                                  //   throw "Cannot load url";
                                                  // }
                                                })
                                        ]),
                                      ),
                                    ]),
                              ],
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            )
          : CircularProgressIndicator(),
    ));
  }
}
