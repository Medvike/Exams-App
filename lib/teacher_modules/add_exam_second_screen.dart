

import 'package:examy/contstants/widgets.dart';
import 'package:examy/cubits/add_exam_cubit/add_exam_cubit.dart';
import 'package:examy/cubits/add_exam_cubit/add_exam_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../contstants/colors.dart';
import '../generated/l10n.dart';

class AddExamScreen extends StatelessWidget {
   late String sessionName;
   late String dayName;
    String? groupName;
   late String examName;
   late String questionsNumber;
   late int duration;
   AddExamScreen(
   {
     this.groupName,
     required this.sessionName,
     required this.dayName,
     required this.examName,
     required this.duration,
     required this.questionsNumber
}
       );
  //vars
   PageController pageController = PageController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context)=>AddExamCubit()..initVars(
            examName: examName,
            questionsNumber: questionsNumber,
            examDuration:duration,
            sessionName: sessionName,
            dayName: dayName,
            groupName: groupName
        ),
      child: BlocConsumer<AddExamCubit,AddExamStates>
        (
        builder: (context,state){
          //vars
          AddExamCubit cubit = AddExamCubit.getObj(context);
          //return
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                    Icons.close,
                  size: 23.w,
                ),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              actions: [
                if(cubit.isFinished==true)
                 IconButton(
                    onPressed: ()async{
                      await cubit.onExamSubmit(context: context);
                    }
                    ,
                    icon: Icon(
                      Icons.check,
                      color: Colors.greenAccent,
                      size: 25.w,


                    )
                )
              ],
            ),
           body: Column(
             children: [
               Expanded(
                 child: PageView.builder(
                   physics: const BouncingScrollPhysics(),
                   controller: pageController,
                   onPageChanged: (index){
                     if( index+1 == int.parse(questionsNumber) ) {
                      cubit.finishExamNow(true);
                     }
                     else{
                       cubit.finishExamNow(false);
                     }

                   },
                   itemBuilder: (context,index)=>questionBuilder(
                       cubit: cubit,
                       index: index,
                       context: context
                   ),
                   itemCount: int.parse(cubit.questionsNumber!),
                 ),
               ),
               Padding(
                 padding: EdgeInsets.symmetric(
                     horizontal: 20.w,
                     vertical: 10.h
                 ),
                 child: Row(
                   mainAxisSize: MainAxisSize.min,
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Expanded(
                       child: Container(
                         height: 35.h,
                         child: Center(
                           child: ListView.builder(
                             shrinkWrap: true,
                             physics: const BouncingScrollPhysics(),
                             scrollDirection: Axis.horizontal,
                             itemBuilder: (context,index)=>pageIndexBuilder(
                               number: ( index + 1 ).toString(),

                             ),
                             itemCount: int.parse(questionsNumber),
                           ),
                         ),
                       ),
                     )
                   ],
                 ),
               ),

             ],
           ),

          );
        },
        listener: (context,state){
          if(state is Loading) {
            showDialog(
               barrierDismissible: false,
                context: context,
                builder: (context)=>defaultDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(

                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      defaultText(text: S.of(context).Loading, fontSize: 20.sp)
                    ],

                  )
                ));
          }
        },
      )
      ,
    );
  }

  Widget questionBuilder(
   {
     required AddExamCubit cubit,
     required int index,
     required BuildContext context
}
      ){
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 20.h
        ),
        child: Column(
          children: [
              Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                defaultText(
                    text: S.of(context).question,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold
                ),
                defaultText(
                  text: (index+1).toString(),
                    fontSize: 25.sp,
                  color: kYellow,
                    fontWeight: FontWeight.bold
                ),
              ],
            ),
              SizedBox(
              height: 10.h,
            ),
              TextFormField(
              controller: cubit.questionsControllers[index],
               maxLines: 5,
               minLines: 1,
               cursorColor: Colors.white,
               style: TextStyle(
                   color: whiteCl,
                   fontSize:23.sp
               ),
               decoration: InputDecoration(
                 suffixIcon: Row(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     IconButton(
                       onPressed: () async {
                         await cubit.questionImagePicker( questionKey: 'q ${index+1}' );

                       },
                       icon: const Icon(Icons.image),
                       color: Colors.white,
                       iconSize: 25.w,
                     ),
                     if(cubit.questionsImages['q ${index+1}']!=null)
                     IconButton(
                       onPressed: ()  {
                          cubit.deleteQuestionImage('q ${index+1}');
                       },
                       icon: const Icon(Icons.delete_forever_rounded),
                       color: Colors.white,
                       iconSize: 25.w,
                     )
                   ],
                 ),
                 hintText: '  ${S.of(context).questionHint} ',
                 focusedErrorBorder: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(20),
                     borderSide: BorderSide(
                         color: orangeCl,
                         width: 1
                     )
                 ),
                 errorBorder: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(20),
                     borderSide: BorderSide(
                         color: orangeCl,
                         width: 1
                     )
                 ),
                 errorStyle: TextStyle(
                     color: whiteCl
                 ),
                 labelStyle: TextStyle(
                     color: whiteCl.withOpacity(.5)
                 ),
                 floatingLabelStyle: TextStyle(
                     color: whiteCl
                 ),
                 hintStyle: TextStyle(
                     color: whiteCl.withOpacity(.5),
                   fontSize: 18.sp
                 ),
                 border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(20),
                     borderSide: BorderSide(
                         color: whiteCl,
                         width: 1
                     )
                 ),
                 focusedBorder: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(20),
                     borderSide: BorderSide(
                         color: whiteCl,
                         width: 1
                     )
                 ),
                 enabledBorder:OutlineInputBorder(
                     borderRadius: BorderRadius.circular(20),
                     borderSide: BorderSide(
                         color: whiteCl,
                         width: 1
                     )
                 ),




               ),
             ),
              SizedBox(
              height: 10.h,
            ),
              Padding(
                padding:  EdgeInsets.symmetric(
                    horizontal: 10.w
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                       Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 2,
                            child: defaultText(
                                text: S.of(context).questionNumber,
                                fontSize: 20.sp,
                              fontWeight: FontWeight.bold
                            )),
                        Expanded(
                          flex: 1,
                          child: DropdownButton(

                            style: TextStyle(
                              fontWeight: FontWeight.bold,

                            ),
                              icon: Icon(
                                Icons.arrow_drop_down_rounded,
                                color: kYellow,


                              ),
                              iconSize: 33.w,

                                isExpanded: true,
                              value: cubit.questionAnswerNUmberValues[index],
                              dropdownColor: greyCl.withOpacity(.5),
                              items: [
                                DropdownMenuItem(
                                  child: defaultText(text: '3', fontSize: 18.sp),
                                  value: 3,
                                ),
                                DropdownMenuItem(
                                  child: defaultText(text: '4', fontSize: 18.sp),
                                  value: 4,
                                ),
                                DropdownMenuItem(
                                  child: defaultText(text: '5', fontSize: 18.sp),
                                  value: 5,
                                ),

                              ],
                              onChanged: (value){
                                cubit.changeAnswersNumber( index: index, newNumber: value!);
                              }),
                        ),

                      ],
                    ),
                     SizedBox(
                       height: 10.h,
                     ),
                     ListView.separated(
                       shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context,answerIndex){

                          // cubit.addQuestionControllers( questionNumber: index );
                          cubit.addAnswersControllers(
                              questionNumber: 'question ${index+1} of answer ${answerIndex+1}',
                          );



                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                child: defaultText(
                                    text: (answerIndex+1).toString(),
                                    fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,

                                ),
                              ),
                              SizedBox(
                                width: 15.w,
                              ),
                              Expanded(
                                child: TextFormField(

                                  onTap: (){},
                                  controller: cubit.answersControllers['question ${index+1} of answer ${answerIndex+1}'],
                                  maxLines: 5,
                                  minLines: 1,
                                  cursorColor: Colors.white,
                                  style: TextStyle(
                                      color: whiteCl,
                                      fontSize:18.sp
                                  ),
                                  decoration: InputDecoration(
                                    suffixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: ()async{
                                            await cubit.answerImagePicker(answerKey: 'question ${index+1} of answer ${answerIndex+1}');

                                          },
                                          icon: Icon(
                                            Icons.image,
                                          ),
                                          color: Colors.white,
                                          iconSize: 25.w,
                                        ),
                                        if(cubit.answersImages['question ${index+1} of answer ${answerIndex+1}']!=null)
                                          IconButton(
                                            onPressed: (){
                                              cubit.deleteAnswerImage('question ${index+1} of answer ${answerIndex+1}');
                                            },
                                            icon: Icon(
                                              Icons.delete_forever_rounded,
                                            ),
                                            color: Colors.white,
                                            iconSize: 25.w,
                                          ),

                                      ],
                                    ),
                                    hintText: '  ${S.of(context).answerHint}  ',
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: orangeCl,
                                            width: 1
                                        )
                                    ),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: orangeCl,
                                            width: 1
                                        )
                                    ),
                                    errorStyle: TextStyle(
                                        color: whiteCl
                                    ),
                                    labelStyle: TextStyle(
                                        color: whiteCl.withOpacity(.5)
                                    ),
                                    floatingLabelStyle: TextStyle(
                                        color: whiteCl
                                    ),
                                    hintStyle: TextStyle(
                                        color: whiteCl.withOpacity(.5),
                                        fontSize: 18.sp
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: whiteCl,
                                            width: 1
                                        )
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: whiteCl,
                                            width: 1
                                        )
                                    ),
                                    enabledBorder:OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: whiteCl,
                                            width: 1
                                        )
                                    ),




                                  ),

                                ),
                              )
                            ],
                          ) ;
                        },
                        separatorBuilder: (context,index)=>SizedBox(
                          height: 20.h,
                        ),
                        itemCount: cubit.questionAnswerNUmberValues[index]
                    ),
                      SizedBox(
                      height: 10.h,
                    ),
                      Padding(
                        padding:  EdgeInsets.symmetric(
                          horizontal: 30.w
                        ),
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              flex: 2,
                              child: defaultText(
                                  text: '${S.of(context).correctAnswerTitle} ',
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold
                              )),
                          Expanded(
                            flex: 1,
                            child: DropdownButton(

                                style: TextStyle(
                                  fontWeight: FontWeight.bold,

                                ),
                                icon: Icon(
                                  Icons.arrow_drop_down_rounded,
                                  color: kYellow,


                                ),
                                iconSize: 33.w,
                                isExpanded: true,
                                value: cubit.correctAnswers[index+1],
                                dropdownColor: greyCl.withOpacity(.5),
                                items: [
                                  DropdownMenuItem(
                                    child: defaultText(text: '1', fontSize: 18.sp),
                                    value: 1,
                                  ),
                                  DropdownMenuItem(
                                    child: defaultText(text: '2', fontSize: 18.sp),
                                    value: 2,
                                  ),
                                  DropdownMenuItem(
                                    child: defaultText(text: '3', fontSize: 18.sp),
                                    value: 3,
                                  ),
                                  if(cubit.questionAnswerNUmberValues[index]>3 )
                                  DropdownMenuItem(
                                    child: defaultText(text: '4', fontSize: 18.sp),
                                    value: 4,
                                  ),
                                if(cubit.questionAnswerNUmberValues[index]>4)
                                  DropdownMenuItem(
                                    child: defaultText(text: '5', fontSize: 18.sp),
                                    value: 5,
                                  ),
                                ],
                                onChanged: (value){
                                  cubit.changeCorrectAnswer(questionNumber: index+1, answerNumber: value!);
                                  print(cubit.correctAnswers.toString());
                                }),
                          ),

                        ],
                    ),
                      ),

                  ],
                ),
              ),







          ],
        ),
      ),
    );
  }





  Widget pageIndexBuilder({
     required String number,

}){
    return InkWell(
      onTap: (){
        pageController.animateToPage(
            int.parse(number)-1,
            duration: Duration(
                seconds: 2
            ),
            curve: Curves.fastLinearToSlowEaseIn
        );
      },
      child: Padding(
        padding:  EdgeInsets.symmetric(
            horizontal: 10.w
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: 8.w,
              vertical: 8.h
          ),
          decoration: BoxDecoration(
            color: greyCl.withOpacity(.5),
            borderRadius: BorderRadius.circular(10),

          ),
          child: defaultText(
              text: number,
              fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

    );
  }
}
