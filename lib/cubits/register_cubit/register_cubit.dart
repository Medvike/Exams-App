

import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examy/cubits/register_cubit/register_states.dart';
import 'package:examy/shared/shared_pref/shared_pref.dart';
import 'package:examy/shared/user_info/user_credential.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../contstants/widgets.dart';
import '../../generated/l10n.dart';

class RegisterCubit extends Cubit<RegisterState> {

//  initialization

  RegisterCubit () : super ( RegisterInitState() );

  static RegisterCubit getObj(BuildContext context) {
    return BlocProvider.of(context);
  }

//  vars
  bool isPass = true;
  String? uid ;
  bool isSame = false ;

//  functions
  void changePassVision(){
    isPass = !isPass ;
    emit( ChangePassVision() );
  }

  Future<void> onRegister(
      {
        required String email,
        required String password,
        required String name,

      }
      ) async{

emit(LoadingState());

Future<void> regFunction() async {

    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
    )
        .then((value) async {
      uid = value.user!.uid;
      emit(RegisterSuccess());

    }).catchError((onError){
      emit( RegisterFail(onError.message) );


    })
    ;
  }

  await regFunction();


  }






  //cancel loading
  void cancelLoading(){
    emit(LoadingCANCEL());
  }



}

