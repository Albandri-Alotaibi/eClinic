import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myapp/facultyhome.dart';
import 'package:myapp/studenthome.dart';
import 'style/Mycolors.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickalert/quickalert.dart';

class innereset extends StatefulWidget {
  const innereset({super.key});

  @override
  State<innereset> createState() => _inneresetState();
}

class _inneresetState extends State<innereset> {
  @override
  final double profileheight = 244;
  final formkey = GlobalKey<FormState>();
  final _emailcontrol = TextEditingController();
  var email;
  bool ifsend = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    email = user?.email!;
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          primary: false,
          centerTitle: true,
          backgroundColor: Mycolors.mainColorWhite,
          shadowColor: Colors.transparent,
          iconTheme: IconThemeData(
            color: Color.fromARGB(255, 12, 12, 12), //change your color here
          ),
          title: Text('Reset password'),
          titleTextStyle: TextStyle(
            fontFamily: 'bold',
            fontSize: 18,
            color: Mycolors.mainColorBlack,
          ),
        ),
        backgroundColor: Mycolors.BackgroundColor,
        body: SingleChildScrollView(
            child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Image(
                image: AssetImage('assets/images/forgot-password.png'),
                width: 180,
                height: 180,
              ),
              SizedBox(
                height: 40,
              ),
              ifsend
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            "We have sent you the reset link on this email:",
                            style: TextStyle(
                                fontFamily: 'main',
                                fontSize: 16,
                                color: Mycolors.mainColorBlack),
                          ),
                        ),
                        Text(
                          email,
                          style: TextStyle(
                              fontFamily: 'bold',
                              fontSize: 16,
                              color: Mycolors.mainColorBlack),
                        ),
                        SizedBox(
                          height: 20,
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
                          onPressed: () async {
                            try {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: email);

                              setState(() {
                                ifsend = true;
                              });
                            } on FirebaseAuthException catch (e) {
                              return;
                            }
                            print(email);
                          },
                          child: Text("Resend"),
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 90),
                      child: ElevatedButton(
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
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance
                                .sendPasswordResetEmail(email: email);
                            // showSucessAlert();
                            setState(() {
                              ifsend = true;
                            });
                          } on FirebaseAuthException catch (e) {
                            print(e);
                            return;
                          }

                          print(email);
                        },
                        child: Text("Send reset password link "),
                      ),
                    ),
            ],
          ),
        )),
      ),
    );
  }

  // Widget buildprofileImage() => CircleAvatar(
  //       radius: profileheight / 2,
  //       backgroundColor: Mycolors.mainColorShadow,
  //       backgroundImage: AssetImage('assets/images/forgot-password.png'),
  //     );

  // showSucessAlert() {
  //   QuickAlert.show(
  //     context: context,
  //     type: QuickAlertType.success,
  //     title: _emailcontrol.text,
  //     text: "We have sent you the reset link on this email:\n ${email}",
  //     onConfirmBtnTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => facultyhome(0),
  //         ),
  //       );
  //     },
  //   );
  // }
}
