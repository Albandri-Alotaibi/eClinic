import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:myapp/domain/extension.dart';
import 'package:myapp/domain/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository_impl.dart';

class BlocProfileStudent extends Cubit<StateBlocProfileStudent> {
  BlocProfileStudent() : super(InitStateBlocProfileStudent());

  static BlocProfileStudent get(context) => BlocProvider.of(context);

  RepositoryImpl repositoryImpl = RepositoryImpl();

  ModelGroup? modelGroup;
  ModelStudent? modelStudent;
  DocumentReference? departement;

  /*
  ModelGroup? modelGroupSelect  ;
  selectModeGroup(ModelGroup modelGroup){
    modelGroupSelect = modelGroup ;
    emit(InitStateBlocProfileStudent()) ;
  }

   */

  // when return from page change department
  resetDepartment() {
    departmentSelect = null;
    if (currentDepartment == null) {
      changeCurrentDepartment(departement);
    }
    if (currentGroup == null) {
      changeCurrentGroup(modelGroup);
    }
    emit(InitStateBlocProfileStudent());
  }

  // when return from page change department
  resetGroup() {
    changeCurrentGroup(modelGroup);
    modelGroupSelectGroupWhentShosNotAMember = null;
    emit(InitStateBlocProfileStudent());
  }

  initialisation({String? message}) async {
    (await repositoryImpl.getInfoProfile())
        .fold((l) => emit(InitStateBlocProfileStudentError(l.error)), (r) {
      modelStudent = r.student;
      modelGroup = r.modelGroub;
      departement = r.departement;
      resetDepartment();
      resetGroup();

      if (message != null) {
        emit(InitStateBlocProfileStudentSaveData(message));
      } else {
        emit(InitStateBlocProfileStudent());
      }
    });
  }

  List<DocumentReference> allDepartments = [];
  DocumentReference? departmentSelect;
  getDepartments() async {
    (await repositoryImpl.getDepartments())
        .fold((l) => emit(InitStateBlocProfileStudentError(l.error)), (r) {
      allDepartments = r;
      //if(departmentSelect == null ) {
      //  allDepartments.remove(departement);
      //}
      //print(r) ;
      // emit(InitStateBlocProfileStudent());
      emit(InitStateBlocProfileStudentChangeCurrentDepartment());
    });
  }

  changeSelectDepatment(DocumentReference? input) {
    departmentSelect = input ?? allDepartments.last;

    // emit(InitStateBlocProfileStudent());
    emit(InitStateBlocProfileStudentChangeCurrentDepartment());
  }

  // when select department
  DocumentReference? currentDepartment;
  changeCurrentDepartment(DocumentReference? input) {
    currentDepartment = input;
    // emit(InitStateBlocProfileStudent());
    emit(InitStateBlocProfileStudentChangeCurrentDepartment());
  }

  // when select group
  ModelGroup? currentGroup;
  changeCurrentGroup(ModelGroup? input) {
    currentGroup = input;
    // emit(InitStateBlocProfileStudent());
    emit(InitStateBlocProfileStudentChangeCurrentGroup());
  }

  // save changed
  saveChange(ModelStudent modelStudentInput, ModelGroup? modelGroupInputIfNew,
      ModelGroup modelGroupWhenChangeFields) async {
    emit(InitStateBlocProfileStudentStartLoading());
    ModelGroup? modelGroupUpdate;
    ModelStudent? modelStudentUpdate;
    if (modelStudentInput != modelStudent) {
      modelStudentUpdate = modelStudentInput;
    }
    //print(modelStudentUpdate) ;
    //print(modelStudent) ;
    if (modelGroupInputIfNew == currentGroup) {
      modelGroupUpdate = modelGroupInputIfNew;
    }
    // when change name group or data completation
    if (modelGroupWhenChangeFields.projectname != currentGroup!.projectname ||
        modelGroupWhenChangeFields.Projectcompletiondate !=
            currentGroup!.Projectcompletiondate) {
      modelGroupUpdate = modelGroupWhenChangeFields;
    }

    (await repositoryImpl.saveChanged(ModelForSaveChangeProfile(
            modelGroupUpdate, modelStudentUpdate, modelStudent)))
        .fold((l) => emit(InitStateBlocProfileStudentError(l.error)), (r) {
      initialisation(message: r);
      //emit(InitStateBlocProfileStudentSaveData(r))
    });
  }

  // check if name exist from groups
  List<ModelGroup> listSomeName = [];
  Future<bool> checkIfNameGroupExist(String newName) async {
    (await repositoryImpl.getAllGroup(currentDepartment!)).fold(
        (l) => debugPrint('error from checkIfNameGroupExist  ${l.error}'), (r) {
      // print(r) ;
      listSomeName = r
          .where((element) =>
              element.projectname.arabicEquatable().toUpperCase().trim() ==
              newName.arabicEquatable().toUpperCase().trim())
          .toList();
      print('lis SOME == $listSomeName');
    });
    listSomeName.remove(currentGroup);
    return listSomeName.isNotEmpty;
  }

  // if select 'not a member at any of these group'
  ModelGroup? modelGroupSelectGroupWhentShosNotAMember;
  changeSelectMumber(ModelGroup? model) {
    if (model != null && model == modelGroupSelectGroupWhentShosNotAMember) {
      modelGroupSelectGroupWhentShosNotAMember = null;
    } else {
      modelGroupSelectGroupWhentShosNotAMember = model;
    }
    emit(InitStateBlocProfileStudent());
  }
}

abstract class StateBlocProfileStudent {}

class InitStateBlocProfileStudent extends StateBlocProfileStudent {}

class InitStateBlocProfileStudentChangeCurrentGroup
    extends StateBlocProfileStudent {}

class InitStateBlocProfileStudentChangeCurrentDepartment
    extends StateBlocProfileStudent {}

class InitStateBlocProfileStudentStartLoading extends StateBlocProfileStudent {}

class InitStateBlocProfileStudentAlart extends StateBlocProfileStudent {
  final String nameGroup;

  InitStateBlocProfileStudentAlart(this.nameGroup);
}

class InitStateBlocProfileStudentError extends StateBlocProfileStudent {
  final String error;

  InitStateBlocProfileStudentError(this.error);
}

class InitStateBlocProfileStudentSaveData extends StateBlocProfileStudent {
  final String message;

  InitStateBlocProfileStudentSaveData(this.message);
}
