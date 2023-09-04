

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
import 'package:firebase_storage/firebase_storage.dart'as fire_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'my_exams_states.dart';

class MyExamsCubit extends Cubit<MyExamsState> {

//  initialization

  MyExamsCubit () : super ( InitMyExamsState() );

  static MyExamsCubit getObj(BuildContext context) {
    return BlocProvider.of(context);
  }

//  vars
List <String> examsNames = [];

//  functions
Future<void> getExams(
      {
        required String sessionName,
        required String dayName,
        required String groupName,
}
    )async{

    await FirebaseFirestore.instance.collection('teachers')
    .doc(uId).collection('sessions').doc(sessionName)
    .collection('week').doc(dayName).collection('groups')
     .doc(groupName).collection('exams').get()
      .then( (value) {
        value.docs.forEach((element) {
          examsNames.add(element.id);
        });
    }) ;
    emit(GetExamsState());


}

Future<void> deleteExam ({
  required String sessionName,
  required String dayName,
  required String groupName,
  required String examName,

})async {
  await FirebaseFirestore.instance.collection('teachers')
      .doc(uId).collection('sessions').doc(sessionName)
      .collection('week').doc(dayName.toLowerCase()).collection('groups')
      .doc(groupName).collection('exams').doc(examName).delete().then((value) async {

    await fire_storage.FirebaseStorage.instance.ref(
     '$userName/$uId/$sessionName/$dayName/$groupName/$examName/questionsImages')
       .listAll().then((value) {
         value.items.forEach((element) {
           fire_storage.FirebaseStorage.instance.ref(element.fullPath).delete();
         });
    })    ;

         await fire_storage.FirebaseStorage.instance.ref(
           '$userName/$uId/$sessionName/$dayName/$groupName/$examName/AnswerImages'
         ).listAll().then((value) {
           value.items.forEach((element) {
             fire_storage.FirebaseStorage.instance.ref(element.fullPath).delete();
           });
         });

        examsNames = [];
        getExams(sessionName: sessionName, dayName: dayName, groupName: groupName);
  });
}

}

