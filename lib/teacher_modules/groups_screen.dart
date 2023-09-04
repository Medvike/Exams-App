import 'package:duration_picker/duration_picker.dart';
import 'package:examy/contstants/widgets.dart';
import 'package:examy/cubits/groups_cubit/groups_cubit.dart';
import 'package:examy/cubits/groups_cubit/groups_state.dart';
import 'package:examy/teacher_modules/days_screen.dart';
import 'package:examy/teacher_modules/one_group_screen.dart';
import 'package:examy/teacher_modules/sessions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../contstants/colors.dart';
import '../generated/l10n.dart';
import 'add_exam_second_screen.dart';

class GroupsScreen extends StatelessWidget {
  final String dayName;
  final String sessionName;
  final String title;
  const GroupsScreen({
    required this.dayName,
    required this.sessionName,
    required this.title

});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
create:
(context)=>GroupsCubit()
..getNames(dayName: dayName,sessionName: sessionName)
..getGroups(),
     child: BlocConsumer<GroupsCubit,GroupsState>
        (
        builder: (context,state){
          //vars
          GroupsCubit cubit = GroupsCubit.getObj(context);
          TextEditingController dialogTextController = TextEditingController();
          GlobalKey<ScaffoldState> scaffoldKey =   GlobalKey<ScaffoldState> ();

          //return
          return state is LoadingGroups ?
          Scaffold(
            appBar: AppBar(
              leading:
              Directionality(
                textDirection: TextDirection.ltr,
                child: IconButton(
                  icon:
                  Icon(Icons.arrow_back)
                  ,
                  iconSize: 20.w,
                  onPressed: (){
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context)=>DaysScreen(sessionName)), (route) => false);
                  },
                ),

              )
              ,
              centerTitle: true,
              title: defaultText(
                  text: title,
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
            extendBody: true,
            key: scaffoldKey,
            appBar: AppBar(
              leading:
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: IconButton(
                    icon:
                   Icon(Icons.arrow_back)
                    ,
                    iconSize: 20.w,
                    onPressed: (){
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context)=>DaysScreen(sessionName)), (route) => false);
                    },
                  ),

                )
              ,
              centerTitle: true,
              title: defaultText(
                  text: title,
                  fontSize: 30.sp
              ),
            ),
            body:cubit.groups.length ==0 ?
                Center(
                  child: defaultText(
                      text: S.of(context).noGroups,
                      fontSize: 25.sp,
                      maxLines: 20,
                    align: TextAlign.center,
                  ),
                )
                :
            Padding(
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
                              text: cubit.groups[index],
                              context: context,

                            );
                          },
                          separatorBuilder: (context,index)=>SizedBox(
                            height: 20.h,
                          ),
                          itemCount: cubit.groups.length
                      )
                  ),

                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
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
                          text: S.of(context).addGroup,
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
                              await cubit.addGroup(groupName: dialogTextController.text);
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
              ) ,

            ),
          );
        },
        listener: (context,state){},
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
              )
            ],
          ),
        ),
      ),
      onTap: (){
     defaultNavigator(
         context: context,
         screen: SingleGroupScreen(
             groupName: text,
             dayName: dayName.toLowerCase(),
             sessionName: sessionName,
             title : title
         )
     );
      },
    );
  }
}
