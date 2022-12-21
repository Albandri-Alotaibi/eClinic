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
  var _idController = TextEditingController();
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
  var zag = 0;
  bool isshow = false;
  List category = [];
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
    retrivegpcategory();
    retriveselectedcategory();
    retrivedepartment();
    retrivecolldep();
    retrivecollage();
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

  String? formatdate(Timestamp ts) {
    var datetostring = DateTime.fromMillisecondsSinceEpoch(ts.seconds * 1000);

    return DateFormat('dd-MM-yyyy').format(datetostring);
  }

  // getusername() async {
  //   final snap = await FirebaseFirestore.instance
  //       .collection('student')
  //       .doc(userid)
  //       .get();
  //   fnDrawer = snap['firstname'];
  //   lnDrawer = snap['lastname'];
  // }

  genrateyear() {
    DateTime now = DateTime.now();
    nowyear = now.year;
    DateTime Dateoftoday = DateTime.now();
    nextyear = nowyear + 1;
    print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
    // print(nextyear);
    years.add(nowyear.toString());
    years.add(nextyear.toString());
    print(years);
  }

  dategp(String? year, String? month) {
    print(selctedyear);
    print(month);
    var gpdate = selctedyear + "-" + month + "-" + "15" + " " + "00:00:00.000";
    DateTime dt = DateTime.parse(gpdate);
    print(gpdate);
    print(dt);
    return dt;
    //2022-12-20 00:00:00.000
    //2023-09-15 00:00:00.000
  }

  retrivegpcategory() async {
    try {
      await FirebaseFirestore.instance
          .collection('gpcategory')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          setState(() {
            options.add(element['gpcategoryname']);
          });
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  retriveselectedcategory() async {
    final snap = await FirebaseFirestore.instance
        .collection('student')
        .doc(userid)
        .get();
    List gpcategoryRef = snap["projectCategory"];
    for (var i = 0; i < gpcategoryRef.length; i++) {
      final DocumentSnapshot docRef = await gpcategoryRef[i].get();
      setState(() {
        categoryfromDB.add(docRef["gpcategoryname"]);
      });
    }
    zag = categoryfromDB.length;
    checkidcategory(categoryfromDB);
    print(categoryfromDB);
  }

  checkidcategory(List<String?> categoryoption) async {
    category.length = 0;
    try {
      await FirebaseFirestore.instance
          .collection('gpcategory')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          setState(() {
            for (var i = 0; i < categoryoption.length; i++) {
              if (element['gpcategoryname'] == categoryoption[i]) {
                final ref = FirebaseFirestore.instance
                    .collection("gpcategory")
                    .doc(element.id);
                category.add(ref);
                print(category);
              }
            }
          });
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  retrivecollage() async {
    try {
      await FirebaseFirestore.instance
          .collection('collage')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          setState(() {
            collage.add(element['collagename']);
          });
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future checkidc(String? collagename) async {
    try {
      await FirebaseFirestore.instance
          .collection('collage')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          setState(() {
            if (collagename == element['collagename']) {
              docsforcollage = element.id;
            }
          });
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  retrivedepartment() async {
    try {
      await FirebaseFirestore.instance
          .collection('collage')
          .doc("CCIS")
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
          .collection('collage')
          .doc("CCIS")
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
      Timestamp gd = snap["graduationDate"];
      var datetostring = DateTime.fromMillisecondsSinceEpoch(gd.seconds * 1000);
      var m = datetostring.month;
      selctedyear = datetostring.year.toString();
      print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
      print(datetostring);
      if (m >= 10) {
        month = datetostring.month.toString();
      }
      if (m < 10) {
        month = "0" + datetostring.month.toString();
        print(month);
      }
      print("jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj");
      print(selctedyear);
      _date = TextEditingController(text: formatdate(gd));
      date = gd;

      final so = snap['socialmedia'];
      final soaccount = snap['socialmediaaccount'];
      _socialmediaccount = TextEditingController(text: soaccount);
      if (so != "None") {
        _socialmed = TextEditingController(text: so);
      }
      social = so;
      var collageRef = snap["college"];
      final DocumentSnapshot docRef1 = await collageRef.get();
      collageselectedfromDB = docRef1["collagename"];
      print("/////////////////////collage///////////////////////////");
      print(collageselectedfromDB);

      var departmentRef = snap["department"];
      final DocumentSnapshot docRef2 = await departmentRef.get();
      departmentselectedfromDB = docRef2["departmentname"];
      print("/////////////////////department///////////////////////////");
      print(departmentselectedfromDB);
    } catch (e) {
      print(e.toString());
      return null;
    }
    checkidc(collageselectedfromDB);
    checkidd(departmentselectedfromDB);
  }

  @override
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
        ),
        backgroundColor: Mycolors.BackgroundColor,
        // drawer: Drawer(
        //     child: ListView(children: [
        //   Card(
        //     shadowColor: Color.fromARGB(94, 114, 168, 243),
        //     elevation: 0,
        //     child: DrawerHeader(
        //         child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Padding(
        //           padding: const EdgeInsets.only(
        //             bottom: 0,
        //           ),
        //           child: Image.asset(
        //             "assets/images/woman.png",
        //             width: 100,
        //             height: 100,
        //           ),
        //         ),
        //         SizedBox(
        //           height: 10,
        //         ),
        //         Center(
        //           child: Text("${fnDrawer} ${lnDrawer}",
        //               style: TextStyle(
        //                   fontFamily: 'bold',
        //                   fontSize: 16,
        //                   color: Mycolors.mainColorBlack)),
        //         ),
        //       ],
        //     )),
        //   ),
        //   ListTile(
        //     leading: Icon(Icons.edit_note),
        //     title: Text(
        //       "Edit profile",
        //       style: TextStyle(
        //           fontFamily: 'main',
        //           fontSize: 16,
        //           color: Mycolors.mainColorBlack),
        //     ),
        //     // hoverColor: Mycolors.mainColorBlue,
        //     onTap: (() {
        //       Navigator.pushNamed(context, 'studentviewprofile');
        //     }),
        //   ),
        //   Divider(
        //     color: Mycolors.mainColorBlue,
        //     thickness: 1,
        //     endIndent: 15,
        //     indent: 15,
        //   ),
        //   ListTile(
        //     leading: Icon(Icons.password),
        //     title: Text(
        //       "Reset password",
        //       style: TextStyle(
        //           fontFamily: 'main',
        //           fontSize: 16,
        //           color: Mycolors.mainColorBlack),
        //     ),
        //     onTap: (() {
        //       // Navigator.pushNamed(context, 'resetpasswprd');
        //     }),
        //   ),
        //   Divider(
        //     color: Mycolors.mainColorBlue,
        //     thickness: 1,
        //     endIndent: 15,
        //     indent: 15,
        //   ),
        //   ListTile(
        //     leading: Icon(Icons.logout),
        //     title: Text(
        //       "Log out",
        //       style: TextStyle(
        //           fontFamily: 'main',
        //           fontSize: 16,
        //           color: Mycolors.mainColorBlack),
        //     ),
        //     onTap: (() {
        //       showConfirmationDialog(context);
        //     }),
        //   ),
        //   Divider(
        //     color: Mycolors.mainColorBlue,
        //     thickness: 1,
        //     endIndent: 15,
        //     indent: 15,
        //   ),
        // ])),
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
                      // if (snapshot.connectionState == ConnectionState.waiting) {
                      //   return Center(child: CircularProgressIndicator());
                      // }
                      if (snapshot.hasData) {
                        print("snapshot");
                        print(snapshot);
                        final cuser =
                            snapshot.data!.data() as Map<String, dynamic>;

                        final fname = cuser['firstname'];
                        final lname = cuser['lastname'];
                        final ksuemail = cuser['ksuemail'];
                        final projectname = cuser['projectname'];
                        final studentid = cuser['studentId'];
                        final so = cuser['socialmedia'];
                        fnDrawer = cuser['firstname'];
                        lnDrawer = cuser['lastname'];

                        // date = cuser["graduationDate"];

                        // date = gd;
                        // print("ggggggggggggggggggggggggggggggggggggggg");
                        // print(cuser["graduationDate"]);
                        //print(date);
                        // formatdate(gd);
                        // print("//////////////////////////////////////////");
                        // print(gd);
                        // print(formatdate(gd));

                        _fnameController = TextEditingController(text: fname);
                        _lnamecontroller = TextEditingController(text: lname);
                        _emailController =
                            TextEditingController(text: ksuemail);
                        _idController = TextEditingController(text: studentid);
                        _projectname = TextEditingController(text: projectname);
                        // _socialmed = TextEditingController(text: so);
                        final soaccount = cuser['socialmediaaccount'];

                        // if (social != "None") {
                        //   _socialmediaccount =
                        //       TextEditingController(text: soaccount);
                        // }

                        //_date = TextEditingController(text: formatdate(gd));
                        // social = so;
                        selectedoptionlist.value = categoryfromDB;
                        collageselectedvalue = collageselectedfromDB;
                        departmentselectedvalue = departmentselectedfromDB;

                        // print("/////////////////ممههههممم//////////////////");
                        // print(date);
                        // print("//////////////////////////////////");
                        // print(departmentselectedfromDB);
                        // print("/////////////////ممههههممم//////////////////");
                        // print(semesterselectedvalue);
                        // print("//////////////////////////////////");
                        // print(semesterselectedfromDB);
                        // print("/////////////////ممههههممم//////////////////");
                        // print(collageselectedvalue);
                        // print("//////////////////////////////////");
                        // print(collageselectedfromDB);

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
                                  labelText: 'KSU Email',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                        width: 0,
                                      ))),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            // TextFormField(
                            //   controller: _idController,
                            //   decoration: InputDecoration(
                            //       labelText: 'Student ID',
                            //       hintText: "Enter your ID number",
                            //       suffixIcon: Icon(Icons.edit),
                            //       border: OutlineInputBorder()),
                            //   autovalidateMode:
                            //       AutovalidateMode.onUserInteraction,
                            //   validator: (value) {
                            //     if (value!.isEmpty || _idController.text == "") {
                            //       return 'Please enter your ID  ';
                            //     } else {
                            //       if (!(idRegEx.hasMatch(_idController.text))) {
                            //         return 'Please ID number only number accepted ';
                            //       } else {
                            //         if (!(countRegEx
                            //             .hasMatch(_idController.text))) {
                            //           return 'Please ID number must be only 9 numbers';
                            //         } else {
                            //           if (!(english
                            //               .hasMatch(_idController.text))) {
                            //             return "only english is allowed";
                            //           }
                            //         }
                            //       }
                            //     }
                            //   },
                            // ),
                            // SizedBox(
                            //   height: 8,
                            // ),
                            TextFormField(
                                controller: _projectname,
                                decoration: InputDecoration(
                                    labelText: ' Graduation project name',
                                    hintText:
                                        "Enter your Graduation project name",
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
                                      _projectname.text == "") {
                                    return 'Please enter Graduation project name ';
                                  } else {
                                    if (!(english
                                        .hasMatch(_projectname.text))) {
                                      return "only english is allowed";
                                    }
                                  }
                                }),
                            SizedBox(
                              height: 8,
                            ),
                            // TextFormField(
                            //   controller: _date,
                            //   readOnly: true,
                            //   decoration: InputDecoration(
                            //     hintText: 'Enter your graduation date',
                            //     labelText: "Graduation date",
                            //     suffixIcon: Icon(Icons.edit),
                            //     border: OutlineInputBorder(),
                            //   ),
                            //   onTap: () async {
                            //     DateTime? pickerdate = await showDatePicker(
                            //         context: context,
                            //         initialDate: DateTime.now(),
                            //         firstDate: DateTime.now(),
                            //         lastDate: DateTime(2100));

                            //     setState(() {
                            //       _date.text = DateFormat('dd-MM-yyyy')
                            //           .format(pickerdate!);
                            //       date = pickerdate;
                            //     });
                            //   },
                            //   validator: ((value) {
                            //     if (_date.text == "" || date == null)
                            //       return 'Please enter your graduation date ';
                            //     return null;
                            //   }),
                            // ),

                            SizedBox(
                              height: 8,
                            ),
                            DropDownMultiSelect(
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.edit),
                                  hintText:
                                      "select your graduation project category",
                                  labelText: " Graduation project category",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            isshow ? Colors.red : Colors.grey),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: isshow
                                            ? Colors.red
                                            : Colors.blueAccent),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: isshow
                                            ? Colors.red
                                            : Colors.blueAccent),
                                    borderRadius: BorderRadius.circular(25),
                                  )
                                  // border: OutlineInputBorder(
                                  //     borderSide: BorderSide(
                                  //         color: isshow ? Colors.red : Colors.grey)
                                  ),
                              options: options,
                              whenEmpty: "",
                              onChanged: (value) {
                                setState(() {
                                  selectedoptionlist.value = value;
                                  selectedoption.value = "";
                                  selectedoptionlist.value.forEach((element) {
                                    selectedoption.value =
                                        selectedoption.value + " " + element;
                                    zag = selectedoptionlist.value.length;
                                    isshow = selectedoption.value.isEmpty;

                                    if (zag < 1) {
                                      isshow = true;
                                    }
                                    if (zag > 0 ||
                                        selectedoption.value.isEmpty ||
                                        selectedoption.value == null) {
                                      isshow = false;
                                    }
                                  });
                                });
                                checkidcategory(selectedoptionlist.value);
                                //isshow = selectedoptionlist.value.isEmpty;
                                zag = selectedoptionlist.value.length;
                                if (zag < 1) {
                                  isshow = true;
                                }
                              },
                              selectedValues: selectedoptionlist.value,
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Visibility(
                              visible: isshow,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Please choose your graduation project category",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 211, 56, 45)),
                                      textAlign: TextAlign.left,
                                    ),
                                  ]),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.edit),
                                labelText: 'College',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: const BorderSide(
                                      width: 0,
                                    )),
                              ),
                              isExpanded: true,
                              items: collage.map((String dropdownitems) {
                                return DropdownMenuItem<String>(
                                  value: dropdownitems,
                                  child: Text(dropdownitems),
                                );
                              }).toList(),

                              onChanged: (String? newselect) {
                                setState(() {
                                  collageselectedvalue = newselect;
                                  collageselectedfromDB = newselect;
                                  checkidc(collageselectedvalue);
                                });
                              },
                              value: collageselectedvalue,

                              // autovalidateMode:
                              //     AutovalidateMode.onUserInteraction,
                              // validator: (value) {
                              //   if (value == null ||
                              //       collageselectedvalue!.isEmpty ||
                              //       collageselectedvalue == null) {
                              //     return 'Please choose your collage';
                              //   }
                              // },
                            ),
                            SizedBox(
                              height: 8,
                            ),

                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.edit),
                                labelText: ' Department',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: const BorderSide(
                                      width: 0,
                                    )),
                              ),
                              isExpanded: true,
                              items: department.map((String dropdownitems) {
                                return DropdownMenuItem<String>(
                                  value: dropdownitems,
                                  child: Text(dropdownitems),
                                );
                              }).toList(),
                              onChanged: (String? newselect) {
                                setState(() {
                                  departmentselectedvalue = newselect;
                                  departmentselectedfromDB = newselect;
                                  checkidd(departmentselectedvalue);
                                });
                              },
                              value: departmentselectedvalue,

                              // autovalidateMode:
                              //     AutovalidateMode.onUserInteraction,
                              // validator: (value) {
                              //   if (value == null ||
                              //       departmentselectedvalue!.isEmpty ||
                              //       departmentselectedvalue == null) {
                              //     return 'Please choose your department';
                              //   }
                              // },
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
                                    }
                                    SizedBox(
                                      height: 8,
                                    );
                                  }),

                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 250, bottom: 4),
                              child: Text(
                                "  Graduation date : ",
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Choose month',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          borderSide: const BorderSide(
                                            width: 0,
                                          )),
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                          child: Text("Jan"), value: "01"),
                                      DropdownMenuItem(
                                          child: Text("Feb"), value: "02"),
                                      DropdownMenuItem(
                                          child: Text("Mar"), value: "03"),
                                      DropdownMenuItem(
                                          child: Text("Apr"), value: "04"),
                                      DropdownMenuItem(
                                          child: Text("May"), value: "05"),
                                      DropdownMenuItem(
                                          child: Text("Jun"), value: "06"),
                                      DropdownMenuItem(
                                          child: Text("Jul"), value: "07"),
                                      DropdownMenuItem(
                                          child: Text("Aug"), value: "08"),
                                      DropdownMenuItem(
                                          child: Text("Sep"), value: "09"),
                                      DropdownMenuItem(
                                          child: Text("Oct"), value: "10"),
                                      DropdownMenuItem(
                                          child: Text("Nov"), value: "11"),
                                      DropdownMenuItem(
                                          child: Text("Dec"), value: "12")
                                    ],
                                    value: month,
                                    onChanged: (value) {
                                      setState(() {
                                        month = value;
                                        print(month);
                                      });
                                    },
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null || month == "") {
                                        return 'Please Choose month';
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      hintText: 'choose year',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          borderSide: const BorderSide(
                                            width: 0,
                                          )),
                                    ),
                                    isExpanded: true,
                                    items: years.map((String dropdownitems) {
                                      return DropdownMenuItem<String>(
                                        value: dropdownitems,
                                        child: Text(dropdownitems),
                                      );
                                    }).toList(),
                                    onChanged: (String? newselect) {
                                      setState(() {
                                        selctedyear = newselect;
                                        print(selctedyear);
                                      });
                                    },
                                    value: selctedyear,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null || selctedyear == "") {
                                        return 'Please choose year';
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
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
                      // sid = _idController.text;
                      pn = _projectname.text;
                      // gpdate = date;
                      socialmedia = social;
                      socoamediaaccount = _socialmediaccount.text;

                      if (social == "None") {
                        socoamediaaccount = "";
                      }
                      if (zag < 1) {
                        isshow = true;
                      }
                      if (zag > 0) {
                        isshow = false;
                      }
                    });

                    if (formkey.currentState!.validate() && zag > 0) {
                      gpdate = dategp(selctedyear, month);
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
                          // "studentId": sid,
                          "projectname": pn,
                          "projectCategory": category,
                          "socialmedia": socialmedia,
                          "socialmediaaccount": socoamediaaccount,
                          "graduationDate": gpdate,
                          'department': FirebaseFirestore.instance
                              .collection("collage")
                              .doc(docsforcollage)
                              .collection("department")
                              .doc(docfordepatment),
                          'college': FirebaseFirestore.instance
                              .collection("collage")
                              .doc(docsforcollage),
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
        backgroundImage: AssetImage('assets/images/woman.png'),
      );
  // showConfirmationDialog(BuildContext context) {
  //   Widget dontCancelAppButton = ElevatedButton(
  //     style: ElevatedButton.styleFrom(
  //       textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
  //       shadowColor: Colors.blue[900],
  //       elevation: 20,
  //       backgroundColor: Mycolors.mainShadedColorBlue,
  //       minimumSize: Size(60, 40),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10), // <-- Radius
  //       ),
  //     ),
  //     child: Text("No"),
  //     onPressed: () {
  //       Navigator.of(context).pop();
  //     },
  //   );

  //   Widget YesCancelAppButton = ElevatedButton(
  //     style: ElevatedButton.styleFrom(
  //       textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
  //       shadowColor: Colors.blue[900],
  //       elevation: 20,
  //       backgroundColor: Mycolors.mainShadedColorBlue,
  //       minimumSize: Size(60, 40),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10), // <-- Radius
  //       ),
  //     ),
  //     child: Text("Yes"),
  //     onPressed: () {
  //       FirebaseAuth.instance.signOut().then((value) => Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => studentlogin())));
  //     },
  //   );

  //   AlertDialog alert = AlertDialog(
  //     // title: Text("LogOut"),
  //     content: Text("Are you sure you want to logout ?"),
  //     actions: [
  //       dontCancelAppButton,
  //       YesCancelAppButton,
  //     ],
  //   );

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }
}
