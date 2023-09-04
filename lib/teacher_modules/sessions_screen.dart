import 'package:examy/contstants/colors.dart';
import 'package:examy/contstants/widgets.dart';
import 'package:examy/cubits/main_bloc/main_bloc.dart';
import 'package:examy/cubits/main_bloc/main_states.dart';
import 'package:examy/cubits/sessions_cubit/sessions_states.dart';
import 'package:examy/shared/user_info/user_credential.dart';
import 'package:examy/teacher_modules/days_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../contstants/functions.dart';
import '../cubits/sessions_cubit/sessiosn_cubit.dart';
import '../generated/l10n.dart';

class SessionsScreen extends StatelessWidget {
  //vars
 TextEditingController dialogTextController = TextEditingController();
 GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context)=>SessionCubit()..getSessions(),
        child: BlocConsumer<SessionCubit,SessionsStates>
          (
          builder: (context,state){
            //vars
            SessionCubit cubit = SessionCubit.getObj(context);
            //return
            return state is LoadingSessions?
            Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(
                      onPressed: (){
                        showDialog(
                            context: context,
                            builder: (context)=>defaultDialog(
                                title: S.of(context).logoutMessage,
                                actions: [
                                  IconButton(
                                      onPressed: ()async{
                                        await logOut(context);
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
                                ]
                            )
                        );
                      },
                      icon: Icon(
                        Icons.output_outlined,
                        color: whiteCl,
                        size: 25.w,
                      )
                  ),

                ],
                leading:  BlocConsumer<MainCubit,MainState> (
                  builder: (context,state){
                    MainCubit  cubit = MainCubit.getObj(context);
                    return  TextButton(
                        onPressed: (){
                          cubit.changeLang();
                        },
                        child: defaultText(text: cubit.lang!, fontSize: 23.sp)
                    );
                  },



                  listener: (context,state){},
                ),



                centerTitle: true,
                title: defaultText(
                    text: S.of(context).stages,
                    fontSize: 30.sp
                ),
              ),
              body: Center(
                child: CircularProgressIndicator(
                  color: whiteCl,
                ),
              ),
            )
                :
            Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(
                      onPressed: (){
                        showDialog(
                            context: context,
                            builder: (context)=>defaultDialog(
                                title: S.of(context).logoutMessage,
                                actions: [
                                  IconButton(
                                      onPressed: ()async{
                                        await logOut(context);
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
                                ]
                            )
                        );
                      },
                      icon: Icon(
                        Icons.output_outlined,
                        color: whiteCl,
                        size: 25.w,
                      )
                  ),

                ],
                leading:  BlocConsumer<MainCubit,MainState> (
                  builder: (context,state){
                    MainCubit  cubit = MainCubit.getObj(context);
                    return  TextButton(
                        onPressed: (){
                          cubit.changeLang();
                        },
                       child: defaultText(text: cubit.lang!, fontSize: 23.sp)
                    );
                  },



                  listener: (context,state){},
                ),



                centerTitle: true,
                title: defaultText(
                    text: S.of(context).stages,
                    fontSize: 30.sp
                ),
              ),
             key: scaffoldKey,
              floatingActionButton: FloatingActionButton(
                onPressed: (){
                 showDialog(
                     context: scaffoldKey.currentContext!,
                     builder: (context)=>AlertDialog(
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(15)
                       ),
                       backgroundColor: mainCl.withOpacity(.7),
                       title: Container(
                         child: defaultText(
                             text: S.of(context).addSession,
                             fontSize: 20.w,

                         ),
                       ),
                       content: TextFormField(
                         controller: dialogTextController,
                         cursorColor: whiteCl,
                         style: TextStyle(
                           color: whiteCl,
                           fontSize: 20.sp
                         ),
                         decoration: InputDecoration(
                           border: UnderlineInputBorder(
                             borderSide: BorderSide(
                               width: 1,
                               color: whiteCl
                             )
                           ),
                           enabledBorder:  UnderlineInputBorder(
                               borderSide: BorderSide(
                                   width: 1,
                                   color: whiteCl
                               )
                           ),
                           focusedBorder:  UnderlineInputBorder(
                               borderSide: BorderSide(
                                   width: 1,
                                   color: whiteCl
                               )
                           ),

                         ),
                       ),
                       actions: [
                         IconButton(
                             onPressed: ()async{
                              await cubit.addToSessions(
                                   text: dialogTextController.text,
                               );
                              Navigator.pop(context);
                              dialogTextController.text = '';
                             },
                             icon: Icon(
                               Icons.check,
                               color: Colors.greenAccent,
                               size: 25.w,
                             )
                         )
                       ],

                     )
                 );
                 
                },
                child: Icon(
                  Icons.add,
                  size: 28.w,
                ),
              ),
              body: cubit.sessions.length==0?
                  SafeArea(
                      child:
                      Center(
                        child: defaultText(
                           align: TextAlign.center,
                            text: S.of(context).noSessions,
                            fontSize: 25.sp,
                          maxLines: 12
                        ),

                      )
                  )
                  :
              SafeArea(
                child: Padding(
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
                                    text: cubit.sessions[index],
                                    context: context,

                                );
                              },
                              separatorBuilder: (context,index)=>SizedBox(
                                height: 20.h,
                              ),
                              itemCount: cubit.sessions.length
                          )
                      ),

                    ],
                  ),
                ),
              ),
            );
          },
          listener: (context,state){}
        )
      ,
    );
  }
 Widget squareButton(
     {
       required String text,
       required BuildContext context,

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
             )],
         ),
       ),
     ),
     onTap: (){
       defaultNavigator(
           context: context,
           screen: DaysScreen(text)
       );
     },
   );
 }
}
