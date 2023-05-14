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
import 'package:myapp/login.dart';
import 'package:myapp/studentlogin.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'style/Mycolors.dart';

class studentviewprofile extends StatefulWidget {
  const studentviewprofile({super.key});

  @override
  State<studentviewprofile> createState() => _studentviewprofileState();
}

class _studentviewprofileState extends State<studentviewprofile> {
  final formkey = GlobalKey<FormState>();
  var collageselectedvalue;
  var departmentselectedvalue;
  late String docsforcollage;
  late String docfordepatment;
  var _fnameController = TextEditingController();
  var _lnamecontroller = TextEditingController();
  var _emailController = TextEditingController();
  var _projectname = TextEditingController();
  var _socialmed = TextEditingController();
  var _socialmediaccount = TextEditingController();
  var _gpcategory = TextEditingController();
  var _graduationdate = TextEditingController();
  var _date = TextEditingController();
  var date;
  var social;
  ////for setstate update
  var fn;
  var ln;
  var sid;
  var pn;
  var gpdate;
  var socialmedia;
  var socoamediaaccount;
  List<String> years = [];

  String? email = '';
  String? userid = '';
  List<String> options = [];
  Rx<List<String>> selectedoptionlist = Rx<List<String>>([]);
  var selectedoption = "".obs;
  var checklengthforcategory = 0;
  bool isshow = false;
  List category = [];
  List gpcategorynamebaeforedit = [];
  List newselectgpcategory = [];
  List<String> categoryfromDB = [];
  List<String> department = [];
  List<String> collage = [];
  var collageselectedfromDB;
  var departmentselectedfromDB;
  var month;
  var nowyear;
  var nextyear;
  var selctedyear;
  var fnDrawer;
  var lnDrawer;
  void initState() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    userid = user!.uid;
    email = user.email!;
    //retrivegpcategory();
    //retriveselectedcategory();
    retrivedepartment();
    retrivecolldep();
    //retrivecollage();
    genrateyear();
    // getusername();
    super.initState();
    bool isshow = false;
  }

  final double coverheight = 280;
  final double profileheight = 144;
  final double top = 136 / 2; //coverheight - profileheight/2;
  RegExp nameRegExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
  RegExp idRegEx = RegExp(r'^[0-9]+$');
  RegExp countRegEx = RegExp(r'^\d{9}$');
  RegExp countRegEx10 = RegExp(r'^\d{10}$');
  RegExp english = RegExp("^[\u0000-\u007F]+\$");
  //https://iwtsp.com/966591356970?fbclid=PAAaZvXSh0XdYn3drgv1lQLEIyU_-_pJ6SLCKzopLNfd0bgHTZ8fec3ua6mc4
  //https://api.whatsapp.com/send/?phone=%2B966542806668&text&type=phone_number&app_absent=0
  //wa.me/ above
  //https://mobile.twitter.com/10Deem
  //https://www.linkedin.com/in/asmaa-alqahtani-08a114190

  RegExp whatsappformat = new RegExp(r'https://iwtsp.com/.*',
      multiLine: false, caseSensitive: false);

  RegExp whatsapp2format = new RegExp(r'https://api.whatsapp.com/.*',
      multiLine: false, caseSensitive: false);

  RegExp linkedinformat = new RegExp(r'https://www.linkedin.com/.*',
      multiLine: false, caseSensitive: false);

  RegExp twitterformat = new RegExp(r'https://mobile.twitter.com/.*',
      multiLine: false, caseSensitive: false);

  String? formatdate(Timestamp ts) {
    var datetostring = DateTime.fromMillisecondsSinceEpoch(ts.seconds * 1000);

    return DateFormat('dd-MM-yyyy').format(datetostring);
  }



  genrateyear() {
    DateTime now = DateTime.now();
    nowyear = now.year;
    DateTime Dateoftoday = DateTime.now();
    nextyear = nowyear + 1;
  
    print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
    print(nextyear);
    years.add(nowyear.toString());
    years.add(nextyear.toString());

    print(years);
  }

  dategp(String? year, String? month) {
    print(selctedyear);
    print(month);
    var gpdate = selctedyear + "-" + month + "-" + "15" + " " + "12:00:00.000";
    DateTime dt = DateTime.parse(gpdate);
    print(gpdate);
    print(dt);
    return dt;
    //2022-12-20 00:00:00.000
    //2023-09-15 00:00:00.000
  }

 

  retrivedepartment() async {
    try {
      await FirebaseFirestore.instance
          // .collection('collage')
          // .doc("CCIS")
          .collection("department")
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          setState(() {
            department.add(element['departmentname']);
          });
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future checkidd(String? departmentename) async {
    try {
      await FirebaseFirestore.instance
          // .collection('collage')
          // .doc("CCIS")
          .collection("department")
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          setState(() {
            if (departmentename == element['departmentname']) {
              docfordepatment = element.id;
            }
          });
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  retrivecolldep() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('student')
          .doc(userid)
          .get();

      final so = snap['socialmedia'];
      final soaccount = snap['socialmediaaccount'];
      _socialmediaccount = TextEditingController(text: soaccount);
      if (so != "None") {
        _socialmed = TextEditingController(text: so);
      }
      social = so;
      final fname = snap['firstname'];
      final lname = snap['lastname'];

      _fnameController = TextEditingController(text: fname);
      _lnamecontroller = TextEditingController(text: lname);
    } catch (e) {
      print(e.toString());
      return null;
    }
    //checkidc(collageselectedfromDB);
    checkidd(departmentselectedfromDB);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          primary: false,
          centerTitle: true,
          leading: BackButton(
            onPressed: () {
              Navigator.pushNamed(context, 'studenthome');
            },
          ),
          titleTextStyle: TextStyle(
            fontFamily: 'bold',
            fontSize: 18,
            color: Mycolors.mainColorBlack,
          ),
          title: Text("My profile"),
          backgroundColor: Mycolors.mainColorWhite,
          shadowColor: Colors.transparent,
          iconTheme: IconThemeData(
            color: Color.fromARGB(255, 12, 12, 12), //change your color here
          ),
        ),
        backgroundColor: Mycolors.BackgroundColor,
        body: SingleChildScrollView(
          clipBehavior: Clip.none,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              key: formkey,
              child: Column(children: [
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('student')
                        .doc(userid)
                        .get(),
                    builder: (context, snapshot) {
                     
                      if (snapshot.hasData) {
                        print("snapshot");
                        print(snapshot);
                        final cuser =
                            snapshot.data!.data() as Map<String, dynamic>;

                        final fname = cuser['firstname'];
                        final lname = cuser['lastname'];
                        final email = cuser['email'];

                        final so = cuser['socialmedia'];
                        fnDrawer = cuser['firstname'];
                        lnDrawer = cuser['lastname'];

                        _emailController = TextEditingController(text: email);

                        final soaccount = cuser['socialmediaaccount'];

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildprofileImage(),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: _fnameController,
                              decoration: InputDecoration(
                                  labelText: ' Frist Name',
                                  // hintText: "Enter your first name",
                                  suffixIcon: Icon(Icons.edit),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                        width: 0,
                                      ))),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty ||
                                    _fnameController.text.isEmpty) {
                                  return 'Please enter your frist name ';
                                } else {
                                  if (nameRegExp
                                      .hasMatch(_fnameController.text)) {
                                    return 'Please frist name only letters accepted ';
                                  } else {
                                    if (!(english
                                        .hasMatch(_fnameController.text))) {
                                      return "only english is allowed";
                                    }
                                  }
                                }
                              },
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              controller: _lnamecontroller,
                              decoration: InputDecoration(
                                  labelText: 'Last Name',
                                  // hintText: "Enter your last name",
                                  suffixIcon: Icon(Icons.edit),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                        width: 0,
                                      ))),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty ||
                                    _lnamecontroller.text == "") {
                                  return 'Please enter your last name ';
                                } else {
                                  if (nameRegExp
                                      .hasMatch(_lnamecontroller.text)) {
                                    return 'Please last name only letters accepted ';
                                  } else {
                                    if (!(english
                                        .hasMatch(_lnamecontroller.text))) {
                                      return "only english is allowed";
                                    }
                                  }
                                }
                              },
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              controller: _emailController,
                              readOnly: true,
                              decoration: InputDecoration(
                                  // hintText: "Enter your KSU email",
                                  labelText: 'Email',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                        width: 0,
                                      ))),
                            ),

                            SizedBox(
                              height: 8,
                            ),
                            DropdownButtonFormField(
                                decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.edit),
                                  labelText: "Social media contact",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                        width: 0,
                                      )),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                      child: Text("Twitter"), value: "Twitter"),
                                  DropdownMenuItem(
                                      child: Text("LinkedIn"),
                                      value: "LinkedIn"),
                                  DropdownMenuItem(
                                      child: Text("WhatsApp"),
                                      value: "WhatsApp"),
                                  DropdownMenuItem(
                                      child: Text("None"), value: "None")
                                ],
                                value: social,
                                onChanged: (value) {
                                  setState(() {
                                    social = value;
                                    _socialmediaccount.text = "";
                                  });
                                }),
                            SizedBox(
                              height: 8,
                            ),
                            if (social != null && social != "None")
                              TextFormField(
                                  controller: _socialmediaccount,
                                  decoration: InputDecoration(
                                      labelText: 'Link account',
                                      hintText: "Enter your link account",
                                      suffixIcon: Icon(Icons.edit),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          borderSide: const BorderSide(
                                            width: 0,
                                          ))),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        _socialmediaccount.text == "") {
                                      return 'Please enter your link account';
                                    } else {
                                      if (!(english
                                          .hasMatch(_socialmediaccount.text))) {
                                        return "only english is allowed";
                                      }
                                      if (social == "WhatsApp") {
                                        if (!(whatsappformat.hasMatch(
                                                _socialmediaccount.text)) &&
                                            !(whatsapp2format.hasMatch(
                                                _socialmediaccount.text))) {
                                          return 'Make sure your link account related to selected social media';
                                        }
                                      }
                                      if (social == "LinkedIn") {
                                        if (!(linkedinformat.hasMatch(
                                            _socialmediaccount.text))) {
                                          return 'Make sure your link account related to selected social media';
                                        }
                                      }
                                      if (social == "Twitter") {
                                        if (!(twitterformat.hasMatch(
                                            _socialmediaccount.text))) {
                                          return 'Make sure your link account related to selected social media';
                                        }
                                      }
                                    }
                                    SizedBox(
                                      height: 8,
                                    );
                                  }),
                            ////////////////////group information (department,project name , project completion date)
                          ],
                        ); //here
                      }
                      return Center(child: CircularProgressIndicator());
                    }),
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
                    setState(() {
                      fn = _fnameController.text;
                      ln = _lnamecontroller.text;

                      socialmedia = social;
                      socoamediaaccount = _socialmediaccount.text;

                      if (social == "None") {
                        socoamediaaccount = "";
                      }
                    });

                    if (formkey.currentState!.validate()) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => studentviewprofile()));
                      try {
                        FirebaseFirestore.instance
                            .collection('student')
                            .doc(userid)
                            .update({
                          "firstname": fn,
                          "lastname": ln,
                          "socialmedia": socialmedia,
                          "socialmediaaccount": socoamediaaccount,
                        });

                        Fluttertoast.showToast(
                          msg:
                              " Your information has been updated successfully",
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
                  child: Text("Save changes"),
                ),
              ]),
            ), ////here
          ),
        ),
      ),
    );
  }

  Widget buildprofileImage() => CircleAvatar(
        radius: profileheight / 2,
        backgroundColor: Colors.grey.shade800,
        backgroundImage: AssetImage("assets/images/User1.png"),
      );
  
 
}
