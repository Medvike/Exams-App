import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examy/contstants/const_vars.dart';
import 'package:examy/cubits/students_cubits/solve_exam_cubit/solve_exam_states.dart';
import 'package:examy/shared/user_info/user_credential.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SolveExamCubit extends Cubit<SolveExamStates>{

  SolveExamCubit () : super ( InitSolveExamState() );

  static SolveExamCubit getObj (BuildContext context) {
    return BlocProvider.of(context);
  }

// vars
Map<String,String> qHeadsImages = {};
Map<String,String> qHeadsStrings = {};
Map<String,String> qAnswersImages = {};
Map<String,List> qAnswersStrings = {};
Map answersNumber = {} ;
Map chosenAnswers = {};
Map chosenAnswersCheck = {};
String? examName;
String? sessionName;
String? dayName;
String? groupName;
String? teacherUid;
String? questionsNumber;
String? duration;
bool isExamDone = false ;
int? fullMark;
int  mark = 0;
Map<String,String> correctAnswers = {} ;







// functions

  Future<void> firstFunction(
  {
    required String examName,
    required String dayName,
    required String sessionName,
    required String groupName,
    required String teacherUid,
    required String duration,
    required String questionsNumber
}
      ) async {

    await initQuestionData(
        examName: examName,
        dayName: dayName,
        sessionName: sessionName,
        groupName: groupName,
        teacherUid: teacherUid,
        duration: duration,
        questionsNumber: questionsNumber
    )
    .then((value) async {
      await getQuestions();
    });

  }

  Future<void> initQuestionData({
    required String examName,
    required String dayName,
    required String sessionName,
    required String groupName,
    required String teacherUid,
    required String duration,
    required String questionsNumber
})async{

    this.examName = examName;
    this.duration = duration;
    this.questionsNumber = questionsNumber;
    this.dayName = dayName;
    this.sessionName = sessionName ;
    this.groupName  = groupName;
    this.teacherUid = teacherUid;
    emit(InitData());


  }

Future<void> getQuestions() async{

    await FirebaseFirestore.instance.collection('teachers').doc(teacherUid)
    .collection('sessions').doc(sessionName).collection('week').doc(dayName)
    .collection('groups').doc(groupName).collection('exams').doc(examName)
    .collection('questions').get()
    .then((value) {

       value.docs.forEach((element) {

        chosenAnswers.addAll({
        element.id : null
      });

        correctAnswers.addAll({
          element.id : element.data()['correctAnswerNumber'].toString(),
        });
         qHeadsImages.addAll({
           element.id : element.data()['q ${element.id} image']??''
         });
         qHeadsStrings.addAll({
           element.id : element.data()['questionHead']
         });
         qAnswersStrings.addAll({
           element.id : element.data()['answers']
         });
         answersNumber.addAll({
           element.id : element.data()['answersNumber']
         });


         //getting answers images
         for (int i = 1 ; i<= element.data()['answersNumber'] ; i++){
           qAnswersImages.addAll({
             'q ${element.id} answer $i' : element.data()['q ${element.id} answer $i']??''
           })  ;
         }






       });

      emit(GetQuestions());
    });


}




Future<void> onExamSubmitted() async {

    Map answers = {} ;
    Future<void> loop() async {

      chosenAnswers.forEach((key, value) {
        answers.addAll(
            {
             key : value
            }
        );
        correctAnswers.forEach((key2, value2) {

          if(  key == key2 &&  value2 == value.toString()   ){
            mark++;
            emit(AddMark());
          }

        })  ;

      });
    }
  await loop().then((value) async {

    await FirebaseFirestore.instance.collection('teachers').doc(teacherUid)
        .collection('sessions').doc(sessionName).collection('week').doc(dayName)
        .collection('groups').doc(groupName).collection('students').doc(userName)
        .collection('exams').doc(examName).set({
         'studentMark':mark,
         'fullMark':questionsNumber,
         'studentAnswers':answers,
         'correctAnswers':correctAnswers,
          'uid':uId

    });
  });

}

void chooseAnswer(
  {
    required String questionNumber,
    required int answerNumber,
}
    ){
    chosenAnswers[questionNumber] = answerNumber;
    emit(ChooseAnswer());
    checkExamDone();
}


void checkExamDone(){

    if( chosenAnswers.containsValue(null) )
       {
         isExamDone = false;
         emit(LastPageState());
       }
    else {
      isExamDone = true;
      emit(LastPageState());
    }


}

}