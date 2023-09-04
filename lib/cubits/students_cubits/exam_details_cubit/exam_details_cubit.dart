import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examy/cubits/students_cubits/exam_details_cubit/exam_details_states.dart';
import 'package:examy/shared/user_info/user_credential.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ExamDetailsCubit extends Cubit<ExamDetailsStates>{

 ExamDetailsCubit () : super ( ExamDetailsInitState() );

  static ExamDetailsCubit getObj (BuildContext context) {
    return BlocProvider.of(context);
  }


// vars

  String? duration ;
  String? questionNumber ;
  bool isExamed = false;
   String? fullMark;
   String? mark;

// functions

Future<void> getExamDetails({
  required String examName,
  required String teacherUid,
  required String sessionName,
  required String dayName,
  required String groupName,

})async{

  emit(LoadingState());
  await FirebaseFirestore.instance.collection('teachers').doc(teacherUid)
      .collection('sessions').doc(sessionName).collection('week').doc(dayName.toLowerCase())
      .collection('groups').doc(groupName).collection('students').doc(userName)
           .collection('exams').get().then((value) async {
     if(value.docs.isNotEmpty){
       value.docs.forEach((element) async {
         if(element.data()['uid']==uId){
           isExamed = true ;
           fullMark = element.data()['fullMark'];
           mark = element.data()['studentMark'].toString();
           emit( IsExamed() );
         }
         else {
           await FirebaseFirestore.instance.collection('teachers').doc(teacherUid)
               .collection('sessions').doc(sessionName).collection('week').doc(dayName)
               .collection('groups').doc(groupName).collection('exams').doc(examName)
               .get().then((value) {

             duration = value['examDuration'];
             questionNumber = value['examQuestions'];
             emit(GetDetails());

           });
         }
       });

     }
     else {
       await FirebaseFirestore.instance.collection('teachers').doc(teacherUid)
           .collection('sessions').doc(sessionName).collection('week').doc(dayName)
           .collection('groups').doc(groupName).collection('exams').doc(examName)
           .get().then((value) {

         duration = value['examDuration'];
         questionNumber = value['examQuestions'];
         emit(GetDetails());

       });
     }

  });
   


  








}

}