import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'style/Mycolors.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
          title: Text('Forget password'),
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
              buildprofileImage(),
              SizedBox(
                height: 40,
              ),
              Text(
                "Enter the email associated with your account and we'll send an email to reset your password",
                style: TextStyle(
                    fontFamily: 'main',
                    fontSize: 16,
                    color: Mycolors.mainColorBlack),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formkey,
                  child: Column(
                    children: [
                      TextFormField(
                          controller: _emailcontrol,
                          decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: "Email ",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(
                                    width: 0,
                                  ))),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty || _emailcontrol.text == "") {
                              return 'Please enter your email';
                            }
                          }),
                      SizedBox(
                        height: 8,
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
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                                email: _emailcontrol.text);
                            showerror(context,
                                " وبعدين ارجعه للوق ان لا انسى احط المسج الخضراء");
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) {
                            //   return LogIn();
                            // }));
                          } on FirebaseAuthException catch (e) {
                            print(e.message);
                            if (e.message ==
                                    "The email address is badly formatted." ||
                                e.message ==
                                    "There is no user record corresponding to this identifier. The user may have been deleted.") {
                              showerror(
                                  context, "please check the email format");
                              // showerror(context, "hhhhhhhhhhhhhh");
                            }
                          }
                          // setState(() {
                          //   email = _emailcontrol.text;
                          // });
                          // try {
                          //   //reset function

                          //   await FirebaseAuth.instance
                          //       .sendPasswordResetEmail(email: email);
                          //   print("00000");
                          // } on FirebaseAuthMultiFactorException catch (error) {
                          //   showerror(context, "please check the error format");
                          //   print("000000000000000000000000");
                          //   print(error.message);
                          //   if (error.message ==
                          //           "The email address is badly formatted." ||
                          //       error.message ==
                          //           "There is no user record corresponding to this identifier. The user may have been deleted.") {
                          //     showerror(
                          //         context, "please check the error format");
                          //     print("wrong");
                          //   }
                          // }
                          print(email);
                        },
                        child: Text("Send "),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  Widget buildprofileImage() => CircleAvatar(
        radius: profileheight / 2,
        backgroundColor: Mycolors.mainColorShadow,
        backgroundImage: AssetImage('assets/images/forgot-password.png'),
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
}
