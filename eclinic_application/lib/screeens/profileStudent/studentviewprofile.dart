import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:myapp/app/constants.dart';
import 'package:myapp/bloc/profileStudent/bloc.dart';
import 'package:myapp/bloc/select_group/bloc.dart';
import 'package:myapp/domain/model.dart';
import 'package:myapp/screeens/profileStudent/widgets/change_departement.dart';
import 'package:myapp/screeens/profileStudent/widgets/change_group.dart';
import 'package:myapp/screeens/resources/dialog.dart';
import 'package:myapp/screeens/resources/snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/style/Mycolors.dart';
import '../../app/shardPreferense.dart';
import 'componants/text_header.dart';
import 'package:myapp/domain/extension.dart';

SizedBox _spacer = const SizedBox(
  height: 15,
);

class studentviewprofile extends StatefulWidget {
  const studentviewprofile({super.key});

  @override
  State<studentviewprofile> createState() => _studentviewprofileState();
}

class _studentviewprofileState extends State<studentviewprofile> {
  final formkey = GlobalKey<FormState>();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnamecontroller = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _socialmediaccount = TextEditingController();
  final TextEditingController _depertement = TextEditingController();
  final TextEditingController _groupName = TextEditingController();
  //String depertement  = '';

  String social = 'None';
  var selctedyear;
  var month;
  var GPdate;
  List<String> years = [];
  var year;
  var nowyear;
  var nextyear;

  @override
  void initState() {
    super.initState();
    //bool isshow = false;
    genrateyear();
  }

  genrateyear() {
    DateTime now = DateTime.now();
    nowyear = now.year;
    //DateTime Dateoftoday = DateTime.now();

    //String s = year.toString();
    nextyear = nowyear + 1;
    years.add(nowyear.toString());
    years.add(nextyear.toString());
  }

  dategp(String? year, String? month) {
    //print(selctedyear);
    //print(month);
    var gpdate = selctedyear + "-" + month + "-" + "15" + " " + "12:00:00.000";
    DateTime dt = DateTime.parse(gpdate);
    //print(gpdate);
    //print(dt);
    return dt;
    //2022-12-20 00:00:00.000
    //2023-09-15 00:00:00.000
  }

  //final double coverheight = 280;
  final double profileheight = 144;
  //final double top = 136 / 2; //coverheight - profileheight/2;
  RegExp nameRegExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
  RegExp idRegEx = RegExp(r'^[0-9]+$');
  RegExp countRegEx = RegExp(r'^\d{9}$');
  RegExp countRegEx10 = RegExp(r'^\d{10}$');
  RegExp english = RegExp("^[\u0000-\u007F]+\$");

  RegExp whatsappformat =
      RegExp(r'https://iwtsp.com/.*', multiLine: false, caseSensitive: false);

  RegExp whatsapp2format = RegExp(r'https://api.whatsapp.com/.*',
      multiLine: false, caseSensitive: false);

  RegExp linkedinformat = RegExp(r'https://www.linkedin.com/.*',
      multiLine: false, caseSensitive: false);

  RegExp twitterformat = RegExp(r'https://mobile.twitter.com/.*',
      multiLine: false, caseSensitive: false);

  @override
  Widget build(BuildContext context) {
    //BlocGroupSelect.get(context).saveTypeUse('student') ;

    return BlocProvider(
      create: (context) => BlocProfileStudent()..initialisation(),
      child: SafeArea(
        child: Builder(builder: (context) {
          return BlocConsumer<BlocProfileStudent, StateBlocProfileStudent>(
              listener: (context, state) {
            if (state is InitStateBlocProfileStudentError) {
              showInSnackBar(context, state.error, onError: true);
              // close loading
              // Navigator.pop(context);
            }

            if (state is InitStateBlocProfileStudentStartLoading) {
              // show loading
              // showLoaderDialog(context);
            }

            if (state is InitStateBlocProfileStudentSaveData) {
              showInSnackBar(context, state.message);
              BlocGroupSelect.get(context).resetDepartment();
              // close loading
              // Navigator.pop(context);
              // Navigator.pushNamed(context, 'studentviewprofile');
            }

            _fnameController.text =
                BlocProfileStudent.get(context).modelStudent?.firstname ?? '';
            _lnamecontroller.text =
                BlocProfileStudent.get(context).modelStudent?.lastname ?? '';
            _emailController.text =
                BlocProfileStudent.get(context).modelStudent?.email ?? '';
            _socialmediaccount.text = BlocProfileStudent.get(context)
                    .modelStudent
                    ?.socialmediaaccount ??
                '';
            social =
                BlocProfileStudent.get(context).modelStudent?.socialmedia ??
                    'None';
            _groupName.text =
                BlocProfileStudent.get(context).currentGroup?.projectname ?? '';
            _depertement.text = BlocProfileStudent.get(context)
                    .currentDepartment
                    ?.path
                    .split('/')
                    .last ??
                '';
            selctedyear = BlocProfileStudent.get(context)
                .currentGroup
                ?.Projectcompletiondate
                ?.convertToWordYears();
            month = BlocProfileStudent.get(context)
                .currentGroup
                ?.Projectcompletiondate
                ?.convertToWordMonth();

            //print(depertement) ;
          }, builder: (context, snapshot) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                primary: false,
                centerTitle: true,
                leading: BackButton(
                  onPressed: () {
                    if (TypeUser.type == 'student') {
                      TypeUser.type = 'student';
                      StorageManager.saveData('TypeUser', 'student');
                      Navigator.pushNamedAndRemoveUntil(
                          context, 'studenthome', (route) => false);
                    } else if (TypeUser.type == 'graduate') {
                      TypeUser.type = 'graduate';
                      // save type user
                      StorageManager.saveData('TypeUser', 'graduate');
                      Navigator.pushNamedAndRemoveUntil(
                          context, 'graduatehome', (route) => false);
                    }
                  },
                ),
                titleTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Mycolors.mainColorBlack,
                ),
                title: const Text("My profile"),
                // backgroundColor: Mycolors.mainColorWhite,
                shadowColor: Colors.transparent,
                iconTheme: const IconThemeData(
                  color:
                      Color.fromARGB(255, 12, 12, 12), //change your color here
                ),
              ),
              // backgroundColor: Mycolors.BackgroundColor,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Image.asset(
                        "assets/images/User1.png",
                        width: 300,
                        height: 120,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        autovalidateMode: AutovalidateMode.always,
                        key: formkey,
                        child: Column(
                          children: [
                            // personal Info
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                  //color: Colors.white ,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const TextHeader(
                                      text: 'Personal info',
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        //buildprofileImage(),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "  First Name:",
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color:
                                                      Mycolors.mainColorBlack,
                                                  fontFamily: 'bold',
                                                  fontSize: 13),
                                              textAlign: TextAlign.start,
                                            )),
                                        TextFormField(
                                          //initialValue: BlocProfileStudent.get(context).modelStudent?.firstname,
                                          controller: _fnameController,

                                          decoration: InputDecoration(
                                              //labelText: ' First Name',
                                              // hintText: "Enter your first name",
                                              suffixIcon: Icon(Icons.edit),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(13),
                                                  borderSide: const BorderSide(
                                                    width: 0,
                                                  ))),
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          validator: (value) {
                                            if (value!.isEmpty ||
                                                _fnameController.text.isEmpty) {
                                              return 'Please enter your frist name ';
                                            } else {
                                              if (nameRegExp.hasMatch(
                                                  _fnameController.text)) {
                                                return 'Please frist name only letters accepted ';
                                              } else {
                                                if (!(english.hasMatch(
                                                    _fnameController.text))) {
                                                  return "only english is allowed";
                                                }
                                              }
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "  Last Name:",
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color:
                                                      Mycolors.mainColorBlack,
                                                  fontFamily: 'bold',
                                                  fontSize: 13),
                                              textAlign: TextAlign.start,
                                            )),
                                        TextFormField(
                                          controller: _lnamecontroller,
                                          decoration: InputDecoration(
                                              //   labelText: 'Last Name',
                                              // hintText: "Enter your last name",
                                              suffixIcon: Icon(Icons.edit),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(13),
                                                  borderSide: const BorderSide(
                                                    width: 0,
                                                  ))),
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          validator: (value) {
                                            if (value!.isEmpty ||
                                                _lnamecontroller.text == "") {
                                              return 'Please enter your last name ';
                                            } else {
                                              if (nameRegExp.hasMatch(
                                                  _lnamecontroller.text)) {
                                                return 'Please last name only letters accepted ';
                                              } else {
                                                if (!(english.hasMatch(
                                                    _lnamecontroller.text))) {
                                                  return "only english is allowed";
                                                }
                                              }
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "  Email:",
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color:
                                                      Mycolors.mainColorBlack,
                                                  fontFamily: 'bold',
                                                  fontSize: 13),
                                              textAlign: TextAlign.start,
                                            )),
                                        TextFormField(
                                          controller: _emailController,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                              // hintText: "Enter your KSU email",
                                              // labelText: 'Email',
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(13),
                                                  borderSide: const BorderSide(
                                                    width: 0,
                                                  ))),
                                        ),

                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              " Social Media:",
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color:
                                                      Mycolors.mainColorBlack,
                                                  fontFamily: 'bold',
                                                  fontSize: 13),
                                              textAlign: TextAlign.start,
                                            )),
                                        DropdownButtonFormField(
                                            decoration: InputDecoration(
                                              suffixIcon: Icon(Icons.edit),
                                              // labelText: "Social Media",
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(13),
                                                  borderSide: const BorderSide(
                                                    width: 0,
                                                  )),
                                            ),
                                            items: const [
                                              DropdownMenuItem(
                                                  child: Text("Twitter"),
                                                  value: "Twitter"),
                                              DropdownMenuItem(
                                                  child: Text("LinkedIn"),
                                                  value: "LinkedIn"),
                                              DropdownMenuItem(
                                                  child: Text("WhatsApp"),
                                                  value: "WhatsApp"),
                                              DropdownMenuItem(
                                                  child: Text("None"),
                                                  value: "None")
                                            ],
                                            value: social,
                                            onChanged: (value) {
                                              setState(() {
                                                social = value ?? 'None';
                                                _socialmediaccount.text = "";
                                              });
                                            }),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        if (social != null && social != "None")
                                          Column(
                                            children: [
                                              Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    " Link:",
                                                    style: TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        color: Mycolors
                                                            .mainColorBlack,
                                                        fontFamily: 'bold',
                                                        fontSize: 13),
                                                    textAlign: TextAlign.start,
                                                  )),
                                              TextFormField(
                                                  key: const Key('link'),
                                                  controller:
                                                      _socialmediaccount,
                                                  decoration: InputDecoration(
                                                      // labelText: 'Link account',
                                                      hintText:
                                                          "Enter your link account",
                                                      suffixIcon:
                                                          Icon(Icons.edit),
                                                      border:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          13),
                                                              borderSide:
                                                                  const BorderSide(
                                                                width: 0,
                                                              ))),
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  validator: (value) {
                                                    if (value!.isEmpty ||
                                                        _socialmediaccount
                                                                .text ==
                                                            "") {
                                                      return 'Please enter your link account';
                                                    } else {
                                                      if (!(english.hasMatch(
                                                          _socialmediaccount
                                                              .text))) {
                                                        return "only english is allowed";
                                                      }
                                                      if (social ==
                                                          "WhatsApp") {
                                                        if (!(whatsappformat.hasMatch(
                                                                _socialmediaccount
                                                                    .text)) &&
                                                            !(whatsapp2format
                                                                .hasMatch(
                                                                    _socialmediaccount
                                                                        .text))) {
                                                          return 'Make sure your link account related to selected social media';
                                                        }
                                                      }
                                                      if (social ==
                                                          "LinkedIn") {
                                                        if (!(linkedinformat
                                                            .hasMatch(
                                                                _socialmediaccount
                                                                    .text))) {
                                                          return 'Make sure your link account related to selected social media';
                                                        }
                                                      }
                                                      if (social == "Twitter") {
                                                        if (!(twitterformat
                                                            .hasMatch(
                                                                _socialmediaccount
                                                                    .text))) {
                                                          return 'Make sure your link account related to selected social media';
                                                        }
                                                      }
                                                    }
                                                    SizedBox(
                                                      height: 8,
                                                    );
                                                  }),
                                              _spacer,
                                            ],
                                          ),
                                        ////////////////////group information (department,project name , project completion date)
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "  Department:",
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color:
                                                      Mycolors.mainColorBlack,
                                                  fontFamily: 'bold',
                                                  fontSize: 13),
                                              textAlign: TextAlign.start,
                                            )),
                                        TextFormField(
                                          key: const Key('department'),
                                          controller: _depertement,
                                          readOnly: true,
                                          onTap: () {
                                            BlocProfileStudent.get(context)
                                                .getDepartments();
                                            BlocProfileStudent.get(context)
                                                .changeSelectDepatment(
                                                    BlocProfileStudent.get(
                                                            context)
                                                        .currentDepartment);
                                            //BlocProfileStudent.get(context).() ;
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) => BlocProvider.value(
                                                        value: BlocProvider.of<
                                                                BlocProfileStudent>(
                                                            context),
                                                        child:
                                                            DepartmentChangeScreen())));
                                          },
                                          decoration: InputDecoration(
                                              // labelText: 'Department',
                                              // hintText: "Enter your first name",
                                              suffixIcon:
                                                  const Icon(Icons.edit),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(13),
                                                  borderSide: const BorderSide(
                                                    width: 0,
                                                  ))),
                                          // autovalidateMode:
                                          // AutovalidateMode.onUserInteraction,
                                        ),
                                      ],
                                    ),
                                  ]),
                            ),

                            //group info
                            const Divider(),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const TextHeader(
                                        text: 'Group info',
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          await BlocGroupSelect.get(context)
                                              .getAllGroups(
                                                  BlocProfileStudent.get(
                                                          context)
                                                      .currentDepartment!);

                                          // ignore: use_build_context_synchronously
                                          BlocGroupSelect.get(context)
                                              .selectGroup(
                                                  BlocProfileStudent.get(
                                                          context)
                                                      .currentGroup);
                                          /*
                                             BlocGroupSelect.get(context).selectGroup(ModelGroup(
                                               // ignore: use_build_context_synchronously
                                                    id : BlocProfileStudent.get(context).currentGroup!.id ,
                                                  // ignore: use_build_context_synchronously
                                                  department: BlocProfileStudent.get(context).currentGroup!.department,
                                                  // ignore: use_build_context_synchronously
                                                  projectname: _groupName.value.text,
                                                  // ignore: use_build_context_synchronously
                                                  students: BlocProfileStudent.get(context).currentGroup!.students ,
                                                  // ignore: use_build_context_synchronously
                                                  Projectcompletiondate: BlocProfileStudent.get(context).currentGroup!.Projectcompletiondate ,
                                                  // ignore: use_build_context_synchronously
                                                  uploadgp: BlocProfileStudent.get(context).currentGroup!.uploadgp ,
                                                ))  ;

                                                 */

                                          // ignore: use_build_context_synchronously
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      BlocProvider.value(
                                                          value: BlocProvider
                                                              .of<BlocProfileStudent>(
                                                                  context),
                                                          child:
                                                              ChangeGroup())));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Mycolors.mainShadedColorBlue,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          child: Text(
                                            'change group',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    color: Colors.white,
                                                    fontSize: 15),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  _spacer,
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        " Group Name:",
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Mycolors.mainColorBlack,
                                            fontFamily: 'bold',
                                            fontSize: 13),
                                        textAlign: TextAlign.start,
                                      )),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  TextFormField(
                                    controller: _groupName,
                                    decoration: InputDecoration(
                                        //  labelText: 'group Name',
                                        // hintText: "Enter your last name",
                                        suffixIcon: Icon(Icons.edit),
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
                                          _lnamecontroller.text == "") {
                                        return 'Please enter name ';
                                      } else {
                                        if (nameRegExp
                                            .hasMatch(_lnamecontroller.text)) {
                                          return 'Please group name only letters accepted ';
                                        }
                                      }
                                    },
                                  ),
                                  _spacer,
                                  if (TypeUser.type == 'student') ...{
                                    Text(
                                      " ${BlocProfileStudent.get(context).currentGroup?.projectname} completion date:",
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: Mycolors.mainColorBlack,
                                          fontFamily: 'bold',
                                          fontSize: 13),
                                      textAlign: TextAlign.start,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      height: 60,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: DropdownButtonFormField(
                                              value: BlocProfileStudent.get(
                                                      context)
                                                  .currentGroup
                                                  ?.Projectcompletiondate
                                                  ?.convertToWordMonth()
                                                  .toString(),
                                              decoration: InputDecoration(
                                                errorStyle:
                                                    TextStyle(fontSize: 0),
                                                hintText: 'month',
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13),
                                                    borderSide:
                                                        const BorderSide(
                                                      width: 0,
                                                    )),
                                              ),
                                              items: const [
                                                DropdownMenuItem(
                                                    child: Text("Jan"),
                                                    value: "01"),
                                                DropdownMenuItem(
                                                    child: Text("Feb"),
                                                    value: "02"),
                                                DropdownMenuItem(
                                                    child: Text("Mar"),
                                                    value: "03"),
                                                DropdownMenuItem(
                                                    child: Text("Apr"),
                                                    value: "04"),
                                                DropdownMenuItem(
                                                    child: Text("May"),
                                                    value: "05"),
                                                DropdownMenuItem(
                                                    child: Text("Jun"),
                                                    value: "06"),
                                                DropdownMenuItem(
                                                    child: Text("Jul"),
                                                    value: "07"),
                                                DropdownMenuItem(
                                                    child: Text("Aug"),
                                                    value: "08"),
                                                DropdownMenuItem(
                                                    child: Text("Sep"),
                                                    value: "09"),
                                                DropdownMenuItem(
                                                    child: Text("Oct"),
                                                    value: "10"),
                                                DropdownMenuItem(
                                                    child: Text("Nov"),
                                                    value: "11"),
                                                DropdownMenuItem(
                                                    child: Text("Dec"),
                                                    value: "12")
                                              ],
                                              onChanged: (value) {
                                                setState(() {
                                                  month = value;
                                                  print('month ====== $month');
                                                });
                                              },
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              //  validator: (value) {
                                              //    if (value == null || month == "") {
                                              //      return ' ';
                                              //    }
                                              //  },
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child:
                                                DropdownButtonFormField<String>(
                                              //value: BlocProfileStudent.get(context).modelGroup?.Projectcompletiondate?.convertToWordYears(),
                                              decoration: InputDecoration(
                                                errorStyle:
                                                    TextStyle(fontSize: 0),
                                                hintText: 'year',
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13),
                                                    borderSide:
                                                        const BorderSide(
                                                      width: 0,
                                                    )),
                                              ),
                                              items: years
                                                  .map((String dropdownitems) {
                                                return DropdownMenuItem<String>(
                                                  value: dropdownitems,
                                                  child: Text(dropdownitems),
                                                );
                                              }).toList(),
                                              onChanged: (String? newselect) {
                                                setState(() {
                                                  selctedyear = newselect;
                                                  //print(selctedyear);
                                                });
                                              },
                                              value: selctedyear,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              // validator: (value) {
                                              //   if (value == null || selctedyear == "") {
                                              //     return ' ';
                                              //   }
                                              // },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  }
                                ],
                              ),
                            ),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Mycolors.mainShadedColorBlue,
                                textStyle: const TextStyle(
                                    fontFamily: 'main', fontSize: 16),
                                shadowColor: Colors.blue[900],
                                elevation: 0,
                                // backgroundColor: Mycolors.mainShadedColorBlue,
                                minimumSize: const Size(150, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(17), // <-- Radius
                                ),
                              ),
                              onPressed: () async {
                                if (formkey.currentState!.validate()) {
                                  GPdate = (selctedyear == null ||
                                          month == null)
                                      ? null
                                      : dategp(selctedyear, month?.toString());
                                  //print(selctedyear) ;
                                  //print(month) ;
                                  //print(GPdate) ;
                                  ModelGroup modelGroupChangedField =
                                      ModelGroup(
                                          department:
                                              BlocProfileStudent.get(context)
                                                  .currentGroup!
                                                  .department,
                                          projectname: _groupName.value.text,
                                          students:
                                              BlocProfileStudent.get(context)
                                                  .currentGroup!
                                                  .students,
                                          uploadgp:
                                              BlocProfileStudent.get(context)
                                                  .currentGroup!
                                                  .uploadgp,
                                          id: BlocProfileStudent.get(context)
                                              .currentGroup!
                                              .id,
                                          Projectcompletiondate: TypeUser
                                                      .type ==
                                                  'graduate'
                                              ? BlocProfileStudent.get(context)
                                                  .currentGroup!
                                                  .Projectcompletiondate
                                              : GPdate);

                                  //print(BlocProfileStudent.get(context).currentGroup!.ref) ;
                                  ModelStudent modelStudentInput = ModelStudent(
                                      lastname: _lnamecontroller.value.text,
                                      email: _emailController.value.text,
                                      //department: null ,
                                      firstname: _fnameController.value.text,
                                      semester: BlocProfileStudent.get(context)
                                          .modelStudent!
                                          .semester,
                                      socialmedia: social,
                                      socialmediaaccount: _socialmediaccount
                                          .value.text
                                          .toNullIfEmplty(),
                                      group: BlocProfileStudent.get(context)
                                          .currentGroup!
                                          .ref);
                                  //print(modelGroupChangedField) ;
                                  //print(BlocProfileStudent.get(context).currentGroup) ;
                                  //print(modelGroupChangedField == BlocProfileStudent.get(context).currentGroup) ;
                                  //check if change name group
                                  if (modelGroupChangedField.projectname !=
                                      BlocProfileStudent.get(context)
                                          .currentGroup
                                          ?.projectname) {
                                    // check if exisit this name
                                    // ignore: use_build_context_synchronously
                                    if (await BlocProfileStudent.get(context)
                                        .checkIfNameGroupExist(
                                            modelGroupChangedField
                                                .projectname)) {
                                      // show dialog  if exist
                                      // ignore: use_build_context_synchronously
                                      buildShowDialog(
                                          context: context,
                                          title: 'Attention',
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              _spacer,
                                              const Icon(
                                                Icons.sd_card_alert_rounded,
                                                size: 80,
                                                color: Colors.amber,
                                              ),
                                              _spacer,
                                              Text(
                                                '${modelGroupChangedField.projectname}  group is already exist please check the group to make sure if you are part of at ',
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(fontSize: 17),
                                              ),
                                              _spacer,
                                              ElevatedButton(
                                                  onPressed: () async {
                                                    // go to cheange group screen with shoing only group
                                                    Navigator.pop(context);
                                                    //print(BlocProfileStudent.get(context).listSomeName) ;
                                                    // get only group this department
                                                    await BlocGroupSelect.get(
                                                            context)
                                                        .getAllGroups(
                                                            BlocProfileStudent
                                                                    .get(
                                                                        context)
                                                                .currentDepartment!);

                                                    // ignore: use_build_context_synchronously
                                                    BlocProfileStudent.get(
                                                            context)
                                                        .changeSelectMumber(
                                                            null);

                                                    // search whit the name
                                                    // ignore: use_build_context_synchronously
                                                    BlocGroupSelect.get(context)
                                                        .serachGroup(
                                                            modelGroupChangedField
                                                                .projectname);
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) => BlocProvider
                                                                .value(
                                                                    value: BlocProvider.of<
                                                                            BlocProfileStudent>(
                                                                        context),
                                                                    child:
                                                                        ChangeGroup(
                                                                      becomFromCheck:
                                                                          true,
                                                                      forSaveGroupWhenBecomFromCheck:
                                                                          modelGroupChangedField,
                                                                      forSaveStudentWhenBecomFromCheck:
                                                                          modelStudentInput,
                                                                    ))));
                                                  },
                                                  child: Text(
                                                    'check',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium!
                                                        .copyWith(
                                                            fontSize: 18,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ))
                                            ],
                                          ),
                                          barrierDismissible: false);
                                    } else {
                                      // ignore: use_build_context_synchronously
                                      BlocProfileStudent.get(context)
                                          .saveChange(
                                              modelStudentInput,
                                              BlocGroupSelect.get(context)
                                                  .modelGroupAddNews,
                                              modelGroupChangedField);
                                    }
                                  } else {
                                    BlocProfileStudent.get(context).saveChange(
                                        modelStudentInput,
                                        BlocGroupSelect.get(context)
                                            .modelGroupAddNews,
                                        modelGroupChangedField);
                                  }
                                } else {
                                  showInSnackBar(
                                      context, 'pleas check fields !',
                                      onError: true);
                                }
                              },
                              child: const Text(
                                "Save",
                              ),
                            ),
                          ],
                        ),
                      ), ////here
                    ),
                  ],
                ),
              ),
            );
          });
        }),
      ),
    );
  }

  Widget buildprofileImage() => CircleAvatar(
        radius: profileheight / 2,
        backgroundColor: Colors.grey.shade800,
        backgroundImage: AssetImage("assets/images/User1.png"),
      );
}
