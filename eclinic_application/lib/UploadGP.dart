import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadGP extends StatefulWidget {
  const UploadGP({super.key});
  @override
  State<UploadGP> createState() => _UploadGPState();
}

class _UploadGPState extends State<UploadGP> {
   String? email = '';
  String? userid = '';


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
 
  final snap = await FirebaseFirestore.instance
        .collection("student")
        .doc(userid).get();
        String projectName=snap['projectname'];

List StudentsArrayOfRef = [];
 final snap2 = await FirebaseFirestore.instance
        .collection("student")
       .where("projectname", isEqualTo: projectName).get().then((QuerySnapshot snapshot) {
      print(snapshot.size);
      snapshot.docs.forEach((DocumentSnapshot doc) {
        print(doc.reference);
        StudentsArrayOfRef.add(doc.reference) ;
      });
    });





         //add to firestore
         await FirebaseFirestore.instance
          .collection("GPlibrary")
          .doc()
          .set({
        'FileUrl': FileUrl,
        'Students':StudentsArrayOfRef,
     });




  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    Body:
    return Column(
      children: [
        if (pickedFile != null)
          Expanded(
              child: Container(
            color: Colors.blue[100],
            child:new GestureDetector(
        onTap: (){
          //print("Container clicked");
          openFile(pickedFile!);
        },
        child: Center(
              child: Text(pickedFile!.name),
            ),
          ) 
          )),
        const SizedBox(height: 32),
         if (pickedFile == null)
        ElevatedButton(
          child: Text('Select File'),
          onPressed: selectFile,
        ),
         if (pickedFile != null)
        ElevatedButton(
          child: Text('Change selected file'),
          onPressed: selectFile,
        ),
         if (pickedFile != null)
        ElevatedButton(
          child: Text('Upload your file'),
          onPressed: uploadFile,
        ),
        const SizedBox(height: 32),
      ],
    );
  } //end build

  openFile(PlatformFile file) {
    //  openFile(file);//lاكانت كذا بالفيديو بس الميثود الثانية ماكانت موجودة
    OpenFile.open(file.path!);
  }



}
