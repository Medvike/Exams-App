


import 'package:examy/teacher_modules/student_answers_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../contstants/colors.dart';
import '../contstants/widgets.dart';

class StudentDetailsScreen extends StatelessWidget {

 late Map examsDetails ;
 late String studentName;
 late String sessionName;
 late String dayName;
 late String groupName;


   StudentDetailsScreen(
      {
        required this.examsDetails,
        required this.studentName,
        required this.sessionName,
        required this.dayName,
        required this.groupName

  });

  @override
  Widget build(BuildContext context) {
    List<String> examsNames = [];
    List<int> marks = [];
    List<String> fullMarks = [];
    //filling vars
    examsDetails.forEach((key, value) {
      examsNames.add(key.toString());
    } );
    examsDetails.forEach((key, value) {
      marks.add(value['mark']);
    } );
    examsDetails.forEach((key, value) {
     fullMarks.add(value['fullMark']);
    } );

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: defaultText(text: studentName, fontSize: 30.sp),
        ),
      body: ListView.separated(
          itemBuilder: (context,index)=>squareBuilder(
            name: examsNames[index],
            fullMark: fullMarks[index],
            mark: marks[index],
            context: context,

          ),
          separatorBuilder:(context,index)=> SizedBox(
            height: 10.h,
          ),
          itemCount: examsNames.length
      ),
    );

  }

  Widget squareBuilder({
   required String name,
    required String fullMark,
    required int mark,
    required BuildContext context

}) {
    return Padding(
      padding:  EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 10.h
      ),
      child: InkWell(
        onTap: (){
         defaultNavigator(context: context, screen: Sdetailed(
             examName: name,
           groupName: groupName,
           dayName: dayName,
           sessionName: sessionName,
           studentName: studentName,

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: defaultText(
                          text: name,
                          maxLines: 1,
                          fontSize: 30.sp,

                      ),
                    )],
                ),
                SizedBox(
                  height: 3.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    defaultText(text: mark.toString(), fontSize: 28.sp,),
                    defaultText(text: ' / ' , fontSize: 28.sp , color: kYellow,fontWeight: FontWeight.bold),
                    defaultText(text: fullMark, fontSize: 28.sp,),

                  ],
                )


              ],
            ),
          ),
        ),
      ),
    );
  }
}
