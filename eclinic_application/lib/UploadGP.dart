import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:myapp/style/Mycolors.dart';
import 'package:open_file/open_file.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multiselect/multiselect.dart';
import 'package:get/get.dart';

class UploadGP extends StatefulWidget {
  const UploadGP({super.key});
  @override
  State<UploadGP> createState() => _UploadGPState();
}

class _UploadGPState extends State<UploadGP> {
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

  void initState() {
    super.initState();
    HasUploadedOrNot();
    graduationDateCheck();
     retrivegpcategory();
      bool isshow = false;
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
   // bool uploadgp = snap['uploadgp'];
DateTime now = new DateTime.now();
Timestamp t = snap['graduationDate'] as Timestamp;
DateTime graduationDate = t.toDate();

if(now.isAfter(graduationDate)){
  setState(() {
    graduationDateArrived=true;
  });
}
else{
setState(() {
    graduationDateArrived=false;
  });
}
    print("**Grad date**${graduationDateArrived}*********");

}//end function grad date









  HasUploadedOrNot() async {
    final FirebaseAuth auth = await FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    userid = user!.uid;
    email = user.email!;

    final snap = await FirebaseFirestore.instance
        .collection("student")
        .doc(userid)
        .get();
    bool uploadgp = snap['uploadgp'];
   // print(uploadgp);

    AlreadyUploaded = uploadgp;
    print("**Uploaded**${AlreadyUploaded}*********");
  }

  PlatformFile? pickedFile;

  Future uploadFile() async {
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

    final snap2 = await FirebaseFirestore.instance
        .collection("student")
        .doc(userid)
        .get();
    String projectName = snap2['projectname'];

    List StudentsArrayOfRef = [];
    final snap3 = await FirebaseFirestore.instance
        .collection("student")
        .where("projectname", isEqualTo: projectName)
        .get()
        .then((QuerySnapshot snapshot) {
      print(snapshot.size);
      snapshot.docs.forEach((DocumentSnapshot doc) {
        print(doc.reference);
        StudentsArrayOfRef.add(doc.reference);
      });
    });

//make uploadGP true to all group 
for (var i = 0; i < StudentsArrayOfRef.length; i++) {
      // final DocumentSnapshot docRef2 =
      //     await StudentsArrayOfRef[i].get();
StudentsArrayOfRef[i].update({
        'uploadgp': true,
      });

}//end loop





    //add to firestore
    await FirebaseFirestore.instance.collection("GPlibrary").doc().set({
      'FileUrl': FileUrl,
      'Students': StudentsArrayOfRef,
    });
  }




ShowingDialog(){


      Widget CancelButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
          shadowColor: Colors.blue[900],
          elevation: 20,
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



  

      Widget ConfirmButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
          shadowColor: Colors.blue[900],
          elevation: 20,
          backgroundColor: Mycolors.mainShadedColorBlue,
          minimumSize: Size(60, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // <-- Radius
          ),
        ),
        child: Text("Confirm"),
        onPressed:() {
          
      //if a category is selected 
      //uploadFile();
    // Navigator.of(context).pop();

      //else
      //error

        
        }  ,
       
      );
     
      AlertDialog alert = AlertDialog(
        // title: Text(""),
        content:
        Column(
            children: [
         Text("Select a Category"),
                   DropDownMultiSelect(
                                decoration: InputDecoration(
                                    hintText:
                                        "Select your graduation project category",
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: isshow
                                              ? Colors.red
                                              : Colors.grey),
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
                              SizedBox(
                                height: 2,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 7),
                                child: Visibility(
                                  visible: isshow,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Please choose your graduation project category",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 211, 56, 45),
                                              fontSize: 12),
                                          textAlign: TextAlign.left,
                                        ),
                                      ]),
                                ),
                              ),
            ]
            ),
        actions: [
          CancelButton,
          ConfirmButton,
        ],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );




}














  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result == null) return;

if(result.files.first.extension=="pdf"){
    setState(() {
      pickedFile = result.files.first;
    });
}else{
  setState(() {
    pickedFile = null;
  });

  //eroor message
showerror(context, "Only pdf format is acceptable");

}//end else not pdf

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

  @override
  Widget build(BuildContext context) {
    print("Category length ${checklengthforcategory}");
    //print("Category selected  ${categoryselected}");

    if ((AlreadyUploaded == false) && (graduationDateArrived==true)) {
      return SafeArea(
          child: Scaffold(
            backgroundColor: Mycolors.BackgroundColor,
              body: Center(
              child: Column(
        children: [
         
         if (pickedFile != null)
         const SizedBox(height: 120),


          if (pickedFile != null)
             Container(
                height: 170,
                width: 380,
                child: Card(
                //Mycolors.mainShadedColorBlue
                color: Color.fromARGB(171, 204, 204, 210),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // <-- Radius
                ),
                shadowColor: Color.fromARGB(171, 212, 212, 240),
                elevation: 40,
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child:  new GestureDetector(
                        child: Center(
                          child: Text(
                        pickedFile!.name,
                        style: TextStyle(
                           decoration: TextDecoration.underline,
                            color:Mycolors.mainShadedColorBlue,
                            fontFamily: 'main',
                            fontSize: 20),
                      textAlign: TextAlign.center)),
                      onTap: () {
                        //print("Container clicked");
                        openFile(pickedFile!);
                      },
                      
                    )
                ),
              ),
             ),



          if (pickedFile != null)
         const SizedBox(height: 200),


           if (pickedFile != null)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
                shadowColor: Colors.blue[900],
                elevation: 20,
                backgroundColor: Mycolors.mainShadedColorBlue,
                minimumSize: Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17), // <-- Radius
                ),
              ),
              child: Text(
                "Change selected file",
              ),
              onPressed: selectFile,
            ),


         if (pickedFile != null)
         const SizedBox(height: 15),



          if (pickedFile != null)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
                shadowColor: Colors.blue[900],
                elevation: 20,
                backgroundColor: Mycolors.mainShadedColorBlue,
                minimumSize: Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17), // <-- Radius
                ),
              ),
              child: Text(
                "Upload your file",
              ),
              onPressed: ShowingDialog,
            ),
          // const SizedBox(height: 32),
       






          //   Expanded(
          //       child: Container(
          //           color: Colors.blue[100],
          //           child: Center(
          //             child: new GestureDetector(
          //               child: Center(
          //                 child: Text(
          //               pickedFile!.name,
          //               style: TextStyle(
          //                   color: Mycolors.mainColorBlack,
          //                   fontFamily: 'main',
          //                   fontSize: 24),
          //             )),
          //             onTap: () {
          //               //print("Container clicked");
          //               openFile(pickedFile!);
          //             },
                      
          //           )
          //       )
          //           )),
          // const SizedBox(height: 100),
         
         if (pickedFile == null)
         const SizedBox(height: 290), 

          if (pickedFile == null)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
                shadowColor: Colors.blue[900],
                elevation: 20,
                backgroundColor: Mycolors.mainShadedColorBlue,
                minimumSize: Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17), // <-- Radius
                ),
              ),
              child: Text(
                "Select file",
              ),
              onPressed: selectFile,
            ),


        
       
       
       
       
        ],
      )
  )
      ));



    } else if(AlreadyUploaded == true){
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
                    "Your GP document has been uploaded by you or one of your group members, Thank you!",
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
    }
    else if(graduationDateArrived == false){
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
                    "You can't upload you GP document now, wait till your finish it all to upload a complete documnet.",
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
    }
    else{
        return SafeArea(
        child: Scaffold(
            body: Container(
              child: Text(
                    "Here")
            )));
    }
  } //end build

  openFile(PlatformFile file) {
    //  openFile(file);//lاكانت كذا بالفيديو بس الميثود الثانية ماكانت موجودة
    OpenFile.open(file.path!);
  }
}
