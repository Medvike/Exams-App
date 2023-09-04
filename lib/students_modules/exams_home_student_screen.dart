import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examy/contstants/functions.dart';
import 'package:examy/cubits/main_bloc/main_bloc.dart';
import 'package:examy/cubits/main_bloc/main_states.dart';
import 'package:examy/cubits/students_cubits/home_cubit/home_states.dart';
import 'package:examy/shared/user_info/user_credential.dart';
import 'package:examy/students_modules/all_exams_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../contstants/colors.dart';
import '../contstants/widgets.dart';
import '../cubits/students_cubits/home_cubit/home_cubit.dart';
import '../generated/l10n.dart';

class StudentsExamHome extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>StudentHomeCubit()..getMyTeacher(),
      child: BlocConsumer<StudentHomeCubit,StudentHomeStates>(
          builder: (context,state){
            //vars
            StudentHomeCubit cubit = StudentHomeCubit.getObj(context);
            GlobalKey<ScaffoldState> scaffoldKey =  GlobalKey<ScaffoldState>();
            TextEditingController reportCon = TextEditingController();
            //return
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                actions: [
                 BlocConsumer<MainCubit,MainState>
                   (
                     builder: (context,state) {
                     return  TextButton(
                         onPressed: (){
                           MainCubit.getObj(context).changeLang();
                         },
                         child: defaultText(text: MainCubit.getObj(context).lang!, fontSize: 23.sp)
                     );
                 }, listener: (context,state){}
                 )
                ],
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  iconSize: 25.w,
                  onPressed: (){
                    scaffoldKey.currentState!.openDrawer();
                  },
                ),
              ),
             drawer: Drawer(
               width: 160.w,
               backgroundColor: mainCl.withOpacity(.8),
               child: SafeArea(
                 child: Padding(
                   padding:  EdgeInsets.symmetric(horizontal: 10.w),
                   child: Column(
                     children: [
                       SizedBox(
                         height: 10.h,
                       ),
                       Padding(
                         padding:  EdgeInsets.symmetric(
                           horizontal: 5.w,
                           vertical: 10.h
                         ),
                         child: InkWell(
                           onTap: (){
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
                                             size: 20.w,
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
                           child: Container(
                             width: 150.w,
                             child: Row(
                               children: [
                                     Icon(
                                       Icons.output_outlined,
                                       color: whiteCl,
                                       size: 21.w,
                                     ),
                                 SizedBox(
                                   width: 5.w,
                                 ),
                                 Container(
                                   child: defaultText(
                                       text: S.of(context).logout,
                                       fontSize: 20.sp,
                                   fontWeight: FontWeight.bold
                                   ),
                                 )
                               ],
                             ),
                           ),
                         ),
                       ),
                       Padding(
                         padding:  EdgeInsets.symmetric(
                             horizontal: 5.w,
                             vertical: 10.h
                         ),
                         child: InkWell(
                           onTap: (){
                             showDialog(
                                 context: context,
                                 builder: (context)=>defaultDialog(
                                     title: S.of(context).reportMessage,
                                     content: TextFormField(
                                       controller: reportCon,
                                       style: TextStyle(
                                         color: whiteCl,
                                         fontSize: 19.sp
                                       ),
                                       cursorColor: whiteCl,
                                       maxLines: null,
                                       decoration: InputDecoration(
                                         enabledBorder: UnderlineInputBorder(
                                           borderSide: BorderSide(
                                             color: whiteCl,
                                             width: 2.w,

                                           )
                                         ),
                                         focusedBorder: UnderlineInputBorder(
                                             borderSide: BorderSide(
                                               color: whiteCl,
                                               width: 2.w,

                                             )
                                         ),
                                       ),
                                     ),
                                     actions: [
                                       IconButton(
                                           onPressed: ()async{
                                          await cubit.report(reportCon.text)
                                          .then( (value) async {
                                            Future<void> nav ()async{
                                              Navigator.pop(context);
                                            }
                                           await nav().then((value) {
                                              defaultToast(
                                                  text: 'problem is reported successfully',
                                                  context: context,
                                                  state: ToastState.success
                                              );
                                            });

                                          })
                                          ;
                                           },
                                           icon: Icon(
                                             Icons.check,
                                             color: Colors.greenAccent,
                                             size: 20.w,
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
                           child: Container(
                             width: 150.w,
                             child: Row(
                               children: [
                                 Icon(
                                   Icons.error_outline,
                                   color: whiteCl,
                                   size: 21.w,
                                 ),
                                 SizedBox(
                                   width: 5.w,
                                 ),
                                 Container(
                                   child: defaultText(
                                       text: S.of(context).report,
                                       fontSize: 20.sp,
                                       fontWeight: FontWeight.bold
                                   ),
                                 )
                               ],
                             ),
                           ),
                         ),
                       ),
                       Spacer(),
                       Column(
                         children: [
                           Column(
                             children: [
                               Container(
                                   child: defaultText(
                                       text: 'this app has been developed by ',
                                       fontSize: 9.sp,
                                       fontWeight: FontWeight.bold
                                   )),
                               SizedBox(
                                 height: 3.h,
                               ),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Container(
                                     child: defaultText(
                                         text: ' Mohamed Abdelhamed',
                                         fontSize: 12.sp,
                                         fontWeight: FontWeight.bold
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(
                                 height: 2.h,
                               ),


                             ],

                           )

                         ],
                       )
                     ],

                   ),
                 ),
               ),
             ),
              body:   cubit.myTeachers.length == 0 ?
                  Center(
                    child: defaultText(
                        text: S.of(context).sWait,
                        fontSize: 25.sp
                    ),
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
                                  text: cubit.myTeachers[index]['name'],
                                  context: context,
                                  teacherUid: cubit.myTeachers[index]['uid'],


                                );
                              },
                              separatorBuilder: (context,index)=>SizedBox(
                                height: 20.h,
                              ),
                              itemCount: cubit.myTeachers.length
                          )
                      ),

                    ],
                  ),
                ),
              ) ,
            );
          },
          listener: (context,state){}
      ),
    );
  }
  Widget squareButton(
      {
        required String text,
        required BuildContext context,
        required String teacherUid,



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
          screen: AllExamsScreen(
               teacherName: text,
               teacherUid: teacherUid,

          )
      );
      }
    );
  }
}
