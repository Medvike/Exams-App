import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examy/contstants/const_vars.dart';
import 'package:examy/contstants/widgets.dart';
import 'package:examy/shared/user_info/user_credential.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../generated/l10n.dart';
import 'exams_home_student_screen.dart';

class InviteScreen extends StatelessWidget {


 String? callerName;
 String? groupName;
 String? collectionName;
 String? dayName;
 String? sessionName;
 String? callerUid;
 String? recName;


 InviteScreen({
   required this.groupName,
   required this.callerName,
   required this.dayName,
   required this.callerUid,
   required this.collectionName,
   required this.sessionName,
   required this.recName
});


 @override
  Widget build(BuildContext context) {

   double width  = MediaQuery.sizeOf(context).width;
   double height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.symmetric(
          horizontal: 12.w
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
         Flexible(
           child: defaultText(
               text: '${callerName.toString()} ${S.of(context).has} ${S.of(context).inviteMessage} ${groupName.toString()} ',
               align: TextAlign.center,
               fontSize: 30.sp,
                textOverflow: null,
                fontWeight: FontWeight.bold

           ),
         ),
            Padding(
                padding: EdgeInsets.symmetric(
              vertical: height/25
            ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: defaultButton(
                       color: Colors.green,
                        onPress: () async {
                         await FirebaseFirestore.instance.collection('students')
                         .doc(uId).collection('myTeachers').doc(callerUid)
                         .set({
                           'studentName':recName,
                           'teacherName':callerName,
                           'teacherUid':callerUid,
                           'studentUid':uId,
                           'dayName':dayName,
                           'groupName':groupName,
                           'sessionName':sessionName,

                         }).then((value) async {

                           await FirebaseFirestore.instance.collection(collectionName!)
                               .doc(callerUid!).collection('sessions').doc(sessionName!)
                               .collection('week').doc(dayName!).collection('groups')
                               .doc(groupName!).collection('students').doc(recName)
                               .set({
                             'name':recName,
                             'studentUid':uId,

                           })
                               .then((value) {
                             Navigator.pushAndRemoveUntil(
                                 context,
                                 MaterialPageRoute(builder: (context)=> StudentsExamHome()),
                                     (route) => false
                             );
                           })
                           ;
                         }


                         );






                        },
                        child: defaultText(
                        text: S.of(context).accept,
                        fontSize: width/20,

                    ),
                      height: height/21,
                      width: width/3
                    ),
                  ),
                  SizedBox(
                    width: width/10,
                  ),
                  Container(
                    child: defaultButton(
                        color: Colors.red,
                        onPress: (){
                         SystemNavigator.pop();
                        },
                        child: defaultText(
                            text: S.of(context).Reject,
                            fontSize: width/20
                        ),
                        height: height/21,
                        width: width/3
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
