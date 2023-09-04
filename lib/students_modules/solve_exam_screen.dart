import 'package:examy/contstants/widgets.dart';
import 'package:examy/cubits/students_cubits/solve_exam_cubit/solve_exam_cubit.dart';
import 'package:examy/cubits/students_cubits/solve_exam_cubit/solve_exam_states.dart';
import 'package:examy/students_modules/results_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../contstants/colors.dart';

class SolveExamScreen extends StatelessWidget {
  final String examName;
  final String sessionName;
  final String dayName;
  final String groupName;
  final String teacherUid;
  final String questionsNumber;
  final String duration;

   SolveExamScreen({
     required this.examName,
     required this.dayName,
     required this.sessionName,
     required this.groupName,
     required this.teacherUid,
     required this.duration,
     required this.questionsNumber
});
   PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>SolveExamCubit()..firstFunction(examName: examName, dayName: dayName, sessionName: sessionName, groupName: groupName, teacherUid: teacherUid, duration: duration, questionsNumber: questionsNumber),
      child: BlocConsumer<SolveExamCubit,SolveExamStates>
        (
        builder: (context,state){
          SolveExamCubit cubit = SolveExamCubit.getObj(context);
          return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Countdown(
                 onFinished: () async{
                    {
                     await cubit.onExamSubmitted()
                     .then((value) {
                       Navigator.pushAndRemoveUntil(
                           context,
                           MaterialPageRoute(builder: (context)=>ResulstsScreen(fullMark: questionsNumber, mark: cubit.mark.toString() )),
                               (route) => false);
                     });

                   }
                 },
                seconds: int.parse(cubit.duration![0])*60,
                build: (context,time){
              return Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.access_time_outlined,
                 size: 25.w,
               ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Row(
                    children :[
                      if( (time / 60).round() != 0)
                      defaultText(text: (time / 60).round().toString() , fontSize: 25.sp),

                      if( (time / 60).round() == 0)
                        defaultText(text: (time).round().toString() , fontSize: 25.sp),

                      if((time / 60).round() > 1)
                      defaultText(text: ' minutes', fontSize: 25.sp),

                      if((time / 60).round() == 1)
                        defaultText(text: ' minute', fontSize: 25.sp),


                      if( (time / 60).round() == 0)
                        defaultText(text: ' seconds', fontSize: 25.sp),




                    ]
                  )
                ],
              );
            }),
            actions: [
                if(cubit.isExamDone)
                IconButton(
                  onPressed: () async {
                    await cubit.onExamSubmitted().then((value) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context)=>ResulstsScreen(fullMark: questionsNumber, mark: cubit.mark.toString() )),
                              (route) => false);
                    });

                  },
                  iconSize: 30.w,
                  icon: Icon(Icons.check),
                color: Colors.greenAccent,

                )
            ],

          ),
         body: cubit.qHeadsStrings.isNotEmpty && cubit.qHeadsImages.isNotEmpty && cubit.qAnswersImages.isNotEmpty && cubit.qAnswersStrings.isNotEmpty?
              Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      physics: const BouncingScrollPhysics(),
                      controller: pageController,
                      itemBuilder: (context,index)=>singleQuestionBuilder(
                          cubit: cubit,
                          index: index,
                          context: context,
                          answersNumber: cubit.answersNumber[(index+1).toString()]
                      ),
                      itemCount: int.parse(questionsNumber),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            height: 35.h,
                            child: Center(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context,index)=>pageIndexBuilder(
                                  number: ( index + 1 ).toString(),

                                ),
                                itemCount: int.parse(questionsNumber),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                ],
              )
               :
             Center(
           child: CircularProgressIndicator(
             color: whiteCl,
           ),
         )
          );
        },
        listener: (context,state){},
      )
      ,
    );
  }
  Widget singleQuestionBuilder(
      {
        required SolveExamCubit cubit,
        required int index,
        required BuildContext context,
        required int answersNumber,

      }
      ){
    return Column(
      children: [
        //question
        Container(
          child: questionHeadBuilder(
              image: cubit.qHeadsImages[(index+1).toString()],
              qString: cubit.qHeadsStrings[(index+1).toString()]!
          ),
        ),
        //answers
        SizedBox(
          height: 20.h,
        ),
        Expanded(
          child: ListView.separated(
            clipBehavior: Clip.antiAliasWithSaveLayer,

              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context,answerIndex){
              print(cubit.qAnswersImages.toString());
                return answerBuilder(
                  text: cubit.qAnswersStrings[(index+1).toString()]![answerIndex],
                  image: cubit.qAnswersImages['q ${index+1} answer ${answerIndex+1}'],
                  answerNumber: answerIndex+1,
                  questionNumber: index+1,
                  cubit: cubit

                );
              },
              separatorBuilder: (context,index){
                return SizedBox(
                  height: 8.h,
                );
              },
              itemCount: answersNumber
          ),
        )



      ],
    );

  }



  //one questionBuilder
  Widget questionHeadBuilder({
    String? image,
    required String qString
  }){

     return
     Padding(
       padding:  EdgeInsets.symmetric(
         horizontal: 15.w
       ),
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         mainAxisSize: MainAxisSize.min,
         children: [
          if( image!='' )
           Container(
             clipBehavior: Clip.antiAliasWithSaveLayer,
             width:  320.w,
             height: 200.h,
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(30),
               image:  DecorationImage(
                 fit: BoxFit.cover,
                 image: NetworkImage(image!),


               )

             ),

           ),
           SizedBox(
             height: 10.h,
           ),
           if( image=='' )
             SizedBox(
               height: 15.h,
             ),
           Container(
             child: defaultText(
              text: qString,
               maxLines: 8,
               fontSize: 20.sp,
               textOverflow: TextOverflow.ellipsis,
               fontWeight: FontWeight.bold
             ),
           )






         ],
       ),
     );


  }


  Widget answerBuilder(
  {
    required String? image,
    required String text,
    required int answerNumber,
    required int questionNumber,
    required SolveExamCubit cubit

}
      ){
    return InkWell(
      onTap: (){
       cubit.chooseAnswer(
           questionNumber: questionNumber.toString(),
           answerNumber: answerNumber
       );
      },
      child: Padding(
        padding:  EdgeInsets.symmetric(
          horizontal: 15.w,
          vertical: 20.h
        ),
        child: Row(
          children: [
            Row(
              children: [
                Container(
                  child: defaultText(
                    text: answerNumber.toString(),
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,

              ),
                ),
                Container(
                  child: defaultText(
                      text: '.',
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold,

                  ),
                )
              ],
            ),
            SizedBox(
              width: 5.w,
            ),
            Container(
              padding: image != '' ? EdgeInsetsDirectional.only(
                  bottom: 5.h,
              ) : null,
              decoration: image != '' ?
              BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      width: 2.w,
                      color:
                      cubit.chosenAnswers[questionNumber.toString()] == answerNumber? kYellow : Colors.transparent
                  )

              )
                  :
              null,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(image!='')
                  Container(
                      width: 297.w,
                      height: 200.h,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: NetworkImage(image!),
                            fit: BoxFit.cover,

                          )
                      ),
                    ),
                  if(image!='')
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      width: 297.w,
                    padding: EdgeInsets.symmetric(
                      horizontal: image == '' ? 15.w : 0,
                      vertical:   image == '' ? 15.w : 0,

                    ),
                    decoration: image == '' ? BoxDecoration(
                        border: Border.all(
                          color: cubit.chosenAnswers[questionNumber.toString()] == answerNumber ? kYellow : whiteCl,
                          width: 2.w,

                        ),
                        borderRadius: BorderRadius.circular(15)
                    ) : null,
                    child: defaultText(
                       align: image == '' ? null : TextAlign.center,
                        text: text,
                        maxLines: 15,
                        fontSize: 20.sp
                    ),
                  )

                ],

              ),
            )
          ],
        ),
      ),
    );
  }

  //page index
  Widget pageIndexBuilder({
    required String number,

  }){
    return InkWell(
      onTap: (){
        pageController.animateToPage(
            int.parse(number)-1,
            duration: Duration(
                seconds: 2
            ),
            curve: Curves.fastLinearToSlowEaseIn
        );
      },
      child: Padding(
        padding:  EdgeInsets.symmetric(
            horizontal: 10.w
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: 8.w,
              vertical: 8.h
          ),
          decoration: BoxDecoration(
            color: greyCl.withOpacity(.5),
            borderRadius: BorderRadius.circular(10),

          ),
          child: defaultText(
            text: number,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

    );
  }
}
