import 'package:examy/cubits/main_bloc/main_bloc.dart';
import 'package:examy/cubits/main_bloc/main_states.dart';
import 'package:examy/cubits/my_exams_cubit/my_exams_cubit.dart';
import 'package:examy/cubits/my_exams_cubit/my_exams_states.dart';
import 'package:examy/teacher_modules/ideal_exam_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../contstants/colors.dart';
import '../contstants/widgets.dart';
import '../generated/l10n.dart';

class MyExamsScreen extends StatelessWidget {
  final String sessionName;
  final String dayName;
  final String groupName;
  const MyExamsScreen(
      {
        super.key,
        required this.groupName,
        required this.dayName,
        required this.sessionName
      }
      );

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(create: (context)=>MyExamsCubit()..getExams(sessionName: sessionName, dayName: dayName, groupName: groupName),
      child: BlocConsumer<MyExamsCubit,MyExamsState> (
        builder: (context,state){
          MyExamsCubit cubit = MyExamsCubit.getObj(context);

          return Scaffold(

            appBar: AppBar(
              leading: BlocConsumer<MainCubit,MainState> (
                builder: (context,state) {
                  return MainCubit.getObj(context).lang=='en'?
                  IconButton(
                      onPressed: (){
                    Navigator.pop(context);
                  },
                      icon: const Icon(Icons.arrow_back),
                     iconSize: 20.w,
                  )
                      :
                  IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_forward),
                    iconSize: 20.w,
                  )
                  ;
                },
                listener: (context,state){},
              ),
              centerTitle: true,
              title: defaultText(text: S.of(context).MyExams, fontSize: 30.sp),

            ),
             body: Padding(
               padding:  EdgeInsets.symmetric(
                   horizontal: 10.w,
                   vertical: 10.h
               ),
               child: Column(
                 children: [
                   Expanded(
                       child: ListView.separated(
                           physics: BouncingScrollPhysics(),
                           itemBuilder: (context,index){
                             return squareButton(
                                 text: cubit.examsNames[index],
                                 context: context,
                                 cubit: cubit
                             );
                           },
                           separatorBuilder: (context,index)=>SizedBox(
                             height: 20.h,
                           ),
                           itemCount: cubit.examsNames.length
                       )
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
        required MyExamsCubit cubit

      }
      ){
    return InkWell(
      onTap: (){
        defaultNavigator(
            context: context,
            screen: IdealExamScreen(
              examName: text,
              sessionName: sessionName,
              groupName: groupName,
              dayName: dayName,
        ));
      },
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

              Expanded(
                child: defaultText(
                  align: TextAlign.center,
                    text: text,
                    maxLines: 1,
                    fontSize: 25.sp
                ),
              ),
              IconButton(
                  onPressed: (){
                    showDialog(
                        context: context,
                        builder: (context)=>AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)
                          ),
                          backgroundColor: mainCl.withOpacity(.7),
                          title: Container(
                            child: defaultText(
                                text: 'Do you want to delete $text ?',
                                fontSize: 20.w,
                                maxLines: 2,
                                align: TextAlign.center

                            ),
                          ),
                          actions: [
                            IconButton(
                                onPressed: ()async{
                                  await cubit.deleteExam(sessionName: sessionName, dayName: dayName, groupName: groupName, examName: text)
                                      .then((value) {
                                    Navigator.pop(context);
                                  });

                                },
                                icon: Icon(
                                  Icons.check,
                                  color: Colors.greenAccent,
                                  size: 25.w,
                                )
                            ),
                            IconButton(
                                onPressed: (){
                                  Navigator.pop(context);

                                },
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.redAccent,
                                  size: 25.w,
                                )
                            )
                          ],

                        )
                    );

                  },
                  icon: Icon(
                Icons.delete_rounded,
                    size: 20.w,
              ))
            ],
          ),
        ),
      ),
    );
  }
}
