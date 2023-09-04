import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examy/cubits/choising_cubit/choising_states.dart';
import 'package:examy/cubits/login_cubit/login_states.dart';
import 'package:examy/shared/shared_pref/shared_pref.dart';
import 'package:examy/shared/user_info/user_credential.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginStates> {

//  initialization

  LoginCubit () : super ( LoginInitState() );

   static LoginCubit getObj(BuildContext context) {
    return BlocProvider.of(context);
  }

//  vars
bool isPass = true;
bool isTeacher = false;

//  functions
void changePassVision(){
   isPass = !isPass ;
   emit( ChangePassVision() );
}

Future<void> loginWithEmailAndPass(
      {
    required String email,
    required String password,
}
    ) async {
    emit(LoadingState());
      await FirebaseAuth.instance.signInWithEmailAndPassword( email: email, password: password)
      .then( (value) {
      uId = value.user!.uid;

      checkingTeacherUid(userId: value.user!.uid)
      .then((value3) {
        
        if(isTeacher == false){
          checkingStudentUid(userId: value.user!.uid);
        }
      } )
      ;

  }).catchError((onError){
    print(onError);
    emit(LoginFail(
      onError.message
    ));

  })
  ;

}

Future<void> checkingTeacherUid( {required String userId} ) async{
  await FirebaseFirestore.instance.collection('teachers')
      .get().then((value2) {
    value2.docs.forEach((element) async{
      if (element.id == userId) {

        userName = element.get('name');
        await PrefsClass.setString(key: 'uId', value: userId);
        await PrefsClass.setString(key: 'userType', value: 'teacher');
        await PrefsClass.setString(key: 'userName', value: element.get('name'));

        isTeacher = true;
        emit(LoginSuccessTeacher());
      }

    }
    );
      }
      );
      }

Future<void> checkingStudentUid( {required String userId} ) async{
    await FirebaseFirestore.instance.collection('students')
        .get().then((value2) {
      value2.docs.forEach((element) async {
        if (element.id == userId) {

          userName = element.get('name');
          await PrefsClass.setString(key: 'uId', value: userId);
          await PrefsClass.setString(key: 'userType', value: 'student');
          await PrefsClass.setString(key: 'userName', value: element.get('name'));

          emit(LoginSuccessStudent());
        }

      }
      );
    }
    );
  }

}