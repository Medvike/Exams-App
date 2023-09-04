

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examy/contstants/const_vars.dart';
import 'package:examy/contstants/widgets.dart';
import 'package:examy/shared/user_info/user_credential.dart';
import 'package:firebase_storage/firebase_storage.dart' as fire_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../generated/l10n.dart';
import 'add_exam_states.dart';

class AddExamCubit extends Cubit<AddExamStates> {

//  initialization

  AddExamCubit () : super ( ExamInitState() );

  static AddExamCubit getObj(BuildContext context) {
    return BlocProvider.of(context);
  }

//  vars
String? examName;
String? questionsNumber;
late String sessionName;
late String dayName;
String? groupName;
int? examDuration;
bool isFinished = false;
List< Map< String,dynamic > > examQuestionsDetails = [];
Map<String,TextEditingController>  answersControllers = {};
Map<int,TextEditingController> questionsControllers = {};
Map< int,int >  correctAnswers = {};
Map< String , File >  answersImages  = {} ;
Map< String , File > questionsImages = {} ;
late List<int> questionAnswerNUmberValues ;





//  functions


void initVars(
      {
        required String? examName,
        required String? questionsNumber,
        required int? examDuration,
        required String sessionName,
        required String dayName,
         String? groupName,


}
    ){
  this.examName = examName;
  this.examDuration = examDuration;
  this.questionsNumber = questionsNumber;
  this.groupName = groupName;
  questionAnswerNUmberValues = List.generate( int.parse(questionsNumber!), (index) => 3);
  answersImages = {};
  questionsImages = {};

  for(int i = 0;  i < int.parse(questionsNumber) ; i++){
    addQuestionControllers(questionNumber: i);

    for(int iAnswer = 1;  iAnswer <= questionAnswerNUmberValues[i] ; iAnswer++){
      addAnswersControllers(
        questionNumber: 'question ${i+1} of answer $iAnswer',
      );
    }

    correctAnswers.addAll({
      i+1 : 1
    });
  }

  this.sessionName = sessionName;
  this.groupName = groupName;
  this.dayName = dayName;
  emit(InitVarsState());
}

void changeAnswersNumber( {
    required int  index , newNumber
}){
  if(newNumber <= 3) {
    if( correctAnswers[index+1]! > 3){
      correctAnswers[index+1] = 3;
    }




  }
  if(newNumber <= 4) {
    if( correctAnswers[index+1]! > 4){
      correctAnswers[index+1] = 4;
    }

  }
  questionAnswerNUmberValues[index] = newNumber;
  emit( ChangeAnswerNumber() );
}

  void changeCorrectAnswer( {
    required int  questionNumber ,
    required int answerNumber
  }){
    correctAnswers[questionNumber] = answerNumber;
    emit( CorrectAnswerState() );
  }

void addAnswersControllers({
    required String questionNumber,
}){
  if(answersControllers[questionNumber] == null){
    answersControllers.addAll({
      questionNumber : TextEditingController()
    });
  }

}

void addQuestionControllers({
  required  int questionNumber,
}){

  if(questionsControllers[questionNumber]==null){
    print('inside id of q adding');
    questionsControllers.addAll({
     questionNumber : TextEditingController()
    });
  }
}

  void addCorrectAnswerNumber({
    required  int questionNumber,
    required int correctAnswerNumber
  }){
    if(correctAnswers[questionNumber]==null){
      correctAnswers.addAll({
        questionNumber : correctAnswerNumber
      });
    }
  }

void finishExamNow( bool finish){
  isFinished = finish;
  emit( FinishExamNow() );
}

//answer key  = question index + answer index + 1
Future<void> answerImagePicker({
    required String answerKey
})async{

 XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
 if( image != null ){
   answersImages.addAll({
    answerKey : File(image.path)
   });
   emit(AddPic());
 }



}

void deleteQuestionImage(String questionKey){
  questionsImages.remove(questionKey);
  emit(DeletePic());

}

  void deleteAnswerImage(String answerKey){
    answersImages.remove(answerKey);
    emit(DeletePic());

  }

  Future<void> questionImagePicker({
    required String questionKey
  })async{

    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if( image != null ){
      questionsImages.addAll({
        questionKey : File(image.path)
      });
      emit(AddPic());
    }



  }

  Future<void> onExamSubmit({
    required BuildContext context
})async{
await FirebaseFirestore.instance.collection('teachers')
.get().then((value) {
  value.docs.forEach((element) async {

    if(element.id==uId){

      if( element.data()['paid'] ){

        emit(Loading());
       Future<void> sendingExam() async{

         await teacher.collection('sessions').doc(sessionName).collection('week')
             .doc(dayName.toLowerCase()).collection('groups').doc(groupName)
             .collection('exams').doc(examName).set({
           'examName':examName,
           'examDuration':'$examDuration minutes',
           'examQuestions':questionsNumber,


         }).then((value) async{



           for(int i = 0 ; i < int.parse(questionsNumber!) ; i++){

             //Adding essential data
             await teacher.collection('sessions').doc(sessionName).collection('week')
                 .doc(dayName.toLowerCase()).collection('groups').doc(groupName)
                 .collection('exams').doc(examName).collection('questions')

             //set the primary data
                 .doc( (i+1).toString() ).set({
               'answersNumber':questionAnswerNUmberValues[i],
               'correctAnswerNumber':correctAnswers[i+1],
               'answers': saveExamAnswersData(questionNumber: i),
               'questionHead':questionsControllers[i]!.text.toString(),
             })

             // rest of the data(pics)
                 .then((value) async {

               // adding Questions Images
               if( questionsImages['q ${i+1}'] != null ){

                 await fire_storage.FirebaseStorage.instance.ref().child(''
                     '$userName/$uId/$sessionName/$dayName/$groupName/'
                     '$examName/questionsImages/${i + 1}/${ Uri.file(questionsImages['q ${i+1}']!.path).pathSegments.last}'
                 ).putFile(questionsImages['q ${i+1}']!).then((afterPutting) {

                   afterPutting.ref.getDownloadURL().then((link) async {

                     await teacher.collection('sessions').doc(sessionName).collection('week')
                         .doc(dayName.toLowerCase()).collection('groups').doc(groupName)
                         .collection('exams').doc(examName).collection('questions')
                         .doc( (i+1).toString() ).update({
                       'q ${i+1} image' : link
                     });

                   });
                 } );

               }

               //  adding answers images

               for(int answerNumber = 1 ; answerNumber <= questionAnswerNUmberValues[i] ; answerNumber++){
                 if(answersImages['question ${i+1} of answer $answerNumber'] != null) {

                   await fire_storage.FirebaseStorage.instance.ref().child(''
                       '$userName/$uId/$sessionName/$dayName/$groupName/'
                       '$examName/AnswerImages/$answerNumber/${ Uri.file(answersImages['question ${i+1} of answer $answerNumber']!.path).pathSegments.last}'
                   ).putFile(answersImages['question ${i+1} of answer $answerNumber']!)
                       .then((AfterPuttingValue) {

                     AfterPuttingValue.ref.getDownloadURL()
                         .then( (link) async {

                       await teacher.collection('sessions').doc(sessionName).collection('week')
                           .doc(dayName.toLowerCase()).collection('groups').doc(groupName)
                           .collection('exams').doc(examName).collection('questions')
                           .doc( (i+1).toString() ).update({
                         'q ${i+1} answer $answerNumber' : link
                       });

                     }
                     );

                   });




                 }
               }




             });











           }




         });
       }
       await sendingExam().then((value) {
         Navigator.pop(context);
         Navigator.pop(context);
         Navigator.pop(context);
       });

      }

      else if( element.data()['paid'] == false ){

        showDialog(
            context: context,
            builder: (context)=>defaultDialog(
              content: defaultText(
                 maxLines: 8,
                  text: S.of(context).sub,
                  fontSize: 23.sp,

              ),
              actions: [
                defaultButton(
                  onPress: ()  {
                    String url = "whatsapp://send?phone=+201144772563&text=";
                    launchUrl(Uri.parse(url));
                  },
                    height: 35.h,
                    child: defaultText(
                    text: S.of(context).subscribe,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp
                ))
              ]

            )
        );
      }
    }
  });
} );







  }
   List<String?> saveExamAnswersData({
    required int questionNumber
})  {

     List<String?> examAnswersData = [];

   for(int iAns = 1 ; iAns <= questionAnswerNUmberValues[questionNumber] ; iAns++){


       examAnswersData.add(
           answersControllers['question ${questionNumber + 1} of answer $iAns']!.text.toString()
       );



   }

   return examAnswersData;


  }

}