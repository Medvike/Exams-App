import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examy/cubits/login_cubit/login_states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/shared_pref/shared_pref.dart';
import '../../shared/user_info/user_credential.dart';
import 'choising_states.dart';

class ChooseCubit extends Cubit<ChooseStates> {

//  initialization

  ChooseCubit () : super ( InitState() );

  static ChooseCubit getObj(BuildContext context) {
    return BlocProvider.of(context);
  }

//  vars
  bool? isStudent ;

//  functions
  void changeStudentState(
      {
    required bool isStudent
}
      ){
    this.isStudent = isStudent ;
    emit( ChangeStudentState() );
  }

  Future<void> addAccount(
      {
    required bool isStudent,
    required String name,
    required String mail,
    required String uid,


      }
      ) async{
    emit(TORSLoading());
    if(!isStudent)
      {
        addTeacher(name: name, mail: mail,uid: uid)

            .then((value) async {
          emit(AddAccTeacherSuccess());
          await PrefsClass.setString(key: 'uId', value: uid);
          uId = uid;
          userName = name;
          await PrefsClass.setString(key: 'userType', value: 'teacher');
        }).catchError((onError){
          print(onError);
          emit(AddAccFail());

        });


      }
    else
        {
         addStudent(name: name, mail: mail,uid: uid)
             .then((value) async {
           emit(AddAccStudentSuccess());
           await PrefsClass.setString(key: 'uId', value: uid);
           uId = uid;
           userName = name;
           await PrefsClass.setString(key: 'userType', value: 'student');

         }).catchError((onError){
           print(onError);
           emit(AddAccFail());

         });

        }
  }

  Future<void> addTeacher(
      {
        required String name,
        required String mail,
        required String uid
      }
      ) async{
    await FirebaseFirestore.instance.collection('teachers').doc(uid)
        .set( {
      'name':name,
      'email': mail,
      'paid': false,
      'uId' : uid
    });


}
Future<void> addStudent(
      {
        required String name,
        required String mail,
        required String uid


      }
    ) async{
  await FirebaseFirestore.instance.collection('students').doc(uid)
      .set( {
    'name':name,
    'email':mail,
    'uId' : uid

  });
}

}