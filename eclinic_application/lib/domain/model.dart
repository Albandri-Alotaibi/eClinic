import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ModelStudent extends Equatable {
  final String firstname;
  final String lastname;
  final String email;
  final String? password;
  // this field use only when save new student
  final DocumentReference? department;
  final String? socialmedia;
  final DocumentReference? semester;
  //final String id;
  final String? socialmediaaccount;
  //final DateTime graduationDate;
  final DocumentReference? group;

  ModelStudent({
    required this.lastname,
    //required this.id,
    required this.email,
    this.department,
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
        socialmedia: json['socialmedia'],
        socialmediaaccount: json['socialmediaaccount'],
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

  @override
  List<Object?> get props =>
      [firstname, lastname, socialmedia, socialmediaaccount, semester, group];
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
        'students': students.map((e) => e.toMap()).toList(),
        'Projectcompletiondate': Projectcompletiondate,
        'uploadgp': uploadgp
      };

  @override
  List<Object?> get props => [id];

  DocumentReference get ref =>
      FirebaseFirestore.instance.collection('studentgroup').doc(id);
}

class ModelStudentsFromGroupRef {
  final DocumentReference ref;
  final String name;

  ModelStudentsFromGroupRef(this.ref, this.name);

  factory ModelStudentsFromGroupRef.fromJson(Map<String, dynamic> json) =>
      ModelStudentsFromGroupRef(json['ref'], json['name']);

  Map<String, dynamic> toMap() => {'ref': ref, 'name': name};
}

class InfoForGetDataForProfileStudent {
  final ModelGroup modelGroub;
  final ModelStudent student;
  final DocumentReference departement;

  InfoForGetDataForProfileStudent(
      this.modelGroub, this.student, this.departement);
}

class ModelForSaveChangeProfile {
  final ModelGroup? modelGroup;
  final ModelStudent? modelStudent;
  final ModelStudent? oldmodelStudent;
  //final DocumentReference? department ;
  //final Map<String , dynamic>? newUpdatingGroup ;
  ModelForSaveChangeProfile(
      this.modelGroup, this.modelStudent, this.oldmodelStudent);
}
