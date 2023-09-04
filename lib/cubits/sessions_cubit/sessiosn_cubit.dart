import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examy/contstants/widgets.dart';
import 'package:examy/cubits/login_cubit/login_states.dart';
import 'package:examy/cubits/sessions_cubit/sessions_states.dart';
import 'package:examy/shared/shared_pref/shared_pref.dart';
import 'package:examy/shared/user_info/user_credential.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../contstants/colors.dart';


class SessionCubit extends Cubit<SessionsStates> {

//  initialization

  SessionCubit () : super ( InitState() );

  static SessionCubit getObj(BuildContext context) {
    return BlocProvider.of(context);
  }

//  vars
List<String> sessions = [] ;

//  functions

Future<void> addToSessions (
      {
      required String text,

}
    ) async{

  emit(AddToSessionsSuccess());
  await FirebaseFirestore.instance.collection('teachers').doc(uId)
      .collection('sessions').doc(text).set({});






}

void getSessions() {
 emit(LoadingSessions());
   FirebaseFirestore.instance.collection('teachers').doc(uId)
      .collection('sessions')
   .snapshots()
   .listen((event) {

     sessions = [];
     event.docs.forEach((element) {
       sessions.add(element.id);
       emit(GetSessionsSuccess());
     });
    emit(NoSessions());
   });

}



}


