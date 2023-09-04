import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examy/contstants/const_vars.dart';
import 'package:examy/shared/shared_pref/shared_pref.dart';
import 'package:examy/shared/user_info/user_credential.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_states.dart';

class StudentHomeCubit extends Cubit<StudentHomeStates>{

  StudentHomeCubit () : super ( InitStudentHomeState() );

 static StudentHomeCubit getObj (BuildContext context) {
   return BlocProvider.of(context);
 }

// vars
List<Map> myTeachers = [];


// functions
Future<void> getMyTeacher()async{
  uId = PrefsClass.getString(key: 'uId');
  FirebaseFirestore.instance.collection('students')
   .doc(uId).collection('myTeachers').snapshots()
   .listen((event) {
     myTeachers = [];
     event.docs.forEach((element) async {
       myTeachers.add( {
         'uid':element.id,
         'name': await element.get('teacherName')
       } );
     });
     emit(GetMyTeachersState());
   }) ;

}

Future<void> report(String report)async{

  await FirebaseFirestore.instance.collection('reports').doc(userName)
   .set({
    'report':report
  })   ;

}



}