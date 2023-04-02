import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/app/constants.dart';
import 'package:myapp/app/shardPreferense.dart';
import 'package:myapp/data/repository_impl.dart';
import 'package:myapp/domain/extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/model.dart';

class BlocGroupSelect extends Cubit<StateBlocGroupSelect> {
  BlocGroupSelect() : super(InitStateBlocGroupSelect());

  static BlocGroupSelect get(context) => BlocProvider.of(context);

  final RepositoryImpl _repositoryImpl = RepositoryImpl();

  List<ModelGroup> listAllGroups = [];

  // reset for manage  profile user
  resetDepartment() {
    modelGroupSelected = null;
    modelGroupAddNews = null;
    emit(InitStateBlocGroupSelect());
  }

  getAllGroups(DocumentReference ref) async {
    (await _repositoryImpl.getAllGroup(ref))
        .fold((l) => emit(InitStateBlocGroupSelectError(l.error)), (r) {
      //print(r);

      listAllGroups = r;
      listAllGroupsForSearching = r;
      debugPrint('get new getAllGroups');
      modelGroupSelected = null;
      modelGroupAddNews = null;
      emit(InitStateBlocGroupSelect());
    });
  }

  ModelGroup? modelGroupAddNews;

  addNewGroup(ModelGroup modelGroup) async {
    //loading = true;
    //(await _repositoryImpl.addNewGroup(modelGroup)).fold((l) {
    //  loading = false;
    //   emit(InitStateBlocGroupSelectError(l.error));
    //}, (r) {
    //print(r) ;
    //   loading = false;
    if (listAllGroups.contains(modelGroup)) {
      listAllGroups.removeWhere((e) => e == modelGroup);
      //print('remove $modelGroup') ;
    }
    listAllGroups.add(modelGroup);
    modelGroupAddNews = modelGroup;
    //listAllGroupsForSearching.add(modelGroup) ;
    emit(InitStateBlocGroupSelectAddGroupDone());
    // });
  }

  bool loading = false;

  signUp(ModelSignUp modelSignUp) async {
    loading = true;
    emit(InitStateBlocGroupSelect());
    (await _repositoryImpl.singUpStudent(modelSignUp)).fold((l) {
      loading = false;
      emit(InitStateBlocGroupSelectError(l.error));
    }, (r) {
      //print(r) ;
      //listAllGroups.add(modelGroup) ;
      loading = false;

      emit(InitStateBlocGroupSelectSignUpDone());
    });
  }

  ModelGroup? modelGroupSelected;
  selectGroup(ModelGroup? modelGroup) {
    if (modelGroup == modelGroupSelected) {
      modelGroupSelected = null;
    } else {
      modelGroupSelected = modelGroup;
    }
    emit(InitStateBlocGroupSelect());
  }

  whenEdutGroup(ModelGroup modelGroup) {
    modelGroupSelected = modelGroup;
    emit(InitStateBlocGroupSelect());
  }

  List<ModelGroup> listAllGroupsForSearching = [];

  serachGroup(String input) {
    print(input);
    if (input.trim() == '') {
      listAllGroupsForSearching = listAllGroups;
    } else {
      listAllGroupsForSearching = listAllGroups
          .where((element) =>
              (element.projectname.arabicEquatable().toUpperCase().trim())
                  .contains(input.arabicEquatable().toUpperCase().trim()))
          .toList();
    }
    emit(InitStateBlocGroupSelect());
  }
}

abstract class StateBlocGroupSelect {}

class InitStateBlocGroupSelect extends StateBlocGroupSelect {}

class InitStateBlocGroupSelectSignUpDone extends StateBlocGroupSelect {}

class InitStateBlocGroupSelectAddGroupDone extends StateBlocGroupSelect {}

class InitStateBlocGroupSelectError extends StateBlocGroupSelect {
  final String error;

  InitStateBlocGroupSelectError(this.error);
}
