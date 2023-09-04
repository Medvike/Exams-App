import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examy/cubits/choising_cubit/choising_states.dart';
import 'package:examy/cubits/days_cubit/days_states.dart';
import 'package:examy/cubits/login_cubit/login_states.dart';
import 'package:examy/shared/user_info/user_credential.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DaysCubit extends Cubit<DaysStates> {

//  initialization

  DaysCubit () : super ( DaysInitState() );

  static DaysCubit getObj(BuildContext context) {
    return BlocProvider.of(context);
  }

//  vars
TextEditingController dialogTextController = TextEditingController();
  String? sessionName;
  bool isChanged = false;
  List days =[
    'Saturday',
    'Sunday',
     'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',

  ];
  List<String> arabicDays = [
  "السبت",
  "الأحد",
  "الإثنين",
  "الثلاثاء",
  "الأربعاء",
  "الخميس",
  "الجمعة"
  ];

//  functions
Future<void> updateName({
    required String oldName,
    required String newName
}) async{
    await FirebaseFirestore.instance.collection('teachers').doc(uId)
    .collection('sessions').doc(oldName).get()

    .then((value) async{
      await FirebaseFirestore.instance.collection('teachers').doc(uId)
      .collection('sessions').doc(newName).set(value.data()!)

      .then((value) async{
        await FirebaseFirestore.instance.collection('teachers').doc(uId)
            .collection('sessions').doc(oldName).delete();

      })
      ;
    });
}
void initializeController({
    required String sessionName
}){
  dialogTextController.text = sessionName;
  emit(InitController());
}

void putSessionName(String sessionName){
  this.sessionName = sessionName;
  emit(PutSessionName());
}

void changeNameQuickly({ required String newSessionName}
){
  sessionName = newSessionName;
  isChanged = true;
  emit(ChangeName());
}

Future<void> deleteSession()async{
  await FirebaseFirestore.instance.collection('teachers').doc(uId)
      .collection('sessions').doc(sessionName).delete();
}


}