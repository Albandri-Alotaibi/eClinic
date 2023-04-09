import 'package:flutter/material.dart';
import 'package:myapp/app/constants.dart';
import 'package:myapp/bloc/select_group/bloc.dart';
import 'package:myapp/domain/extension.dart';
import 'package:myapp/domain/model.dart';
import 'package:myapp/graduatehome.dart';
import 'package:myapp/graduateverfication.dart';
import 'package:myapp/screeens/resources/snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/style/Mycolors.dart';
import 'package:uuid/uuid.dart';
import 'package:myapp/app/constants.dart';
import 'package:myapp/app/shardPreferense.dart';
import '../resources/dialog.dart';

SizedBox _space = const SizedBox(
  height: 20,
);

class GroupSelection extends StatefulWidget {
  GroupSelection({Key? key, required this.generalInfo}) : super(key: key);
  //static String  route = '/groupSelection' ;
  final ModelStudent generalInfo;

  @override
  State<GroupSelection> createState() => _GroupSelectionState();
}

class _GroupSelectionState extends State<GroupSelection> {
  final TextEditingController _inputNameGroup = TextEditingController();

  final TextEditingController _inputAddNameGroup = TextEditingController();
  var selctedyear;
  var month;
  var GPdate;
  List<String> years = [];
  var year;
  var nowyear;
  var nextyear;

  final formkey = GlobalKey<FormState>();

  DateTime dategp(String? year, String? month) {
    print(selctedyear);
    print(month);
    var gpdate = selctedyear + "-" + month + "-" + "15" + " " + "12:00:00.000";
    DateTime dt = DateTime.parse(gpdate);
    print(gpdate);
    print(dt);
    return dt;
    //2022-12-20 00:00:00.000
    //2023-09-15 00:00:00.000
  }

  genrateyear() {
    DateTime now = DateTime.now();
    nowyear = now.year;
    DateTime Dateoftoday = DateTime.now();

    String s = year.toString();
    nextyear = nowyear + 1;
    years.add(nowyear.toString());
    years.add(nextyear.toString());
  }

  @override
  void initState() {
    super.initState();
    _inputNameGroup.addListener(() {
      BlocGroupSelect.get(context).serachGroup(_inputNameGroup.value.text);
    });
    genrateyear();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          primary: false,
          centerTitle: true,
          shadowColor: Colors.transparent,
          iconTheme: IconThemeData(
            color: Color.fromARGB(255, 12, 12, 12), //change your color here
          ),
          titleTextStyle: TextStyle(
            color: Mycolors.mainColorBlack,
            fontSize: 24,
          ),
          title: const Text('Group Selecte'),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: BlocConsumer<BlocGroupSelect, StateBlocGroupSelect>(
              listener: (context, state) async {
            if (state is InitStateBlocGroupSelectError) {
              showInSnackBar(context, state.error, onError: true);
            }

            if (state is InitStateBlocGroupSelectSignUpDone) {
              //showInSnackBar(context, 'Your account has been registered');
              if (TypeUser.type == 'student') {
                TypeUser.type = 'student';
                StorageManager.saveData('TypeUser', 'student');

                Navigator.pushNamedAndRemoveUntil(
                    context, 'studentverfication', (route) => false);
              }

              if (TypeUser.type == 'graduate') {
                TypeUser.type = 'graduate';
                // save type user
                StorageManager.saveData('TypeUser', 'graduate');
                // await Future.delayed(Duration(seconds: 1), () {});
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => graduateverfication(),
                  ),
                );
              }
            }

            if (state is InitStateBlocGroupSelectAddGroupDone) {
              showInSnackBar(context, 'Your group has been added');
              BlocGroupSelect.get(context)
                  .serachGroup(_inputAddNameGroup.value.text);
            }
          }, builder: (context, snapshot) {
            // return Column(
            return BlocGroupSelect.get(context).loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      _space,
                      TextFormField(
                        controller: _inputNameGroup,
                        autofocus: false,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          label: const Text(' Find your group'),
                          suffixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.01),
                          //border: InputBorder.none,

                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 10.0, top: 10.0, right: 14.0),
                          //hintStyle:    TextStyle(color: Colors.grey.withOpacity(.5)) ,
                          labelStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          errorStyle: const TextStyle(color: Colors.red),
                          // enable border stayle

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: BorderSide(
                                width: 5, color: Colors.black.withOpacity(.5)),
                          ),
                        ),
                      ),
                      //_space,
                      const SizedBox(
                        height: 5,
                      ),
                      if (BlocGroupSelect.get(context).modelGroupSelected !=
                          null)
                        _buildItem(context,
                            BlocGroupSelect.get(context).modelGroupSelected!),
                      const Divider(),

                      Expanded(
                        child: SingleChildScrollView(
                          child:
                              // BlocGroupSelect.get(context).loading
                              //     ? const Center(
                              //         child: CircularProgressIndicator(),
                              //       )
                              // :
                              Column(
                            children: [
                              Column(
                                children: BlocGroupSelect.get(context)
                                    .listAllGroupsForSearching
                                    .where((element) =>
                                        element !=
                                        BlocGroupSelect.get(context)
                                            .modelGroupSelected)
                                    .map((e) => _buildItem(context, e))
                                    .toList(),
                              ),
                              const Divider(),
                              if (BlocGroupSelect.get(context)
                                      .modelGroupAddNews ==
                                  null)
                                InkWell(
                                  onTap: () {
                                    _inputAddNameGroup.text =
                                        _inputNameGroup.value.text;
                                    buildShowDialog(
                                        context: context,
                                        title: 'Create New Group',
                                        child: Form(
                                          key: formkey,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              _space,
                                              Text("Project name : "),
                                              SizedBox(
                                                height: 10,
                                              ),

                                              SizedBox(
                                                height: 60,
                                                child: TextFormField(
                                                  controller:
                                                      _inputAddNameGroup,
                                                  autofocus: false,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration: InputDecoration(
                                                      errorStyle: TextStyle(
                                                          fontSize: 0),
                                                      //label: const Text('create name project'),
                                                      filled: true,
                                                      fillColor: Colors.black
                                                          .withOpacity(0.01),
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                              left: 14.0,
                                                              bottom: 8.0,
                                                              top: 8.0,
                                                              right: 14.0),
                                                      hintStyle: TextStyle(
                                                          color: Colors.grey
                                                              .withOpacity(.5)),
                                                      labelStyle:
                                                          const TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                      // enable border stayle
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
                                                  validator: (v) {
                                                    if (v?.trim() == '') {
                                                      return ' ';
                                                    }
                                                  },
                                                ),
                                              ),
                                              _space,
                                              // Project completion date

                                              if (TypeUser.type ==
                                                  'student') ...{
                                                Text(
                                                    " Project completion date : "),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                SizedBox(
                                                  height: 60,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        //flex: 1,
                                                        child:
                                                            DropdownButtonFormField(
                                                          decoration:
                                                              InputDecoration(
                                                            errorStyle:
                                                                TextStyle(
                                                                    fontSize:
                                                                        0),
                                                            hintText: 'month',
                                                            border:
                                                                OutlineInputBorder(
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
                                                                child:
                                                                    Text("Jan"),
                                                                value: "01"),
                                                            DropdownMenuItem(
                                                                child:
                                                                    Text("Feb"),
                                                                value: "02"),
                                                            DropdownMenuItem(
                                                                child:
                                                                    Text("Mar"),
                                                                value: "03"),
                                                            DropdownMenuItem(
                                                                child:
                                                                    Text("Apr"),
                                                                value: "04"),
                                                            DropdownMenuItem(
                                                                child:
                                                                    Text("May"),
                                                                value: "05"),
                                                            DropdownMenuItem(
                                                                child:
                                                                    Text("Jun"),
                                                                value: "06"),
                                                            DropdownMenuItem(
                                                                child:
                                                                    Text("Jul"),
                                                                value: "07"),
                                                            DropdownMenuItem(
                                                                child:
                                                                    Text("Aug"),
                                                                value: "08"),
                                                            DropdownMenuItem(
                                                                child:
                                                                    Text("Sep"),
                                                                value: "09"),
                                                            DropdownMenuItem(
                                                                child:
                                                                    Text("Oct"),
                                                                value: "10"),
                                                            DropdownMenuItem(
                                                                child:
                                                                    Text("Nov"),
                                                                value: "11"),
                                                            DropdownMenuItem(
                                                                child:
                                                                    Text("Dec"),
                                                                value: "12")
                                                          ],
                                                          onChanged: (value) {
                                                            setState(() {
                                                              month = value;
                                                              //print(month);
                                                            });
                                                          },
                                                          autovalidateMode:
                                                              AutovalidateMode
                                                                  .onUserInteraction,
                                                          validator: (value) {
                                                            if (value == null ||
                                                                month == "") {
                                                              return ' ';
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child:
                                                            DropdownButtonFormField<
                                                                String>(
                                                          decoration:
                                                              InputDecoration(
                                                            hintText: ' year',
                                                            errorStyle:
                                                                TextStyle(
                                                                    fontSize:
                                                                        0),
                                                            border:
                                                                OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            13),
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      width: 0,
                                                                    )),
                                                          ),
                                                          //itemHeight: 60,

                                                          items: years.map((String
                                                              dropdownitems) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value:
                                                                  dropdownitems,
                                                              child: Text(
                                                                dropdownitems,
                                                              ),
                                                            );
                                                          }).toList(),
                                                          onChanged: (String?
                                                              newselect) {
                                                            setState(() {
                                                              selctedyear =
                                                                  newselect;
                                                              //print(selctedyear);
                                                            });
                                                          },
                                                          value: selctedyear,
                                                          autovalidateMode:
                                                              AutovalidateMode
                                                                  .onUserInteraction,
                                                          validator: (value) {
                                                            if (value == null ||
                                                                selctedyear ==
                                                                    "") {
                                                              return ' ';
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              },

                                              _space,
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontFamily:
                                                                  'main',
                                                              fontSize: 16),
                                                      backgroundColor: Mycolors
                                                          .mainShadedColorBlue,
                                                      elevation: 0,
                                                      minimumSize:
                                                          const Size(100, 50),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                17), // <-- Radius
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontFamily:
                                                                  'main',
                                                              fontSize: 16),
                                                      backgroundColor: Mycolors
                                                          .mainShadedColorBlue,
                                                      elevation: 0,
                                                      minimumSize:
                                                          const Size(100, 50),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                17), // <-- Radius
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      formkey.currentState!
                                                          .save();
                                                      //formkey.currentState!.validate() ;
                                                      //if(formkey.currentState.)
                                                      print(formkey
                                                          .currentState!
                                                          .validate());
                                                      if (formkey.currentState!
                                                          .validate()) {
                                                        print(TypeUser.type);
                                                        GPdate =
                                                            TypeUser.type ==
                                                                    'graduate'
                                                                ? null
                                                                : dategp(
                                                                    selctedyear,
                                                                    month);
                                                        //'graduationDate' : (GPdate as DateTime).toIso8601String() ,
                                                        //print('date : $GPdate');

                                                        ModelGroup modelg = ModelGroup(
                                                            department: widget
                                                                .generalInfo
                                                                .department!,
                                                            projectname:
                                                                _inputAddNameGroup
                                                                    .value.text,
                                                            students: const [],
                                                            Projectcompletiondate:
                                                                GPdate,
                                                            id: Uuid().v4());
                                                        BlocGroupSelect.get(
                                                                context)
                                                            .addNewGroup(
                                                                modelg);
                                                        Navigator.pop(context);
                                                        _inputNameGroup.text =
                                                            modelg.projectname;
                                                        BlocGroupSelect.get(
                                                                context)
                                                            .selectGroup(
                                                                modelg);
                                                      }
                                                    },
                                                    child: const Text('Create'),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ));
                                  },
                                  child: Container(
                                    height: 60,
                                    alignment: Alignment.center,
                                    width: size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(17),
                                      border: Border.all(
                                          color: Colors.green.withOpacity(.8)),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.add_box,
                                          size: 50,
                                          color: Colors.green,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Create new group ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.green),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      _space,
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          textStyle:
                              const TextStyle(fontFamily: 'main', fontSize: 16),
                          backgroundColor: Mycolors.mainShadedColorBlue,
                          elevation: 0,
                          minimumSize: const Size(150, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(17), // <-- Radius
                          ),
                        ),
                        onPressed: () async {
                          if (BlocGroupSelect.get(context).modelGroupSelected !=
                              null) {
                            ModelSignUp modelSignUp = ModelSignUp(
                                modelGroup: BlocGroupSelect.get(context)
                                    .modelGroupSelected!,
                                modelStudent: widget.generalInfo,
                                password: widget.generalInfo.password!,
                                email: widget.generalInfo.email);

                            BlocGroupSelect.get(context).signUp(modelSignUp);
                          } else {
                            showInSnackBar(context, 'Please select a group',
                                onError: true);
                          }
                        },
                        child: const Text('Sign up'),
                      ),
                      _space,
                    ],
                  );
          }),
        ),
      ),
    );
  }

  Widget _buildItem(context, ModelGroup modelGroup,
      {Color color = Colors.white}) {
    return InkWell(
      onTap: () {
        BlocGroupSelect.get(context).selectGroup(modelGroup);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            color: Color.fromARGB(107, 224, 224, 224),
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(0, 0, 0, 0).withOpacity(.0),
                  offset: const Offset(4, 5),
                  blurRadius: 6,
                  spreadRadius: 1)
            ],
            borderRadius: BorderRadius.circular(17)),
        child: ListTile(
          contentPadding: const EdgeInsets.only(
              left: 14.0, bottom: 8.0, top: 8.0, right: 14.0),
          title: Text(
            modelGroup.projectname,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          subtitle: modelGroup == BlocGroupSelect.get(context).modelGroupAddNews
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Completion Date: " +
                          (modelGroup.Projectcompletiondate?.convertToWord() ??
                              ''),
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      "Created by you",
                      style: TextStyle(fontSize: 14, color: Colors.green),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Wrap(
                    children: List.generate(
                        modelGroup.students.length > 5
                            ? 5
                            : modelGroup.students.length,
                        (index) => modelGroup.students
                            .map((e) => Text(
                                  '${e.name}${modelGroup.students.last == e ? '' : ','}',
                                  style: TextStyle(
                                      color: Mycolors.mainShadedColorBlue),
                                ))
                            .toList()[index]),
                  ),
                ),
          leading: InkWell(
            onTap: () {
              if (modelGroup ==
                  BlocGroupSelect.get(context).modelGroupAddNews) {
                _inputAddNameGroup.text = modelGroup.projectname;
                print(modelGroup.Projectcompletiondate?.convertToWordMonth()
                    .toString());
                selctedyear =
                    modelGroup.Projectcompletiondate?.convertToWordYears();
                buildShowDialog(
                    context: context,
                    title: 'Edit Group',
                    child: Form(
                      key: formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _space,
                          Text("Project name : "),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 60,
                            child: TextFormField(
                              controller: _inputAddNameGroup,
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  errorStyle: TextStyle(fontSize: 0),

                                  //label: const Text('create name project'),

                                  filled: true,
                                  fillColor: Colors.black.withOpacity(0.01),
                                  contentPadding: const EdgeInsets.only(
                                      left: 14.0,
                                      bottom: 8.0,
                                      top: 8.0,
                                      right: 14.0),
                                  hintStyle: TextStyle(
                                      color: Colors.grey.withOpacity(.5)),
                                  labelStyle: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  // enable border stayle
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(13),
                                      borderSide: const BorderSide(
                                        width: 0,
                                      ))),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (v) {
                                if (v?.trim() == '') {
                                  return ' ';
                                }
                              },
                            ),
                          ),
                          _space,
                          if (TypeUser.type == 'student') ...{
                            const Text(" Project completion date : "),
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
                                      value: modelGroup.Projectcompletiondate
                                              ?.convertToWordMonth()
                                          .toString(),
                                      decoration: InputDecoration(
                                        errorStyle: TextStyle(fontSize: 0),
                                        hintText: 'month',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(13),
                                            borderSide: const BorderSide(
                                              width: 0,
                                            )),
                                      ),
                                      items: const [
                                        DropdownMenuItem(
                                            child: Text("Jan"), value: "01"),
                                        DropdownMenuItem(
                                            child: Text("Feb"), value: "02"),
                                        DropdownMenuItem(
                                            child: Text("Mar"), value: "03"),
                                        DropdownMenuItem(
                                            child: Text("Apr"), value: "04"),
                                        DropdownMenuItem(
                                            child: Text("May"), value: "05"),
                                        DropdownMenuItem(
                                            child: Text("Jun"), value: "06"),
                                        DropdownMenuItem(
                                            child: Text("Jul"), value: "07"),
                                        DropdownMenuItem(
                                            child: Text("Aug"), value: "08"),
                                        DropdownMenuItem(
                                            child: Text("Sep"), value: "09"),
                                        DropdownMenuItem(
                                            child: Text("Oct"), value: "10"),
                                        DropdownMenuItem(
                                            child: Text("Nov"), value: "11"),
                                        DropdownMenuItem(
                                            child: Text("Dec"), value: "12")
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          month = value;
                                          //print(month);
                                        });
                                      },
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value == null || month == "") {
                                          return ' ';
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: DropdownButtonFormField<String>(
                                      //value: modelGroup.graduationdate?.convertToWordYears(),

                                      decoration: InputDecoration(
                                        errorStyle: TextStyle(fontSize: 0),
                                        hintText: 'year',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(13),
                                            borderSide: const BorderSide(
                                              width: 0,
                                            )),
                                      ),
                                      items: years.map((String dropdownitems) {
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
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value == null ||
                                            selctedyear == "") {
                                          return ' ';
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          },
                          _space,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  textStyle: const TextStyle(
                                      fontFamily: 'main', fontSize: 16),
                                  backgroundColor: Mycolors.mainShadedColorBlue,
                                  elevation: 0,
                                  minimumSize: const Size(100, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(17), // <-- Radius
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  textStyle: const TextStyle(
                                      fontFamily: 'main', fontSize: 16),
                                  backgroundColor: Mycolors.mainShadedColorBlue,
                                  elevation: 0,
                                  minimumSize: const Size(100, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(17), // <-- Radius
                                  ),
                                ),
                                onPressed: () async {
                                  formkey.currentState!.save();
                                  //formkey.currentState!.validate() ;
                                  //if(formkey.currentState.)
                                  //if(formkey.currentState.validate())
                                  if (formkey.currentState!.validate()) {
                                    GPdate = TypeUser.type == 'graduate'
                                        ? null
                                        : dategp(selctedyear, month);
                                    //'graduationDate' : (GPdate as DateTime).toIso8601String() ,
                                    //print('date : $GPdate');
                                    ModelGroup modelg = ModelGroup(
                                        department:
                                            widget.generalInfo.department!,
                                        projectname:
                                            _inputAddNameGroup.value.text,
                                        students: const [],
                                        Projectcompletiondate: GPdate,
                                        id: modelGroup.id);
                                    BlocGroupSelect.get(context)
                                        .addNewGroup(modelg);
                                    Navigator.pop(context);
                                    _inputNameGroup.text = modelg.projectname;
                                    BlocGroupSelect.get(context)
                                        .whenEdutGroup(modelg);
                                  }
                                },
                                child: const Text('Edit'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ));
              }
            },
            child: Icon(
              modelGroup == BlocGroupSelect.get(context).modelGroupAddNews
                  ? Icons.edit
                  : Icons.group,
              size: 35,
            ),
          ),
          trailing: BlocBuilder<BlocGroupSelect, StateBlocGroupSelect>(
              builder: (context, snapshot) {
            return InkWell(
                onTap: () {
                  BlocGroupSelect.get(context).selectGroup(modelGroup);
                },
                child: Icon(
                  BlocGroupSelect.get(context).modelGroupSelected == modelGroup
                      ? Icons.radio_button_on
                      : Icons.radio_button_off,
                  color: BlocGroupSelect.get(context).modelGroupSelected ==
                          modelGroup
                      ? Mycolors.mainShadedColorBlue
                      : null,
                ));
          }),
        ),
      ),
    );
  }
}
