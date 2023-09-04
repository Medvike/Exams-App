import 'package:duration_picker/duration_picker.dart';
import 'package:examy/cubits/main_bloc/main_bloc.dart';
import 'package:examy/cubits/main_bloc/main_states.dart';
import 'package:examy/cubits/one_group_cubit/single_group_cubit.dart';
import 'package:examy/deep_links/deep_link.dart';import 'package:examy/shared/user_info/user_credential.dart';
import 'package:examy/teacher_modules/add_exam_second_screen.dart';
import 'package:examy/teacher_modules/groups_screen.dart';
import 'package:examy/teacher_modules/my_exams_scrren.dart';
import 'package:examy/teacher_modules/student_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

import '../contstants/colors.dart';
import '../contstants/widgets.dart';
import '../cubits/one_group_cubit/singlr_groupe_states.dart';
import '../generated/l10n.dart';

class SingleGroupScreen extends StatelessWidget {

  final String groupName;
  final String sessionName;
  final String dayName;
  final String title;



    SingleGroupScreen(
  {
    required this.groupName,
    required this.dayName,
    required this.sessionName,
    required this.title
}
      );

GlobalKey<FormState> formKey = GlobalKey<FormState>();
GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
TextEditingController nameCon = TextEditingController();
TextEditingController qNumCon = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
    create: (context)=>SingleGroupCubit()..getName(
        dayName: dayName, sessionName: sessionName, groupName: groupName)
        ..getMyStudents()

      ,
      child: BlocConsumer<SingleGroupCubit,SingleGroupStates>
        (
          builder: (context,state){
            //vars
            SingleGroupCubit cubit = SingleGroupCubit.getObj(context);


            //return
            return state is SingleGroupLoading?
                Scaffold(
                    appBar: AppBar(
                      leading: BlocConsumer<MainCubit,MainState>(
                        builder: (context,state){
                          return IconButton(
                            onPressed: (){
                              Navigator.pop(context);

                            },
                            icon: MainCubit.getObj(context).lang=='en' ?const Icon(Icons.arrow_back) :const Icon(Icons.arrow_forward) ,
                            iconSize: 20.w,
                          );
                        },
                        listener: (context,state){},

                      ),
                      actions: [
                        IconButton(
                          onPressed: (){
                            scaffoldKey.currentState!.openEndDrawer();
                          },
                          icon: Icon(Icons.menu_outlined),
                          iconSize: 22.w,),
                      ],
                      centerTitle: true,
                      title: defaultText(
                          text: cubit.groupName!,
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
              key: scaffoldKey,
              appBar: AppBar(
                leading: BlocConsumer<MainCubit,MainState>(
                builder: (context,state){
                  return IconButton(
                    onPressed: (){
                      Navigator.pop(context);

                    },
                    icon: MainCubit.getObj(context).lang=='en' ?const Icon(Icons.arrow_back) :const Icon(Icons.arrow_forward) ,
                    iconSize: 20.w,
                  );
                },
                  listener: (context,state){},

                ),
                actions: [
                  IconButton(
                    onPressed: (){
                      scaffoldKey.currentState!.openEndDrawer();
                    },
                    icon: Icon(Icons.menu_outlined),
                    iconSize: 22.w,),
                ],
                centerTitle: true,
                title: defaultText(
                    text: cubit.groupName!,
                    fontSize: 30.sp
                ),
              ),
                endDrawer: Drawer(
                  width: 170.w,
                  backgroundColor: greyCl.withOpacity(.6),
                  child: SafeArea(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15.h,
                          ),
                          Padding(
                            padding:  EdgeInsets.symmetric(
                                vertical: 15.h,
                                horizontal: 5.w
                            ),
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context)=>AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                      backgroundColor: mainCl.withOpacity(.7),
                                      title: Container(
                                        child: defaultText(
                                            text: '${S.of(context).deleteGroup} (${cubit.groupName}) ',
                                            fontSize: 20.w,
                                            maxLines: 2,
                                            align: TextAlign.center

                                        ),
                                      ),
                                      actions: [
                                        IconButton(
                                            onPressed: ()async{
                                              await cubit.deleteGroup(groupName: groupName)
                                                  .then((value) {
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(builder: (context)=>GroupsScreen(dayName: dayName, sessionName: sessionName,title: title,)),
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children:[
                                  Icon(
                                    Icons.delete,
                                    size: 22.w,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  defaultText(
                                      text: S.of(context).deleteGroup,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold
                                  )
                                ],


                              ),
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.symmetric(
                                vertical: 15.h,
                                horizontal: 5.w
                            ),
                            child: InkWell(
                              onTap: ()async{
                                await DeepLinkProvider.createLink(
                                    collectionName: 'teachers',
                                    uId: uId!,
                                    userName: userName??'A Teacher',
                                    isTeacher: true,
                                    sessionName: sessionName,
                                    groupName: groupName,
                                    dayName: dayName.toLowerCase()

                                ).then((value) async {
                                  await Share.share(value.toString());
                                });


                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children:[
                                  Icon(
                                    Icons.share,
                                    size: 22.w,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  defaultText(
                                      text: S.of(context).invite,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold
                                  )
                                ],


                              ),
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.symmetric(
                                vertical: 15.h,
                                horizontal: 5.w
                            ),
                            child: InkWell(
                              onTap: (){
                                defaultNavigator(context: context, screen: MyExamsScreen(
                                  sessionName: sessionName,
                                  dayName: dayName,
                                  groupName: groupName,


                                ));
                              },

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children:[
                                  Icon(
                                    Icons.edit,
                                    size: 22.w,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  defaultText(
                                      text: S.of(context).MyExams,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold
                                  )
                                ],


                              ),
                            ),
                          )


                        ],
                      )
                  ),
                ),
                floatingActionButton: FloatingActionButton(

                  onPressed: () async{
              showDialog(
                  context: context,
                  builder: (context)=>
                      defaultDialog(
                          title: '${S.of(context).addExam}',
                          content:SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: nameCon,
                                    cursorColor: whiteCl,
                                    validator: (value){
                                      if(value!.isEmpty){
                                        return S.of(context).examNameError;
                                      }
                                      return null;
                                    },
                                    style: TextStyle(
                                        color: whiteCl,
                                        fontSize: 20.sp
                                    ),
                                    decoration: InputDecoration(
                                      focusedErrorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Colors.orangeAccent
                                          )
                                      ),
                                      hintText: S.of(context).examName,
                                      hintStyle: TextStyle(
                                          color: whiteCl.withOpacity(.5),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15

                                      ),
                                      border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: whiteCl
                                          )
                                      ),
                                      errorBorder:  UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Colors.orangeAccent
                                          )
                                      ),
                                      errorStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.sp
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
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  TextFormField(

                                    controller: qNumCon,
                                    validator: (value){
                                      if(value!.isEmpty){
                                        return S.of(context).examQuestionError;
                                      }
                                      return null;
                                    },
                                    cursorColor: whiteCl,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                        color: whiteCl,
                                        fontSize: 20.sp
                                    ),
                                    decoration: InputDecoration(
                                      errorBorder:  UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Colors.orangeAccent
                                          )
                                      ),
                                      errorStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.sp
                                      ),
                                      focusedErrorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Colors.orangeAccent
                                          )
                                      ),
                                      hintText: S.of(context).questionNumber,
                                      hintStyle: TextStyle(
                                          color: whiteCl.withOpacity(.5),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15

                                      ),
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
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [

                                      Expanded(
                                          child: defaultText(
                                              text: '${S.of(context).examDuration} ...',
                                              color: Colors.white.withOpacity(.8),
                                              fontSize: 18.sp
                                          )),
                                      IconButton(
                                          onPressed: () async {
                                            await showDurationPicker(

                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                              ),
                                              context: context,

                                              initialTime: Duration(minutes: cubit.examDuration),
                                            ).then((value) {
                                              cubit.changeExamDuration(value!.inMinutes);
                                            });
                                          },
                                          icon: Icon(
                                            Icons.timer_rounded,
                                            color: Colors.orangeAccent,
                                            size: 25.w,
                                          )
                                      ),
                                    ],
                                  )


                                ],
                              ),
                            ),
                          ),
                          actions: [
                            IconButton(
                                onPressed: (){
                                  if(formKey.currentState!.validate()&&cubit.examDuration!=0){
                                    defaultNavigator(
                                        context: context,
                                        screen: AddExamScreen(
                                          groupName: groupName,
                                          dayName: dayName,
                                          sessionName: sessionName,
                                          examName: nameCon.text,
                                          duration: cubit.examDuration,
                                          questionsNumber: qNumCon.text,
                                        )
                                    );
                                  }
                                  else if(cubit.examDuration==0){
                                    defaultToast(
                                        state: ToastState.error,
                                        text: S.of(context).examDurationError,
                                        context: context
                                    );
                                  }
                                },
                                icon: Icon(
                                  Icons.check,
                                  color: Colors.greenAccent,
                                  size: 25.w,
                                )
                            )
                          ]
                      ));



                  },
                  child: Icon(
                    Icons.note_alt_outlined,
                    size: 32.w,
                  ),
                ),
                body: cubit.students.length==0 ?
                Center(
                  child: defaultText(
                    text: S.of(context).noStudents,
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
                                text: cubit.students[index],
                                 context: context,
                                cubit: cubit

                              );
                            },
                            separatorBuilder: (context,index)=>SizedBox(
                              height: 20.h,
                            ),
                            itemCount: cubit.students.length
                        )
                    ),

                  ],
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
        required SingleGroupCubit cubit

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
      onTap: ()async{

      Map examsDetails = {}  ;

      await cubit.getMarks(studentName: text)
          .then((value) {
        examsDetails = value ;
      });

    defaultNavigator(
     context: context,
     screen: StudentDetailsScreen(
       examsDetails: examsDetails,
       studentName: text,
       sessionName: sessionName,
       groupName: groupName,
       dayName: dayName,
     ));
      },
    );
  }
}
