import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/bloc/profileStudent/bloc.dart';
import 'package:myapp/domain/extension.dart';
import 'package:myapp/screeens/profileStudent/componants/text_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/style/Mycolors.dart';
import 'package:uuid/uuid.dart';

import '../../../app/constants.dart';
import '../../../bloc/select_group/bloc.dart';
import '../../../domain/model.dart';
import '../../resources/dialog.dart';
import '../../resources/snackbar.dart';

SizedBox _spacer = const SizedBox(
  height: 15,
);

class DepartmentChangeScreen extends StatefulWidget {
  DepartmentChangeScreen({Key? key}) : super(key: key);
  static String routing = '/DepartmentChangeScreen';

  @override
  State<DepartmentChangeScreen> createState() => _DepartmentChangeScreenState();
}

class _DepartmentChangeScreenState extends State<DepartmentChangeScreen> {
  //List<String> department = [];

  // for groub
  final TextEditingController _inputNameGroup = TextEditingController();
  final TextEditingController _inputAddNameGroup = TextEditingController();
  final formkey = GlobalKey<FormState>();
  var selctedyear;
  var month;
  var GPdate;
  List<String> years = [];
  var year;
  var nowyear;
  var nextyear;
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
    genrateyear();
    _inputNameGroup.addListener(() {
      BlocGroupSelect.get(context).serachGroup(_inputNameGroup.value.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BlocProfileStudent, StateBlocProfileStudent>(
        listener: (context, state) {
      if (state is InitStateBlocProfileStudentError) {
        showInSnackBar(context, state.error, onError: true);
      }
    }, builder: (context, snapshot) {
      return WillPopScope(
        child: SafeArea(
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
              title: Text('Edit Department'),
            ),
            body: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  _spacer,
                  const TextHeader(text: 'Choose department'),
                  _spacer,
                  DropdownButtonFormField<DocumentReference>(
                    decoration: InputDecoration(
                      hintText: ' Choose your department :',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide: const BorderSide(
                            width: 0,
                          )),
                    ),
                    isExpanded: true,
                    items: BlocProfileStudent.get(context)
                        .allDepartments
                        .map((DocumentReference dropdownitems) {
                      return DropdownMenuItem<DocumentReference>(
                        value: dropdownitems,
                        child: Text(dropdownitems.toStringNameDepartement()),
                      );
                    }).toList(),
                    onChanged: (DocumentReference? newselect) {
                      BlocProfileStudent.get(context)
                          .changeSelectDepatment(newselect);
                      BlocGroupSelect.get(context).getAllGroups(newselect!);
                    },
                    value: BlocProfileStudent.get(context).departmentSelect,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  _spacer,
                  BlocConsumer<BlocGroupSelect, StateBlocGroupSelect>(
                      listener: (context, state) {},
                      builder: (context, snapshot) {
                        return (BlocProfileStudent.get(context)
                                        .departmentSelect ==
                                    null ||
                                BlocProfileStudent.get(context)
                                        .departmentSelect ==
                                    BlocProfileStudent.get(context)
                                        .currentDepartment)
                            ? const SizedBox()
                            : Expanded(
                                child: Column(
                                  children: [
                                    //_spacer ,
                                    const TextHeader(
                                        text: 'Find your new group'),
                                    _spacer,
                                    TextFormField(
                                      controller: _inputNameGroup,
                                      autofocus: false,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        // label: const Text(' Find your group'),
                                        suffixIcon: const Icon(Icons.search),
                                        filled: true,
                                        fillColor:
                                            Colors.black.withOpacity(0.01),
                                        //border: InputBorder.none,

                                        //contentPadding: const EdgeInsets.only(
                                        //    left: 14.0, bottom: 10.0, top: 10.0, right: 14.0),
                                        //hintStyle:    TextStyle(color: Colors.grey.withOpacity(.5)) ,
                                        labelStyle: const TextStyle(
                                          color: Colors.black,
                                        ),
                                        errorStyle:
                                            const TextStyle(color: Colors.red),
                                        // enable border stayle

                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(13),
                                          borderSide: BorderSide(
                                              width: 5,
                                              color:
                                                  Colors.black.withOpacity(.5)),
                                        ),
                                      ),
                                    ),

                                    //_space,
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    if (BlocGroupSelect.get(context)
                                            .modelGroupSelected !=
                                        null)
                                      _buildItem(
                                          context,
                                          BlocGroupSelect.get(context)
                                              .modelGroupSelected!),
                                    const Divider(),

                                    Expanded(
                                      child: SingleChildScrollView(
                                        child:
                                            BlocGroupSelect.get(context).loading
                                                ? const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  )
                                                : Column(
                                                    children: [
                                                      Column(
                                                        children: BlocGroupSelect
                                                                .get(context)
                                                            .listAllGroupsForSearching
                                                            .where((element) =>
                                                                element !=
                                                                BlocGroupSelect.get(
                                                                        context)
                                                                    .modelGroupSelected)
                                                            .map((e) =>
                                                                _buildItem(
                                                                    context, e))
                                                            .toList(),
                                                      ),
                                                      const Divider(),
                                                      if (BlocGroupSelect.get(
                                                                  context)
                                                              .modelGroupAddNews ==
                                                          null)
                                                        InkWell(
                                                          onTap: () {
                                                            _inputAddNameGroup
                                                                    .text =
                                                                _inputNameGroup
                                                                    .value.text;
                                                            buildShowDialog(
                                                                context:
                                                                    context,
                                                                title:
                                                                    'Create New Group',
                                                                child: Form(
                                                                  key: formkey,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      _spacer,
                                                                      Text(
                                                                          "Project Name: "),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),

                                                                      SizedBox(
                                                                        height:
                                                                            60,
                                                                        child:
                                                                            TextFormField(
                                                                          controller:
                                                                              _inputAddNameGroup,
                                                                          autofocus:
                                                                              false,
                                                                          keyboardType:
                                                                              TextInputType.text,
                                                                          decoration: InputDecoration(
                                                                              errorStyle: TextStyle(fontSize: 0),
                                                                              //label: const Text('create name project'),
                                                                              filled: true,
                                                                              fillColor: Colors.black.withOpacity(0.01),
                                                                              contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0, right: 14.0),
                                                                              hintStyle: TextStyle(color: Colors.grey.withOpacity(.5)),
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
                                                                          validator:
                                                                              (v) {
                                                                            if (v?.trim() ==
                                                                                '') {
                                                                              return ' ';
                                                                            }
                                                                          },
                                                                        ),
                                                                      ),
                                                                      _spacer,
                                                                      // Project completion date
                                                                      if (TypeUser
                                                                              .type ==
                                                                          'student') ...{
                                                                        Text(
                                                                            " Project completion date : "),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              60,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Expanded(
                                                                                //flex: 1,
                                                                                child: DropdownButtonFormField(
                                                                                  decoration: InputDecoration(
                                                                                    errorStyle: TextStyle(fontSize: 0),
                                                                                    hintText: 'month',
                                                                                    border: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius.circular(13),
                                                                                        borderSide: const BorderSide(
                                                                                          width: 0,
                                                                                        )),
                                                                                  ),
                                                                                  items: const [
                                                                                    DropdownMenuItem(child: Text("Jan"), value: "01"),
                                                                                    DropdownMenuItem(child: Text("Feb"), value: "02"),
                                                                                    DropdownMenuItem(child: Text("Mar"), value: "03"),
                                                                                    DropdownMenuItem(child: Text("Apr"), value: "04"),
                                                                                    DropdownMenuItem(child: Text("May"), value: "05"),
                                                                                    DropdownMenuItem(child: Text("Jun"), value: "06"),
                                                                                    DropdownMenuItem(child: Text("Jul"), value: "07"),
                                                                                    DropdownMenuItem(child: Text("Aug"), value: "08"),
                                                                                    DropdownMenuItem(child: Text("Sep"), value: "09"),
                                                                                    DropdownMenuItem(child: Text("Oct"), value: "10"),
                                                                                    DropdownMenuItem(child: Text("Nov"), value: "11"),
                                                                                    DropdownMenuItem(child: Text("Dec"), value: "12")
                                                                                  ],
                                                                                  onChanged: (value) {
                                                                                    setState(() {
                                                                                      month = value;
                                                                                      //print(month);
                                                                                    });
                                                                                  },
                                                                                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                                                                  decoration: InputDecoration(
                                                                                    hintText: ' year',
                                                                                    errorStyle: TextStyle(fontSize: 0),
                                                                                    border: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius.circular(13),
                                                                                        borderSide: const BorderSide(
                                                                                          width: 0,
                                                                                        )),
                                                                                  ),
                                                                                  //itemHeight: 60,

                                                                                  items: years.map((String dropdownitems) {
                                                                                    return DropdownMenuItem<String>(
                                                                                      value: dropdownitems,
                                                                                      child: Text(
                                                                                        dropdownitems,
                                                                                      ),
                                                                                    );
                                                                                  }).toList(),
                                                                                  onChanged: (String? newselect) {
                                                                                    setState(() {
                                                                                      selctedyear = newselect;
                                                                                      //print(selctedyear);
                                                                                    });
                                                                                  },
                                                                                  value: selctedyear,
                                                                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                                  validator: (value) {
                                                                                    if (value == null || selctedyear == "") {
                                                                                      return ' ';
                                                                                    }
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      },

                                                                      _spacer,
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          ElevatedButton(
                                                                            style:
                                                                                ElevatedButton.styleFrom(
                                                                              textStyle: const TextStyle(fontFamily: 'main', fontSize: 16),
                                                                              backgroundColor: Mycolors.mainShadedColorBlue,
                                                                              elevation: 0,
                                                                              minimumSize: const Size(100, 50),
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(17), // <-- Radius
                                                                              ),
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                const Text('Cancel'),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          ElevatedButton(
                                                                            style:
                                                                                ElevatedButton.styleFrom(
                                                                              textStyle: const TextStyle(fontFamily: 'main', fontSize: 16),
                                                                              backgroundColor: Mycolors.mainShadedColorBlue,
                                                                              elevation: 0,
                                                                              minimumSize: const Size(100, 50),
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(17), // <-- Radius
                                                                              ),
                                                                            ),
                                                                            onPressed:
                                                                                () async {
                                                                              formkey.currentState!.save();
                                                                              //formkey.currentState!.validate() ;
                                                                              //if(formkey.currentState.)
                                                                              print(formkey.currentState!.validate());
                                                                              if (formkey.currentState!.validate()) {
                                                                                //GPdate = dategp(
                                                                                //    selctedyear, month);
                                                                                //'graduationDate' : (GPdate as DateTime).toIso8601String() ,
                                                                                //print('date : $GPdate');
                                                                                GPdate = TypeUser.type == 'graduate' ? null : dategp(selctedyear, month);

                                                                                ModelGroup modelg = ModelGroup(department: BlocProfileStudent.get(context).departmentSelect!, projectname: _inputAddNameGroup.value.text, students: const [], Projectcompletiondate: GPdate, id: Uuid().v4());
                                                                                BlocGroupSelect.get(context).addNewGroup(modelg);
                                                                                Navigator.pop(context);
                                                                                _inputNameGroup.text = modelg.projectname;
                                                                                BlocGroupSelect.get(context).selectGroup(modelg);
                                                                              }
                                                                            },
                                                                            child:
                                                                                const Text('Create'),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ));
                                                          },
                                                          child: Container(
                                                            height: 60,
                                                            alignment: Alignment
                                                                .center,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          17),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .green
                                                                      .withOpacity(
                                                                          .8)),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                const Icon(
                                                                  Icons.add_box,
                                                                  size: 50,
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                  'Create new group ',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                          .green),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                      }),
                  _spacer,
                  (BlocProfileStudent.get(context).departmentSelect == null ||
                          BlocProfileStudent.get(context).departmentSelect ==
                              BlocProfileStudent.get(context).currentDepartment)
                      ? const SizedBox()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(
                                fontFamily: 'main', fontSize: 16),
                            backgroundColor: Mycolors.mainShadedColorBlue,
                            elevation: 0,
                            minimumSize: const Size(150, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(17), // <-- Radius
                            ),
                          ),
                          onPressed: () async {
                            if (BlocGroupSelect.get(context)
                                    .modelGroupSelected !=
                                null) {
                              BlocProfileStudent.get(context)
                                  .changeCurrentGroup(
                                      BlocGroupSelect.get(context)
                                          .modelGroupSelected!);
                              BlocProfileStudent.get(context)
                                  .changeCurrentDepartment(
                                      BlocProfileStudent.get(context)
                                          .departmentSelect);

                              Navigator.pop(context);
                              print('selected££££££££');
                            } else {
                              showInSnackBar(context, 'Please select a group',
                                  onError: true);
                            }
                          },
                          child: const Text('Select group'),
                        ),
                  _spacer,
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async {
          print('return £££££ ');
          BlocProfileStudent.get(context).resetDepartment();
          BlocGroupSelect.get(context).resetDepartment();
          return true;
        },
      );
    });
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
                  color: Colors.black.withOpacity(.0),
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
                    if (TypeUser.type == 'student')
                      Text(
                        "Completion date: " +
                            (modelGroup.Projectcompletiondate
                                    ?.convertToWord() ??
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
                buildShowDialog(
                    context: context,
                    title: 'Edit Group',
                    child: Form(
                      key: formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _spacer,
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
                          _spacer,
                          if (TypeUser.type == 'student') ...{
                            Text(" Project completion date : "),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 60,
                              child: Row(
                                children: [
                                  Expanded(
                                    //flex: 1,
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
                                      decoration: InputDecoration(
                                        hintText: ' year',
                                        errorStyle: TextStyle(fontSize: 0),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(13),
                                            borderSide: const BorderSide(
                                              width: 0,
                                            )),
                                      ),
                                      //itemHeight: 60,

                                      items: years.map((String dropdownitems) {
                                        return DropdownMenuItem<String>(
                                          value: dropdownitems,
                                          child: Text(
                                            dropdownitems,
                                          ),
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
                          _spacer,
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
                                    //GPdate = dategp(selctedyear, month);
                                    //'graduationDate' : (GPdate as DateTime).toIso8601String() ,
                                    //print('date : $GPdate');
                                    GPdate = TypeUser.type == 'graduate'
                                        ? null
                                        : dategp(selctedyear, month);

                                    ModelGroup modelg = ModelGroup(
                                        department:
                                            BlocProfileStudent.get(context)
                                                .departmentSelect!,
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
