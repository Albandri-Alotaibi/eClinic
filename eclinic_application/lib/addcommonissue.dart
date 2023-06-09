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
import 'package:myapp/facultyhome.dart';
import 'package:myapp/screeens/resources/snackbar.dart';
import 'package:open_file/open_file.dart';
import 'style/Mycolors.dart';
import 'package:myapp/home.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:firebase_storage/firebase_storage.dart';

class addcommonissue extends StatefulWidget {
  const addcommonissue({super.key});

  @override
  State<addcommonissue> createState() => _addcommonissueState();
}

class _addcommonissueState extends State<addcommonissue> {
  @override
  int _selectedIndex = 2;
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
  var fname;
  var lname;
  var fullname;
  var facultyRef;
  List links = [];
  List linkname = [];
  // List file = [];
  List<PlatformFile>? filesurl = [];
  List fileurltoDB = [];
  var urlname;
  bool exist = true;
  var title;
  var showlink;
  bool isloading = false;
  final formkey = GlobalKey<FormState>();
  final formkeyforlink = GlobalKey<FormState>();
  final _issuetitleconstroller = TextEditingController();
  final _problemController = TextEditingController();
  final _solutioncontroll = TextEditingController();
  final _linkcontroll = TextEditingController();
  final _linknamecontroll = TextEditingController();
  RegExp english = RegExp("^[\u0000-\u007F]+\$");
  // File? _file;
  PlatformFile? pickedFile;

  var specialityselectedvalue;
  void initState() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    userid = user!.uid;
    retrivespeciality();
    createdname();
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

  createdname() async {
    final snap = await FirebaseFirestore.instance
        .collection('faculty')
        .doc(userid)
        .get();
    facultyRef = FirebaseFirestore.instance.collection("faculty").doc(userid);
    fname = snap['firstname'];
    lname = snap['lastname'];
    print("ggggggggggggggggggggggggggggggggggggggg");
    print(fname);
    fullname = fname + " " + lname;
    print(fullname);
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

 

  void openfile(PlatformFile file) {
    OpenFile.open(file.path);
  }

  upload() async {
    setState(() {
      isloading = true;
    });

    for (var i = 0; i < filesurl!.length; i++) {
      final path = filesurl![i].name;
      final File file = File(filesurl![i].path!);
      final ref = await FirebaseStorage.instance.ref().child(path);
      await ref.putFile(file);
      final FileUrl = await ref.getDownloadURL();
      fileurltoDB.add(FileUrl);
      print(FileUrl);
      print(fileurltoDB);
    }
    setState(() {
      print("finnnnnsssssssssshhhhh");
      isloading = false;
    });
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
            backgroundColor: Colors.white,
            appBar: AppBar(
              primary: false,
              centerTitle: true,
              backgroundColor: Mycolors.mainColorWhite,
              shadowColor: Colors.transparent,
              //foregroundColor: Mycolors.mainColorBlack,
              // automaticallyImplyLeading: false,
              iconTheme: IconThemeData(
                color: Color.fromARGB(255, 12, 12, 12), //change your color here
              ),
              title: Text('Add FAQ',
                  style: TextStyle(
                      // fontFamily: ,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Mycolors.mainColorBlack)),

              titleTextStyle: TextStyle(
                // fontFamily: 'main',
                fontSize: 24,
                color: Mycolors.mainColorBlack,
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: 380,
                    child: Form(
                        key: formkey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 7),
                                    height: 40,
                                    width: 135,
                                    child: FloatingActionButton.extended(
                                      heroTag: "btn1",
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            30), // <-- Radius
                                        side: BorderSide(
                                          width: 1,
                                          color: Mycolors.mainShadedColorBlue,
                                        ),
                                      ),
                                      splashColor: Mycolors.mainShadedColorBlue,
                                      elevation: 0,
                                      foregroundColor:
                                          Mycolors.mainShadedColorBlue,
                                      label: Text(
                                        'Upload file',
                                      ), // <-- Text
                                      backgroundColor: Colors.white,
                                      icon: Icon(
                                        // <-- Icon
                                        Icons.upload_outlined,
                                        size: 24.0,
                                      ),
                                      onPressed: (() async {
                                        final result = await FilePicker.platform
                                            .pickFiles(allowMultiple: true);
                                        if (result == null) return;
                                        setState(() {
                                          pickedFile = result.files.first;
                                          if (pickedFile != null) {
                                            filesurl?.addAll(result.files);

                                          
                                          }
                                          var exe = pickedFile!.extension;
                                          print("00000000000000000000");
                                          print(pickedFile!.path);
                                          print(pickedFile!.name);
                                          print(filesurl);
                                        });
                                       
                                      }),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                            
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 7),
                                    height: 40,
                                    width: 135,
                                    child: FloatingActionButton.extended(
                                      heroTag: "btn2",
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            30), // <-- Radius
                                        side: BorderSide(
                                          width: 1,
                                          color: Mycolors.mainShadedColorBlue,
                                        ),
                                      ),
                                      splashColor: Mycolors.mainShadedColorBlue,
                                      elevation: 0,
                                      foregroundColor:
                                          Mycolors.mainShadedColorBlue,
                                      label: Text(
                                        'Add link',
                                        style: TextStyle(
                                          color: Mycolors.mainShadedColorBlue,
                                        ),
                                      ), // <-- Text
                                      backgroundColor: Colors.white,

                                      icon: Icon(
                                        // <-- Icon
                                        Icons.link_outlined,
                                        color: Mycolors.mainShadedColorBlue,
                                        size: 24.0,
                                      ),
                                      onPressed: (() {
                                        _linkcontroll.text = "";
                                        _linknamecontroll.text = "";
                                        showConfirmationDialog(context);
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Specialty of the question:",
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Mycolors.mainColorBlack,
                                      fontWeight: FontWeight.w500,
                                      // fontFamily: 'bold',
                                      fontSize: 13),
                                  textAlign: TextAlign.start,
                                ),
                              ),

                              SizedBox(
                                height: 5,
                              ),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  hintText: ' Choose the specialty  ',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(13),
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
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null ||
                                      specialityselectedvalue!.isEmpty ||
                                      specialityselectedvalue == null) {
                                    return 'Please choose the specialty of the question';
                                  }
                                },
                              ),
                              SizedBox(
                                height: 8,
                              ),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Title of the question:",
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Mycolors.mainColorBlack,
                                      // fontFamily: 'bold',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13),
                                  textAlign: TextAlign.start,
                                ),
                              ),

                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                  controller: _issuetitleconstroller,
                                  decoration: InputDecoration(
                                      // labelText: ' issue title :',
                                      hintText: "Enter the title ",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(13),
                                          borderSide: const BorderSide(
                                            width: 0,
                                          ))),
                                  onChanged: (value) {
                                    setState(() {
                                      retriveissuetitle(
                                          _issuetitleconstroller.text);
                                    });
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        _issuetitleconstroller.text == "") {
                                      return 'Please enter the title of the question ';
                                    } else {
                                      if (!(english.hasMatch(
                                          _issuetitleconstroller.text))) {
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
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Question:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis,
                                      color: Mycolors.mainColorBlack,
                                      // fontFamily: 'bold',
                                      fontSize: 13),
                                  textAlign: TextAlign.start,
                                ),
                              ),

                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: _problemController,
                                minLines: 4,
                                maxLines: 10,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                    //   labelText: ' problem :',
                                    hintText: "Enter the question ",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(13),
                                        borderSide: const BorderSide(
                                          width: 0,
                                        ))),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      _problemController.text == "") {
                                    return 'Please enter the question';
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
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Answer:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis,
                                      color: Mycolors.mainColorBlack,
                                      // fontFamily: 'bold',
                                      fontSize: 13),
                                  textAlign: TextAlign.start,
                                ),
                              ),

                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: _solutioncontroll,
                                minLines: 4,
                                maxLines: 10,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                    // labelText: ' Solution :',
                                    hintText: "Enter the answer ",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(13),
                                        borderSide: const BorderSide(
                                          width: 0,
                                        ))),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      _solutioncontroll.text == "") {
                                    return 'Please enter the answer';
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
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    "Links:",
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: Mycolors.mainColorBlack,
                                        // fontFamily: 'bold',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13),
                                    textAlign: TextAlign.start,
                                  ),
                                ),

                              for (var i = 0; i < links.length; i++)
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Wrap(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 11),
                                        child: RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: linkname[i],
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: Colors.blue),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () async {
                                                       
                                                        launch(links[i]);
                                                      })
                                          ]),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 1),
                                        child: IconButton(
                                            onPressed: (() =>
                                                ConfirmationDialogfordelete(
                                                    context, i)),
                                            icon: Icon(
                                              Icons.cancel,
                                              size: 20,
                                            )),
                                      )
                                    ],
                                  ),
                                ),

                             
                              if (filesurl!.length > 0)
                                const Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                              if (filesurl!.length > 0)
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Files:",
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: Mycolors.mainColorBlack,
                                        //  fontFamily: 'bold',
                                        fontSize: 13),
                                    textAlign: TextAlign.start,
                                  ),
                                ),

                              if (filesurl != null)
                                for (var l = 0; l < filesurl!.length; l++)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 200),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: filesurl![l].name,
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: Colors.blue),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () async {
                                                        openfile(filesurl![l]);
                                                      })
                                          ]),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 1),
                                          child: IconButton(
                                              onPressed: (() =>
                                                  ConfirmationDialogfordeleteforfile(
                                                      context, l)),
                                              icon: Icon(
                                                Icons.cancel,
                                                size: 20,
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                              SizedBox(
                                height: 8,
                              ),
                             
                              SizedBox(
                                height: 8,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(fontSize: 16),
                                  // shadowColor: Colors.blue[900],
                                  elevation: 0,
                                  backgroundColor: Mycolors.mainShadedColorBlue,
                                  minimumSize: Size(150, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(17), // <-- Radius
                                  ),
                                ),
                                onPressed: () async {
                                  if (formkey.currentState!.validate()) {
                                    upload();
                                    retriveissuetitle(
                                        _issuetitleconstroller.text);

                                    if (exist == true) {
                                      confirm(context);
                                    }
                                    if (exist == false) {
                                      showInSnackBar(context,
                                          "Another frequently asked question with the same title already exists",
                                          onError: true);
                                    }
                                  }
                                },
                                child: Text("Add"),
                              ),
                            ])),
                  )),
            )));
  }

  showConfirmationDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontSize: 16),
        // shadowColor: Colors.blue[900],
        elevation: 0,
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
        textStyle: TextStyle(fontSize: 16),
        // shadowColor: Colors.blue[900],
        elevation: 0,
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
            urlname = _linknamecontroll.text;
            print(link);
            links.add(link);
            linkname.add(urlname);
            print(urlname);
            print(linkname);

            //add to array of map
            Navigator.of(context).pop();
          });
        }
      },
    );
    AlertDialog alert = AlertDialog(
      // title: Text(""),
      content: SizedBox(
        height: 230,
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
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "URL name",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                            color: Mycolors.mainColorBlack,
                            // fontFamily: 'bold',
                            fontSize: 13),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                        controller: _linknamecontroll,
                        decoration: InputDecoration(
                            //  labelText: 'URL name',
                            hintText: "Enter the url name ",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13),
                                borderSide: const BorderSide(
                                  width: 0,
                                ))),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty || _linknamecontroll.text == "") {
                            return 'Please enter the link name';
                          } else {
                            if (!(english.hasMatch(_linknamecontroll.text))) {
                              return "only english is allowed";
                            }
                          }
                        }),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              SizedBox(
                width: 350,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "URL",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                            color: Mycolors.mainColorBlack,
                            // fontFamily: 'bold',
                            fontSize: 13),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                        controller: _linkcontroll,
                        decoration: InputDecoration(
                            //labelText: 'URL',
                            hintText: "Paste the link ",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13),
                                borderSide: const BorderSide(
                                  width: 0,
                                ))),
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
                  ],
                ),
              ),
              SizedBox(
                height: 8,
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
        textStyle: TextStyle(fontSize: 16),
        //shadowColor: Colors.blue[900],
        elevation: 0,
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
        textStyle: TextStyle(fontSize: 16),
        //shadowColor: Colors.blue[900],
        elevation: 0,
        backgroundColor: Mycolors.mainShadedColorBlue,
        minimumSize: Size(70, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // <-- Radius
        ),
      ),
      child: Text("Confirm"),
      onPressed: () async {
        showInSnackBar(context,
            "The frequently asked question has been added successfully");
        if (formkey.currentState!.validate()) {
          problem = _problemController.text;
          solution = _solutioncontroll.text;
          isuuetitle = _issuetitleconstroller.text;
          await FirebaseFirestore.instance.collection('commonissue').doc().set({
            "issuetitle": isuuetitle,
            "problem": problem,
            "solution": solution,
            "semester": semesterRef,
            "issuecategory": FirebaseFirestore.instance
                .collection("facultyspeciality")
                .doc(docforspeciality),
            "links": links,
            "linkname": linkname,
            "filesurl": fileurltoDB,
            'createdby': facultyRef,
            'lastmodified': null,
          });
          // Navigator.pushNamed(context, 'facultyListFAQ');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => facultyhome(_selectedIndex),
            ),
          );
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
                  "You will add frequently asked question under ${specialityselectedvalue} specialty "),
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
        textStyle: TextStyle(fontSize: 16),
        // shadowColor: Colors.blue[900],
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
        textStyle: TextStyle(fontSize: 16),
        //shadowColor: Colors.blue[900],
        elevation: 0,
        backgroundColor: Mycolors.mainShadedColorBlue,
        minimumSize: Size(60, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // <-- Radius
        ),
      ),
      child: Text("Yes"),
      onPressed: () async {
        links.remove(links[i]);
        linkname.remove(linkname[i]);
        Future.delayed(Duration(seconds: 0), () {
          setState(() {});
        });
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      // title: Text("LogOut"),
      content: Text("Are you sure you want to delete this link?"),
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

  ConfirmationDialogfordeleteforfile(BuildContext context, var i) {
    Widget dontCancelAppButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontSize: 16),
        // shadowColor: Colors.blue[900],
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
        textStyle: TextStyle(fontSize: 16),
        // shadowColor: Colors.blue[900],
        elevation: 0,
        backgroundColor: Mycolors.mainShadedColorBlue,
        minimumSize: Size(60, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // <-- Radius
        ),
      ),
      child: Text("Yes"),
      onPressed: () async {
        // links.remove(links[i]);
        // linkname.remove(linkname[i]);
        print("/////////////////////////////////");
        print(i);
        filesurl?.remove(filesurl![i]);
        Future.delayed(Duration(seconds: 0), () {
          setState(() {});
        });
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      // title: Text("LogOut"),
      content: Text("Are you sure you want to delete this file?"),
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
