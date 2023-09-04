// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `stages`
  String get stages {
    return Intl.message(
      'stages',
      name: 'stages',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to Log out?`
  String get logoutMessage {
    return Intl.message(
      'Do you want to Log out?',
      name: 'logoutMessage',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get logout {
    return Intl.message(
      'Log out',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Report`
  String get report {
    return Intl.message(
      'Report',
      name: 'report',
      desc: '',
      args: [],
    );
  }

  /// `Report a problem`
  String get reportMessage {
    return Intl.message(
      'Report a problem',
      name: 'reportMessage',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to Delete this Stage ?`
  String get deleteSession {
    return Intl.message(
      'Do you want to Delete this Stage ?',
      name: 'deleteSession',
      desc: '',
      args: [],
    );
  }

  /// `Add New Educational Stage`
  String get addSession {
    return Intl.message(
      'Add New Educational Stage',
      name: 'addSession',
      desc: '',
      args: [],
    );
  }

  /// `Add New Group`
  String get addGroup {
    return Intl.message(
      'Add New Group',
      name: 'addGroup',
      desc: '',
      args: [],
    );
  }

  /// `Add New Exam`
  String get addExam {
    return Intl.message(
      'Add New Exam',
      name: 'addExam',
      desc: '',
      args: [],
    );
  }

  /// `has`
  String get has {
    return Intl.message(
      'has',
      name: 'has',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get accept {
    return Intl.message(
      'Accept',
      name: 'accept',
      desc: '',
      args: [],
    );
  }

  /// `Reject`
  String get Reject {
    return Intl.message(
      'Reject',
      name: 'Reject',
      desc: '',
      args: [],
    );
  }

  /// `Exam Name`
  String get examName {
    return Intl.message(
      'Exam Name',
      name: 'examName',
      desc: '',
      args: [],
    );
  }

  /// `Exam Duration`
  String get examDuration {
    return Intl.message(
      'Exam Duration',
      name: 'examDuration',
      desc: '',
      args: [],
    );
  }

  /// `Answers Number`
  String get questionNumber {
    return Intl.message(
      'Answers Number',
      name: 'questionNumber',
      desc: '',
      args: [],
    );
  }

  /// `Delete Group`
  String get deleteGroup {
    return Intl.message(
      'Delete Group',
      name: 'deleteGroup',
      desc: '',
      args: [],
    );
  }

  /// `My Exams`
  String get MyExams {
    return Intl.message(
      'My Exams',
      name: 'MyExams',
      desc: '',
      args: [],
    );
  }

  /// `Invite Students`
  String get invite {
    return Intl.message(
      'Invite Students',
      name: 'invite',
      desc: '',
      args: [],
    );
  }

  /// `please enter exam name`
  String get examNameError {
    return Intl.message(
      'please enter exam name',
      name: 'examNameError',
      desc: '',
      args: [],
    );
  }

  /// `please enter number of questions`
  String get examQuestionError {
    return Intl.message(
      'please enter number of questions',
      name: 'examQuestionError',
      desc: '',
      args: [],
    );
  }

  /// `please enter exam duration`
  String get examDurationError {
    return Intl.message(
      'please enter exam duration',
      name: 'examDurationError',
      desc: '',
      args: [],
    );
  }

  /// `Question`
  String get questionTitle {
    return Intl.message(
      'Question',
      name: 'questionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Answers Number`
  String get answerNumberTitle {
    return Intl.message(
      'Answers Number',
      name: 'answerNumberTitle',
      desc: '',
      args: [],
    );
  }

  /// `Correct Answer`
  String get correctAnswerTitle {
    return Intl.message(
      'Correct Answer',
      name: 'correctAnswerTitle',
      desc: '',
      args: [],
    );
  }

  /// `Write your Question`
  String get questionHint {
    return Intl.message(
      'Write your Question',
      name: 'questionHint',
      desc: '',
      args: [],
    );
  }

  /// `Write Your Answer`
  String get answerHint {
    return Intl.message(
      'Write Your Answer',
      name: 'answerHint',
      desc: '',
      args: [],
    );
  }

  /// `Loading ...`
  String get Loading {
    return Intl.message(
      'Loading ...',
      name: 'Loading',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `This name is already in use .. please change it `
  String get sameName {
    return Intl.message(
      'This name is already in use .. please change it ',
      name: 'sameName',
      desc: '',
      args: [],
    );
  }

  /// `Add new educational stages from the '+' button`
  String get noSessions {
    return Intl.message(
      'Add new educational stages from the \'+\' button',
      name: 'noSessions',
      desc: '',
      args: [],
    );
  }

  /// `Add new Groups from the '+' button`
  String get noGroups {
    return Intl.message(
      'Add new Groups from the \'+\' button',
      name: 'noGroups',
      desc: '',
      args: [],
    );
  }

  /// `Invite students from the side menu `
  String get noStudents {
    return Intl.message(
      'Invite students from the side menu ',
      name: 'noStudents',
      desc: '',
      args: [],
    );
  }

  /// `E-mail`
  String get mailHint {
    return Intl.message(
      'E-mail',
      name: 'mailHint',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get passHint {
    return Intl.message(
      'Password',
      name: 'passHint',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account ?`
  String get noAcc {
    return Intl.message(
      'Don\'t have an account ?',
      name: 'noAcc',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get Reg {
    return Intl.message(
      'Register',
      name: 'Reg',
      desc: '',
      args: [],
    );
  }

  /// `name`
  String get name {
    return Intl.message(
      'name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get start {
    return Intl.message(
      'Start',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  /// `Exams`
  String get exams {
    return Intl.message(
      'Exams',
      name: 'exams',
      desc: '',
      args: [],
    );
  }

  /// `Result`
  String get result {
    return Intl.message(
      'Result',
      name: 'result',
      desc: '',
      args: [],
    );
  }

  /// `minutes`
  String get mins {
    return Intl.message(
      'minutes',
      name: 'mins',
      desc: '',
      args: [],
    );
  }

  /// `minute`
  String get min {
    return Intl.message(
      'minute',
      name: 'min',
      desc: '',
      args: [],
    );
  }

  /// `questions`
  String get questions {
    return Intl.message(
      'questions',
      name: 'questions',
      desc: '',
      args: [],
    );
  }

  /// `question`
  String get question {
    return Intl.message(
      'question',
      name: 'question',
      desc: '',
      args: [],
    );
  }

  /// `you're not subscribed with this service ! ... Contact us to get this service`
  String get sub {
    return Intl.message(
      'you\'re not subscribed with this service ! ... Contact us to get this service',
      name: 'sub',
      desc: '',
      args: [],
    );
  }

  /// `Subscribe`
  String get subscribe {
    return Intl.message(
      'Subscribe',
      name: 'subscribe',
      desc: '',
      args: [],
    );
  }

  /// `invited you to join`
  String get inviteMessage {
    return Intl.message(
      'invited you to join',
      name: 'inviteMessage',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your e-mail`
  String get mailError {
    return Intl.message(
      'Please enter your e-mail',
      name: 'mailError',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get passError {
    return Intl.message(
      'Please enter your password',
      name: 'passError',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login2 {
    return Intl.message(
      'Login',
      name: 'login2',
      desc: '',
      args: [],
    );
  }

  /// `There are no teachers yet ! `
  String get sWait {
    return Intl.message(
      'There are no teachers yet ! ',
      name: 'sWait',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your name`
  String get nameError {
    return Intl.message(
      'Please enter your name',
      name: 'nameError',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get Reg2 {
    return Intl.message(
      'Register',
      name: 'Reg2',
      desc: '',
      args: [],
    );
  }

  /// `Teacher`
  String get teacher {
    return Intl.message(
      'Teacher',
      name: 'teacher',
      desc: '',
      args: [],
    );
  }

  /// `Student`
  String get student {
    return Intl.message(
      'Student',
      name: 'student',
      desc: '',
      args: [],
    );
  }

  /// `JOIN AS`
  String get join {
    return Intl.message(
      'JOIN AS',
      name: 'join',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
