import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonIssueViewScreen extends StatefulWidget {
  const CommonIssueViewScreen({
    super.key,
    required this.commonIssue,
  });

  final Map<String, dynamic> commonIssue;

  @override
  CommonIssueViewScreenState createState() => CommonIssueViewScreenState();
}

class CommonIssueViewScreenState extends State<CommonIssueViewScreen> {
  late List students;

  late ThemeData themeData;

  var loading = false;
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
            Image(
              image: AssetImage('./assets/images/eClinicLogo-blue.png'),
              height: 80,
            ),
            Center(child: CircularProgressIndicator()),
            SizedBox(height: 20),
            Text(
              "Fetching the issue information, Please wait.....\n\n ",
              textAlign: TextAlign.center,
            ),
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
          title: Text(widget.commonIssue['issuetitle'] ?? ""),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
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
                          const Icon(
                            Icons.collections_bookmark,
                            color: Colors.grey,
                          ),
                          Text(
                            "  Speciality: ${category?['specialityname']}",
                            style: TextStyle(
                                letterSpacing: 0.1,
                                fontSize: 14,
                                fontFamily: "main",
                                color: themeData.colorScheme.primary,
                                fontWeight: FontWeight.w600),
                          )
                        ]),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        Row(children: [
                          const Icon(
                            Icons.timer,
                            color: Colors.grey,
                          ),
                          Text(
                            "  Semester: ${semester?['semestername']}",
                            style: TextStyle(
                                letterSpacing: 0.1,
                                fontSize: 14,
                                fontFamily: "main",
                                color: themeData.colorScheme.primary,
                                fontWeight: FontWeight.w600),
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
                                  "  Solution: ${widget.commonIssue['solution']})",
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
                        if (widget.commonIssue['document'] != null)
                          const Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                        /**
                         * Document
                         */
                        if (widget.commonIssue['document'] != null)
                          ListTile(
                              leading: const Icon(Icons.file_copy),
                              title: const Text('Docuemnt'),
                              subtitle: const Text("Click to download"),
                              onTap: () =>
                                  launchUrl(widget.commonIssue['document'])),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),

                        /**
                         * links
                         */
                        if (widget.commonIssue['links'] != null &&
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
                                  onTap: () => launchUrl(Uri.parse(
                                      widget.commonIssue['links'][item]))),
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
}

//end
