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
import 'editFAQ.dart';
import 'style/Mycolors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class viewFAQ extends StatefulWidget {
  String value;
  viewFAQ({super.key, required this.value});
  @override
  State<viewFAQ> createState() => _viewFAQState(value);
}

class _viewFAQState extends State<viewFAQ> {
  String value;

  _viewFAQState(this.value);
  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {});
    });
    // TODO: implement initState
    getcommonissue();
    super.initState();
  }

  var title;
  var problem;
  var solution;
  var semster;
  var speciality;
  List links = [];
  List linkname = [];
  List<PlatformFile>? filesurl = [];
  var snap;
  List filsbefordownload = [];

  getcommonissue() async {
    snap = await FirebaseFirestore.instance
        .collection('commonissue')
        .doc(widget.value)
        .get();
    title = snap["issuetitle"];
    problem = snap["problem"];
    solution = snap["solution"];
    links = snap["links"];
    linkname = snap["linkname"];
    filsbefordownload = snap['filesurl'];
    var semRef = snap['semester'];
    final DocumentSnapshot docRef = await semRef.get();
    semster = docRef['semestername'];

    var speRef = snap['issuecategory'];
    final DocumentSnapshot docRef2 = await speRef.get();
    speciality = docRef2['specialityname'];

    //     var collageRef = snap["collage"];
    // final DocumentSnapshot docRef3 = await collageRef.get();
    // collageselectedfromDB = docRef3["collagename"];

    print(snap["issuetitle"]);
    print(problem);
    print(solution);
    print(links);
    print(linkname);
    print(value);
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Mycolors.BackgroundColor,
      body: snap != null
          ? ListView(
              shrinkWrap: true,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => editFAQ(value: value))));
                  },
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Card(
                            color: Mycolors.mainColorWhite,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(17), // <-- Radius
                            ),
                            shadowColor:
                                const Color.fromARGB(94, 114, 168, 243),
                            child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: ListTile(
                                  title: Text("${title}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'bold',
                                      )),

                                  textColor: Mycolors.mainColorBlue,
                                  trailing: const Icon(
                                    Icons.edit_note,
                                    color: Colors.blue,
                                  ),

                                  // fontFamily: 'main',
                                  // fontWeight: FontWeight.w600
                                  // ),
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 16, right: 7, left: 7),
                    child: Column(
                      children: <Widget>[
                        // const Image(
                        //     image: AssetImage('./assets/images/check-mark.png'),
                        //     height: 180),

                        Column(
                          children: <Widget>[
                            Row(children: [
                              // const Icon(
                              //   Icons.collections_bookmark,
                              //   color: Colors.grey,
                              // ),
                              Text(
                                "  Speciality: ${speciality}",
                                style: TextStyle(
                                    letterSpacing: 0.1,
                                    fontSize: 14,
                                    fontFamily: "main",
                                    color: Mycolors.mainColorBlue,
                                    fontWeight: FontWeight.w500),
                              )
                            ]),
                            const Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                            Row(children: [
                              // const Icon(
                              //   Icons.timer,
                              //   color: Colors.grey,
                              // ),
                              Text(
                                "  Semester: ${semster} ",
                                style: TextStyle(
                                    letterSpacing: 0.1,
                                    fontSize: 14,
                                    fontFamily: "main",
                                    color: Mycolors.mainColorBlue,
                                    fontWeight: FontWeight.w500),
                              )
                            ]),
                            const Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.question_mark_outlined,
                                        color: Colors.red,
                                      ),
                                      Expanded(
                                          child: Text(
                                        "  Problem:\n\n${problem}",
                                        // "  Problem:\n\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                                        style: TextStyle(
                                            letterSpacing: 1.5,
                                            fontSize: 15,
                                            fontFamily: "main",
                                            color: Mycolors.mainColorBlue,
                                            fontWeight: FontWeight.w500),

                                        // decoration: const InputDecoration(
                                        //   prefixIcon: Icon(Icons.collections),
                                        // ),
                                      ))
                                    ])),
                            const Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.lightbulb,
                                      color: Colors.green,
                                    ),
                                    Expanded(
                                        child: Text(
                                      "  Solution:\n\n ${solution})",
                                      // "  Solution:\n\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                                      style: TextStyle(
                                          letterSpacing: 2,
                                          fontSize: 14,
                                          fontFamily: "main",
                                          color: Mycolors.mainColorBlue,
                                          fontWeight: FontWeight.w500),
                                    ))
                                  ],
                                )),
                            if (filsbefordownload != null)
                              const Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                            /**
                         * Document
                         */
                            if (filsbefordownload.length > 0)
                              Wrap(children: [
                                for (var item = 0;
                                    item < filsbefordownload.length;
                                    item++)
                                  ListTile(
                                      leading: const Icon(Icons.file_copy),
                                      title: Text('Document ${item + 1}'),
                                      subtitle:
                                          Text("هينا الرابط حق الفايرستورج"),
                                      onTap: () {
                                        openFile(
                                            url: filsbefordownload[item],
                                            fileName: "file");
                                      }),
                              ]),
                            const Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),

                            /**
                         * links
                         */
                            if (links.length > 0)
                              Wrap(children: [
                                for (var item = 0; item < links.length; item++)
                                  ListTile(
                                      leading: const Icon(Icons.link),
                                      title: linkname != null
                                          ? Text(linkname[item])
                                          : Text('Link ${item + 1}'),
                                      subtitle: Text(links[item]),
                                      onTap: () {
                                        launch(links[item]);
                                      }),
                              ]),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          : CircularProgressIndicator(),
      //   body: snap != null
      //       ? Container(
      //           child: SingleChildScrollView(
      //             child: Column(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 SizedBox(
      //                   height: 30,
      //                 ),
      //                 Card(
      //                   color: Mycolors.mainColorWhite,
      //                   shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(17), // <-- Radius
      //                   ),
      //                   shadowColor: Color.fromARGB(94, 114, 168, 243),
      //                   elevation: 20,
      //                   child: Padding(
      //                     padding: const EdgeInsets.only(
      //                         right: 100, left: 150, top: 30, bottom: 30),
      //                     child: Row(
      //                       children: [
      //                         Text(
      //                           title,
      //                           overflow: TextOverflow.clip,
      //                           style: TextStyle(
      //                               color: Mycolors.mainColorBlue,
      //                               fontFamily: 'main',
      //                               fontSize: 17),
      //                         ),
      //                         SizedBox(
      //                           width: 20,
      //                         ),
      //                         Padding(
      //                           padding: const EdgeInsets.all(3),
      //                           child: IconButton(
      //                               onPressed: () {
      //                                 Navigator.of(context).push(
      //                                     MaterialPageRoute(
      //                                         builder: ((context) =>
      //                                             editFAQ(value: value))));
      //                               },
      //                               icon: Icon(
      //                                 Icons.edit_note,
      //                                 size: 20,
      //                               )),
      //                         )
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //                 Card(
      //                   color: Mycolors.mainColorWhite,
      //                   shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(17), // <-- Radius
      //                   ),
      //                   shadowColor: Color.fromARGB(94, 114, 168, 243),
      //                   elevation: 20,
      //                   child: Padding(
      //                     padding: const EdgeInsets.only(
      //                         right: 100, left: 150, top: 30, bottom: 30),
      //                     child: Column(
      //                       children: [
      //                         Padding(
      //                           padding:
      //                               const EdgeInsets.only(left: 6, right: 70),
      //                           child: Text(
      //                             "Problem:",
      //                             style: TextStyle(
      //                                 color: Mycolors.mainColorBlue,
      //                                 fontFamily: 'bold',
      //                                 fontSize: 17),
      //                           ),
      //                         ),

      //                         Text(
      //                           problem,
      //                           overflow: TextOverflow.clip,
      //                           style: TextStyle(
      //                               color: Mycolors.mainColorBlue,
      //                               fontFamily: 'main',
      //                               fontSize: 15),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //                 Card(
      //                   color: Mycolors.mainColorWhite,
      //                   shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(17), // <-- Radius
      //                   ),
      //                   shadowColor: Color.fromARGB(94, 114, 168, 243),
      //                   elevation: 20,
      //                   child: Padding(
      //                     padding: const EdgeInsets.only(
      //                         right: 100, left: 150, top: 30, bottom: 30),
      //                     child: Column(
      //                       children: [
      //                         Padding(
      //                           padding:
      //                               const EdgeInsets.only(left: 6, right: 70),
      //                           child: Text(
      //                             "Solution:",
      //                             style: TextStyle(
      //                                 color: Mycolors.mainColorBlue,
      //                                 fontFamily: 'bold',
      //                                 fontSize: 17),
      //                           ),
      //                         ),
      //                         Text(
      //                           solution,
      //                           overflow: TextOverflow.clip,
      //                           style: TextStyle(
      //                               color: Mycolors.mainColorBlue,
      //                               fontFamily: 'main',
      //                               fontSize: 15),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //                 if (links.length > 0)
      //                   for (var i = 0; i < links.length; i++)
      //                     Card(
      //                       color: Mycolors.mainColorWhite,
      //                       shape: RoundedRectangleBorder(
      //                         borderRadius:
      //                             BorderRadius.circular(17), // <-- Radius
      //                       ),
      //                       shadowColor: Color.fromARGB(94, 114, 168, 243),
      //                       elevation: 20,
      //                       child: Padding(
      //                         padding: const EdgeInsets.only(
      //                             right: 100, left: 150, top: 30, bottom: 30),
      //                         child: Column(
      //                           children: [
      //                             Padding(
      //                               padding:
      //                                   const EdgeInsets.only(left: 6, right: 10),
      //                               child: Text(
      //                                 "More resourses:",
      //                                 style: TextStyle(
      //                                     overflow: TextOverflow.ellipsis,
      //                                     color: Mycolors.mainColorBlue,
      //                                     fontFamily: 'bold',
      //                                     fontSize: 17),
      //                               ),
      //                             ),
      //                             Row(
      //                                 mainAxisAlignment: MainAxisAlignment.center,
      //                                 children: [
      //                                   RichText(
      //                                     text: TextSpan(children: [
      //                                       TextSpan(
      //                                           text: linkname[i],
      //                                           style: TextStyle(
      //                                               decoration:
      //                                                   TextDecoration.underline,
      //                                               overflow:
      //                                                   TextOverflow.ellipsis,
      //                                               color: Colors.blue),
      //                                           recognizer: TapGestureRecognizer()
      //                                             ..onTap = () {
      //                                               //var url = links[i];
      //                                               // final uri = Uri.parse(url);
      //                                               // ignore: deprecated_member_use
      //                                               // if (await canLaunch(url)) {
      //                                               // ignore: deprecated_member_use
      //                                               launch(links[i]);
      //                                               // } else {
      //                                               //   throw "Cannot load url";
      //                                               // }
      //                                             })
      //                                     ]),
      //                                   ),
      //                                 ]),
      //                           ],
      //                         ),
      //                       ),
      //                     ),
      //                 if (filsbefordownload.length > 0)
      //                   for (var l = 0; l < filsbefordownload.length; l++)
      //                     Padding(
      //                       padding: const EdgeInsets.only(right: 200),
      //                       child: Row(
      //                         mainAxisAlignment: MainAxisAlignment.center,
      //                         children: [
      //                           RichText(
      //                             text: TextSpan(children: [
      //                               TextSpan(
      //                                   text: "file${l + 1}",
      //                                   style: TextStyle(
      //                                       decoration: TextDecoration.underline,
      //                                       color: Colors.blue),
      //                                   recognizer: TapGestureRecognizer()
      //                                     ..onTap = () async {
      //                                       print(filsbefordownload[l]);
      //                                       // openfile(filesurl![l]);
      //                                       openFile(
      //                                           url: filsbefordownload[l],
      //                                           fileName: "file");
      //                                     })
      //                             ]),
      //                           ),
      //                           // Padding(
      //                           //   padding: const EdgeInsets.only(top: 1),
      //                           //   child: IconButton(
      //                           //       onPressed: (() => (context)),
      //                           //       icon: Icon(
      //                           //         Icons.cancel,
      //                           //         size: 20,
      //                           //       )),
      //                           // )
      //                         ],
      //                       ),
      //                     ),
      //               ],
      //             ),
      //           ),
      //         )
      //       : CircularProgressIndicator(),
    ));
  }
}
