import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myapp/facultyhome.dart';
import 'package:myapp/screeens/resources/snackbar.dart';
import 'package:myapp/viewFAQ.dart';
import 'editFAQ.dart';
import 'style/Mycolors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:open_file/open_file.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import '';
import 'package:myapp/screeens/resources/dialog.dart';

class editFAQ extends StatefulWidget {
  String value;
  editFAQ({super.key, required this.value});

  @override
  State<editFAQ> createState() => _editFAQState();
}

class _editFAQState extends State<editFAQ> {
  @override
  void initState() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    userid = user!.uid;
    // TODO: implement initState
    super.initState();
    getcommonissue();
    createdname();
    getlink();
    getfacultysemester();
  }

  int _selectedIndex = 2;
  var userid;
  final formkey = GlobalKey<FormState>();
  final formkeyforlink = GlobalKey<FormState>();
  var link;
  String? title;
  var problem;
  var solution;
  var newproblem;
  var newsolution;
  List newlinks = [];
  List links = [];
  List linkname = [];
  var urlname;
  List<PlatformFile>? filesurl = [];
  List filsbefordownload = [];
  List fileurltoDB = [];
  bool isloading = false;
  PlatformFile? pickedFile;
  var c;
  int i = 0;
  var snap;
  bool exist = false;
  var semesterref;
  var _issuetitleconstroller = TextEditingController();
  var _problemController = TextEditingController();
  var _solutioncontroll = TextEditingController();
  final _linkcontroll = TextEditingController();
  final _linknamecontroll = TextEditingController();
  RegExp english = RegExp("^[\u0000-\u007F]+\$");
  var fname;
  var lname;
  var fullname;
  var facultyRef;

  getcommonissue() async {
    snap = await FirebaseFirestore.instance
        .collection('commonissue')
        .doc(widget.value)
        .get();
    setState(() {
      title = snap["issuetitle"];
    });
    problem = snap["problem"];
    solution = snap["solution"];
    _problemController = TextEditingController(text: problem);
    _solutioncontroll = TextEditingController(text: solution);

    // links = snap["links"];

    // for (var j = 0; j < links.length; j++) {
    //   links.add(links[j]);
    //   print("neeeeeeeeeeewwwwwwwwwww");
    //   print(links[j]);
    // }

    if (title != null) {
      exist = true;
    }
    print(problem);
    print(solution);
    print(links);
    print(linkname);
    print(widget.value);
  }

  getfacultysemester() async {
    var snap = await FirebaseFirestore.instance
        .collection('faculty')
        .doc(userid)
        .get();
    semesterref = snap["semester"];
  }

  getlink() async {
    var snap1 = await FirebaseFirestore.instance
        .collection('commonissue')
        .doc(widget.value)
        .get();
    links = snap1["links"];
    linkname = snap1["linkname"];
    filsbefordownload = snap1['filesurl'];
    print("kkkkkkkkkkkkkkkkkkkkkkkkkk");
    // print(linkname);
    // print(links);
    print(filsbefordownload);
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
      // delete fileurltoDB after check
      fileurltoDB.add(FileUrl);
      filsbefordownload.add(FileUrl);
      //delete from the new if its down load
      // filesurl?.remove(filesurl![i]);
      print(FileUrl);
      print(fileurltoDB);
    }
    setState(() {
      print("finnnnnsssssssssshhhhh");
      filesurl?.clear();
      isloading = false;
    });
  }

  Future openFile({required String url, String? fileName}) async {
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

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.delete_sweep_outlined,
                color: Mycolors.mainColorRed,
              ),
              onPressed: () {
                //delete common issue
                confirmdeltewarning(context);
              },
            )
          ],
          centerTitle: true,
          backgroundColor: Mycolors.mainColorWhite,
          shadowColor: Colors.transparent,
          iconTheme: const IconThemeData(
            color: Color.fromARGB(255, 12, 12, 12),
          ),
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: Mycolors.mainShadedColorBlue,
          ),
          title: Text("${title}"),
          leading: InkWell(
            onTap: () {
              Navigator.pop(this.context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black45,
            ),
          ),
        ),
        body: SingleChildScrollView(
            clipBehavior: Clip.none,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formkey,
                child: Column(children: [
                  FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('commonissue')
                          .doc(widget.value)
                          .get(),
                      builder: ((context, snapshot) {
                        _issuetitleconstroller =
                            TextEditingController(text: title);

                        return Column(
                          children: [
                            // TextFormField(
                            //   controller: _issuetitleconstroller,
                            //   readOnly: true,
                            //   decoration: InputDecoration(
                            //       labelText: ' issue title :',
                            //       // hintText: "Enter issue title",

                            //       border: OutlineInputBorder(
                            //           borderRadius: BorderRadius.circular(25),
                            //           borderSide: const BorderSide(
                            //             width: 0,
                            //           ))),
                            //   autovalidateMode:
                            //       AutovalidateMode.onUserInteraction,
                            // ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // ElevatedButton(
                                //   style: ElevatedButton.styleFrom(
                                //     textStyle: TextStyle(
                                //         fontFamily: 'main', fontSize: 16),
                                //     //shadowColor: Colors.blue[900],
                                //     elevation: 0,
                                //     backgroundColor:
                                //         Mycolors.mainShadedColorBlue,
                                //     minimumSize: Size(150, 50),
                                //     shape: RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.circular(
                                //           17), // <-- Radius
                                //     ),
                                //   ),
                                //   onPressed: (() async {
                                //     final result = await FilePicker.platform
                                //         .pickFiles(allowMultiple: true);
                                //     if (result == null) return;
                                //     setState(() {
                                //       pickedFile = result.files.first;
                                //       if (pickedFile != null) {
                                //         filesurl?.addAll(result.files);

                                //         // for (var i = 0; i < result.count; i++) {
                                //         //    filesurl?.add(result.files as PlatformFile);
                                //         // }
                                //       }
                                //       var exe = pickedFile!.extension;
                                //       print("00000000000000000000");
                                //       print(pickedFile!.path);
                                //       print(pickedFile!.name);
                                //       print(filesurl);
                                //     });
                                //   }),
                                //   child: Text("upload file"),
                                // ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(bottom: 7),
                                  height: 40,
                                  width: 135,
                                  child: FloatingActionButton.extended(
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

                                          // for (var i = 0; i < result.count; i++) {
                                          //    filesurl?.add(result.files as PlatformFile);
                                          // }
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
                                // ElevatedButton(
                                //   style: ElevatedButton.styleFrom(
                                //     textStyle: TextStyle(
                                //         fontFamily: 'main', fontSize: 16),
                                //     //shadowColor: Colors.blue[900],
                                //     elevation: 0,
                                //     backgroundColor:
                                //         Mycolors.mainShadedColorBlue,
                                //     minimumSize: Size(150, 50),
                                //     shape: RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.circular(
                                //           17), // <-- Radius
                                //     ),
                                //   ),
                                //   onPressed: (() {
                                //     _linkcontroll.text = "";
                                //     _linknamecontroll.text = "";
                                //     showConfirmationDialog(context);
                                //   }),
                                //   child: Text("add link"),
                                // ),
                                Container(
                                  padding: const EdgeInsets.only(bottom: 7),
                                  height: 40,
                                  width: 135,
                                  child: FloatingActionButton.extended(
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
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Question:",
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Mycolors.mainColorBlack,
                                    fontWeight: FontWeight.w500,
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
                              maxLines: 50,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.edit),
                                  // labelText: ' problem :',
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
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Answer:",
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Mycolors.mainColorBlack,
                                    fontWeight: FontWeight.w500,
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
                              maxLines: 50,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.edit),
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
                              height: 10,
                            ),
                            if (links.length > 0)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Links:",
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Mycolors.mainColorBlack,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13),
                                  textAlign: TextAlign.start,
                                ),
                              ),

                            if (links.length > 0)
                              Row(
                                children: List.generate(
                                  links.length,
                                  (index) => Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // Text(
                                      //   "More Resources",
                                      //   style: TextStyle(
                                      //       overflow: TextOverflow.ellipsis,
                                      //       color: Mycolors.mainColorBlue,
                                      //       fontFamily: 'bold',
                                      //       fontSize: 17),
                                      //   textAlign: TextAlign.start,
                                      // ),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Wrap(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 11),
                                              child: RichText(
                                                text: TextSpan(children: [
                                                  TextSpan(
                                                      text: linkname[index],
                                                      style: TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          color: Colors.blue),
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () async {
                                                              launch(
                                                                  links[index]);
                                                            })
                                                ]),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 1),
                                              child: IconButton(
                                                  onPressed: (() {
                                                    // c = links[i];
                                                    ConfirmationDialogfordeletelink(
                                                        context, index);
                                                  }),
                                                  icon: Icon(
                                                    Icons.cancel,
                                                    size: 20,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            if (filesurl!.length > 0 ||
                                filsbefordownload.length > 0)
                              const Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                            if (filesurl!.length > 0 ||
                                filsbefordownload.length > 0)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Files:",
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Mycolors.mainColorBlack,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13),
                                  textAlign: TextAlign.start,
                                ),
                              ),

                            if (filsbefordownload.length > 0)
                              for (var s = 0; s < filsbefordownload.length; s++)
                                Padding(
                                  padding: const EdgeInsets.only(right: 267),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                              text: "File ${s + 1}",
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Colors.blue),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () async {
                                                  print(filsbefordownload[s]);
                                                  // openfile(filesurl![l]);
                                                  openFile(
                                                      url: filsbefordownload[s],
                                                      fileName: "File");
                                                })
                                        ]),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 1),
                                        child: IconButton(
                                            onPressed: (() =>
                                                ConfirmationDialogfordeleteforfileafterdownload(
                                                    context, s)),
                                            icon: Icon(
                                              Icons.cancel,
                                              size: 20,
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                            if (filesurl != null)
                              for (var l = 0; l < filesurl!.length; l++)
                                Padding(
                                  padding: const EdgeInsets.only(right: 175),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                              text: filesurl![l].name,
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Colors.blue),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () async {
                                                  openfile(filesurl![l]);
                                                })
                                        ]),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 1),
                                        child: IconButton(
                                            onPressed: (() =>
                                                ConfirmationDialogfordeleteforfilebefordownload(
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
                              height: 20,
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     // ElevatedButton(
                            //     //   style: ElevatedButton.styleFrom(
                            //     //     textStyle: TextStyle(
                            //     //         fontFamily: 'main', fontSize: 16),
                            //     //     //shadowColor: Colors.blue[900],
                            //     //     elevation: 0,
                            //     //     backgroundColor:
                            //     //         Mycolors.mainShadedColorBlue,
                            //     //     minimumSize: Size(150, 50),
                            //     //     shape: RoundedRectangleBorder(
                            //     //       borderRadius: BorderRadius.circular(
                            //     //           17), // <-- Radius
                            //     //     ),
                            //     //   ),
                            //     //   onPressed: (() async {
                            //     //     final result = await FilePicker.platform
                            //     //         .pickFiles(allowMultiple: true);
                            //     //     if (result == null) return;
                            //     //     setState(() {
                            //     //       pickedFile = result.files.first;
                            //     //       if (pickedFile != null) {
                            //     //         filesurl?.addAll(result.files);

                            //     //         // for (var i = 0; i < result.count; i++) {
                            //     //         //    filesurl?.add(result.files as PlatformFile);
                            //     //         // }
                            //     //       }
                            //     //       var exe = pickedFile!.extension;
                            //     //       print("00000000000000000000");
                            //     //       print(pickedFile!.path);
                            //     //       print(pickedFile!.name);
                            //     //       print(filesurl);
                            //     //     });
                            //     //   }),
                            //     //   child: Text("upload file"),
                            //     // ),
                            //     SizedBox(
                            //       width: 10,
                            //     ),
                            //     Container(
                            //       padding: const EdgeInsets.only(bottom: 7),
                            //       height: 40,
                            //       width: 135,
                            //       child: FloatingActionButton.extended(
                            //         shape: RoundedRectangleBorder(
                            //           borderRadius: BorderRadius.circular(
                            //               30), // <-- Radius
                            //           side: BorderSide(
                            //             width: 1,
                            //             color: Mycolors.mainShadedColorBlue,
                            //           ),
                            //         ),
                            //         splashColor: Mycolors.mainShadedColorBlue,
                            //         elevation: 0,
                            //         foregroundColor:
                            //             Color.fromARGB(255, 255, 255, 255),
                            //         label: Text(
                            //           'Uplouad file',
                            //         ), // <-- Text
                            //         backgroundColor:
                            //             Mycolors.mainShadedColorBlue,
                            //         icon: Icon(
                            //           // <-- Icon
                            //           Icons.upload_outlined,
                            //           size: 24.0,
                            //         ),
                            //         onPressed: (() async {
                            //           final result = await FilePicker.platform
                            //               .pickFiles(allowMultiple: true);
                            //           if (result == null) return;
                            //           setState(() {
                            //             pickedFile = result.files.first;
                            //             if (pickedFile != null) {
                            //               filesurl?.addAll(result.files);

                            //               // for (var i = 0; i < result.count; i++) {
                            //               //    filesurl?.add(result.files as PlatformFile);
                            //               // }
                            //             }
                            //             var exe = pickedFile!.extension;
                            //             print("00000000000000000000");
                            //             print(pickedFile!.path);
                            //             print(pickedFile!.name);
                            //             print(filesurl);
                            //           });
                            //         }),
                            //       ),
                            //     ),
                            //     SizedBox(
                            //       width: 10,
                            //     ),
                            //     // ElevatedButton(
                            //     //   style: ElevatedButton.styleFrom(
                            //     //     textStyle: TextStyle(
                            //     //         fontFamily: 'main', fontSize: 16),
                            //     //     //shadowColor: Colors.blue[900],
                            //     //     elevation: 0,
                            //     //     backgroundColor:
                            //     //         Mycolors.mainShadedColorBlue,
                            //     //     minimumSize: Size(150, 50),
                            //     //     shape: RoundedRectangleBorder(
                            //     //       borderRadius: BorderRadius.circular(
                            //     //           17), // <-- Radius
                            //     //     ),
                            //     //   ),
                            //     //   onPressed: (() {
                            //     //     _linkcontroll.text = "";
                            //     //     _linknamecontroll.text = "";
                            //     //     showConfirmationDialog(context);
                            //     //   }),
                            //     //   child: Text("add link"),
                            //     // ),
                            //     Container(
                            //       padding: const EdgeInsets.only(bottom: 7),
                            //       height: 40,
                            //       width: 135,
                            //       child: FloatingActionButton.extended(
                            //         shape: RoundedRectangleBorder(
                            //           borderRadius: BorderRadius.circular(
                            //               30), // <-- Radius
                            //           side: BorderSide(
                            //             width: 1,
                            //             color: Mycolors.mainShadedColorBlue,
                            //           ),
                            //         ),
                            //         splashColor: Mycolors.mainShadedColorBlue,
                            //         elevation: 0,
                            //         foregroundColor:
                            //             Color.fromARGB(255, 255, 255, 255),
                            //         label: Text(
                            //           'Add link',
                            //         ), // <-- Text
                            //         backgroundColor:
                            //             Mycolors.mainShadedColorBlue,
                            //         icon: Icon(
                            //           // <-- Icon
                            //           Icons.link_outlined,
                            //           size: 24.0,
                            //         ),
                            //         onPressed: (() {
                            //           _linkcontroll.text = "";
                            //           _linknamecontroll.text = "";
                            //           showConfirmationDialog(context);
                            //         }),
                            //       ),
                            //     ),
                            //   ],
                            // ),

                            SizedBox(
                              height: 50,
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
                              onPressed: () {
                                upload();
                                if (formkey.currentState!.validate()) {
                                  ConfirmationDialogforupdate(context);
                                }
                              },
                              child: Text("Save"),
                            ),
                          ],
                        );
                      })),
                  SizedBox(
                    height: 20,
                  ),
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
                  //     shadowColor: Colors.blue[900],
                  //     elevation: 16,
                  //     backgroundColor: Mycolors.mainShadedColorBlue,
                  //     minimumSize: Size(150, 50),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(17), // <-- Radius
                  //     ),
                  //   ),
                  //   onPressed: (() {
                  //     ConfirmationDialogfordelete(context);
                  //   }),
                  //   child: Text("delete common issue"),
                  // ),
                ]),
              ),
            )),
      ),
    );
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
            // print(_linkcontroll.text);
            // print(link);
            links.add(link);
            linkname.add(urlname);
            print(links);
            Navigator.of(context).pop();
          });
        }
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(""),
      content: SizedBox(
        height: 200,
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
              SizedBox(
                width: 350,
                child: TextFormField(
                    controller: _linknamecontroll,
                    decoration: InputDecoration(
                        // labelText: 'URL name',
                        hintText: "Enter the url name  ",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: const BorderSide(
                              width: 0,
                            ))),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty || _linknamecontroll.text == "") {
                        return 'Please enter the url name';
                      } else {
                        if (!(english.hasMatch(_linknamecontroll.text))) {
                          return "only english is allowed";
                        }
                      }
                    }),
              ),
              SizedBox(
                height: 8,
              ),
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
              SizedBox(
                width: 350,
                child: TextFormField(
                    controller: _linkcontroll,
                    decoration: InputDecoration(
                        // labelText: 'Li',
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

  confirmdeltewarning(BuildContext context) {
    // set up the buttons
    buildShowDialog(
      context: context,
      title: 'Warning',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.sd_card_alert_rounded,
            size: 80,
            color: Colors.amber,
          ),
          SizedBox(
            height: 4,
          ),
          Text(
              "Are you sure you want to delete the frequently asked question ?"),
          SizedBox(
            height: 8,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
                  //shadowColor: Colors.blue[900],
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
              ),
              SizedBox(
                width: 5,
              ),
              ElevatedButton(
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
                  await FirebaseFirestore.instance
                      .collection("commonissue")
                      .doc(widget.value)
                      .delete();
                  // Navigator.pushNamed(context, 'facultyListFAQ');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => facultyhome(_selectedIndex),
                    ),
                  );
                  showInSnackBar(context,
                      "The frequently asked question has been deleted successfully");
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  // ConfirmationDialogfordelete(BuildContext context) {
  //   Widget dontCancelAppButton = ElevatedButton(
  //     style: ElevatedButton.styleFrom(
  //       textStyle: TextStyle(fontSize: 16),
  //       //shadowColor: Colors.blue[900],
  //       elevation: 0,
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
  //       textStyle: TextStyle(fontSize: 16),
  //       // shadowColor: Colors.blue[900],
  //       elevation: 0,
  //       backgroundColor: Mycolors.mainShadedColorBlue,
  //       minimumSize: Size(60, 40),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10), // <-- Radius
  //       ),
  //     ),
  //     child: Text("Yes"),
  //     onPressed: () async {
  //       await FirebaseFirestore.instance
  //           .collection("commonissue")
  //           .doc(widget.value)
  //           .delete();
  //       // Navigator.pushNamed(context, 'facultyListFAQ');
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => facultyhome(_selectedIndex),
  //         ),
  //       );
  //       showInSnackBar(
  //           context, "The  has been deleted successfully");
  //     },
  //   );

  //   AlertDialog alert = AlertDialog(
  //     // title: Text("LogOut"),
  //     content: Text("Are you sure you want to delete the common issue ?"),
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

  ConfirmationDialogforupdate(BuildContext context) {
    Widget dontCancelAppButton = ElevatedButton(
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
        setState(() {
          newproblem = _problemController.text;
          newsolution = _solutioncontroll.text;
          newlinks = links;
          //اضيف الفايل اللي انضاف جديد على الالراي اللي قبل
        });

        if (formkey.currentState!.validate()) {
          //alertsucceful
          // Navigator.pushNamed(context, 'facultyListFAQ');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => facultyhome(_selectedIndex),
            ),
          );
          try {
            FirebaseFirestore.instance
                .collection('commonissue')
                .doc(widget.value)
                .update({
              'problem': newproblem,
              'solution': newsolution,
              'links': newlinks,
              'linkname': linkname,
              'semester': semesterref,
              'filesurl': filsbefordownload,
              'lastmodified': facultyRef,
            });

            // Fluttertoast.showToast(
            //   msg: " Your information has been updated successfully",
            //   toastLength: Toast.LENGTH_SHORT,
            //   gravity: ToastGravity.CENTER,
            //   timeInSecForIosWeb: 2,
            //   backgroundColor: Color.fromARGB(255, 127, 166, 233),
            //   textColor: Color.fromARGB(255, 248, 249, 250),
            //   fontSize: 18.0,
            // );
            showInSnackBar(context,
                "The frequently asked question has been updated successfully");
          } on FirebaseAuthException catch (error) {
            // Fluttertoast.showToast(
            //   msg: "Something wronge",
            //   toastLength: Toast.LENGTH_SHORT,
            //   gravity: ToastGravity.CENTER,
            //   timeInSecForIosWeb: 5,
            //   backgroundColor: Color.fromARGB(255, 127, 166, 233),
            //   textColor: Color.fromARGB(255, 252, 253, 255),
            //   fontSize: 18.0,
            // );
            showInSnackBar(context, "Something wronge", onError: true);
          }
        }
      },
    );

    AlertDialog alert = AlertDialog(
      // title: Text("LogOut"),
      content: Text(
          "Are you sure you want to update the The frequently asked question ?"),
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

  ConfirmationDialogfordeletelink(BuildContext context, var i) {
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
      onPressed: () {
        // i = i - 1;
        //  print(linkname1);
        //كان فيه مشاكل بالانديكس وانحلت بالمعادله هذي
        // i = i - 1;
        // print("ppppppppppppppppp");
        // print(i);
        // // print(s);
        // //عشان الاي تكون قيمتها 1 دايم مع ان مفروض انه انديكس زيرو لكنه متخلف
        // if (i == 1) {
        //   i = 0;
        // }
        // links.remove(links[i]);
        // linkname.remove(linkname[i]);
        // Future.delayed(Duration(seconds: 0), () {
        //   setState(() {});
        // });
        // Navigator.of(context).pop();
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
      content: Text("Are you sure you want to delete this link ?"),
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

  ConfirmationDialogfordeleteforfilebefordownload(BuildContext context, var i) {
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

  ConfirmationDialogfordeleteforfileafterdownload(BuildContext context, var i) {
    Widget dontCancelAppButton = ElevatedButton(
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
        // links.remove(links[i]);
        // linkname.remove(linkname[i]);
        print("/////////////////////////////////");
        print(i);
        filsbefordownload.remove(filsbefordownload[i]);
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
