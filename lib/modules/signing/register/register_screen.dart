import 'package:examy/cubits/add_exam_cubit/add_exam_states.dart';
import 'package:examy/cubits/register_cubit/register_states.dart';
import 'package:examy/modules/signing/t%20or%20s/t_or_s_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../contstants/colors.dart';
import '../../../contstants/widgets.dart';
import '../../../cubits/register_cubit/register_cubit.dart';
import '../../../generated/l10n.dart';

class RegisterScreen extends StatelessWidget {
  String? callerName;
  String? groupName;
  String? collectionName;
  String? dayName;
  String? sessionName;
  String? callerUid;
  RegisterScreen({
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
    TextEditingController nameController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return  BlocProvider(
        create: (context)=>RegisterCubit(),
        child: BlocConsumer<RegisterCubit,RegisterState>
          (
          builder: (context,state){
            //vars
            RegisterCubit cubit = RegisterCubit.getObj(context);
            //return
            return Scaffold(
              appBar: AppBar(),
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
                                  text: S.of(context).Reg,
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
                          controller: nameController,
                          labelText: S.of(context).name,
                          onValidate: (value)  {

                            if(value!.isEmpty)
                            {
                              return S.of(context).nameError;
                            }

                            return null;
                          },
                          prefixIcon: Icon(
                            Icons.edit,
                            size: width/14,
                            color: whiteCl.withOpacity(.5),
                          ),


                        ),
                      ),
                            SizedBox(
                              height: height/30,
                            ),
                            Container(
                              child: defaultInput(
                                  width: width,
                                  labelText: S.of(context).passHint,
                                  controller: passController,
                                  isPass : cubit.isPass,
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
                              height: height/30,
                            ),
                            Container(
                              child: defaultInput(
                                  width: width,
                                  keyBoardType: TextInputType.emailAddress,
                                  controller: mailController,
                                  labelText: S.of(context).mailHint,
                                  onValidate: (value){
                                    if(value!.isEmpty)
                                    {
                                      return S.of(context).mailError;
                                    }
                                    return null;
                                  },
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    size: width/14,
                                    color: whiteCl.withOpacity(.5),

                                  )

                              ),
                            ),
                            SizedBox(
                              height: height/50,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                defaultButton(
                                    onPress: ()  {
                                      if(formKey.currentState!.validate())
                                      {
                                        cubit.onRegister(
                                            email: mailController.text,
                                            password: passController.text,
                                            name: nameController.text,



                                        );


                                      }


                                    },
                                    width: 150.w,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Spacer(),
                                        Container(
                                          child: defaultText(
                                              text: S.of(context).Reg2,
                                              fontSize: 25.sp,
                                              fontWeight: FontWeight.bold,

                                          ),
                                        ),
                                        Spacer(),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: whiteCl,
                                          size: 22.w,
                                        )
                                      ],
                                    ))
                              ],
                            ),
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
            RegisterCubit cubit = RegisterCubit.getObj(context) ;

            if(state is RegisterSuccess){
              if(callerName!=null){
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder:
                            (context)=> ChooseScreen(
                              email: mailController.text,
                              password: passController.text,
                              name: nameController.text,
                              callerName: callerName,
                              groupName: groupName,
                              dayName: dayName,
                              callerUid:callerUid,
                              collectionName: collectionName,
                              sessionName: sessionName,
                              uid: cubit.uid,


                        )),
                        (route) => false
                );
              }
              else if(callerName==null){
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder:
                            (context)=> ChooseScreen(
                          email: mailController.text,
                          password: passController.text,
                          name: nameController.text,
                          uid: cubit.uid,

                        )),
                        (route) => false
                );
              }


            }
            else if(state is RegisterFail)
            {
              defaultToast(
                  text: state.message,
                  context: context,
                  state: ToastState.error
              );
            }

          },
        )
      ,
    );
  }
}
