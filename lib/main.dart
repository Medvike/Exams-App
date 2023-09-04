import 'package:bloc/bloc.dart';
import 'package:examy/contstants/colors.dart';
import 'package:examy/cubits/main_bloc/main_bloc.dart';
import 'package:examy/cubits/main_bloc/main_states.dart';
import 'package:examy/deep_links/deep_link.dart';
import 'package:examy/modules/signing/login/login_screen.dart';
import 'package:examy/shared/shared_pref/shared_pref.dart';
import 'package:examy/shared/user_info/user_credential.dart';
import 'package:examy/students_modules/exams_home_student_screen.dart';
import 'package:examy/students_modules/invitation_acception.dart';
import 'package:examy/teacher_modules/sessions_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'cubits/bloc_observer.dart';
import 'generated/l10n.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await PrefsClass.init();
  Widget firsScreen = LoginScreen();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity
  );
  userName =  PrefsClass.getString(key: 'userName');
  uId = PrefsClass.getString(key: 'uId');
  var sharedUserType = await DeepLinkProvider.initDynamicLink();
  if(sharedUserType != null){
    if( sharedUserType['recType'] == 'student' ) {
      if(uId != null){
        firsScreen = InviteScreen(
          callerName: sharedUserType["senderName"],
          groupName: sharedUserType["groupName"],
          dayName: sharedUserType["dayName"],
          callerUid: sharedUserType["senderUid"],
          collectionName: sharedUserType["collectionName"],
          sessionName: sharedUserType["sessionName"],
          recName: userName,




        );
      }
      else if(uId == null){
        firsScreen = LoginScreen(
          callerName: sharedUserType["senderName"],
          groupName: sharedUserType["groupName"],
          dayName: sharedUserType["dayName"],
          callerUid: sharedUserType["senderUid"],
          collectionName: sharedUserType["collectionName"],
          sessionName: sharedUserType["sessionName"],
        );
      }

    }
  }
  else if(uId!=null){
    String? userType = PrefsClass.getString(key: 'userType');
    if(userType == 'teacher'){
      firsScreen = SessionsScreen();
    }
    else if(userType == 'student'){
      firsScreen = StudentsExamHome();
    }
  }
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: mainCl.withOpacity(.7),
        statusBarColor: mainCl
      )
  );

  Bloc.observer = MyBlocObserver();

  runApp( MyApp(firsScreen) );

}

class MyApp extends StatelessWidget {
  late Widget firstScreen;

  MyApp(this.firstScreen);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context,child){
        return BlocProvider(
          create: (context)=>MainCubit()..initLang(),
          child: BlocConsumer<MainCubit,MainState>(
            builder: (context,state){
              MainCubit cubit = MainCubit.getObj(context);
              return MaterialApp(
                locale: Locale( cubit.lang ?? "en" ),
                localizationsDelegates: const[
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                debugShowCheckedModeBanner: false,
                home: firstScreen,
                theme: ThemeData(
                  inputDecorationTheme: InputDecorationTheme(
                    suffixIconColor: whiteCl,

                  ),
                  iconTheme: IconThemeData(
                    color: whiteCl,
                  ),
                  primaryColor: secCl,
                  scaffoldBackgroundColor: mainCl,
                  appBarTheme: const AppBarTheme(
                      color: Colors.transparent,
                      elevation: 0
                  ),



                ),
              );
            },
            listener: (context,state){},
          ),
        );

      },
    );
  }
}
