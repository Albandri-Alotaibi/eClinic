import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myapp/editFAQ.dart';
import 'package:path/path.dart' hide context;
import 'style/Mycolors.dart';

class facultyViewFAQ extends StatefulWidget {
  const facultyViewFAQ({
    super.key,
    required this.commonIssue,
  });
  final Map<String, dynamic> commonIssue;
  @override
  State<facultyViewFAQ> createState() => _facultyViewFAQState();
}

class _facultyViewFAQState extends State<facultyViewFAQ> {
  @override
  late List students;

  late ThemeData themeData;

  var loading = false;
  int loadingFile = -1;
  Map<int, String> downloadedFilesStatus = {};

  Map<String, dynamic>? semester;
  Map<String, dynamic>? category;

  @override
  void initState() {
    super.initState();

    loading = true;
    initCommonIssue();
  }

  void initCommonIssue() async {
    //get issue semester from reference
    DocumentSnapshot semesterData = await widget.commonIssue['semester'].get();
    if (semesterData.exists) {
      semester = semesterData.data() as Map<String, dynamic>;
    }

    //get issue category from reference
    DocumentSnapshot categoryData =
        await widget.commonIssue['issuecategory'].get();
    if (categoryData.exists) {
      category = categoryData.data() as Map<String, dynamic>;
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    //while loading data from database, show loading ...
    if (loading) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            // Image(
            //   image: AssetImage('./assets/images/eClinicLogo-blue.png'),
            //   height: 80,
            // ),
            Center(child: CircularProgressIndicator()),
            SizedBox(height: 20),
            // Text(
            //   "Fetching the issue information, Please wait.....\n\n ",
            //   textAlign: TextAlign.center,
            // ),
          ],
        ),
      );
    }
    //if loading is done, show issue info box
    else {
      return issueInfoBox();
    }
  }

  Widget issueInfoBox() {
    return SafeArea(
      child: Scaffold(
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
          title: Text(''),

          titleTextStyle: TextStyle(
            fontFamily: 'main',
            fontSize: 24,
            color: Mycolors.mainColorBlack,
          ),
        ),
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) =>
                        editFAQ(value: widget.commonIssue['id']))));
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
                          borderRadius: BorderRadius.circular(17), // <-- Radius
                        ),
                        shadowColor: const Color.fromARGB(94, 114, 168, 243),
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: ListTile(
                              title:
                                  Text(widget.commonIssue['issuetitle'] ?? "",
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
                            "  Speciality: ${category?['specialityname']}",
                            style: TextStyle(
                                letterSpacing: 0.1,
                                fontSize: 14,
                                fontFamily: "main",
                                color: themeData.colorScheme.primary,
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
                            "  Semester: ${semester?['semestername']}",
                            style: TextStyle(
                                letterSpacing: 0.1,
                                fontSize: 14,
                                fontFamily: "main",
                                color: themeData.colorScheme.primary,
                                fontWeight: FontWeight.w500),
                          )
                        ]),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.question_mark_outlined,
                                    color: Colors.red,
                                  ),
                                  Expanded(
                                      child: Text(
                                    "  Problem:\n\n${widget.commonIssue['problem']}",
                                    // "  Problem:\n\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                                    style: TextStyle(
                                        letterSpacing: 1.5,
                                        fontSize: 15,
                                        fontFamily: "main",
                                        color: themeData.colorScheme.primary,
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
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.lightbulb,
                                  color: Colors.green,
                                ),
                                Expanded(
                                    child: Text(
                                  "  Solution:\n\n ${widget.commonIssue['solution']})",
                                  // "  Solution:\n\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                                  style: TextStyle(
                                      letterSpacing: 2,
                                      fontSize: 14,
                                      fontFamily: "main",
                                      color: themeData.colorScheme.primary,
                                      fontWeight: FontWeight.w500),
                                ))
                              ],
                            )),
                        if (widget.commonIssue['filesurl'] != null)
                          const Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                        /**
                         * Document
                         */
                        if (widget.commonIssue['filesurl'] != null &&
                            widget.commonIssue['filesurl'] is List &&
                            widget.commonIssue['filesurl'].isNotEmpty)
                          Wrap(children: [
                            for (var item = 0;
                                item <
                                    (widget.commonIssue['filesurl'] ?? [])
                                        .length;
                                item++)
                              ListTile(
                                  leading: loadingFile == item
                                      ? const CircularProgressIndicator()
                                      : const Icon(Icons.file_copy),
                                  title: Text('Document ${item + 1}'),
                                  subtitle: Text(
                                    loadingFile == item
                                        ? "Opening..."
                                        : (downloadedFilesStatus
                                                .containsKey(item)
                                            ? downloadedFilesStatus[item]!
                                            : getFilename(
                                                widget.commonIssue['filesurl']
                                                    [item])),
                                    style: downloadedFilesStatus
                                            .containsKey(item)
                                        ? TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: downloadedFilesStatus[item]!
                                                    .contains('Error')
                                                ? Colors.red
                                                : Colors.green)
                                        : null,
                                  ),
                                  onLongPress: () async =>
                                      await Clipboard.setData(ClipboardData(
                                          text: widget.commonIssue['filesurl']
                                              [item])),
                                  onTap: () async => {
                                        downloadFile(
                                            widget.commonIssue['filesurl']
                                                [item],
                                            item)
                                      }),
                          ]),

                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),

                        /**
                         * links
                         */
                        if (widget.commonIssue['links'] != null &&
                            widget.commonIssue['links'] is List &&
                            widget.commonIssue['linkname'] is List &&
                            widget.commonIssue['links'].isNotEmpty)
                          Wrap(children: [
                            for (var item = 0;
                                item <
                                    (widget.commonIssue['links'] ?? []).length;
                                item++)
                              ListTile(
                                  leading: const Icon(Icons.link),
                                  title: widget.commonIssue['linkname'][item] !=
                                          null
                                      ? Text(
                                          widget.commonIssue['linkname'][item])
                                      : Text('Link ${item + 1}'),
                                  subtitle:
                                      Text(widget.commonIssue['links'][item]),
                                  onLongPress: () async =>
                                      await Clipboard.setData(ClipboardData(
                                          text: widget.commonIssue['links']
                                              [item])),
                                  onTap: () => launchUrl(
                                      Uri.parse(widget.commonIssue['links'][item]),
                                      mode: LaunchMode.externalApplication)),
                          ])

                        // Container(
                        //   margin: const EdgeInsets.only(top: 16),
                        //   width: MediaQuery.of(context).size.width,
                        //   decoration: BoxDecoration(
                        //     borderRadius:
                        //         const BorderRadius.all(Radius.circular(24)),
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color:
                        //             themeData.colorScheme.primary.withAlpha(18),
                        //         blurRadius: 3,
                        //         offset: const Offset(0, 1),
                        //       ),
                        //     ],
                        //   ),
                        //   // child: ElevatedButton(
                        //   //     style: ButtonStyle(
                        //   //         padding: MaterialStateProperty.all(
                        //   //             const EdgeInsets.symmetric(
                        //   //                 vertical: 16))),
                        //   //     onPressed: () {
                        //   //       Navigator.pushNamed(context, 'studenthome');
                        //   //     },
                        //   //     child: Text("Back to Home.",
                        //   //         style: TextStyle(
                        //   //             fontWeight: FontWeight.w600,
                        //   //             color:
                        //   //                 themeData.colorScheme.onPrimary,
                        //   //             letterSpacing: 0.5))),
                        // ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> downloadFile(String file, itemNumber) async {
    final Reference ref = FirebaseStorage.instance.refFromURL(file);

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final String urlFilename =
        basename(file.contains('?') ? file.split("?").first : file);

    final File tempFile = File('$appDocPath/$urlFilename');

    if (downloadedFilesStatus.containsKey(itemNumber) &&
        downloadedFilesStatus[itemNumber]!.contains("opened")) {
      await OpenFile.open(tempFile.path);
      return;
    }

    setState(() {
      loadingFile = itemNumber;
    });

    try {
      await ref.writeToFile(tempFile);
      await tempFile.create();
      await OpenFile.open(tempFile.path);
    } on FirebaseException {
      setState(() {
        downloadedFilesStatus[itemNumber] =
            "Error, we can not open this file ($urlFilename)";
        loadingFile = -1;
      });

      launchUrl(Uri.parse(widget.commonIssue['links'][itemNumber]),
          mode: LaunchMode.externalApplication);
    }
    setState(() {
      downloadedFilesStatus[itemNumber] =
          "File is already opened ($urlFilename).";
      loadingFile = -1;
    });
  }

  String getFilename(file) {
    return basename(file.contains('?') ? file.split("?").first : file);
  }
}