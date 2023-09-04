import 'package:examy/contstants/colors.dart';
import 'package:examy/contstants/widgets.dart';
import 'package:examy/cubits/days_cubit/days_states.dart';
import 'package:examy/cubits/main_bloc/main_bloc.dart';
import 'package:examy/cubits/main_bloc/main_states.dart';import 'package:examy/teacher_modules/groups_screen.dart';
import 'package:examy/teacher_modules/sessions_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../cubits/days_cubit/days_cubit.dart';
import '../generated/l10n.dart';

class DaysScreen extends StatelessWidget {

final String sessionName;
DaysScreen(this.sessionName);

  //vars



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context)=>DaysCubit()..initializeController(sessionName: sessionName)..putSessionName(sessionName),
       child: BlocConsumer<DaysCubit,DaysStates>
         (
         builder: (context,state){
           //vars

           DaysCubit cubit = DaysCubit.getObj(context);

           //return
           return Scaffold(
             appBar: AppBar(
               leading:  BlocConsumer<MainCubit,MainState>(
                 builder: (context,state){
                   return IconButton(
                       onPressed: (){
                         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>SessionsScreen()), (route) => false);
                       },
                       icon: MainCubit.getObj(context).lang=='en'? Icon(Icons.arrow_back) :  Icon(Icons.arrow_forward)

                   );
                 },
                 listener: (context,state){},
               ),
               actions: [
                 IconButton(
                     onPressed: () {
                   showDialog(
                       context: context,
                       builder: (context)=>AlertDialog(
                         shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(15)
                         ),
                         backgroundColor: mainCl.withOpacity(.7),
                         title: Container(
                           child: defaultText(
                             text: '${S.of(context).deleteSession} (${cubit.sessionName}) ',
                             fontSize: 20.w,
                             maxLines: 2,
                             align: TextAlign.center

                           ),
                         ),
                         actions: [
                           IconButton(
                               onPressed: ()async{
                                 await cubit.deleteSession()
                                     .then((value) {
                                   Navigator.pushAndRemoveUntil(
                                       context,
                                       MaterialPageRoute(builder: (context)=>SessionsScreen()),
                                           (route) => false);
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
                         Icons.delete,
                        size: 22.w,
                     )
                 )
               ],
               centerTitle: true,
               title: defaultText(
                   text: cubit.sessionName!,
                   fontSize: 30.sp
               ),
             ),
             body:  Padding(
           padding:  EdgeInsets.symmetric(
           horizontal: 10.w,
               vertical: 10.h
           ),
           child: Column(
           children: [
           BlocConsumer<MainCubit,MainState>(
            builder: (context,state){
              return  Expanded(
                  child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context,index){
                        return squareButton(
                          text: MainCubit.getObj(context).lang=='en'?
                          cubit.days[index] : cubit.arabicDays[index] ,
                          enDayName:cubit.days[index],
                          context: context,

                        );
                      },
                      separatorBuilder: (context,index)=>SizedBox(
                        height: 20.h,
                      ),
                      itemCount: cubit.days.length
                  )
              );
            },
             listener:  (context,state){},
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
      required String enDayName

    }
    ){
  return BlocConsumer<MainCubit,MainState>(
      builder: (context,state) {
        return  InkWell(
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
          onTap: (){
            defaultNavigator(
                context: context,
                screen: GroupsScreen(
                  dayName: enDayName.toLowerCase(),
                  sessionName: sessionName,
                  title: MainCubit.getObj(context).lang=='en'? enDayName : text,
                )
            );
          },
        );
      },
      listener: (context,state){}
  );
}
}
