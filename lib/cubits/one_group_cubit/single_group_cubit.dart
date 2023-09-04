

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examy/contstants/const_vars.dart';
import 'package:examy/cubits/choising_cubit/choising_states.dart';
import 'package:examy/cubits/days_cubit/days_states.dart';
import 'package:examy/cubits/groups_cubit/groups_state.dart';
import 'package:examy/cubits/login_cubit/login_states.dart';
import 'package:examy/cubits/one_group_cubit/singlr_groupe_states.dart';
import 'package:examy/shared/user_info/user_credential.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingleGroupCubit extends Cubit<SingleGroupStates> {

//  initialization

  SingleGroupCubit () : super ( SingleGroupInitState() );

  static SingleGroupCubit getObj(BuildContext context) {
    return BlocProvider.of(context);
  }

//  vars

  String? dayName;
  String? sessionName;
  String? groupName;
  List students =[];
  TextEditingController dialogTextController = TextEditingController();
  int examDuration = 0 ;


//  functions
  void getName(
      {
        required String dayName,
        required String sessionName,
        required String groupName,

}
      ){
    this.dayName = dayName ;
    this.groupName = groupName;
    this.sessionName = sessionName;
    emit( GetNamesSuccess() );
  }
  void getMyStudents() {
   emit(SingleGroupLoading());
    teacher.collection('sessions').doc(sessionName)
    .collection('week').doc(dayName!.toLowerCase())
    .collection('groups').doc(groupName).collection('students')
     .snapshots()
     .listen((event) {
      students = [];
      event.docs.forEach((element) {
        students.add(element.id);
        emit(GetStudentSuccess());

      });

    });
        emit(NoData());
  }

  Future<Map> getMarks({
    required String studentName
}) async {

    Map marksData = {};

    await teacher.collection('sessions').doc(sessionName)
        .collection('week').doc(dayName!.toLowerCase())
        .collection('groups').doc(groupName).collection('students')
        .doc(studentName).collection('exams').get()
        .then((value) {

          value.docs.forEach((element) {
            marksData.addAll({
              element.id : {
                'fullMark' : element.data()['fullMark'],
                'mark'     : element.data()['studentMark'],
              }

            });
          });
    });

    return marksData;

  }

  Future<void> deleteGroup({
    required String groupName
}) async {

    await teacher.collection('sessions').doc(sessionName)
        .collection('week').doc(dayName!.toLowerCase())
        .collection('groups').doc(groupName).delete();
  }

  void changeExamDuration(int value){
    examDuration = value;
    emit(ChangeExamDurationAllGroups());
  }

}