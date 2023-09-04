import 'package:examy/contstants/widgets.dart';
import 'package:examy/students_modules/exams_home_student_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../contstants/colors.dart';
import '../generated/l10n.dart';



class ResulstsScreen extends StatelessWidget {
  late String fullMark;
  late String mark;


  ResulstsScreen({
    required this.fullMark,
    required this.mark
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              Padding(
                padding:  EdgeInsets.symmetric(
                  horizontal: 27.w,
                  vertical: 18.h
                ),
                child: Container(
                  width: 340.w,
                  height: 350.h,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      width: 2,
                      color: whiteCl
                    )

                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: defaultText(
                            text: S.of(context).result,
                            fontSize: 40.sp,
                        fontWeight: FontWeight.bold
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: defaultText(
                                text: '$mark  /  $fullMark ',
                                fontSize: 40.sp,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      )

                    ],
                  ),
                ),
              ),
             MaterialButton(
               onPressed: (){
                 Navigator.pushAndRemoveUntil(
                     context,
                     MaterialPageRoute(builder: (context)=>StudentsExamHome() ),
                         (route) => false);

             },
               child: Container(
                 width: 35.w,
                 height: 35.h,
                 child: Icon(Icons.close,color: whiteCl,size: 20.w,),
                 decoration: BoxDecoration(
                   shape: BoxShape.circle,
                   color: Colors.redAccent
                 ),
               ),
             )
            ],
          ),
        ),
      ),
    );
  }
}
