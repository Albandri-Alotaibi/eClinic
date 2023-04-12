import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/UploadGPG.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' hide context;
import 'style/Mycolors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/home.dart';
import 'package:myapp/app/constants.dart';
import 'package:myapp/app/shardPreferense.dart';

class graduatehome extends StatefulWidget {
  const graduatehome({super.key});

  @override
  State<graduatehome> createState() => _graduatehomeState();
}

class _graduatehomeState extends State<graduatehome> {
  @override
  String? fname;
  String? lname;
  String? email = '';
  String? userid = '';
  bool havename = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    userid = user?.uid;
    email = user?.email;
    // while (user != null && user.email != null) {
    //   userid = user.uid;
    //   email = user.email!;
    //   break;
    // }
    getusername();
  }

  getusername() async {
    while (userid != '') {
      final snap = await FirebaseFirestore.instance
          .collection('graduate')
          .doc(userid)
          .get();
      setState(() {
        fname = snap['firstname'];
        lname = snap['lastname'];
      });
      // setState(() {
      //   havename = true;
      // });
      // break;
    }
  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Color.fromARGB(255, 12, 12, 12), //change your color here
              ),
              title: Text(
                "GP upload",
                style: TextStyle(
                    //  fontFamily: 'bold',
                    fontSize: 20,
                    color: Mycolors.mainColorBlack),
              ),
              primary: false,
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            drawer: Drawer(
                width: 210,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.zero,
                      topLeft: Radius.zero,
                      bottomRight: Radius.circular(40),
                      topRight: Radius.circular(40)),
                ),
                child: ListView(children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(70), // <-- Radius
                    ),
                    shadowColor: Color.fromARGB(94, 253, 254, 254),
                    elevation: 0,
                    child: DrawerHeader(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 0,
                          ),
                          child: Image.asset(
                            "assets/images/User1.png",
                            width: 100,
                            height: 100,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        //  if (havename)

                        Center(
                          child: Text("${fname} ${lname}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Mycolors.mainColorBlack)),
                        ),
                      ],
                    )),
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.edit_note, color: Mycolors.mainColorBlue),
                    title: Text(
                      "My profile",
                      style: TextStyle(
                          fontSize: 15,
                          color: Mycolors.mainColorBlack,
                          fontWeight: FontWeight.w400),
                    ),
                    // hoverColor: Mycolors.mainColorBlue,
                    onTap: (() {
                      Navigator.pushNamed(context, 'studentviewprofile');
                    }),
                  ),
                  Divider(
                    color: Mycolors.mainColorBlue,
                    thickness: 1,
                    endIndent: 15,
                    indent: 15,
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.password, color: Mycolors.mainColorBlue),
                    title: Text(
                      "Reset password",
                      style: TextStyle(
                          fontSize: 16,
                          color: Mycolors.mainColorBlack,
                          fontWeight: FontWeight.w400),
                    ),
                    onTap: (() {
                      Navigator.pushNamed(context, 'innereset');
                    }),
                  ),
                  Divider(
                    color: Mycolors.mainColorBlue,
                    thickness: 1,
                    endIndent: 15,
                    indent: 15,
                  ),
                  ListTile(
                    leading: Icon(Icons.logout, color: Mycolors.mainColorBlue),
                    title: Text(
                      "Log out",
                      style: TextStyle(
                          fontSize: 16,
                          color: Mycolors.mainColorBlack,
                          fontWeight: FontWeight.w400),
                    ),
                    onTap: (() {
                      showConfirmationDialog(context);
                    }),
                  ),
                  Divider(
                    color: Mycolors.mainColorBlue,
                    thickness: 1,
                    endIndent: 15,
                    indent: 15,
                  ),
                ])),
            body: UploadGPG()));
  }

  showConfirmationDialog(BuildContext context) {
    Widget dontCancelAppButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
        shadowColor: Colors.blue[900],
        elevation: 0,
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
        elevation: 0,
        backgroundColor: Mycolors.mainShadedColorBlue,
        minimumSize: Size(60, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // <-- Radius
        ),
      ),
      child: Text("Yes"),
      onPressed: () {
        FirebaseAuth.instance.signOut().then((value) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => home())));
      },
    );

    AlertDialog alert = AlertDialog(
      // title: Text("LogOut"),
      content: Text("Are you sure you want to logout ?"),
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

//+++++++++++++++++++++++++++++++++++++++++DEEM+++++++++++++++++++++++++++++++++++++++++++++++++++++++
  }
}
