

import 'package:bloc/bloc.dart';
import 'package:examy/cubits/main_bloc/main_states.dart';
import 'package:examy/shared/shared_pref/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class MainCubit extends Cubit<MainState> {

//  initialization

  MainCubit () : super ( MainInitState()  );

  static MainCubit getObj(BuildContext context) {
    return BlocProvider.of(context);
  }

//  vars
String? lang ;



//  functions
initLang() {
  lang = PrefsClass.getString(key: 'lang')??"en";
}

void changeLang(){
  if(lang=='en') {

    lang='ar';
    PrefsClass.setString(key: 'lang', value: 'ar');
    emit(ChangeLang());

  }
  else {
    lang='en';
    PrefsClass.setString(key: 'lang', value: 'en');
    emit(ChangeLang());
  }



  }


}

