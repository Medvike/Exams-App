import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:examy/contstants/colors.dart';
import 'package:examy/contstants/widgets.dart';
import 'package:examy/cubits/students_cubits/exam_details_cubit/exam_details_cubit.dart';
import 'package:examy/cubits/students_cubits/exam_details_cubit/exam_details_states.dart';
import 'package:examy/students_modules/results_screen.dart';
import 'package:examy/students_modules/solve_exam_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../generated/l10n.dart';

class ExamDetailsScreen extends StatelessWidget {
  final String examName;
  final String sessionName;
  final String dayName;
  final String groupName;
  final String teacherUid;



  const ExamDetailsScreen({
  required this.examName,
  required this.dayName,
  required this.sessionName,
  required this.groupName,
  required this.teacherUid

});


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ExamDetailsCubit()..getExamDetails(
            examName: examName,
            teacherUid:teacherUid,
            sessionName: sessionName,
            dayName: dayName,
            groupName: groupName
        ),
        child: BlocConsumer<ExamDetailsCubit,ExamDetailsStates>
          (
          builder: (context,state){
            //vars
            ExamDetailsCubit cubit = ExamDetailsCubit.getObj(context);
            //return
            return Scaffold(
           appBar: AppBar(
      centerTitle: true,
       title: Container(
    child: defaultText(
        text: examName,
        fontSize: 35.sp
    ),
  ),

),
              body:  state is LoadingState?
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,

                ),
              )
                  :
              cubit.isExamed==false?
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 const Spacer(),
                  ConditionalBuilder(
                      condition: cubit.duration!=null && cubit.questionNumber!=null,
                      builder: (context)=>Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.query_builder_sharp,
                                size: 23.w,
                                color: whiteCl,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              defaultText(
                                text: '${cubit.duration![0]} ${S.of(context).mins}' ,
                                fontSize: 30.sp,
                                fontWeight: FontWeight.bold,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.quiz,
                                size: 23.w,
                                color: whiteCl,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              defaultText(
                                text:
                                '${cubit.questionNumber} ${int.parse(cubit.questionNumber!)>1 ? S.of(context).question : S.of(context).questions }'
                                ,
                                fontSize: 30.sp,
                                fontWeight: FontWeight.bold,
                              )
                            ],
                          )
                        ],
                      ),
                      fallback: (context)=>const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,

                        ),
                      )
                  ),

                 const Spacer(),
                  Padding(
                    padding:  EdgeInsets.symmetric(
                      horizontal: 30.w,
                      vertical: 5.h
                    ),
                    child: defaultButton(
                      onPress: (){

                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context)=>SolveExamScreen(
                              examName: examName,
                              dayName: dayName,
                              sessionName: sessionName,
                              groupName: groupName,
                              teacherUid: teacherUid,
                              duration: cubit.duration!,
                              questionsNumber: cubit.questionNumber!,
                            )),
                                (route) => false
                        );

                      },
                        child: defaultText(
                        text: S.of(context).start,
                      fontSize: 28.sp,


                    )),
                  ),
                ],
              )
                  :
             ResulstsScreen(fullMark: cubit.fullMark!, mark: cubit.mark!)
              ,
            );
          },
          listener: (context,state){},
        )
      ,

    );

  }
}
