import 'package:examy/modules/signing/login/login_screen.dart';
import 'package:examy/shared/shared_pref/shared_pref.dart';
import 'package:examy/shared/user_info/user_credential.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> logOut(BuildContext context)async{
  await PrefsClass.deleteString(key: 'uId');
  uId = null;
  userName = null;
  await PrefsClass.deleteString(key: 'userName')
  .then((value) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => LoginScreen() ),
            (route) => false
    );
  })
  ;




}