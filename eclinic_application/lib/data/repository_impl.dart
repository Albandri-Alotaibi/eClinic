import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/app/failure.dart';
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
              .collection('student')
              .doc(uid)
              .set(dataStudent)
              .then((value) {
            dataStudent['group'].update({
              'students': FieldValue.arrayUnion([
                {
                  'ref':
                      FirebaseFirestore.instance.collection('student').doc(uid),
                  'name':
                      '${modelSignUp.modelStudent.firstname} ${modelSignUp.modelStudent.lastname}'
                }
              ])
            });
          });
        });
      });
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
        list.add(ModelGroup(
            department: data['department'],
            projectname: data['projectname'],
            students: List<Map<String, dynamic>>.from(data['students'])
                .map((e) => ModelStudentsFromGroupRef.fromJson(e))
                .toList(),
            Projectcompletiondate: data['Projectcompletiondate']?.toDate(),
            uploadgp: data['uploadgp'],
            id: doc.id));
      }
      return Right(list);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, dynamic>> addNewGroup(ModelGroup modelGroup) async {
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
}
