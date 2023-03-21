import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myapp/login.dart';
import 'style/Mycolors.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickalert/quickalert.dart';
import 'package:myapp/screeens/resources/snackbar.dart';

class resetpassword extends StatefulWidget {
  const resetpassword({super.key});

  @override
  State<resetpassword> createState() => _resetpasswordState();
}

class _resetpasswordState extends State<resetpassword> {
  @override
  final double profileheight = 244;
  final formkey = GlobalKey<FormState>();
  final _emailcontrol = TextEditingController();
  var email;
  bool ifsend = false;
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
          title: Text(''),
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
                height: 70,
              ),
              // Align(
              //   alignment: Alignment.center,
              //   child: Text(
              //     "Forget your password?",
              //     style: TextStyle(
              //         fontWeight: FontWeight.w500,
              //         overflow: TextOverflow.ellipsis,
              //         color: Mycolors.mainColorBlack,
              //         fontFamily: 'bold',
              //         fontSize: 17),
              //     textAlign: TextAlign.start,
              //   ),
              // ),
              // SizedBox(
              //   height: 50,
              // ),
              // Image(
              //   image: AssetImage('assets/images/forgot-password.png'),
              //   width: 180,
              //   height: 180,
              // ),
              // SizedBox(
              //   height: 40,
              // ),
              ifsend
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Reset link has been sent on this email:",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                                color: Mycolors.mainColorBlack,
                                fontFamily: 'bold',
                                fontSize: 17),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          _emailcontrol.text,
                          style: TextStyle(
                              fontFamily: 'main',
                              fontSize: 16,
                              color: Mycolors.mainColorBlack),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "  Please check your email and click \nin the received link to reset password",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                                color: Mycolors.mainColorGray,
                                fontFamily: 'main',
                                fontSize: 17),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        Image(
                          image: AssetImage('assets/images/checkmailbox .png'),
                          width: 180,
                          height: 180,
                        ),
                        SizedBox(
                          height: 80,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            textStyle:
                                TextStyle(fontFamily: 'main', fontSize: 16),
                            //shadowColor: Colors.blue[900],
                            elevation: 0,
                            backgroundColor: Mycolors.mainShadedColorBlue,
                            minimumSize: Size(150, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(17), // <-- Radius
                            ),
                          ),
                          onPressed: () async {
                            try {
                              // await FirebaseAuth.instance
                              //     .sendPasswordResetEmail(email: email);
                              Navigator.pushNamed(context, "login");

                              setState(() {
                                // ifsend = false;
                                // _emailcontrol.text = "";
                              });
                            } on FirebaseAuthException catch (e) {
                              return;
                            }
                            print(email);
                          },
                          child: Text("Login"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Didn't receive the reset link ? ",
                                style: TextStyle(
                                    color: Mycolors.mainColorBlack,
                                    fontFamily: 'main',
                                    fontSize: 14),
                              ),
                              GestureDetector(
                                  onTap: () async {
                                    try {
                                      await FirebaseAuth.instance
                                          .sendPasswordResetEmail(email: email);

                                      setState(() {
                                        ifsend = true;
                                        showInSnackBar(context,
                                            "Another link has been sent ");
                                      });
                                    } on FirebaseAuthException catch (e) {
                                      return;
                                    }
                                    print(email);
                                  },
                                  child: Text(
                                    " Resend",
                                    style: TextStyle(
                                        color: Mycolors.mainColorBlack,
                                        fontFamily: 'bold',
                                        fontSize: 14),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    )
                  : SizedBox(
                      width: 600,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Forget your password?",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis,
                                  color: Mycolors.mainColorBlack,
                                  fontFamily: 'bold',
                                  fontSize: 17),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "   Enter your registered email below to\n receive password reset instruction link ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis,
                                  color: Mycolors.mainColorGray,
                                  fontFamily: 'main',
                                  fontSize: 17),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Image(
                            image: AssetImage('assets/images/enteremail.png'),
                            width: 180,
                            height: 180,
                          ),
                          SizedBox(
                            height: 80,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 383,
                              child: Form(
                                key: formkey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextFormField(
                                        controller: _emailcontrol,
                                        decoration: InputDecoration(
                                            labelText: 'Email',
                                            hintText: "Email ",
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(13),
                                                borderSide: const BorderSide(
                                                  width: 0,
                                                ))),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (value!.isEmpty ||
                                              _emailcontrol.text == "") {
                                            return 'Please enter your email';
                                          }
                                        }),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        textStyle: TextStyle(
                                            fontFamily: 'main', fontSize: 16),
                                        // shadowColor: Colors.blue[900],
                                        elevation: 0,
                                        backgroundColor:
                                            Mycolors.mainShadedColorBlue,
                                        minimumSize: Size(150, 50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              17), // <-- Radius
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (formkey.currentState!.validate()) {
                                          try {
                                            await FirebaseAuth.instance
                                                .sendPasswordResetEmail(
                                                    email: _emailcontrol.text);
                                            // showSucessAlert();
                                            setState(() {
                                              ifsend = true;
                                            });
                                          } on FirebaseAuthException catch (e) {
                                            print(e.message);
                                            if (e.message ==
                                                "The email address is badly formatted.") {
                                              showerror(context,
                                                  "please check the email format");
                                            }
                                            if (e.message ==
                                                "There is no user record corresponding to this identifier. The user may have been deleted.") {
                                              // showSucessAlert();
                                              setState(() {
                                                ifsend = true;
                                              });
                                            }
                                          }
                                        }

                                        print(email);
                                      },
                                      child: Text("Send "),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, bottom: 40),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Remember password ? ",
                                            style: TextStyle(
                                                color: Mycolors.mainColorBlack,
                                                fontFamily: 'main',
                                                fontSize: 14),
                                          ),
                                          GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, "login");
                                              },
                                              child: Text(
                                                " Log in",
                                                style: TextStyle(
                                                    color:
                                                        Mycolors.mainColorBlack,
                                                    fontFamily: 'bold',
                                                    fontSize: 14),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        )),
      ),
    );
  }

  Widget buildprofileImage() => CircleAvatar(
      // radius: profileheight / 2,
      // backgroundColor: Mycolors.mainColorShadow,
      // backgroundImage: AssetImage('assets/images/forgot-password.png'),
      //  Image(image: AssetImage('assets/images/forgot-password.png')),
      );

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

  // showSucessAlert() {
  //   QuickAlert.show(
  //     context: context,
  //     type: QuickAlertType.success,
  //     title: _emailcontrol.text,
  //     text:
  //         'If this is a registered email, then a reset link will be sent to it.',
  //     onConfirmBtnTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => login(),
  //         ),
  //       );
  //     },
  //   );
  // }
}
