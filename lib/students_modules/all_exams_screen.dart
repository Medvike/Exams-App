import 'package:examy/contstants/colors.dart';
import 'package:examy/contstants/widgets.dart';
import 'package:examy/cubits/students_cubits/all_exams_cubit/all_exams_cubit.dart';
import 'package:examy/cubits/students_cubits/all_exams_cubit/all_exams_states.dart';
import 'package:examy/students_modules/exam_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../generated/l10n.dart';

class AllExamsScreen extends StatelessWidget {

  late String teacherName;
  late String teacherUid;




   AllExamsScreen(
  {
    required this.teacherName,
    required this.teacherUid,
}
       );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AllExamsCubit()..getExams(teacherUid : teacherUid),
        child: BlocConsumer<AllExamsCubit,AllExamsStates>
        (
      builder: (context,state){
        //vars
        AllExamsCubit cubit = AllExamsCubit.getObj(context);

        //return
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Container(
              child: defaultText(
                  text: teacherName,
                  fontSize: 25.sp
              ),
            ),


          ),
          body:  SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                //exams word
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Padding(
                      padding:  EdgeInsets.symmetric(
                        horizontal: 5.w
                      ),
                      child: Container(
                        height: 0.5.h,
                        width: 30.w,
                        color: whiteCl,
                      ),
                    ),
                    Container(
                      child: defaultText(
                          text: S.of(context).exams,
                          fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(.5)
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.symmetric(
                          horizontal: 5.w
                      ),
                      child: Container(
                        height: 0.5.h,
                        width: 30.w,
                        color: whiteCl,
                      ),
                    ),
                  ]
                ),
                Padding(
                  padding:  EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 10.h
                  ),
                  child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context,index){
                        return squareButton(
                          text: cubit.exams[index],
                          context: context,
                          cubit : cubit

                        );
                      },
                      separatorBuilder: (context,index)=>SizedBox(
                        height: 20.h,
                      ),
                      itemCount: cubit.exams.length
                  ),
                ),
              ],
            ),
          ),
        );
      },
      listener: (context,state){},
      ),
    );
  }

  Widget squareButton(
      {
        required String text,
        required BuildContext context,
        required AllExamsCubit cubit

      }
      ){
    return InkWell(
        child: Container(
          decoration: BoxDecoration(
              color: greyCl.withOpacity(.5),
              borderRadius: BorderRadius.circular(15)
          ),
          height: 80.h,
          child: Padding(
            padding:  EdgeInsets.symmetric(
                horizontal: 10.w
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: defaultText(
                      text: text,
                      maxLines: 1,
                      fontSize: 25.sp
                  ),
                )
              ],
            ),
          ),
        ),
        onTap: () {
        defaultNavigator(
            context: context,
            screen: ExamDetailsScreen(
               examName : text,
               sessionName: cubit.sessionName!,
               groupName: cubit.groupName!,
               dayName: cubit.dayName!,
               teacherUid: teacherUid,


            ) );
        }
    );
  }
}
