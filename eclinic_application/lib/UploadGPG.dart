import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:myapp/screeens/resources/snackbar.dart';
import 'package:myapp/studenthome.dart';
import 'package:myapp/style/Mycolors.dart';
import 'package:open_file/open_file.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multiselect/multiselect.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'model/socialLinks.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';

class UploadGPG extends StatefulWidget {
  const UploadGPG({super.key});
  @override
  State<UploadGPG> createState() => _UploadGPGState();
}

class _UploadGPGState extends State<UploadGPG> {
  RegExp english = RegExp("^[\u0000-\u007F]+\$");
  final GitHubController = TextEditingController();
  bool checkboxvalue = false;
  var semesterselectedvalue;
  var year;
  List<String> semester = [];
  late String docsforsemestername;
  String? email = '';
  String? userid = '';
  List<String> options = [];
  Rx<List<String>> selectedoptionlist = Rx<List<String>>([]);
  var selectedoption = "".obs;
  var checklengthforcategory = 0;
  bool isshow = false;
  bool? AlreadyUploaded;
  List category = [];
  List gpcategoryname = [];
  final formkey = GlobalKey<FormState>();
  RegExp GitHubFormat = new RegExp(r'https://github.com/.*',
      multiLine: false, caseSensitive: false);
  var GPname;
  var Fileurl;
  late String id;
  var CodeLink = '';
  var AddedGitHubRepository;
  List<socialLinks> SocialLinks = [];
  var Students;
  var group;
  late String groupid;
  bool? endSearchForLink = false;
  void initState() {
    super.initState();
    HasUploadedOrNot();

    retrivegpcategory();
    retrievesemester();
    retrieveForAfterUploadView();
    bool isshow = false;
  }

// CheckCode2() async{
//    print("222NewMethod*********-ppppppppppppppppppppppppp");
//           print(endSearchForLink);
//   final snap4 = await FirebaseFirestore.instance
//             .collection("GPlibrary")
//             .doc(id)
//             .get();

//         if (snap4.data()!.containsKey('CodeLink') == true) {
//           CodeLink = snap4['CodeLink'];
//           print("ppppppppppppppppppppppppp");
//           print(CodeLink);
//           setState(() {
//             endSearchForLink = true;
//           });
//         print("NewMethod*********-ppppppppppppppppppppppppp");
//           print(endSearchForLink);
//           } else {
//           setState(() {
//             endSearchForLink = true;
//           });
//         }
// }
  retrieveForAfterUploadView() async {
    final FirebaseAuth auth = await FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    userid = user!.uid;
    email = user.email!;

    final snap = await FirebaseFirestore.instance
        .collection("graduate")
        .doc(userid)
        .get();

// group
    group = await snap['group'];
    final DocumentSnapshot groupRef = await group.get();
    print(groupRef['projectname']);
    GPname = groupRef['projectname'];
    groupid = groupRef.id;

    //  final snap2 = await group
    //       .snapshots()
    //       .listen((event) async {
    //         print("INSIDE");
    //     bool? found;
    //     if (event.data()!.containsKey('appointments') == true) {
    //       if (event['appointments'].length == 0) {
    //         print("NOOO1 Future booked Appoinyments");
    //         setState(() {
    //           isExists = false;
    //         });
    //       }

    final snap3 = await FirebaseFirestore.instance
        .collection("GPlibrary")
        .where("group", isEqualTo: group)
        .get()
        .then((QuerySnapshot snapshot) {
//Map<String, dynamic> dataMap = snapshot.data() as Map<String, dynamic>;

      print("yes1");
      print(snapshot.size);
      snapshot.docs.forEach((DocumentSnapshot doc) async {
        // print(doc.reference);
        // StudentsArrayOfRef.add(doc.reference);
        print("yes2");
        Fileurl = await doc['FileUrl'];
        id = doc.id;

        var group = await doc['group'];
        final DocumentSnapshot groupRef = await group.get();

        //for social media
        Students = await groupRef['students'];
        for (var i = 0; i < Students.length; i++) {
          //  final DocumentSnapshot docRef2 = await Students[i].get();
          final DocumentSnapshot docRef2 = await Students[i]['ref'].get();
          print(docRef2['firstname']);
          var haveSocialAccount = docRef2['socialmedia'];

          if (haveSocialAccount != 'None') {
            print("inside not None");
            var medType = docRef2['socialmedia'];
            var link = docRef2['socialmediaaccount'];
            var Firstname = docRef2['firstname'];
            setState(() {
              SocialLinks.add(new socialLinks(
                studentName: Firstname,
                mediaType: medType,
                link: link,
              ));
            });
          }
        }
        //end social media
        print("11ppppppppppppppppppppppppp");
        print(endSearchForLink);
        final snap4 = await FirebaseFirestore.instance
            .collection("GPlibrary")
            .doc(id)
            .get();
        //print(snap4.id);

        if (snap4.data()!.containsKey('CodeLink') == true) {
          CodeLink = snap4['CodeLink'];
          print("ppppppppppppppppppppppppp");
          print(CodeLink);
          setState(() {
            endSearchForLink = true;
          });
          print("*********-ppppppppppppppppppppppppp");
          print(endSearchForLink);
        } else {
          setState(() {
            endSearchForLink = true;
          });
        }
      });
    });
    print("22-ppppppppppppppppppppppppp");
    print(endSearchForLink);
  } //end method

  Future openFile2({required String url, String? fileName}) async {
    final file = await downloadFile(url, fileName!);
    if (file == null) return;

    print('Path: ${file.path}');

    OpenFile.open(file.path);
  }

  Future<File?> downloadFile(String url, String name) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');

    try {
      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        ),
      );

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      return file;
    } catch (e) {
      return null;
    }
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

  checkidcategory(List<String?> categoryoption) async {
    category.clear();
    gpcategoryname.clear();
    // print(specialityoption);
    // print(speciality.length);
    // print(speciality);

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
                gpcategoryname.add(element['gpcategoryname']);
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

  HasUploadedOrNot() async {
    print("33-ppppppppppppppppppppppppp");
    print(endSearchForLink);
    final FirebaseAuth auth = await FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    userid = user!.uid;
    email = user.email!;

    final snap = await FirebaseFirestore.instance
        .collection("graduate")
        .doc(userid)
        .get();

    var group = await snap['group'];
    final DocumentSnapshot groupRef = await group.get();
    print(groupRef['projectname']);

    bool uploadgp = groupRef['uploadgp'];

    setState(() {
      AlreadyUploaded = uploadgp;
    });
    print("**Uploaded**${AlreadyUploaded}*********");
  }

  PlatformFile? pickedFile;

  Future uploadFile() async {
    final snap = await FirebaseFirestore.instance
        .collection("graduate")
        .doc(userid)
        .get();

    final snap4 = await snap['group'].update({
      'uploadgp': true,
    });

    print("*************** ABOUT TO UPLOAD *******************");

    final FirebaseAuth auth = await FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    userid = user!.uid;
    email = user.email!;

    final path = 'GPfiles/${pickedFile!.name}';
    final File file = File(pickedFile!.path!);

    final ref = await FirebaseStorage.instance.ref().child(path);

    //add to storage
    await ref.putFile(file);

    final FileUrl = await ref.getDownloadURL();
    print(FileUrl);

    var group = await snap['group'];
    final DocumentSnapshot groupRef = await group.get();
    String projectName = groupRef['projectname'];

    //add to firestore
    if (checkboxvalue == true) {
      await FirebaseFirestore.instance.collection("GPlibrary").doc().set({
        'FileUrl': FileUrl,
        'group': group,
        'GPcategory': category,
        'semester': FirebaseFirestore.instance
            .collection("semester")
            .doc(docsforsemestername),
        'CodeLink': GitHubController.text,
      });
    } else {
      await FirebaseFirestore.instance.collection("GPlibrary").doc().set({
        'FileUrl': FileUrl,
        'group': group,
        'semester': FirebaseFirestore.instance
            .collection("semester")
            .doc(docsforsemestername),
        'GPcategory': category,
      });
    }
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (result == null) return;

    if (result.files.first.extension == "pdf") {
      setState(() {
        pickedFile = result.files.first;
      });
    } else {
      setState(() {
        pickedFile = null;
      });

      //error message
      showInSnackBar(context, "Only pdf format is acceptable", onError: true);
      //showerror(context, "Only pdf format is acceptable");
    } //end else not pdf
  }

//semester functions
  retrievesemester() async {
    bool past = true;
    try {
      await FirebaseFirestore.instance
          .collection('semester')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          setState(() {
            // DateTime now = DateTime.now();
            // year = now.year;
            // print(year);
            // DateTime Dateoftoday = DateTime.now();

            // String s = year.toString();
            // print(s);
            // String sn = element['semestername'];
            // var startdate = element['startdate'];
            // startdate.toString();
            semester.add(element['semestername']); //من عندي
            // if (startdate != null) {
            //   if ((sn.contains(s))) {
            //     print(sn);
            //     semester.add(element['semestername']);
            //     print("ppppppppppppppppppppppppppppppppppppppp");
            //     print(semester);
            //   }

            //   Timestamp t = element['enddate'];
            //   DateTime enddate = t.toDate();

            //   if (Dateoftoday.isAfter(enddate)) {
            //     semester.remove(element['semestername']);
            //   }
            // }
          });
        });
        print(semester);
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future checkids(String? semstername) async {
    try {
      await FirebaseFirestore.instance
          .collection('semester')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          setState(() {
            if (semstername == element['semestername']) {
              docsforsemestername = element.id;
            }
          });
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  FocusNode myFocusNode = new FocusNode();
  @override
  Widget build(BuildContext context) {
    if ((AlreadyUploaded == false)) {
      return SafeArea(
          child: Scaffold(
              appBar: AppBar(
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
                // leading: BackButton(
                //   color: Colors.black,
                //   onPressed: () {
                //     Navigator.of(context).pop();
                //   },
                // ),
              ),
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                  child: Center(
                child: Column(children: [
                  if (pickedFile != null)
                    if (pickedFile != null)
                      Container(
                        height: 80,
                        width: 360,
                        child: Card(
                          //Mycolors.mainShadedColorBlue
                          color: Color.fromARGB(0, 232, 232, 232),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(13), // <-- Radius

                              side: BorderSide(
                                  color: Color.fromARGB(255, 211, 211, 211),
                                  width: 1)),
                          shadowColor: Color.fromARGB(171, 212, 212, 240),
                          elevation: 0,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image(
                                      image: AssetImage(
                                          'assets/images/document.png'),
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 7),
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            child: Text(
                                              pickedFile!.name,
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Mycolors
                                                      .mainShadedColorBlue,
                                                  fontSize: 20),
                                              textAlign: TextAlign.start,
                                              softWrap: false,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            onTap: () {
                                              openFile(pickedFile!);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    //iconSize: 100,
                                    alignment: Alignment.topRight,
                                    color: Color.fromARGB(187, 90, 90, 90),
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 30,
                                    ),
                                    // the method which is called
                                    // when button is pressed
                                    onPressed: selectFile,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  if (pickedFile != null) const SizedBox(height: 45),
                  if (pickedFile != null)
                    Container(
                      height: 125,
                      width: 360,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Under which category does your project fall?",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Mycolors.mainColorBlack,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.5)),
                            SizedBox(
                              height: 7,
                            ),
                            DropDownMultiSelect(
                              decoration: InputDecoration(
                                hintText: "Choose a category",
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: isshow
                                          ? Color.fromARGB(255, 202, 54, 44)
                                          : Colors.grey),
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: isshow
                                          ? Color.fromARGB(255, 209, 57, 46)
                                          : Mycolors.mainShadedColorBlue),
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2,
                                      color: isshow
                                          ? Color.fromARGB(255, 209, 57, 46)
                                          : Mycolors.mainShadedColorBlue),
                                  borderRadius: BorderRadius.circular(13),
                                ),
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
                                    checklengthforcategory =
                                        selectedoptionlist.value.length;
                                    isshow = selectedoption.value.isEmpty;

                                    if (checklengthforcategory < 1) {
                                      isshow = true;
                                    }
                                    if (checklengthforcategory > 0 ||
                                        selectedoption.value.isEmpty ||
                                        selectedoption.value == null) {
                                      isshow = false;
                                    }
                                  });
                                });
                                checkidcategory(selectedoptionlist.value);
                                // isshow = selectedoptionlist.value.isEmpty;
                                checklengthforcategory =
                                    selectedoptionlist.value.length;
                                if (checklengthforcategory < 1) {
                                  isshow = true;
                                }
                              },
                              selectedValues: selectedoptionlist.value,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 7),
                              child: Visibility(
                                visible: isshow,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "You have to select at least one graduation project category",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 211, 56, 45),
                                            fontSize: 12),
                                        textAlign: TextAlign.left,
                                      ),
                                    ]),
                              ),
                            ),
                          ]),
                    ),
                  Form(
                    key: formkey,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (pickedFile != null)
                              Container(
                                // height: 125,
                                width: 360,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        "When did you finish your graduation project?",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Mycolors.mainColorBlack,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.5)),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(13.0)),
                                            borderSide: BorderSide(
                                                width: 2,
                                                color: Mycolors
                                                    .mainShadedColorBlue)),
                                        hintText: 'Choose a semester',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(13),
                                            borderSide: BorderSide(
                                              color:
                                                  Mycolors.mainShadedColorBlue,
                                              width: 1,
                                            )),
                                      ),
                                      isExpanded: true,
                                      items:
                                          semester.map((String dropdownitems) {
                                        return DropdownMenuItem<String>(
                                          value: dropdownitems,
                                          child: Text(dropdownitems),
                                        );
                                      }).toList(),
                                      onChanged: (String? newselect) {
                                        setState(() {
                                          semesterselectedvalue = newselect;
                                          checkids(semesterselectedvalue);
                                        });
                                      },
                                      value: semesterselectedvalue,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value == null ||
                                            semesterselectedvalue!.isEmpty ||
                                            semesterselectedvalue == null) {
                                          return 'Please choose a semester';
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            if (pickedFile != null)
                              SizedBox(
                                height: 20,
                              ),
                            if (pickedFile != null)
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 10,
                                  ), //SizedBox
                                  Checkbox(
                                      value: checkboxvalue,
                                      onChanged: (newvalue) {
                                        setState(() {
                                          checkboxvalue = newvalue!;
                                        });
                                      }),

                                  Text(
                                    'I would like to share GitHub repository link',
                                    style: TextStyle(fontSize: 17.0),
                                  ),
                                  //Text
                                  // SizedBox(width: 5),
                                ],
                              ),
                            if (checkboxvalue == true)
                              Container(
                                width: 360,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      focusNode: myFocusNode,
                                      controller: GitHubController,
                                      onTap: () {
                                        setState(() {
                                          FocusScope.of(context)
                                              .requestFocus(myFocusNode);
                                        });
                                      },
                                      decoration: InputDecoration(
                                          hintText:
                                              "Please add your GitHub repository link here",

                                          ///*******وش فايدتها؟ */
                                          labelText: 'GitHub repository link',
                                          labelStyle: TextStyle(
                                              color: myFocusNode.hasFocus
                                                  ? Mycolors.mainShadedColorBlue
                                                  : Colors.black),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(13.0)),
                                              borderSide: BorderSide(
                                                  width: 2,
                                                  color: Mycolors
                                                      .mainShadedColorBlue)),
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
                                            GitHubController.text == "") {
                                          return 'Please add GitHub repository link ';
                                        } else {
                                          if (!(GitHubFormat.hasMatch(
                                              GitHubController.text))) {
                                            return 'Only GitHub link is acceptable';
                                          } else {
                                            if (!(english.hasMatch(
                                                GitHubController.text))) {
                                              return "only english is allowed";
                                            }
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (pickedFile != null) const SizedBox(height: 15),
                  if (pickedFile != null)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(fontSize: 16),
                        shadowColor: Colors.blue[900],
                        elevation: 0,
                        backgroundColor: Mycolors.mainShadedColorBlue,
                        minimumSize: Size(200, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17), // <-- Radius
                        ),
                      ),
                      child: Text(
                        "Upload",
                      ),
                      onPressed: () {
                        // if(checkboxvalue==true){
                        if (formkey.currentState!.validate() &&
                            checklengthforcategory > 0) {
                          uploadFile();
                          showSucessAlert();
                          print("category is selected ");
                        } else if (checklengthforcategory == 0) {
                          setState(() {
                            isshow = true;
                          });
                        }
                      },
                    ),
                  if (pickedFile == null) const SizedBox(height: 230),
                  if (pickedFile == null)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              iconSize: 120,
                              alignment: Alignment.center,
                              color: Color.fromARGB(255, 5, 81, 212),
                              icon: const Icon(
                                Icons.upload_file,
                                size: 120,
                              ),
                              onPressed: selectFile,
                            ),
                          ],
                        ),
                        new GestureDetector(
                          child: Center(
                              child: Text("Select a file",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 120, 127, 139),

                                      //Mycolors.mainShadedColorBlue,

                                      fontSize: 20),
                                  textAlign: TextAlign.center)),
                          onTap: () {
                            selectFile();
                            //print("clicked");
                          },
                        ),
                      ],
                    ),
                ]),
              ))));
    } else if (AlreadyUploaded == true && endSearchForLink! == true) {
      return SafeArea(
        child: Scaffold(
            appBar: AppBar(
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
              // leading: BackButton(
              //   color: Colors.black,
              //   onPressed: () {
              //     Navigator.of(context).pop();
              //   },
              // ),
            ),
            backgroundColor: Mycolors.BackgroundColor,
            body: Center(
              // width: 360,
              // alignment: Alignment.topCenter,
              child: SizedBox(
                width: 370,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                        child: Card(
                          color: Mycolors.mainShadedColorBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(17), // <-- Radius
                          ),
                          shadowColor: Color.fromARGB(94, 114, 168, 243),
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                                "Your GP document has been uploaded by you or one of your group members along with your social media conctacts.\nYou can edit you socials from your profile.",
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    color: Mycolors.mainColorWhite,
                                    fontSize: 17),
                                textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: 160,
                    // ),
                    Card(
                      color: Color.fromARGB(37, 232, 232, 232),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13), // <-- Radius

                          side: const BorderSide(
                              color: Color.fromARGB(255, 211, 211, 211),
                              width: 1)),
                      elevation: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  iconSize: 60,
                                  alignment: Alignment.center,
                                  color: Color.fromARGB(255, 5, 81, 212),
                                  icon: const Icon(
                                    Icons.file_open,
                                    size: 60,
                                  ),
                                  onPressed: () {
                                    openFile2(
                                      url: Fileurl,
                                      fileName: '${GPname}.pdf',
                                    );
                                  }),
                            ],
                          ),
                          GestureDetector(
                            child: const Center(
                                child: Text("View your GP document",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 120, 127, 139),

                                        //Mycolors.mainShadedColorBlue,

                                        fontSize: 20),
                                    textAlign: TextAlign.center)),
                            onTap: () {
                              openFile2(
                                url: Fileurl,
                                fileName: '${GPname}.pdf',
                              );
                              //print("clicked");
                            },
                          ),
                        ],
                      ),
                    ),

                    //CODE
                    const SizedBox(
                      height: 0,
                    ),
                    if (CodeLink != '')
                      Card(
                        color: Color.fromARGB(37, 232, 232, 232),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(13), // <-- Radius

                            side: const BorderSide(
                                color: Color.fromARGB(255, 211, 211, 211),
                                width: 1)),
                        elevation: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                    iconSize: 60,
                                    alignment: Alignment.center,
                                    color: Color.fromARGB(255, 5, 81, 212),
                                    icon: const Icon(
                                      Icons.code,
                                      size: 60,
                                    ),
                                    onPressed: () {
                                      launch(CodeLink);
                                    }),
                              ],
                            ),
                            GestureDetector(
                              child: const Center(
                                  child: Text("View your Github repository",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 120, 127, 139),

                                          //Mycolors.mainShadedColorBlue,

                                          fontSize: 20),
                                      textAlign: TextAlign.center)),
                              onTap: () {
                                launch(CodeLink);
                              },
                            ),
                          ],
                        ),
                      ),
                    Spacer(),
                    if (SocialLinks.length != 0)
                      Card(
                          color: Color.fromARGB(37, 232, 232, 232),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(13), // <-- Radius

                              side: const BorderSide(
                                  color: Color.fromARGB(255, 211, 211, 211),
                                  width: 1)),
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: SizedBox(
                              //  height: 50,
                              child: GridView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 200,
                                          childAspectRatio: 3,
                                          crossAxisSpacing: 60,
                                          mainAxisSpacing: 10),
                                  itemCount: SocialLinks.length,
                                  itemBuilder: ((context, index) {
                                    if (index < SocialLinks.length) {
                                      if (SocialLinks[index].mediaType ==
                                          'WhatsApp') {
                                        return Container(
                                          child: ListView(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            children: <Widget>[
                                              Row(
                                                children: [
                                                  Text('     '),
                                                  GestureDetector(
                                                    onTap: () {
                                                      launch(SocialLinks[index]
                                                          .link);
                                                    },
                                                    child: Image.asset(
                                                      'assets/images/whatsapp.png',
                                                      // name: 'ff',
                                                      width: 40,
                                                      height: 40,

                                                      //fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Text('   ' +
                                                      SocialLinks[index]
                                                          .studentName),
                                                ],
                                              ),
                                              //Text("vvvv")
                                            ],
                                          ),
                                          //Text('xxxxxx')
                                        );
                                      } else if (SocialLinks[index].mediaType ==
                                          'Twitter') {
                                        return Container(
                                          child: ListView(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            children: <Widget>[
                                              Row(
                                                children: [
                                                  Text('     '),
                                                  GestureDetector(
                                                    onTap: () {
                                                      launch(SocialLinks[index]
                                                          .link);
                                                    },
                                                    child: Image.asset(
                                                      'assets/images/twitter.png', // On click should redirect to an URL
                                                      width: 40,
                                                      height: 40,
                                                      //fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Text('   ' +
                                                      SocialLinks[index]
                                                          .studentName),
                                                ],
                                              ),
                                              // Text("vvvv")
                                            ],
                                          ),
                                        );
                                      } else if (SocialLinks[index].mediaType ==
                                          'LinkedIn') {
                                        return Container(
                                          child: ListView(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            children: <Widget>[
                                              Row(
                                                children: [
                                                  Text('     '),
                                                  GestureDetector(
                                                    onTap: () {
                                                      launch(SocialLinks[index]
                                                          .link);
                                                    },
                                                    child: Image.asset(
                                                      'assets/images/linkedin.png', // On click should redirect to an URL
                                                      width: 40,
                                                      height: 40,
                                                      //fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Text('   ' +
                                                      SocialLinks[index]
                                                          .studentName),
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Row();
                                      }
                                    } else {
                                      return Row();
                                    }
                                  })),
                            ),
                          )),
                    SizedBox(
                      height: 10,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom: 7),
                          height: 40,
                          width: 100,
                          child: FloatingActionButton.extended(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(30), // <-- Radius
                              side: BorderSide(
                                width: 1,
                                color: Color.fromARGB(255, 169, 43, 34),
                              ),
                            ),
                            splashColor: Colors.red[900],
                            elevation: 0,
                            foregroundColor: Color.fromARGB(255, 255, 255, 255),
                            label: Text(
                              'Delete',
                            ), // <-- Text
                            backgroundColor: Colors.red[900],
                            icon: Icon(
                              // <-- Icon
                              Icons.delete,
                              size: 24.0,
                            ),
                            onPressed: () => {showConfirmationDialog(context)},
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            )),
      );
    } else {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
              child: CircularProgressIndicator(
                  color: Mycolors.mainShadedColorBlue)));
    }
  } //end build

  openFile(PlatformFile file) {
    OpenFile.open(file.path!);
  }

  showSucessAlert() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: "Uploaded successfully",
      text: 'Thank you!',
      onConfirmBtnTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UploadGPG(),
          ),
        );
      },
    );
  }

  showConfirmationDialog(BuildContext context) async {
    Widget dontDeleteAppButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontSize: 16),
        shadowColor: Colors.blue[900],
        elevation: 0,
        backgroundColor: Mycolors.mainShadedColorBlue,
        minimumSize: Size(60, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // <-- Radius
        ),
      ),
      child: Text("Cancle"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget YesDeleteButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontSize: 16),
        shadowColor: Colors.blue[900],
        elevation: 0,
        backgroundColor: Mycolors.mainShadedColorBlue,
        minimumSize: Size(60, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // <-- Radius
        ),
      ),
      child: Text("Delete"),
      onPressed: () {
        DeleteGP();
      },
    );
    AlertDialog alert = AlertDialog(
      content: SizedBox(
        height: 190,
        child: Form(
          key: formkey,
          child: Column(children: [
            Text(
                "Deleting your GP will remove it from the GP library.\n Are you sure you want to delete it?\n"),
          ]),
        ),
      ),
      actions: [
        dontDeleteAppButton,
        YesDeleteButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  } //END FUNCTION

  DeleteGP() async {
    await FirebaseFirestore.instance.collection("GPlibrary").doc(id).delete();

    FirebaseFirestore.instance.collection("studentgroup").doc(groupid).update({
      'uploadgp': false,
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadGPG(),
      ),
    );
    showInSnackBar(context, "Your project has been successfully deleted");
  } //end delete function
}
