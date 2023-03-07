import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '/domain/model.dart';

import '../app/failure.dart';

abstract class Repository {
  Future<Either<Failure, dynamic>> singUpStudent(ModelSignUp modelSignUp);
  Future<Either<Failure, List<ModelGroup>>> getAllGroup(
      DocumentReference department);
  Future<Either<Failure, dynamic>> addNewGroup(ModelGroup modelGroup);
}
