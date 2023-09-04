import 'package:examy/cubits/ideal_exam_cubit/ideal_exam_states.dart';
import 'package:examy/cubits/my_exams_cubit/my_exams_cubit.dart';
import 'package:examy/cubits/my_exams_cubit/my_exams_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../contstants/colors.dart';
import '../contstants/widgets.dart';
import '../cubits/ideal_exam_cubit/ideal_exam_cubit.dart';

class Sdetailed extends StatelessWidget {
  final String examName;
  final String sessionName;
  final String groupName;
  final String dayName;
  final String studentName;



  Sdetailed(
   {
     required this.examName,
     required this.groupName,
     required this.dayName,
     required this.sessionName,
     required this.studentName


}
       );
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=> IdealExamCubit()..getQuestionsData
        (sessionName: sessionName, dayName: dayName,
          groupName: groupName, examName: examName,
          studentName: studentName
      ) ,
      child: BlocConsumer<IdealExamCubit,IdealExamStates>
        (
        builder: (context,state) {
          IdealExamCubit cubit = IdealExamCubit.getObj(context);
          return Scaffold(
            appBar: AppBar(),
            body :Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    physics: const BouncingScrollPhysics(),
                    controller: pageController,
                    itemBuilder: (context,index)=>singleQuestionBuilder(
                        cubit: cubit,
                        index: index,
                        context: context,
                        answersNumber: cubit.questions[(index+1).toString()]!['answersNumber']
                    ),
                    itemCount: cubit.qNumbers.length,
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
                              itemCount: cubit.qNumbers.length,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

              ],
            ),

          );
        },
        listener: (context,state){},

      ),

    );
  }

  Widget singleQuestionBuilder(
      {
        required IdealExamCubit cubit,
        required int index,
        required BuildContext context,
        required int answersNumber,

      }
      ){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: defaultText(
                  text:'Question ',
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold

              ),
            ),
            Container(
              child: defaultText(
                  text:(index+1).toString(),
                  fontSize: 30.sp,
                  color: kYellow,
                  fontWeight: FontWeight.bold

              ),
            )
          ],
        ),
        SizedBox(
          height: 8.h,
        ),
        //question
        Container(
          child: questionHeadBuilder(
              image: cubit.questions[(index+1).toString()]!['q ${index+1} image'],
              qString: cubit.questions[(index+1).toString()]!['questionHead']
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
                return answerBuilder(
                  text: cubit.questions[(index+1).toString()]!['answers'][answerIndex],
                  image: cubit.questions[(index+1).toString()]!['answersImagesList'][answerIndex],
                  answerNumber: answerIndex+1,
                  questionNumber: index+1,
                  cubit: cubit,
                  isCorrect: (answerIndex+1).toString() == cubit.correctAnswers![(answerIndex+1).toString()] ? true : false,
                  hisAnswer : answerIndex+1 == cubit.studentAnswers![(index+1).toString()] ? true : false,
                  



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
            if( image!=null )
              Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                width:  320.w,
                height: 200.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image:  DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(image),


                    )

                ),

              ),
            SizedBox(
              height: 10.h,
            ),
            if( image==null )
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
        required IdealExamCubit cubit,
        required bool isCorrect,
        required bool hisAnswer,
     






      }
      ){
    return Padding(
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
            padding: image != null ? EdgeInsetsDirectional.only(
              bottom: 5.h,
            ) : null,
            decoration: image != null ?
            BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    width: 2.w,
                    color: hisAnswer&&isCorrect ? Colors.green
                        :
                    hisAnswer && !isCorrect  ? Colors.redAccent
                        :
                    isCorrect ? Colors.green : Colors.transparent


                )

            )
                :
            null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if(image!=null)
                  Container(
                    width: 275.w,
                    height: 200.h,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: NetworkImage(image),
                          fit: BoxFit.cover,

                        )
                    ),
                  ),
                if(image!=null)
                  SizedBox(
                    height: 10.h,
                  ),
                Container(
                  width: 275.w,
                  padding: EdgeInsets.symmetric(
                    horizontal: image == null ? 15.w : 0,
                    vertical:   image == null ? 15.w : 0,

                  ),
                  decoration: image == null ? BoxDecoration(
                      border: Border.all(
                        color: hisAnswer&&isCorrect ? Colors.green
                            :
                        hisAnswer && !isCorrect  ? Colors.redAccent
                            :
                            isCorrect ? Colors.green : Colors.white
                       , width: 3.w,

                      ),
                      borderRadius: BorderRadius.circular(15)
                  ) : null,
                  child: defaultText(
                      align: image == null ? null : TextAlign.center,
                      text: text,
                      maxLines: 15,
                      fontSize: 20.sp
                  ),
                )

              ],

            ),
          ),
          SizedBox(
            width: 5.w,
          ),
          if(hisAnswer&&isCorrect)
            Column(
              children: [
                Icon(
                  Icons.person,
                  size: 20.w,
                ),
                SizedBox(
                  height: 2.h,
                ),
                Icon(
                  Icons.check_circle_sharp,
                  size: 20.w,
                ),

              ],
            ),
          if(hisAnswer && !isCorrect)
            Icon(
              Icons.person,
              size: 20.w,
            ),
           if(isCorrect&&!hisAnswer)
             Icon(
               Icons.check_circle_sharp,
               size: 20.w,
             )

        ],
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
