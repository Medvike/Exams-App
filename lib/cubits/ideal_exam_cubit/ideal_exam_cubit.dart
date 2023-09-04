import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examy/contstants/const_vars.dart';
import 'package:examy/cubits/choising_cubit/choising_states.dart';
import 'package:examy/cubits/ideal_exam_cubit/ideal_exam_states.dart';
import 'package:examy/cubits/login_cubit/login_states.dart';
import 'package:examy/shared/shared_pref/shared_pref.dart';
import 'package:examy/shared/user_info/user_credential.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IdealExamCubit extends Cubit<IdealExamStates> {

//  initialization

  IdealExamCubit () : super ( IdealExamInitState() );

  static IdealExamCubit getObj(BuildContext context) {
    return BlocProvider.of(context);
  }

//  vars
//  this map keys start with 1 as a String
Map<String, Map<String,dynamic> > questions = {};
List qNumbers = [];
Map? studentAnswers ;
Map? correctAnswers ;

//  functions
 Future<void> getQuestionsData(
      {
        required String sessionName,
        required String dayName,
        required String groupName,
        required String examName,
        String? studentName,
    
}
     ) async{

   if(studentName!=null) {
     await teacher.collection('sessions').doc(sessionName)
         .collection('week').doc(dayName).collection('groups').doc(groupName)
         .collection('students').doc(studentName).collection('exams')
         .doc(examName).get().then((value) {
           studentAnswers = value.data()!['studentAnswers'];
           correctAnswers = value.data()!['correctAnswers'];
           print('correct : $correctAnswers');
           print('hisAnswers : $studentAnswers');


     } ).catchError((err){
       print(err);});
   }

   await teacher.collection('sessions').doc(sessionName)
    .collection('week').doc(dayName).collection('groups').doc(groupName)  
    .collection('exams').doc(examName).collection('questions').get()
       .then((value) {
      value.docs.forEach((element) {

         List answersImages  = [];
         for(int i = 1 ;  i <= element.data()['answersNumber'] ; i++ ) {

          answersImages.add(

               element.data()['q ${element.id} answer $i']

          );

        }

        questions.addAll({
          element.id : {
            'answers': element.data()['answers'],
            'answersNumber':element.data()['answersNumber'],
            'correctAnswerNumber': element.data()['correctAnswerNumber'],
            'questionHead': element.data()['questionHead'],
            'q ${element.id} image': element.data()['q ${element.id} image'],
             'answersImagesList':answersImages


          }
        });
        qNumbers.add(element.id);

      });
      emit(GetQuestionState());
   });

   
   
}

Color answerColor (
      {
        required bool isCorrect,
        required bool hisAnswer,
       }
    ){

   if (  hisAnswer==false && isCorrect==true )
  {

  return Colors.yellow;
  }

   else if (  hisAnswer==true )
   {

     return Colors.redAccent;
   }

   else {

     return Colors.white;

   }


}

}