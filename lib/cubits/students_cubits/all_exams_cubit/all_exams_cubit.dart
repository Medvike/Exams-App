import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examy/cubits/students_cubits/all_exams_cubit/all_exams_states.dart';
import 'package:examy/shared/user_info/user_credential.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AllExamsCubit extends Cubit<AllExamsStates>{

  AllExamsCubit () : super ( AllExamsInitState() );

  static AllExamsCubit getObj (BuildContext context) {
    return BlocProvider.of(context);
  }

// vars
List<String> exams = [];
String? sessionName;
String? dayName;
String? groupName;

// functions
Future<void> getExams({
  required String teacherUid,
}) async{

   FirebaseFirestore.instance.collection('students').doc(uId).collection('myTeachers')
      .doc(teacherUid).snapshots().listen( (event) async {

        groupName   = event['groupName'];
        sessionName = event['sessionName'];
        dayName     = event['dayName'];

       FirebaseFirestore.instance.collection('teachers').doc(teacherUid)
        .collection('sessions').doc( event['sessionName'] )
        .collection('week')
        .doc(event['dayName']).collection('groups')
        .doc( event['groupName'] )
        .collection('exams')
       .snapshots().listen((value) {
    exams = [];
       value.docs.forEach((element) {
         exams.add(element.id);
         emit(GetExam());

       });

     })

    ;
  });






}



}