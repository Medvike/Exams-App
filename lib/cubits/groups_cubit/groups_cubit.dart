import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examy/contstants/const_vars.dart';
import 'package:examy/cubits/choising_cubit/choising_states.dart';
import 'package:examy/cubits/days_cubit/days_states.dart';
import 'package:examy/cubits/groups_cubit/groups_state.dart';
import 'package:examy/cubits/login_cubit/login_states.dart';
import 'package:examy/shared/user_info/user_credential.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupsCubit extends Cubit<GroupsState> {

//  initialization

  GroupsCubit () : super ( GroupsInitState() );

  static GroupsCubit getObj(BuildContext context) {
    return BlocProvider.of(context);
  }

//  vars

  String? dayName;
  String? sessionName;
  List groups = [];
  int examDuration = 0 ;


//  functions
 void getNames({
    required String dayName,
   required String sessionName,
}){
   this.dayName     =  dayName    ;
   this.sessionName =  sessionName ;

 }
 Future<void> addGroup({
    required String groupName
}) async {
   await teacher.collection('sessions').doc(sessionName)
   .collection('week').doc(dayName!.toLowerCase()).collection('groups')
   .doc(groupName).set({
     'groupName':groupName
   })
       ;
 }

 void getGroups(){
      emit(LoadingGroups());
       teacher.collection('sessions').doc(sessionName)
       .collection('week').doc(dayName!.toLowerCase()).collection('groups')
       .snapshots()
       .listen((event) {
         groups = [];
         event.docs.forEach((element) {
           groups.add(element.id);
           emit(GetGroupsSuccess());
         });
         emit(NoGroups());
       });
 }

  void changeExamDuration(int value){
    examDuration = value;
    emit(ChangeExamDuration());
  }

}