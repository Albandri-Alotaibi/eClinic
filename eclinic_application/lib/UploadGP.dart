import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
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
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';



class UploadGP extends StatefulWidget {
  const UploadGP({super.key});
  @override
  State<UploadGP> createState() => _UploadGPState();
}

class _UploadGPState extends State<UploadGP> {
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
  bool? graduationDateArrived;
  //bool categoryselected=false;
  List category = [];
  List gpcategoryname = [];
  final formkey = GlobalKey<FormState>();
  RegExp GitHubFormat = new RegExp(r'https://github.com/.*',
      multiLine: false, caseSensitive: false);
var GPname;
var Fileurl;
late String id;
var CodeLink='';
var AddedGitHubRepository;

  void initState() {
    super.initState();
    HasUploadedOrNot();
    graduationDateCheck();
    retrivegpcategory();
    retrievesemester();
    retrieveForAfterUploadView();
    bool isshow = false;
  }


retrieveForAfterUploadView() async {
   final FirebaseAuth auth = await FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    userid = user!.uid;
    email = user.email!;


   final snap = await FirebaseFirestore.instance
        .collection("student")
        .doc(userid)
        .get();

// group
 var group=await snap['group'];
  final DocumentSnapshot groupRef = await group.get(); 
  print(groupRef['projectname']);
GPname=groupRef['projectname'];



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
      snapshot.docs.forEach((DocumentSnapshot doc) async{
        // print(doc.reference);
        // StudentsArrayOfRef.add(doc.reference);
        print("yes2");
           Fileurl=await doc['FileUrl'];
           id=doc.id;
          
       final snap4 = await FirebaseFirestore.instance
        .collection("GPlibrary")
        .doc(id)
        .get();
 //print(snap4.id);
    if (snap4.data()!.containsKey('CodeLink') == true) {
      CodeLink=snap4['CodeLink'];
      print("ppppppppppppppppppppppppp");
      print(CodeLink);
    }



    });     
});







}//end method




Future openFile2({required String url, String? fileName}) async{
      final file= await downloadFile(url, fileName!);
      if(file==null)return;

      print('Path: ${file.path}');

      OpenFile.open(file.path);


}

Future<File?> downloadFile(String url, String name) async{
final appStorage = await getApplicationDocumentsDirectory();
final file= File('${appStorage.path}/$name');

try{
final response= await Dio().get(
     url,
     options: Options(
      responseType: ResponseType.bytes,
      followRedirects: false,
      receiveTimeout:0,
     ),
);

final raf= file.openSync(mode: FileMode.write);
raf.writeFromSync(response.data);
await raf.close();

return file;
}
catch(e){
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

  graduationDateCheck() async {
    final FirebaseAuth auth = await FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    userid = user!.uid;
    email = user.email!;

    final snap = await FirebaseFirestore.instance
        .collection("student")
        .doc(userid)
        .get();

// group
 var group=await snap['group'];
  final DocumentSnapshot groupRef = await group.get(); 
  print(groupRef['projectname']);
 
    DateTime now = new DateTime.now();
    Timestamp t = groupRef['Projectcompletiondate'] as Timestamp;
    DateTime graduationDate = t.toDate();

    if (now.isAfter(graduationDate)) {
      setState(() {
        graduationDateArrived = true;
      });
    } else {
      setState(() {
        graduationDateArrived = false;
      });
    }
    print("**Grad date**${graduationDateArrived}*********");
  } //end function grad date

  HasUploadedOrNot() async {
    final FirebaseAuth auth = await FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    userid = user!.uid;
    email = user.email!;

    final snap = await FirebaseFirestore.instance
        .collection("student")
        .doc(userid)
        .get();

var group=await snap['group'];
final DocumentSnapshot groupRef = await group.get(); 
  print(groupRef['projectname']);

    bool uploadgp = groupRef['uploadgp'];

    AlreadyUploaded = uploadgp;
    print("**Uploaded**${AlreadyUploaded}*********");
  }

  PlatformFile? pickedFile;

  Future uploadFile() async {

final snap = await FirebaseFirestore.instance
        .collection("student")
        .doc(userid)
        .get();

// final snap = await FirebaseFirestore.instance
//         .collection("student")
//         .doc(userid)
//         .update({
//       'uploadgp': true,
//     });

// var group=await snap['group'];
// final DocumentSnapshot groupRef = await group.get(); 

//COULD BE WRONG**************make group abload true*************************** THE COMMENT ONE ABOVE IS THE OLD
final snap4 = await snap['group']
        .update({
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

   var group=await snap['group'];
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
      showerror(context, "Only pdf format is acceptable");
    } //end else not pdf
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
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
                      Padding(
                        padding: const EdgeInsets.only(right: 12, left: 0),
                        child: Text(
                          msg,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
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

  @override
  Widget build(BuildContext context) {
    print("Category length ${checklengthforcategory}");
    //print("Category selected  ${categoryselected}");

    if ((AlreadyUploaded == false) && (graduationDateArrived == true)) {
      return SafeArea(
          child: Scaffold(
              backgroundColor: Mycolors.BackgroundColor,
              body: SingleChildScrollView(
                child: Center(
                    child: Column(
                  children: [
                    if (pickedFile != null) const SizedBox(height: 20),

                    if (pickedFile != null)
                      Container(
                        height: 170,
                        width: 380,
                        child: Card(
                          //Mycolors.mainShadedColorBlue
                          color: Color.fromARGB(171, 204, 204, 210),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30), // <-- Radius
                          ),
                          shadowColor: Color.fromARGB(171, 212, 212, 240),
                          elevation: 40,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    //iconSize: 100,
                                    alignment: Alignment.topLeft,
                                    color: Color.fromARGB(255, 74, 72, 72),
                                    icon: const Icon(
                                      Icons.attach_file,
                                      size: 35,
                                    ),
                                    // the method which is called
                                    // when button is pressed
                                    onPressed: selectFile,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: new GestureDetector(
                                  child: Center(
                                      child: Text(pickedFile!.name,
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color:
                                                  Mycolors.mainShadedColorBlue,
                                              fontFamily: 'main',
                                              fontSize: 20),
                                          textAlign: TextAlign.end)),
                                  onTap: () {
                                    openFile(pickedFile!);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    if (pickedFile != null) const SizedBox(height: 35),

                    if (pickedFile != null)
                      Container(
                        height: 125,
                        width: 360,
                        child: Column(children: [
                          Text(
                              "Under which category does your project fall? \n",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Mycolors.mainColorBlack,
                                  fontFamily: 'main',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.5)),
                          DropDownMultiSelect(
                            decoration: InputDecoration(
                                hintText: "Graduation project category",
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: isshow ? Colors.red : Colors.grey),
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
                                )),
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
                                          color:
                                              Color.fromARGB(255, 211, 56, 45),
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
                        padding: const EdgeInsets.all(13.0),
                        child: Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (pickedFile != null)
                                Container(
                                  // height: 125,
                                  width: 360,
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                          "When did you finish your graduation project? \n",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Mycolors.mainColorBlack,
                                              fontFamily: 'main',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.5)),
                                      DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          hintText: ' Choose a semester:',
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              borderSide: const BorderSide(
                                                width: 0,
                                              )),
                                        ),
                                        isExpanded: true,
                                        items: semester
                                            .map((String dropdownitems) {
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
                                    ), //Text
                                    SizedBox(width: 5),
                                  ],
                                ),
                              if (checkboxvalue == true)
                                Container(
                                  width: 360,
                                  child: TextFormField(
                                    controller: GitHubController,
                                    decoration: InputDecoration(
                                        hintText:
                                            "Please add your GitHub repository link here",

                                        ///*******وش فايدتها؟ */
                                        labelText: ' GitHub repository link',
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
                          textStyle:
                              TextStyle(fontFamily: 'main', fontSize: 16),
                          shadowColor: Colors.blue[900],
                          elevation: 20,
                          backgroundColor: Mycolors.mainShadedColorBlue,
                          minimumSize: Size(200, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(17), // <-- Radius
                          ),
                        ),
                        child: Text(
                          "Upload file",
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
                      // ElevatedButton(
                      //   style: ElevatedButton.styleFrom(
                      //     textStyle:
                      //         TextStyle(fontFamily: 'main', fontSize: 16),
                      //     shadowColor: Colors.blue[900],
                      //     elevation: 20,
                      //     backgroundColor: Mycolors.mainShadedColorBlue,
                      //     minimumSize: Size(200, 50),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius:
                      //           BorderRadius.circular(17), // <-- Radius
                      //     ),
                      //   ),
                      //   child: Text(
                      //     "Select file",
                      //   ),
                      //   onPressed: selectFile,
                      // ),



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
                                              
                                              color:Color.fromARGB(255, 120, 127, 139),

                                                  //Mycolors.mainShadedColorBlue,
                                             // fontFamily: 'main',
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
    } else if (AlreadyUploaded == true) {
      return SafeArea(
        child: Scaffold(
            backgroundColor: Mycolors.BackgroundColor,
            body: Container(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 19),
                    child: Text(
                      "GP upload",
                      style: TextStyle(
                          color: Mycolors.mainColorBlack,
                          fontFamily: 'main',
                          fontSize: 24),
                    ),
                  ),
                  Card(
                    color: Mycolors.mainShadedColorBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17), // <-- Radius
                    ),
                    shadowColor: Color.fromARGB(94, 114, 168, 243),
                    elevation: 20,
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Text(
                        "Your GP document has been uploaded by you or one of your group members along with your social media conctacts.\nYou can edit you socials from your profile.",
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            color: Mycolors.mainColorWhite,
                            fontFamily: 'main',
                            fontSize: 17),
                      ),
                    ),
                  ),

                  




          Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                         
                                         onPressed: (){ 
                                         openFile2(
                                url:Fileurl,
                                fileName:'${GPname}.pdf',
                                );
                                         }
                                        ),
                                     ],
                                   ),
                               new GestureDetector(
                                  child: Center(
                                      child: Text("View your file",
                                          style: TextStyle(
                                              
                                              color:Color.fromARGB(255, 120, 127, 139),

                                                  //Mycolors.mainShadedColorBlue,
                                             // fontFamily: 'main',
                                              fontSize: 20),
                                          textAlign: TextAlign.center)),
                                  onTap: () {
                                    openFile2(
                                url:Fileurl,
                                fileName:'${GPname}.pdf',
                                );
                                  //print("clicked");
                                  },
                                ),
                  ],
                ),

  




  //CODE
   const SizedBox(height: 10,),
           if(CodeLink != '')
          new RichText(
                                                text: new TextSpan(
                                                  //text: 'Meeting Link : ',
                                                  children: [
                                                    new TextSpan(
                                                      // style: defaultText,
                                                      text: "Github repository link : ",
                                                      style: TextStyle(
                                                          color: Mycolors
                                                              .mainColorBlack,
                                                          fontFamily: 'main',
                                                          fontSize: 15),
                                                    ),
                                                    new TextSpan(
                                                      //new TextStyle(color: Colors.blue)
                                                      text: 'Click here \n',
                                                      style: TextStyle(
                                                          color: Colors.blue,
                                                          fontFamily: 'main',
                                                          fontSize: 15),
                                                      recognizer:
                                                          new TapGestureRecognizer()
                                                            ..onTap = () {
                                                              launch(CodeLink); //''+BookedAppointments[index].meetingInfo+''
                                                            },
                                                    ),
                                                  ],
                                                ),
                                              ),





                ],
              ),
            )),
      );
    } else if (graduationDateArrived == false) {
      return SafeArea(
        child: Scaffold(
            backgroundColor: Mycolors.BackgroundColor,
            body: Container(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 19),
                    child: Text(
                      "GP upload",
                      style: TextStyle(
                          color: Mycolors.mainColorBlack,
                          fontFamily: 'main',
                          fontSize: 24),
                    ),
                  ),
                  Card(
                    color: Mycolors.mainShadedColorBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17), // <-- Radius
                    ),
                    shadowColor: Color.fromARGB(94, 114, 168, 243),
                    elevation: 20,
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Text(
                        "You can't upload you GP document now.\nWait till your finish it, to upload a complete documnet.",
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            color: Mycolors.mainColorWhite,
                            fontFamily: 'main',
                            fontSize: 17),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      );
    } else {
      return SafeArea(
          child: Scaffold(
        body: Container(child: Text("")),
      ));
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
            builder: (context) => UploadGP(), //studenthome
          ),
        );
      },
    );
  }
}
