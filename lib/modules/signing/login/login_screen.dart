import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examy/contstants/colors.dart';
import 'package:examy/contstants/widgets.dart';
import 'package:examy/cubits/login_cubit/login_cubit.dart';
import 'package:examy/cubits/login_cubit/login_states.dart';
import 'package:examy/generated/l10n.dart';
import 'package:examy/modules/signing/register/register_screen.dart';
import 'package:examy/shared/user_info/user_credential.dart';
import 'package:examy/students_modules/exams_home_student_screen.dart';
import 'package:examy/teacher_modules/sessions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../students_modules/invitation_acception.dart';

class LoginScreen extends StatelessWidget {
  String? callerName;
  String? groupName;
  String? collectionName;
  String? dayName;
  String? sessionName;
  String? callerUid;
  LoginScreen({
     this.groupName,
     this.callerName,
     this.dayName,
     this.callerUid,
     this.collectionName,
     this.sessionName,
  });


  @override
  Widget build(BuildContext context) {

    //vars
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    TextEditingController passController = TextEditingController();
    TextEditingController mailController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();


    return  BlocProvider(
        create: (context) => LoginCubit(),
        child: BlocConsumer<LoginCubit,LoginStates>
          (
          builder: (context,state){
            //vars
            LoginCubit cubit = LoginCubit.getObj(context);

            //return
            return Scaffold(
              body:  SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:  EdgeInsets.symmetric(
                          horizontal: width/20
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: defaultText(
                                  text: S.of(context).login,
                                  fontSize: width/8,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(
                              height: height/20,
                            ),
                            Container(
                              child: defaultInput(
                                  width: width,
                                  controller: mailController,
                                  onValidate: (value){
                                    if(value!.isEmpty)
                                    {
                                      return S.of(context).mailError;
                                    }
                                    return null;
                                  },
                                  labelText: S.of(context).mailHint,
                                  keyBoardType: TextInputType.emailAddress,
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    size: width/14,
                                    color: whiteCl.withOpacity(.5),
                                  )

                              ),
                            ),
                            SizedBox(
                              height: height/30,
                            ),
                            Container(
                              child: defaultInput(
                                  width: width,
                                  controller: passController,
                                  isPass: cubit.isPass,
                                  labelText: S.of(context).passHint,
                                  onValidate: (value){
                                    if(value!.isEmpty)
                                    {
                                      return S.of(context).passError;
                                    }
                                    return null;
                                  },
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    size: width/14,
                                    color: whiteCl.withOpacity(.5),
                                  ),
                                  suffixIcon: InkWell(
                                    onTap: (){
                                      cubit.changePassVision();
                                    },
                                    child: cubit.isPass?
                                    Icon(Icons.remove_red_eye_rounded)
                                        :
                                    Icon(Icons.visibility_off)
                                    ,
                                  )

                              ),
                            ),
                            SizedBox(
                              height: height/70,
                            ),
                            Row(
                              children: [
                                defaultText(
                                    text: S.of(context).noAcc,
                                    fontSize: 18.sp,
                                ),
                                TextButton(
                                  onPressed: (){
                                    if(callerName == null){
                                      defaultNavigator(
                                          context: context,
                                          screen: RegisterScreen()
                                      );
                                    }
                                    else if(callerName!=null){
                                      defaultNavigator(
                                          context: context,
                                          screen: RegisterScreen(
                                            callerName: callerName,
                                            groupName: groupName,
                                            dayName: dayName,
                                            callerUid:callerUid,
                                            collectionName: collectionName,
                                            sessionName: sessionName,

                                          )
                                      );
                                    }

                                  },
                                  child: defaultText(
                                      text: S.of(context).Reg,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline


                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: height/70,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                defaultButton(
                                    width: 150.w,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Spacer(),
                                        Container(
                                          child: defaultText(
                                              text: S.of(context).login2,
                                              fontSize: 25.sp,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Spacer(),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: whiteCl,
                                          size: 22.w,
                                        )
                                      ],
                                    ),
                                  onPress: (){
                               if(formKey.currentState!.validate()){
                            cubit.loginWithEmailAndPass(
                                email: mailController.text,
                                password: passController.text
                            );
                               }
                                  }
                                )
                              ],
                            ),
                            SizedBox(
                                height: 10.h,
                              ),
                            if(state is! LoadingState)
                              SizedBox(
                                height: 5.h,
                              ),
                            if(state is LoadingState)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 150.w,
                                  child: LinearProgressIndicator(
                                    minHeight: 5.h,

                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          listener: (context,state){
            if(state is LoginSuccessStudent){
              if(callerName == null){
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder:
                            (context)=> StudentsExamHome()),
                        (route) => false
                );
              }
              else if(callerName != null){
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder:
                            (context)=> InviteScreen(
                              callerName: callerName,
                              groupName: groupName,
                              dayName: dayName,
                              callerUid:callerUid,
                              collectionName: collectionName,
                              sessionName: sessionName,
                              recName: userName,




                            )),
                        (route) => false
                );
              }


            }
            else if(state is LoginFail){
              defaultToast(
                  text: state.errorMessage,
                  context: context,
                  state: ToastState.error
              );
            }
            else if (state is LoginSuccessTeacher){
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context)=> SessionsScreen()),
                      (route) => false);

            }
          },
        )
      ,
    );
  }
}
