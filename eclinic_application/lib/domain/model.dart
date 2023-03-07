import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ModelStudent {
  final String firstname;
  final String lastname;
  final String email;
  final String? password;
  final DocumentReference department;
  final String? socialmedia;
  final String? semester;
  //final String id;
  final String? socialmediaaccount;
  //final DateTime graduationDate;
  final DocumentReference? group;

  ModelStudent({
    required this.lastname,
    //required this.id,
    required this.email,
    required this.department,
    this.password,
    this.semester,
    this.socialmedia = 'None',
    this.group,
    this.socialmediaaccount,
    required this.firstname,
    //required this.graduationDate
  });

  factory ModelStudent.fromJson(Map<String, dynamic> json) => ModelStudent(
        lastname: json['lastname'],
        group: json['group'],
        //id: json['id'],
        email: json['email'],
        password: json['password'],
        department: json['department'],
        semester: json['semester'],
        firstname: json['firstname'],
        //graduationDate: DateTime.parse(json['graduationDate'])
      );

  Map<String, dynamic> toMap() => {
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        //'department': department,
        'socialmedia': socialmedia,
        //'id': id,
        'socialmediaaccount': socialmediaaccount,
        //'graduationDate': graduationDate.toIso8601String(),
        'group': group,
        'semester': semester
      };
}

class ModelSignUp {
  final ModelStudent modelStudent;
  final String password;
  final String email;
  final ModelGroup modelGroup;

  ModelSignUp(
      {required this.modelStudent,
      required this.password,
      required this.email,
      required this.modelGroup});
}

class ModelGroup extends Equatable {
  final DocumentReference department;
  final String projectname;
  final String? id;
  final bool? uploadgp;
  final List<ModelStudentsFromGroupRef> students;
  final DateTime? Projectcompletiondate;
  ModelGroup(
      {required this.department,
      required this.projectname,
      required this.students,
      this.Projectcompletiondate,
      this.uploadgp = false,
      this.id});
  factory ModelGroup.fromJson(Map<String, dynamic> json) => ModelGroup(
      department: json['department'],
      projectname: json['projectname'],
      students: List<Map<String, dynamic>>.from(json['students'])
          .map((e) => ModelStudentsFromGroupRef.fromJson(e))
          .toList(),
      Projectcompletiondate: json['Projectcompletiondate']?.toDate(),
      uploadgp: json['uploadgp'],
      id: json['id']);
  Map<String, dynamic> toMap() => {
        'department': department,
        'projectname': projectname,
        'students': students,
        'Projectcompletiondate': Projectcompletiondate,
        'uploadgp': uploadgp
      };

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}

class ModelStudentsFromGroupRef {
  final DocumentReference ref;
  final String name;

  ModelStudentsFromGroupRef(this.ref, this.name);

  factory ModelStudentsFromGroupRef.fromJson(Map<String, dynamic> json) =>
      ModelStudentsFromGroupRef(json['ref'], json['name']);

  Map<String, dynamic> toMap() => {'ref': ref, 'name': name};
}
