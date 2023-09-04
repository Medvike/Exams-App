import 'package:examy/contstants/colors.dart';
import 'package:examy/contstants/widgets.dart';
import 'package:examy/cubits/choising_cubit/choising_cubit.dart';
import 'package:examy/cubits/choising_cubit/choising_states.dart';
import 'package:examy/shared/shared_pref/shared_pref.dart';
import 'package:examy/students_modules/exams_home_student_screen.dart';
import 'package:examy/teacher_modules/sessions_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../generated/l10n.dart';
import '../../../shared/user_info/user_credential.dart';
import '../../../students_modules/invitation_acception.dart';

class ChooseScreen extends StatelessWidget {
  final String name;
  final String password;
  final String email;
  String? callerName;
  String? groupName;
  String? collectionName;
  String? dayName;
  String? sessionName;
  String? callerUid;
  String? uid;
   ChooseScreen(
  {
    required this.name,
    required this.email,
    required this.password,
    this.groupName,
    this.callerName,
    this.dayName,
    this.callerUid,
    this.collectionName,
    this.sessionName,
    required this.uid

}
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context)=>ChooseCubit(),
        child: BlocConsumer<ChooseCubit,ChooseStates>
          (
          builder: (context,state){
            //vars
            ChooseCubit cubit = ChooseCubit.getObj(context);

            //return
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: defaultText(text: S.of(context).join, fontSize: 30.sp),

                actions: [
                    if(cubit.isStudent!=null)
                    IconButton(
                    onPressed: ()async{
                      if(cubit.isStudent==false){

                        await cubit.addAccount(
                            isStudent: false,
                           name: name,
                           uid: uid!,
                           mail: email
                        ).then((value) async {
                          await PrefsClass.setString(key: 'userName', value: name);
                        });


                      }
                      else{
                        await cubit.addAccount(
                            isStudent: true,
                            name: name,
                            uid: uid!,
                            mail: email
                        ).then((value) async {
                          await PrefsClass.setString(key: 'userName', value: name);
                        });
                      }
                    },
                    icon: Icon(
                      Icons.check,
                      size: 32.w,
                      color: Colors.greenAccent,
                    ),


                  ),
                ],
              ),
              body: SafeArea(
                child: Center(
                  child: Padding(
                    padding:  EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 10.h
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        Container(
                          height: 200.h,
                          child: Row(
                            children: [
                              Expanded(
                                child: defaultButton(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'lib/assets/svg/book-and-apple-svgrepo-com.svg',
                                        height: 75.h,
                                        width: 75.w,
                                        color: whiteCl,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      defaultText(text: S.of(context).student, fontSize: 30.sp)
                                    ],
                                  ),
                                  onPress: (){
                                    cubit.changeStudentState(
                                        isStudent: true
                                    );
                                  },
                                  color: cubit.isStudent==true?
                                      greenCl
                                      :
                                      secCl
                                ),
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              Expanded(
                                child: defaultButton(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'lib/assets/svg/presentation-teacher-svgrepo-com.svg',
                                        height: 75.h,
                                        width: 75.w,
                                        color: whiteCl,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      defaultText(text: S.of(context).teacher, fontSize: 30.sp)
                                    ],
                                  ),
                                  onPress: (){
                                    cubit.changeStudentState(
                                        isStudent: false
                                    );
                                  },
                                    color: cubit.isStudent==false?
                                    greenCl
                                        :
                                    secCl
                                ),
                              )
                            ],
                          ),
                        ),
                        Spacer(),





                      ],
                    ),
                  ),
                ),

              ),
            );
          },
          listener: (context,state){
            if(state is AddAccTeacherSuccess){
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder:
                          (context)=> SessionsScreen()),
                      (route) => false
              );

            }
               else
            if(state is AddAccStudentSuccess){
              if(callerName !=null){
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder:
                            (context)=> InviteScreen(
                              callerName: callerName,
                              groupName: groupName,
                              dayName: dayName,
                              callerUid: callerUid,
                              collectionName: collectionName,
                              sessionName: sessionName,
                              recName: userName,




                            )),
                        (route) => false
                );
              }
              else if(callerName == null){
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder:
                            (context)=> StudentsExamHome()),
                        (route) => false
                );
              }


            }
            else if (state is TORSLoading) {
              showDialog(context: context, builder: (context)=>defaultDialog(
                content: Container(
                  width: 120.w,
                  height: 120.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    ],
                  ),
                )
              ) );
            }
          },
        )
      ,
    );
  }
}
