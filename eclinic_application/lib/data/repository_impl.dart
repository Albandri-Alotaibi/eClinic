import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/app/constants.dart';
import 'package:myapp/app/failure.dart';
import 'package:myapp/domain/extension.dart';
import 'package:myapp/domain/model.dart';
import 'package:myapp/domain/repository.dart';

class RepositoryImpl extends Repository {
  @override
  Future<Either<Failure, dynamic>> singUpStudent(
      ModelSignUp modelSignUp) async {
    try {
      Map<String, dynamic> dataStudent = {};
      dataStudent.addAll(modelSignUp.modelStudent.toMap());
      //print(modelSignUp.modelGroup.id!) ;
      addNewGroup(modelSignUp.modelGroup).then((value) async {
        dataStudent['group'] = FirebaseFirestore.instance
            .collection('studentgroup')
            .doc(modelSignUp.modelGroup.id!);
        //ModelStudent modelStudentMaker = ModelStudent.fromJson(dataStudent) ;
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: modelSignUp.email, password: modelSignUp.password)
            .then((value) async {
          final FirebaseAuth auth = FirebaseAuth.instance;
          final User? user = auth.currentUser;
          final uid = user!.uid;
          await FirebaseFirestore.instance
              .collection(TypeUser.type)
              .doc(uid)
              .set(dataStudent)
              .then((value) {
            dataStudent['group'].update({
              'students': FieldValue.arrayUnion([
                {
                  'ref': FirebaseFirestore.instance
                      .collection(TypeUser.type)
                      .doc(uid),
                  'name':
                      '${modelSignUp.modelStudent.firstname} ${modelSignUp.modelStudent.lastname}'
                }
              ])
            });
          });
        });
      });
      print("gggggggggggrrrrrrrrrrrouuuuupppppp idddddddddd");
      print(modelSignUp.modelGroup.id);
      return const Right('_r');
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ModelGroup>>> getAllGroup(
      DocumentReference department) async {
    try {
      var data = await FirebaseFirestore.instance
          .collection('studentgroup')
          .where('department', isEqualTo: department)
          .get();
      List<ModelGroup> list = [];
      for (var doc in data.docs) {
        var data = doc.data();
        //print()
        list.add(ModelGroup(
            department: data['department'],
            projectname: data['projectname'],
            students: List<Map<String, dynamic>>.from(data['students'])
                .map((e) => ModelStudentsFromGroupRef.fromJson(e))
                .toList(),
            Projectcompletiondate: data['Projectcompletiondate']?.toDate(),
            uploadgp: data['uploadgp'],
            id: doc.reference.path.split('/').last));
      }
      return Right(list);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, dynamic>> addNewGroup(ModelGroup modelGroup) async {
    print("aaaaaaaaaadddddddddddddddddddd group");
    print(modelGroup.toMap());
    print("9999999999999999999999999999");
    print(modelGroup.students);
    try {
      await FirebaseFirestore.instance
          .collection('studentgroup')
          .doc(modelGroup.id)
          .set(modelGroup.toMap());
      List<ModelGroup> list = [];
      return Right(list);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, InfoForGetDataForProfileStudent>>
      getInfoProfile() async {
    // get info for profile
    try {
      String uidUser = FirebaseAuth.instance.currentUser!.uid;
      // get user
      final dataUser = await FirebaseFirestore.instance
          .collection(TypeUser.type)
          .doc(uidUser)
          .get();
      print(dataUser.data());
      print("h88888888888");
      print(dataUser.data());
      ModelStudent modelStudent = ModelStudent.fromJson(dataUser.data()!);
      // get group
      print(modelStudent);
      final dataGroup = await modelStudent.group!.get();
      //ModelGroup modelGroup = ModelGroup.fromJson(dataGroup.data() as  Map<String, dynamic> ) ;

      print(dataGroup['students']);
      var data = dataGroup.data() as Map<String, dynamic>;
      print("999999999999999999999999");
      print(data['students']);
      print(dataGroup.data());
      ModelGroup modelGroup = ModelGroup(
          department: data['department'],
          projectname: data['projectname'],
          students: List<Map<String, dynamic>>.from(data['students'])
              .map((e) => ModelStudentsFromGroupRef.fromJson(e))
              .toList(),
          Projectcompletiondate: data['Projectcompletiondate']?.toDate(),
          uploadgp: data['uploadgp'],
          id: modelStudent.group!.path.split('/').last);

      //print(modelGroup.department.path) ;
      return Right(InfoForGetDataForProfileStudent(
          modelGroup, modelStudent, modelGroup.department));
    } catch (e) {
      // when error return  Failure
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DocumentReference>>> getDepartments() async {
    List<DocumentReference> department = [];
    try {
      await FirebaseFirestore.instance
          .collection("department")
          .get()
          .then((querySnapshot) {
        for (var element in querySnapshot.docs) {
          department.add(element.reference);
        }
      });
      //print("DONE DEP");
      return Right(department);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> saveChanged(
      ModelForSaveChangeProfile modelForSaveChangeProfile) async {
    print("0000000000000000000000000000");
    print(modelForSaveChangeProfile.modelGroup?.toMap());
    try {
      String uidUser = FirebaseAuth.instance.currentUser!.uid;
      // when create new group or change name group
      if (modelForSaveChangeProfile.modelGroup != null) {
        await FirebaseFirestore.instance
            .collection('studentgroup')
            .doc(modelForSaveChangeProfile.modelGroup!.id)
            .set(modelForSaveChangeProfile.modelGroup!.toMap());
        //.then((value) {
        //_deleteStudentTFromGroup(modelForSaveChangeProfile.oldmodelStudent!);
        //_addStudentToGroup(modelForSaveChangeProfile.modelStudent!);
        //_checkGroupIfLenghtStudentZiroDelete(
        //    modelForSaveChangeProfile.oldmodelStudent!.group!);
        //});
      }

      // when update info  student
      if (modelForSaveChangeProfile.modelStudent != null) {
        FirebaseFirestore.instance
            .collection(TypeUser.type)
            .doc(uidUser)
            .update(modelForSaveChangeProfile.modelStudent!
                .toMap()
                .removeNullValues())
            .then((value) {
          // if student change  group
          //if (modelForSaveChangeProfile.modelStudent!.group !=
          //    modelForSaveChangeProfile.oldmodelStudent!.group) {
          _deleteStudentTFromGroup(modelForSaveChangeProfile.oldmodelStudent!);
          _addStudentToGroup(modelForSaveChangeProfile.modelStudent!);
          _checkGroupIfLenghtStudentZiroDelete(
              modelForSaveChangeProfile.oldmodelStudent!.group!);
          //}
        });
      }
      if (modelForSaveChangeProfile.modelGroup == null &&
          modelForSaveChangeProfile.modelStudent == null) {
        return Left(Failure('No changes have been made'));
      }
      return const Right('Saved successfully');
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  _addStudentToGroup(ModelStudent modelStudent) async {
    String uidUser = FirebaseAuth.instance.currentUser!.uid;
    modelStudent.group!.update({
      'students': FieldValue.arrayUnion([
        {
          'ref':
              FirebaseFirestore.instance.collection(TypeUser.type).doc(uidUser),
          'name': '${modelStudent.firstname} ${modelStudent.lastname}'
        }
      ])
    });
  }

  _deleteStudentTFromGroup(ModelStudent modelStudent) async {
    String uidUser = FirebaseAuth.instance.currentUser!.uid;
    await modelStudent.group!.update({
      'students': FieldValue.arrayRemove([
        {
          'ref':
              FirebaseFirestore.instance.collection(TypeUser.type).doc(uidUser),
          'name': '${modelStudent.firstname} ${modelStudent.lastname}'
        }
      ])
    });
  }

  _checkGroupIfLenghtStudentZiroDelete(DocumentReference refGroup) async {
    var mapDataGroup = (await refGroup.get()).data();
    //print(mapDataGroup) ;
    ModelGroup modelGroupData =
        ModelGroup.fromJson(mapDataGroup as Map<String, dynamic>);
    //print(modelGroupData) ;
    if (modelGroupData.students.isEmpty) {
      _deleteGroup(refGroup);
    }
  }

  _deleteGroup(DocumentReference refGroup) {
    refGroup.delete().then((value) => debugPrint('group deleted '));
  }
}
