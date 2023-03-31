import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:myapp/studenthome.dart';
import 'package:myapp/style/Mycolors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'model/socialLinks.dart';
import 'package:url_launcher/url_launcher.dart';

class viewOneGP extends StatefulWidget {
  viewOneGP({super.key, required this.GPid});
  var GPid;
  @override
  State<viewOneGP> createState() => _viewOneGPState();
}

class _viewOneGPState extends State<viewOneGP> {
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.GPid.runtimeType);
    print(widget.GPid);
    retrieve();
  }

  bool? endSearchForLink = false;
  var GPcategory;
  var GPname;
  var CodeLink = '';
  var Students;
  var group;
  var Fileurl;
  String? email = '';
  String? userid = '';
  List<socialLinks> SocialLinks = [];

  retrieve() async {
    final FirebaseAuth auth = await FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    userid = user!.uid;
    email = user.email!;

    final snap = await FirebaseFirestore.instance
        .collection("GPlibrary")
        .doc(widget.GPid)
        .get();

    Fileurl = await snap['FileUrl'];
    print(Fileurl);

    if (snap.data()!.containsKey('CodeLink') == true) {
      CodeLink = snap['CodeLink'];
    }
    var group = await snap['group'];
    final DocumentSnapshot groupRef = await group.get();

    Students = await groupRef['students'];
    print(Students.length);

    GPname = groupRef['projectname'];

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
    setState(() {
      endSearchForLink = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (endSearchForLink! == true) {
      return SafeArea(
          child: Scaffold(
              appBar: AppBar(
                title: Text(
                  "${GPname}",
                  style: TextStyle(
                      //  fontFamily: 'bold',
                      fontSize: 20,
                      color: Mycolors.mainColorBlack),
                ),
                elevation: 0,
                primary: false,
                centerTitle: true,
                backgroundColor: Colors.white,
                leading: BackButton(
                  color: Colors.black,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => studenthome(2),
                      ),
                    );
                  },
                ),
              ),
              backgroundColor: Colors.white, //Mycolors.BackgroundColor
              body: Center(
                  child: SizedBox(
                width: 370,
                child: Column(children: <Widget>[
                  const SizedBox(
                    height: 50,
                  ),

                  Card(
                    color: Color.fromARGB(37, 232, 232, 232),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13), // <-- Radius

                        side: BorderSide(
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
                                  openFile(
                                    url: Fileurl,
                                    fileName: '${GPname}.pdf',
                                  );
                                }),
                          ],
                        ),
                        new GestureDetector(
                          child: Center(
                              child: Text("View GP document",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 120, 127, 139),

                                      //Mycolors.mainShadedColorBlue,

                                      fontSize: 20),
                                  textAlign: TextAlign.center)),
                          onTap: () {
                            openFile(
                              url: Fileurl,
                              fileName: '${GPname}.pdf',
                            );
                            //print("clicked");
                          },
                        ),
                      ],
                    ),
                  ),

                  // ElevatedButton(
                  //     child: Text('Open file'),
                  //     onPressed: () => openFile(
                  //           url: Fileurl,
                  //           fileName: '${GPname}.pdf',
                  //         )),

                  if (CodeLink != '')
                    Card(
                      color: Color.fromARGB(37, 232, 232, 232),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13), // <-- Radius

                          side: BorderSide(
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
                                    Icons.code,
                                    size: 60,
                                  ),
                                  onPressed: () {
                                    launch(CodeLink);
                                  }),
                            ],
                          ),
                          new GestureDetector(
                            child: Center(
                                child: Text("View Github repository",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 120, 127, 139),

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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Students contact links:",
                          style: TextStyle(
                              color: Color.fromARGB(255, 120, 127, 139),
                              fontSize: 15),
                        ),
                        Card(
                            color: Color.fromARGB(0, 232, 232, 232),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(13), // <-- Radius

                                side: const BorderSide(
                                    color: Color.fromARGB(187, 211, 211, 211),
                                    width: 1)),
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 8),
                              child: SizedBox(
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
                                                        launch(
                                                            SocialLinks[index]
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
                                        } else if (SocialLinks[index]
                                                .mediaType ==
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
                                                        launch(
                                                            SocialLinks[index]
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
                                        } else if (SocialLinks[index]
                                                .mediaType ==
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
                                                        launch(
                                                            SocialLinks[index]
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
                      ],
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                ]),
              ))));
    } else {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
              child: CircularProgressIndicator(
                  color: Mycolors.mainShadedColorBlue)));
    }
  } //end build

  socialMediaCreation() {
    //  for (int i = 0; i < BookedAppointments.length; i++) {

    //  }
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
} //end class
